#!/usr/bin/env bash
#
# Menerapkan/menyegarkan patch skill openspec-propose
# (.claude/skills/openspec-propose/SKILL.md dan .agents/skills/openspec-propose/SKILL.md),
# DAN salinan command project-scoped milik store ini
# (.claude/commands/opsx/propose.md), supaya /opsx:propose maupun
# /openspec-propose (untuk agent non-Claude):
#   1. mengklasifikasikan tipe change (fix/perf/workaround, atau tanpa tag
#      untuk feature - default store ini), dan
#   2. menghitung nomor urut change lewat scripts/next-change.sh|.ps1,
# alih-alih membiarkan agent menebak, lupa memberi nomor, atau tidak
# konsisten memberi tag tipe.
#
# CATATAN: sengaja TIDAK menyentuh command global (~/.claude/commands/opsx) -
# scripts/setup.ps1|.sh menyalin salinan project-scoped di atas ke
# <workspace_root>/.claude, bukan ke ~/.claude, justru supaya store OpenSpec
# berbeda di mesin yang sama tidak berebut satu file/folder global yang sama.
# Kalau file global itu masih ada (peninggalan setup versi lama), biarkan -
# jangan dipatch di sini, karena Claude Code selalu resolve ke situ dulu
# sebelum fallback ke .claude/ milik workspace mana pun; mem-patch-nya lagi
# cuma menghidupkan kembali masalah berebut file global yang sama.
#
# Dipanggil otomatis oleh setup-lead.sh sebagai bagian dari bootstrap store
# baru. Berdiri sendiri (tidak menyentuh schema atau registrasi store) supaya
# aman dijalankan ulang KAPAN PUN — termasuk setelah `openspec init ...
# --force` menyegarkan skill ke versi vendor default, yang menghapus patch
# ini.
#
# Idempoten DAN self-upgrading: apa pun yang ada di antara baris "Choose one
# schema form below..." dan baris "Using the configured default:" dianggap
# milik patch ini dan ditulis ulang dari nol setiap kali script ini
# dijalankan - jadi memperbarui isi patch di script ini otomatis diterapkan
# ulang ke store manapun yang menjalankan versi terbaru script ini, tanpa
# perlu skema versi/marker terpisah.
#
# Pemakaian:
#   ./scripts/patch-propose-skill.sh

set -euo pipefail

script_dir=$(cd "$(dirname "$0")" && pwd)
store_root=$(dirname "$script_dir")

patch_one() {
  local file="$1"
  [ -f "$file" ] || return 0

  local before after
  before=$(cat "$file")

  if ! awk '
    /^   Choose one schema form below\./ { print; mode = 1; next }
    mode == 1 && /^   Using the configured default:$/ {
      print ""
      print "   **Change type**: classify this change before computing its number - `fix` (correcting broken existing behavior), `perf` (speed or efficiency of existing behavior, no behavior change), `workaround` (an explicit temporary or stopgap measure, root cause deliberately not addressed yet), or omit entirely for a new feature or capability (the default and most common case for this store). Best effort only - if genuinely unclear, default to no tag rather than guessing; a developer can rename the change folder manually later if the tag turns out wrong."
      print ""
      print "   **Numbered change convention**: if `scripts/next-change.sh` or `scripts/next-change.ps1` exists at the store root, this store uses a three-digit sequential prefix, optionally followed by the type classified above (`001-foo`, `002-fix-bar`, `003-perf-baz`, `004-workaround-qux`) instead of a bare slug. Compute it before creating the change directory:"
      print "   ```bash"
      print "   ./scripts/next-change.sh \"<name>\" [--type fix|perf|workaround]                # Linux / macOS"
      print "   powershell -File ./scripts/next-change.ps1 -Slug \"<name>\" [-Type fix|perf|workaround]     # Windows"
      print "   ```"
      print "   Use the numbered output (e.g. `003-perf-<name>`) as `<name>` in the commands below, replacing the plain slug from step 1. If neither script exists, use the plain kebab-case name as-is."
      print ""
      print $0
      mode = 0
      found = 1
      next
    }
    mode == 1 { next }
    { print }
    END { if (!found) exit 1 }
  ' "$file" > "$file.tmp"; then
    rm -f "$file.tmp"
    echo "      PERINGATAN: $file tidak punya baris anchor yang diharapkan - dilewati, periksa manual." >&2
    return 0
  fi

  mv "$file.tmp" "$file"
  after=$(cat "$file")
  if [ "$before" = "$after" ]; then
    echo "      $file sudah sesuai, dilewati."
  else
    echo "      $file ter-patch/diperbarui."
  fi
}

patch_one "$store_root/.claude/skills/openspec-propose/SKILL.md"
patch_one "$store_root/.agents/skills/openspec-propose/SKILL.md"

# Salinan project-scoped milik store ini - sumber yang di-copy setup.sh ke
# <workspace_root>/.claude di tiap mesin. Lihat CATATAN di header soal kenapa
# command global (~/.claude) sengaja tidak disentuh di sini.
patch_one "$store_root/.claude/commands/opsx/propose.md"
