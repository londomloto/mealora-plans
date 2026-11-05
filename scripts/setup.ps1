<#
.SYNOPSIS
  Menyiapkan sebuah OpenSpec store pada satu mesin. Jalankan sekali per mesin.

  Script ini tidak terikat pada satu proyek: id store dan nama schema dibaca dari
  store tempat script berada, sehingga dapat disalin apa adanya ke store lain.

.DESCRIPTION
  Dua hal yang tidak dapat dibagikan lewat Git dan karenanya harus dikerjakan
  per mesin:

    1. Registrasi store. Registry OpenSpec bersifat lokal
       (%LOCALAPPDATA%\openspec). Pointer membagikan *arah* store, bukan
       *registrasi*-nya.
    2. Pointer di root workspace. File ini sengaja TIDAK di-commit ke repo mana
       pun: root workspace bukan repo Git, dan menjadikannya repo akan membuat
       15 repo client tersarang di dalam working tree-nya.
    3. Slash command dan skill Claude Code, dipasang di ROOT WORKSPACE
       (<WorkspaceRoot>\.claude), bukan di ~/.claude (user-level). Claude Code
       selalu resolve command ke ~/.claude dulu bila ada di sana, baru fallback
       ke .claude/ milik folder proyek terdekat - dipasang di root workspace
       (bukan tiap repo client) supaya /opsx:* tetap tersedia dari repo kode
       mana pun di bawahnya tanpa menambah .claude/ ke repo itu sendiri, DAN
       supaya asset store ini tidak menimpa/tertimpa asset store OpenSpec lain
       di root workspace yang berbeda pada mesin yang sama (dulu keduanya sama-
       sama menulis ke ~/.claude, jadi saling berebut satu file/folder yang
       sama). Bila ~/.claude masih punya asset dari instalasi versi lama, script
       ini memperingatkan - asset itu HARUS dihapus manual, karena tetap akan
       mengalahkan mirror di root workspace selama masih ada.

  Setelah script ini dijalankan, perintah openspec dapat dijalankan dari dalam
  repo mana pun di bawah root workspace tanpa flag --store, dan tidak ada satu
  file pun bertambah di repo service maupun devops.

.PARAMETER WorkspaceRoot
  Folder yang memuat repo kode. Default: folder induk dari checkout store ini
  (mis. store di D:\...\myproject\myproject-plans -> workspace D:\...\myproject).

  Default itu hanya tebakan. Bila store di-clone terpisah dari repo kode,
  tunjuk foldernya secara eksplisit. Script menghitung berapa repo Git yang
  benar-benar ternaungi (sampai kedalaman 5, berhenti di batas tiap repo) dan
  memperingatkan bila nol.

  Repo yang tersebar di beberapa folder induk tidak dapat dinaungi satu pointer;
  jalankan script sekali per folder induk.

.PARAMETER Force
  Timpa pointer dan asset Claude yang sudah ada bila isinya berbeda.

.PARAMETER SkipClaudeAssets
  Lewati pemasangan slash command dan skill Claude Code di root workspace.
  Pakai bila Anda tidak memakai Claude Code.

.EXAMPLE
  .\scripts\setup.ps1

.EXAMPLE
  .\scripts\setup.ps1 -WorkspaceRoot D:\Workspaces\projects\myproject
#>
[CmdletBinding()]
param(
    [string]$WorkspaceRoot,
    [switch]$Force,
    [switch]$SkipClaudeAssets
)

$ErrorActionPreference = 'Stop'

$storeRoot = Split-Path -Parent $PSScriptRoot

# Id store dan nama schema diturunkan dari store itu sendiri, bukan ditulis mati,
# supaya script ini dapat disalin apa adanya ke store OpenSpec mana pun.
$metadataPath = Join-Path $storeRoot '.openspec-store\store.yaml'
if (-not (Test-Path $metadataPath)) {
    throw "Ini bukan checkout store OpenSpec: $metadataPath tidak ditemukan. Jalankan script dari dalam folder store."
}

$storeId = $null
foreach ($line in Get-Content $metadataPath) {
    if ($line -match '^id:\s*(\S.*?)\s*$') { $storeId = $Matches[1].Trim('"', "'"); break }
}
if (-not $storeId) {
    throw "Tidak dapat membaca 'id' dari $metadataPath."
}

