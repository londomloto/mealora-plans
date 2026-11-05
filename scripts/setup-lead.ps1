<#
.SYNOPSIS
  Menyiapkan store OpenSpec BARU dari checkout kosong (mis. tim lead baru saja
  membuat repo git plan kosong dan menyalin folder scripts/ ini dari template).
  Jalankan SEKALI per store, oleh satu orang, sebelum scripts/setup.ps1 bisa
  dipakai siapa pun (termasuk oleh orang yang sama).

.DESCRIPTION
  scripts/setup.ps1 mengasumsikan store sudah punya struktur openspec/ dan
  identitas store (.openspec-store/store.yaml). Checkout yang benar-benar
  kosong tidak punya keduanya, sehingga setup.ps1 gagal dengan pesan
  "store tidak ada". Script ini yang mengerjakan bagian satu-kali itu:

    1. openspec init - membuat struktur openspec/ (specs/, changes/, config.yaml)
       bila belum ada.
    2. Patch skill openspec-propose (.claude/ dan .agents/) lewat
       scripts/patch-propose-skill.ps1, supaya /opsx:propose otomatis
       menghitung nomor urut change lewat scripts/next-change.ps1|.sh, bukan
       membiarkan agent menebak atau lupa memberi nomor.
    3. Menyalin schema template dari scripts/schema-template/ ke
       openspec/schemas/<SchemaName>/ dan mengarahkan config.yaml ke schema
       tersebut, supaya store baru tidak terjebak dengan schema default
       "spec-driven" bawaan OpenSpec.
    4. openspec store register - mendaftarkan folder ini sebagai store lokal
       dengan id yang diberikan.

  Setelah script ini selesai, scripts/setup.ps1 bisa dijalankan seperti biasa
  oleh siapa pun (termasuk Anda sendiri) yang meng-clone store ini di mesin
  masing-masing.

.PARAMETER Id
  Id store, mis. "bizcare-plans". Wajib diisi.

.PARAMETER SchemaName
  Nama schema project-local yang akan dibuat di openspec/schemas/<SchemaName>.
  Default: "kct-spec-driven" - konvensi standar KCT, sama di semua store dari
  template ini. Isi manual hanya kalau store ini memang butuh nama lain.

.PARAMETER Remote
  URL clone kanonis untuk dicatat di .openspec-store/store.yaml. Opsional -
  bila folder ini sudah punya remote git `origin` (repo plan sudah dibuat di
  server dan di-clone), remote itu terdeteksi otomatis dan tidak perlu diisi.
  Isi manual hanya untuk folder yang benar-benar belum punya remote.

.PARAMETER Force
  Timpa openspec/schemas/<SchemaName> yang sudah ada bila isinya berbeda, dan
  paksa openspec init menimpa file lama.

.EXAMPLE
  .\scripts\setup-lead.ps1 -Id bizcare-plans

.EXAMPLE
  .\scripts\setup-lead.ps1 -Id bizcare-plans -Remote git@git.kct.co.id:KCT/bizcare-plans.git

.EXAMPLE
  .\scripts\setup-lead.ps1 -Id bizcare-plans -SchemaName custom-name
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Id,
    [string]$SchemaName,
    [string]$Remote,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$scriptsDir = $PSScriptRoot
$storeRoot = Split-Path -Parent $scriptsDir

if (-not $SchemaName) {
    $SchemaName = 'kct-spec-driven'
}

# Bila folder ini sudah punya remote git (repo plan kosong sudah dibuat di
# server dan di-clone), pakai itu - -Remote hanya perlu diisi manual untuk
# folder yang benar-benar belum punya remote. git menulis ke stderr saat
# remote 'origin' tidak ada; dengan $ErrorActionPreference = 'Stop' itu jadi
# error terminating kalau tidak ditangkap try/catch (2>$null saja tidak cukup
# untuk command native di PowerShell).
if (-not $Remote) {
    try {
        $detectedRemote = git -C $storeRoot remote get-url origin 2>$null
        if ($LASTEXITCODE -eq 0 -and $detectedRemote) {
            $Remote = $detectedRemote.Trim()
        }
    } catch {
        # Tidak ada remote 'origin' - wajar untuk folder yang belum pernah di-push.
    }
}

