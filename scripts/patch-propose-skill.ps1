<#
.SYNOPSIS
  Menerapkan/menyegarkan patch skill openspec-propose
  (.claude/skills/openspec-propose/SKILL.md dan
  .agents/skills/openspec-propose/SKILL.md), DAN salinan command project-
  scoped milik store ini (.claude/commands/opsx/propose.md), supaya
  /opsx:propose maupun /openspec-propose (untuk agent non-Claude):
    1. mengklasifikasikan tipe change (fix/perf/workaround, atau tanpa tag
       untuk feature - default store ini), dan
    2. menghitung nomor urut change lewat scripts/next-change.ps1|.sh,
  alih-alih membiarkan agent menebak, lupa memberi nomor, atau tidak
  konsisten memberi tag tipe.

  CATATAN: sengaja TIDAK menyentuh command global (~/.claude/commands/opsx) -
  scripts/setup.ps1|.sh menyalin salinan project-scoped di atas ke
  <WorkspaceRoot>/.claude, bukan ke ~/.claude, justru supaya store OpenSpec
  berbeda di mesin yang sama tidak berebut satu file/folder global yang sama.
  Kalau file global itu masih ada (peninggalan setup versi lama), biarkan -
  jangan dipatch di sini, karena Claude Code selalu resolve ke situ dulu
  sebelum fallback ke .claude/ milik workspace mana pun; mem-patch-nya lagi
  cuma menghidupkan kembali masalah berebut file global yang sama.

.DESCRIPTION
  Dipanggil otomatis oleh setup-lead.ps1 sebagai bagian dari bootstrap store
  baru. Berdiri sendiri (tidak menyentuh schema atau registrasi store) supaya
  aman dijalankan ulang KAPAN PUN — termasuk setelah `openspec init ...
  -Force` menyegarkan skill ke versi vendor default, yang menghapus patch
  ini.

  Idempoten DAN self-upgrading: apa pun yang ada di antara baris "Choose one
  schema form below..." dan baris "Using the configured default:" dianggap
  milik patch ini dan ditulis ulang dari nol setiap kali script ini
  dijalankan - jadi memperbarui isi patch di script ini otomatis diterapkan
  ulang ke store manapun yang menjalankan versi terbaru script ini, tanpa
  perlu skema versi/marker terpisah.

.EXAMPLE
  .\scripts\patch-propose-skill.ps1
#>
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

$scriptsDir = $PSScriptRoot
$storeRoot = Split-Path -Parent $scriptsDir

function Patch-ProposeSkill {
    param([string]$Path)

    if (-not (Test-Path $Path)) { return }

    $before = Get-Content $Path -Raw

    $block = @'
   **Change type**: classify this change before computing its number - `fix` (correcting broken existing behavior), `perf` (speed or efficiency of existing behavior, no behavior change), `workaround` (an explicit temporary or stopgap measure, root cause deliberately not addressed yet), or omit entirely for a new feature or capability (the default and most common case for this store). Best effort only - if genuinely unclear, default to no tag rather than guessing; a developer can rename the change folder manually later if the tag turns out wrong.

   **Numbered change convention**: if `scripts/next-change.sh` or `scripts/next-change.ps1` exists at the store root, this store uses a three-digit sequential prefix, optionally followed by the type classified above (`001-foo`, `002-fix-bar`, `003-perf-baz`, `004-workaround-qux`) instead of a bare slug. Compute it before creating the change directory:
   ```bash
   ./scripts/next-change.sh "<name>" [--type fix|perf|workaround]                # Linux / macOS
   powershell -File ./scripts/next-change.ps1 -Slug "<name>" [-Type fix|perf|workaround]     # Windows
   ```
   Use the numbered output (e.g. `003-perf-<name>`) as `<name>` in the commands below, replacing the plain slug from step 1. If neither script exists, use the plain kebab-case name as-is.

'@

    # Toleran terhadap LF maupun CRLF - file skill ini dihasilkan OpenSpec CLI
    # (biasanya LF) tapi bisa saja tersentuh alat lain di Windows.
    $pattern = '(?ms)(^   Choose one schema form below\..*?\r?\n)\r?\n?.*?(?=^   Using the configured default:\r?\n)'
    if ($before -notmatch $pattern) {
        Write-Warning "$Path tidak punya baris anchor yang diharapkan - dilewati, periksa manual."
        return
    }

    $regex = [regex]::new($pattern)
    $after = $regex.Replace($before, { param($m) $m.Groups[1].Value + "`n" + $block }, 1)

    if ($before -eq $after) {
        Write-Host "      $Path sudah sesuai, dilewati."
    } else {
        Set-Content -Path $Path -Value $after -NoNewline
        Write-Host "      $Path ter-patch/diperbarui."
    }
}

Patch-ProposeSkill (Join-Path $storeRoot '.claude\skills\openspec-propose\SKILL.md')
Patch-ProposeSkill (Join-Path $storeRoot '.agents\skills\openspec-propose\SKILL.md')

# Salinan project-scoped milik store ini - sumber yang di-copy setup.ps1 ke
# <WorkspaceRoot>\.claude di tiap mesin. Lihat CATATAN di .SYNOPSIS soal
# kenapa command global (~/.claude) sengaja tidak disentuh di sini.
Patch-ProposeSkill (Join-Path $storeRoot '.claude\commands\opsx\propose.md')