$storeConfigPath = Join-Path $storeRoot 'openspec\config.yaml'
$schemaName = $null
if (Test-Path $storeConfigPath) {
    foreach ($line in Get-Content $storeConfigPath) {
        if ($line -match '^schema:\s*(\S.*?)\s*$') { $schemaName = $Matches[1].Trim('"', "'"); break }
    }
}
if (-not $schemaName) { $schemaName = 'spec-driven' }

if (-not $WorkspaceRoot) {
    $WorkspaceRoot = Split-Path -Parent $storeRoot
}
if (-not (Test-Path $WorkspaceRoot)) {
    throw "Folder workspace tidak ditemukan: $WorkspaceRoot"
}
$WorkspaceRoot = (Resolve-Path $WorkspaceRoot).Path

# Pointer hanya berguna bila menaungi repo kode. Struktur folder tiap orang
# berbeda, jadi tebakan default (folder induk store) harus diverifikasi, bukan
# dipercaya begitu saja: pointer yang ditulis di folder salah tetap "berhasil"
# dibuat tetapi tidak menaungi apa pun.
#
# Penelusuran berhenti begitu sebuah folder dikenali sebagai repo, sehingga isi
# repo tidak ikut dijelajahi. Batas kedalaman hanya pengaman terhadap pohon
# folder yang tidak wajar; resolusi OpenSpec sendiri tidak punya batas ini.
$maxScanDepth = 5
$skipDirNames = @('node_modules', 'vendor', 'dist', 'build', 'target', '.venv', '__pycache__')

function Measure-GitRepo {
    param([string]$Path, [int]$Depth, [string]$ExcludePath)

    if ($Depth -gt $script:maxScanDepth) { return 0 }
    $found = 0
    foreach ($dir in (Get-ChildItem -Path $Path -Directory -Force -ErrorAction SilentlyContinue)) {
        if ($dir.FullName -eq $ExcludePath) { continue }
        if ($dir.Name.StartsWith('.') -or $script:skipDirNames -contains $dir.Name) { continue }
        if (Test-Path (Join-Path $dir.FullName '.git')) {
            $found++
            continue
        }
        $found += Measure-GitRepo -Path $dir.FullName -Depth ($Depth + 1) -ExcludePath $ExcludePath
    }
    return $found
}

$coveredRepos = Measure-GitRepo -Path $WorkspaceRoot -Depth 1 -ExcludePath $storeRoot

Write-Host "Store    : $storeId ($storeRoot)"
Write-Host "Workspace: $WorkspaceRoot"
Write-Host "Schema   : $schemaName"
Write-Host "Repo      : $coveredRepos repo Git di bawah workspace"
Write-Host ""

if ($coveredRepos -eq 0) {
    Write-Warning "Tidak ditemukan satu pun repo Git di bawah $WorkspaceRoot."
    Write-Warning "Pointer akan dibuat, tetapi kemungkinan besar tidak menaungi repo kode mana pun."
    Write-Warning "Bila store ini di-clone terpisah dari repo kode, ulangi dengan folder yang benar:"
    Write-Warning "  .\scripts\setup.ps1 -WorkspaceRoot <folder yang memuat repo kode>"
    Write-Warning "Repo yang tersebar di beberapa folder induk: jalankan sekali per folder induk."
    Write-Host ""
}

# --- 1. Registrasi store (lokal per mesin) ---------------------------------
Write-Host "[1/3] Mendaftarkan store '$storeId'..."

$registered = $false
try {
    $listJson = openspec store list --json 2>$null
    if ($LASTEXITCODE -eq 0 -and $listJson) {
        $parsed = $listJson | ConvertFrom-Json
        foreach ($entry in @($parsed.stores)) {
            if ($entry.id -eq $storeId) { $registered = $true }
        }
    }
} catch {
    # Daftar tidak terbaca; biarkan perintah register di bawah yang melapor.
}

if ($registered) {
    Write-Host "      sudah terdaftar, dilewati."
} else {
    openspec store register $storeRoot --id $storeId
    if ($LASTEXITCODE -ne 0) {
        throw "Registrasi store gagal. Bila id sudah dipakai checkout lain, jalankan 'openspec store unregister $storeId' lebih dulu."
    }
}

# --- 2. Pointer di root workspace ------------------------------------------
Write-Host "[2/3] Menulis pointer di root workspace..."

$pointerDir = Join-Path $WorkspaceRoot 'openspec'
$pointerPath = Join-Path $pointerDir 'config.yaml'