Write-Host "Store root : $storeRoot"
Write-Host "Store id   : $Id"
Write-Host "Schema     : $SchemaName"
if ($Remote) { Write-Host "Remote     : $Remote" }
Write-Host ""

# --- Guard: jangan jalankan di atas checkout yang sudah jadi store sungguhan -
$existingMetadata = Join-Path $storeRoot '.openspec-store\store.yaml'
if ((Test-Path $existingMetadata) -and -not $Force) {
    throw "$existingMetadata sudah ada - folder ini sudah jadi store. Pakai scripts/setup.ps1 (setup per mesin), bukan setup-lead.ps1. Bila memang ingin menulis ulang identitas store, jalankan ulang dengan -Force."
}

# --- 1. openspec init (bila openspec/ belum berbentuk root sungguhan) -------
$openspecDir = Join-Path $storeRoot 'openspec'
$hasRealRoot = (Test-Path (Join-Path $openspecDir 'specs')) -or (Test-Path (Join-Path $openspecDir 'changes'))

Write-Host "[1/4] openspec init..."
if ($hasRealRoot) {
    Write-Host "      openspec/specs atau openspec/changes sudah ada, dilewati."
} else {
    Push-Location $storeRoot
    try {
        $initArgs = @('init', '.', '--tools', 'claude,agents')
        if ($Force) { $initArgs += '--force' }
        & openspec @initArgs
        # Fallback ke --tools claude saja kalau ini gagal: tool 'agents' baru
        # ada di rilis OpenSpec CLI yang lebih baru, dan sudah kejadian nyata
        # seorang lead kena "Invalid tool(s): agents" di CLI lamanya, membuat
        # SELURUH bootstrap gagal padahal --tools claude saja cukup untuk
        # lanjut. Jangan dihapus tanpa mengganti dengan penanganan versi CLI
        # yang setara.
        if ($LASTEXITCODE -ne 0) {
            Write-Warning "openspec init dengan --tools claude,agents gagal - kemungkinan versi OpenSpec CLI di mesin ini belum mendukung tool 'agents'. Mencoba ulang dengan --tools claude saja..."
            $initArgs = @('init', '.', '--tools', 'claude')
            if ($Force) { $initArgs += '--force' }
            & openspec @initArgs
            if ($LASTEXITCODE -ne 0) {
                throw "openspec init tetap gagal walau tanpa 'agents' (exit code $LASTEXITCODE). Periksa versi OpenSpec CLI ('openspec --version') dan error di atas."
            }
            Write-Warning "Folder .agents/ (dukungan agent non-Claude) TIDAK dibuat karena versi OpenSpec CLI ini belum mendukung tool 'agents'. Upgrade OpenSpec CLI, lalu jalankan 'openspec init . --tools claude,agents -Force' manual bila perlu."
        }
    } finally {
        Pop-Location
    }
}

# --- 2. Patch skill openspec-propose (nomor urut change otomatis) ----------
Write-Host "[2/4] Menerapkan patch skill openspec-propose..."
& (Join-Path $scriptsDir 'patch-propose-skill.ps1')

# --- 3. Schema template ------------------------------------------------------
Write-Host "[3/4] Menyalin schema template..."

$templateSrc = Join-Path $scriptsDir 'schema-template'
if (-not (Test-Path $templateSrc)) {
    throw "Schema template tidak ditemukan di $templateSrc. Pastikan folder scripts/ disalin utuh dari repo template ini."
}

