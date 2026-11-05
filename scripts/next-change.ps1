<#
.SYNOPSIS
  Menghitung nomor urut change berikutnya untuk store ini.

.DESCRIPTION
  Konvensi: setiap change diberi nomor urut tiga digit, 001-foo, 002-bar, dan
  seterusnya. OpenSpec tidak punya penomoran otomatis, jadi nomor dihitung
  dari change yang sudah ada.

  Pemindaian mencakup DUA tempat, karena `openspec archive` memindahkan change
  ke folder arsip sambil menambahkan prefix tanggal:
    openspec/changes/<NNN>-<slug>
    openspec/changes/archive/<YYYY-MM-DD>-<NNN>-<slug>
  Tanpa memindai arsip, nomor yang sudah terpakai bisa terpakai ulang.

.PARAMETER Slug
  Slug kebab-case untuk change baru. Bila diisi, script mencetak nama lengkap
  yang siap dipakai (mis. 003-manual-price-override) alih-alih hanya nomornya.

.PARAMETER Type
  Klasifikasi opsional, disisipkan tepat setelah nomor: "fix" (memperbaiki
  perilaku yang sudah ada dan salah/rusak), "perf" (kecepatan/efisiensi
  perilaku yang sudah ada, perilaku tidak berubah), atau "workaround" (solusi
  sementara/stopgap, root cause sengaja belum dibereskan). Tanpa -Type,
  change dianggap feature baru (default store ini) - tidak dapat tag.
  Klasifikasi ini best effort; salah tag tinggal rename manual folder-nya,
  tidak ada konsekuensi lain. Butuh -Slug.

.PARAMETER Create
  Langsung jalankan `openspec new change <nama>`. Perlu -Slug.

.EXAMPLE
  .\scripts\next-change.ps1
  003

.EXAMPLE
  .\scripts\next-change.ps1 -Slug lead-generation-journeys
  003-lead-generation-journeys

.EXAMPLE
  .\scripts\next-change.ps1 -Slug checkout-bug -Type fix
  003-fix-checkout-bug

.EXAMPLE
  .\scripts\next-change.ps1 -Slug lead-generation-journeys -Create
#>
[CmdletBinding()]
param(
    [string]$Slug,
    [ValidateSet('fix', 'perf', 'workaround')]
    [string]$Type,
    [switch]$Create
)

$ErrorActionPreference = 'Stop'

if ($Type -and -not $Slug) {
    throw "-Type butuh -Slug juga, mis. -Slug nama-perubahan -Type $Type"
}

$storeRoot = Split-Path -Parent $PSScriptRoot
$changesDir = Join-Path $storeRoot 'openspec\changes'
$archiveDir = Join-Path $changesDir 'archive'

if (-not (Test-Path $changesDir)) {
    throw "Folder changes tidak ditemukan di $changesDir. Jalankan script ini dari checkout store OpenSpec."
}

$numbers = New-Object System.Collections.Generic.List[int]

# Change aktif: <NNN>-<slug>
Get-ChildItem -Path $changesDir -Directory | Where-Object { $_.Name -ne 'archive' } | ForEach-Object {
    if ($_.Name -match '^(\d{3})-') { $numbers.Add([int]$Matches[1]) }
}

# Change terarsip: <YYYY-MM-DD>-<NNN>-<slug>
if (Test-Path $archiveDir) {
    Get-ChildItem -Path $archiveDir -Directory | ForEach-Object {
        if ($_.Name -match '^\d{4}-\d{2}-\d{2}-(\d{3})-') { $numbers.Add([int]$Matches[1]) }
    }
}

# Measure-Object mengembalikan double; format D3 hanya menerima tipe integral.
if ($numbers.Count -eq 0) { $next = 1 } else { $next = [int]($numbers | Measure-Object -Maximum).Maximum + 1 }

if ($next -gt 999) {
    throw "Nomor change sudah mencapai 999. Perluas konvensi ke empat digit sebelum melanjutkan."
}

$padded = '{0:D3}' -f $next

if (-not $Slug) {
    Write-Output $padded
    return
}

if ($Slug -notmatch '^[a-z0-9]+(?:-[a-z0-9]+)*$') {
    throw "Slug '$Slug' tidak valid. Pakai kebab-case: huruf kecil, angka, dan tanda hubung tunggal."
}

if ($Type) {
    $name = "$padded-$Type-$Slug"
} else {
    $name = "$padded-$Slug"
}

if ($Create) {
    Write-Host "Membuat change '$name'..."
    openspec new change $name
} else {
    Write-Output $name
}