# Pointer hanya dibaca bila folder openspec/ bersifat config-only. Folder yang
# sudah punya specs/ atau changes/ adalah root planning sungguhan dan tidak
# boleh ditimpa.
foreach ($shape in @('specs', 'changes')) {
    if (Test-Path (Join-Path $pointerDir $shape)) {
        throw "$pointerDir sudah berisi '$shape' sehingga merupakan root OpenSpec sungguhan, bukan pointer. Hentikan dan periksa manual."
    }
}

$pointerContent = @"
# Pointer OpenSpec untuk workspace ini.
#
# File ini menunjuk seluruh repo di bawah folder ini ke store '$storeId',
# sehingga perintah openspec dapat dijalankan dari dalam repo kode tanpa
# flag --store dan tanpa menambah file apa pun di repo tersebut.
#
# Dihasilkan oleh script setup di store $storeId - bersifat lokal per mesin,
# jangan di-commit ke repo mana pun.
schema: $schemaName
store: $storeId
"@

# Ditulis UTF-8 TANPA BOM dan dibandingkan setelah dinormalisasi, supaya pointer
# yang dihasilkan setup.sh di Linux dan setup.ps1 di Windows benar-benar identik
# dan tidak saling dilaporkan "berbeda".
function Write-TextNoBom {
    param([string]$Path, [string]$Content)
    [System.IO.File]::WriteAllText($Path, ($Content -replace "`r`n", "`n") + "`n", (New-Object System.Text.UTF8Encoding $false))
}
function Get-NormalizedText {
    param([string]$Path)
    $raw = [System.IO.File]::ReadAllText($Path)
    return ($raw -replace "^﻿", "" -replace "`r`n", "`n").Trim()
}

if (Test-Path $pointerPath) {
    if ((Get-NormalizedText $pointerPath) -eq ($pointerContent -replace "`r`n", "`n").Trim()) {
        Write-Host "      sudah sesuai, dilewati."
    } elseif ($Force) {
        Write-TextNoBom -Path $pointerPath -Content $pointerContent
        Write-Host "      ditimpa (-Force)."
    } else {
        Write-Warning "Pointer sudah ada dengan isi berbeda: $pointerPath"
        Write-Warning "Periksa isinya, lalu jalankan ulang dengan -Force bila memang ingin ditimpa."
    }
} else {
    if (-not (Test-Path $pointerDir)) {
        New-Item -ItemType Directory -Path $pointerDir | Out-Null
    }
    Write-TextNoBom -Path $pointerPath -Content $pointerContent
    Write-Host "      dibuat: $pointerPath"
}

# Peringatan bila root workspace ternyata sebuah repo Git - pointer akan muncul
# sebagai file untracked di sana.
if (Test-Path (Join-Path $WorkspaceRoot '.git')) {
    Write-Warning "Root workspace adalah repo Git. Tambahkan 'openspec/' ke .gitignore atau .git/info/exclude agar pointer tidak ikut ter-commit."
}

# --- 3. Slash command dan skill Claude Code di root workspace ---------------
Write-Host "[3/3] Memasang asset Claude Code di root workspace..."