$schemaDest = Join-Path $openspecDir "schemas\$SchemaName"
if ((Test-Path $schemaDest) -and -not $Force) {
    Write-Warning "$schemaDest sudah ada, dilewati. Jalankan ulang dengan -Force untuk menimpanya."
} else {
    if (Test-Path $schemaDest) { Remove-Item -Path $schemaDest -Recurse -Force }
    New-Item -ItemType Directory -Path $schemaDest -Force | Out-Null
    Copy-Item -Path (Join-Path $templateSrc '*') -Destination $schemaDest -Recurse

    # schema.yaml datang dengan `name: kct-spec-driven` - selaraskan dengan
    # nama folder tujuan (biasanya sama persis, kecuali -SchemaName di-override)
    # supaya `openspec schema which` konsisten.
    $schemaYamlPath = Join-Path $schemaDest 'schema.yaml'
    (Get-Content $schemaYamlPath -Raw) -replace '(?m)^name:\s*kct-spec-driven\s*$', "name: $SchemaName" |
        Set-Content -Path $schemaYamlPath -NoNewline
    Add-Content -Path $schemaYamlPath -Value ""

    Write-Host "      disalin ke $schemaDest"
}

# Arahkan config.yaml ke schema ini, bukan default "spec-driven" hasil openspec init.
$configPath = Join-Path $openspecDir 'config.yaml'
if (Test-Path $configPath) {
    $configContent = Get-Content $configPath -Raw
    if ($configContent -match '(?m)^schema:\s*(\S.*?)\s*$') {
        $currentSchema = $Matches[1].Trim('"', "'")
        if ($currentSchema -eq $SchemaName) {
            Write-Host "      config.yaml sudah menunjuk schema '$SchemaName'."
        } else {
            $newContent = $configContent -replace '(?m)^schema:\s*\S.*$', "schema: $SchemaName"
            Set-Content -Path $configPath -Value $newContent -NoNewline
            Write-Host "      config.yaml diarahkan dari '$currentSchema' ke '$SchemaName'."
        }
    } else {
        Write-Warning "Tidak menemukan baris 'schema:' di $configPath - tambahkan manual: schema: $SchemaName"
    }
} else {
    Write-Warning "$configPath tidak ditemukan - lewati pengaturan schema, periksa manual setelah ini selesai."
}

# --- 4. Registrasi store ----------------------------------------------------
Write-Host "[4/4] Mendaftarkan store '$Id'..."

& openspec store register $storeRoot --id $Id --yes
if ($LASTEXITCODE -ne 0) {
    throw "Registrasi store gagal. Bila id sudah dipakai checkout lain, jalankan 'openspec store unregister $Id' lebih dulu."
}

# `store register` tidak punya flag --remote (itu cuma ada di `store setup`,
# yang membuat store dari nol, bukan mendaftarkan checkout yang sudah ada).
# Tulis manual ke metadata store bila remote diberikan.
if ($Remote) {
    $metadataPath = Join-Path $storeRoot '.openspec-store\store.yaml'
    if (Test-Path $metadataPath) {
        $metaContent = Get-Content $metadataPath -Raw
        if ($metaContent -match '(?m)^remote:.*$') {
            $metaContent = $metaContent -replace '(?m)^remote:.*$', "remote: $Remote"
        } else {
            $metaContent = $metaContent.TrimEnd("`r", "`n") + "`nremote: $Remote`n"
        }
        Set-Content -Path $metadataPath -Value $metaContent -NoNewline
        Write-Host "      remote dicatat di $metadataPath"
    }
}

Write-Host ""
Write-Host "Selesai. Langkah berikutnya:"
Write-Host "  1. Jalankan scripts\setup.ps1 di mesin ini seperti biasa (menulis pointer workspace + asset Claude Code)."
Write-Host "  2. Sesuaikan openspec\schemas\$SchemaName\schema.yaml dan openspec\config.yaml dengan domain project ini"
Write-Host "     (cari komentar '# CUSTOMIZE' di schema.yaml)."
Write-Host "  3. Commit dan push store ini, lalu commit juga scripts\setup.ps1 / setup.sh apa adanya - teammate lain"
Write-Host "     cukup clone dan jalankan scripts\setup.ps1 tanpa perlu setup-lead.ps1."