if ($SkipClaudeAssets) {
    Write-Host "      dilewati (-SkipClaudeAssets)."
} else {
    $workspaceClaude = Join-Path $WorkspaceRoot '.claude'

    # Asset ini dihasilkan `openspec init --tools claude` di dalam store. Disalin ke
    # ROOT WORKSPACE (bukan ~/.claude) supaya /opsx:* tersedia dari repo mana pun
    # di bawah workspace ini tanpa menambah .claude/ ke repo milik client, dan
    # tanpa menimpa/tertimpa asset store OpenSpec lain di root workspace berbeda
    # pada mesin yang sama. Lihat peringatan asset lama di ~/.claude di bawah -
    # itu tetap mengalahkan mirror ini selama masih ada.
    $assetPairs = @(
        @{ Source = Join-Path $storeRoot '.claude\commands\opsx'; Target = Join-Path $workspaceClaude 'commands\opsx'; Label = 'commands/opsx' }
    )
    foreach ($skillDir in Get-ChildItem -Path (Join-Path $storeRoot '.claude\skills') -Directory -Filter 'openspec-*' -ErrorAction SilentlyContinue) {
        $assetPairs += @{
            Source = $skillDir.FullName
            Target = Join-Path $workspaceClaude (Join-Path 'skills' $skillDir.Name)
            Label  = 'skills/' + $skillDir.Name
        }
    }

    $installed = 0
    $skipped = 0
    $conflicts = @()

    foreach ($pair in $assetPairs) {
        if (-not (Test-Path $pair.Source)) { continue }

        if (Test-Path $pair.Target) {
            # Bandingkan isi; asset ini milik OpenSpec, tapi bisa saja sudah diedit user.
            # Urutkan berdasarkan path relatif, bukan nama saja: file bernama sama di
            # subfolder berbeda tidak boleh terpasangkan keliru.
            $sourceFiles = @(Get-ChildItem -Path $pair.Source -Recurse -File |
                Sort-Object { $_.FullName.Substring($pair.Source.Length) })
            $targetFiles = @(Get-ChildItem -Path $pair.Target -Recurse -File |
                Sort-Object { $_.FullName.Substring($pair.Target.Length) })
            $identical = $sourceFiles.Count -eq $targetFiles.Count
            if ($identical) {
                for ($i = 0; $i -lt $sourceFiles.Count; $i++) {
                    if ((Get-FileHash $sourceFiles[$i].FullName).Hash -ne (Get-FileHash $targetFiles[$i].FullName).Hash) {
                        $identical = $false
                        break
                    }
                }
            }
            if ($identical) { $skipped++; continue }
            if (-not $Force) { $conflicts += $pair.Label; continue }
            Remove-Item -Path $pair.Target -Recurse -Force
        }

        $parent = Split-Path -Parent $pair.Target
        if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
        Copy-Item -Path $pair.Source -Destination $pair.Target -Recurse
        $installed++
    }

    Write-Host "      dipasang: $installed, sudah sesuai: $skipped"
    if ($conflicts.Count -gt 0) {
        Write-Warning ("Asset berikut sudah ada dengan isi berbeda dan dibiarkan apa adanya: " + ($conflicts -join ', '))
        Write-Warning "Jalankan ulang dengan -Force bila ingin menimpanya dengan versi dari store ini."
    }

    # Peringatan bila root workspace ternyata sebuah repo Git - asset akan muncul
    # sebagai file untracked di sana, sama seperti pointer openspec/.
    if (Test-Path (Join-Path $WorkspaceRoot '.git')) {
        Write-Warning "Root workspace adalah repo Git. Tambahkan '.claude/' ke .gitignore atau .git/info/exclude agar asset ini tidak ikut ter-commit."
    }

    # Asset lama di ~/.claude (versi setup.ps1 sebelum ini memasang di sana) TETAP
    # MENGALAHKAN mirror yang baru saja dipasang di atas, karena Claude Code selalu
    # resolve command/skill ke ~/.claude dulu bila ada sebelum fallback ke .claude/
    # milik proyek. Cuma warning, tidak dihapus otomatis - folder ini global lintas
    # semua workspace OpenSpec di mesin ini, mungkin masih dipakai workspace lain
    # yang belum pindah ke skema root-workspace ini.
    $legacyGlobalClaude = Join-Path $env:USERPROFILE '.claude'
    $legacyGlobalCommand = Join-Path $legacyGlobalClaude 'commands\opsx'
    $legacyGlobalSkillsDir = Join-Path $legacyGlobalClaude 'skills'
    $legacyGlobalSkills = @(Get-ChildItem -Path $legacyGlobalSkillsDir -Directory -Filter 'openspec-*' -ErrorAction SilentlyContinue)
    if ((Test-Path $legacyGlobalCommand) -or $legacyGlobalSkills.Count -gt 0) {
        Write-Warning "Ditemukan asset OpenSpec lama di user-level ($legacyGlobalClaude) - INI AKAN MENGALAHKAN mirror yang baru saja dipasang di $workspaceClaude, selama masih ada."
        Write-Warning "Hapus manual (pastikan tidak ada workspace OpenSpec lain di mesin ini yang masih mengandalkannya) supaya /opsx:* memakai versi workspace ini:"
        Write-Warning "  Remove-Item -Recurse -Force '$legacyGlobalCommand'"
        foreach ($legacySkill in $legacyGlobalSkills) {
            Write-Warning "  Remove-Item -Recurse -Force '$($legacySkill.FullName)'"
        }
    }
}

Write-Host ""
Write-Host "Selesai. Verifikasi dengan menjalankan dari dalam salah satu repo service:"
Write-Host "  openspec context"
Write-Host "Keluarannya harus menyebut: Using OpenSpec root: $storeId"
Write-Host ""
Write-Host "Di sesi Claude Code berikutnya, /opsx:propose dan seterusnya sudah tersedia."

