#!/usr/bin/env bash
#
# Menyiapkan sebuah OpenSpec store pada satu mesin. Jalankan sekali per mesin.
#
# Script ini tidak terikat pada satu proyek: id store dan nama schema dibaca dari
# store tempat script berada, sehingga dapat disalin apa adanya ke store lain.
# Padanan POSIX dari scripts/setup.ps1 — perilaku dan keluarannya dijaga sama.
#
# Tiga hal yang tidak dapat dibagikan lewat Git dan karenanya dikerjakan di sini:
#
#   1. Registrasi store. Registry OpenSpec bersifat lokal per mesin.
#   2. Pointer di root workspace. File ini sengaja TIDAK di-commit ke repo mana
#      pun: root workspace umumnya bukan repo Git, dan menjadikannya repo akan
#      membuat repo kode tersarang di dalam working tree-nya.
#   3. Slash command dan skill Claude Code, dipasang di ROOT WORKSPACE
#      (<workspace_root>/.claude), bukan di ~/.claude (user-level). Claude Code
#      selalu resolve command ke ~/.claude dulu bila ada, baru fallback ke
#      .claude/ milik folder proyek terdekat - dipasang di root workspace (bukan
#      tiap repo client) supaya /opsx:* tetap tersedia dari repo kode mana pun di
#      bawahnya tanpa menambah .claude/ ke repo itu sendiri, DAN supaya asset
#      store ini tidak saling menimpa dengan asset store OpenSpec lain di root
#      workspace berbeda pada mesin yang sama (dulu keduanya sama-sama menulis
#      ke ~/.claude). Asset lama di ~/.claude tetap mengalahkan mirror ini
#      selama masih ada - script memperingatkan, tidak menghapus otomatis.
#
# Pemakaian:
#   ./scripts/setup.sh
#   ./scripts/setup.sh --workspace-root /path/ke/folder-repo
#   ./scripts/setup.sh --force
#   ./scripts/setup.sh --skip-claude-assets

set -euo pipefail

workspace_root=""
force=0
skip_claude_assets=0

while [ $# -gt 0 ]; do
  case "$1" in
    --workspace-root)
      [ $# -ge 2 ] || { echo "Error: --workspace-root membutuhkan nilai." >&2; exit 1; }
      workspace_root="$2"; shift 2 ;;
    --workspace-root=*) workspace_root="${1#*=}"; shift ;;
    --force) force=1; shift ;;
    --skip-claude-assets) skip_claude_assets=1; shift ;;
    -h|--help) sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Error: opsi tidak dikenal: $1" >&2; exit 1 ;;
  esac
done

script_dir=$(cd "$(dirname "$0")" && pwd)
store_root=$(dirname "$script_dir")

# --- Id store dan schema diturunkan dari store, bukan ditulis mati -----------
metadata_path="$store_root/.openspec-store/store.yaml"
if [ ! -f "$metadata_path" ]; then
  echo "Error: ini bukan checkout store OpenSpec: $metadata_path tidak ditemukan." >&2
  echo "Jalankan script dari dalam folder store." >&2
  exit 1
fi

store_id=$(sed -n 's/^id:[[:space:]]*\(.*\)$/\1/p' "$metadata_path" | head -n1 | tr -d '"'"'"' \r')
if [ -z "$store_id" ]; then
  echo "Error: tidak dapat membaca 'id' dari $metadata_path." >&2
  exit 1
fi

schema_name=""
store_config="$store_root/openspec/config.yaml"
if [ -f "$store_config" ]; then
  schema_name=$(sed -n 's/^schema:[[:space:]]*\(.*\)$/\1/p' "$store_config" | head -n1 | tr -d '"'"'"' \r')
fi
[ -n "$schema_name" ] || schema_name="spec-driven"

# --- Folder workspace -------------------------------------------------------
[ -n "$workspace_root" ] || workspace_root=$(dirname "$store_root")
if [ ! -d "$workspace_root" ]; then
  echo "Error: folder workspace tidak ditemukan: $workspace_root" >&2
  exit 1
fi
workspace_root=$(cd "$workspace_root" && pwd)

# Pointer hanya berguna bila menaungi repo kode. Struktur folder tiap orang
# berbeda, jadi tebakan default (folder induk store) harus diverifikasi: pointer
# yang ditulis di folder salah tetap "berhasil" dibuat tetapi tidak menaungi
# apa pun.
#
# Penelusuran berhenti begitu sebuah folder dikenali sebagai repo, sehingga isi
# repo tidak ikut dijelajahi. Batas kedalaman hanya pengaman terhadap pohon
# folder yang tidak wajar; resolusi OpenSpec sendiri tidak punya batas ini.
max_scan_depth=5
skip_dir_names="node_modules vendor dist build target .venv __pycache__"

count_git_repos() {
  local path="$1" depth="$2" found=0 entry name
  [ "$depth" -le "$max_scan_depth" ] || { echo 0; return; }
  for entry in "$path"/*/; do
    [ -d "$entry" ] || continue
    entry="${entry%/}"
    [ "$entry" != "$store_root" ] || continue
    name=$(basename "$entry")
    case "$name" in .*) continue ;; esac
    case " $skip_dir_names " in *" $name "*) continue ;; esac
    if [ -e "$entry/.git" ]; then
      found=$((found + 1))
      continue
    fi
    found=$((found + $(count_git_repos "$entry" $((depth + 1)))))
  done
  echo "$found"
}

covered_repos=$(count_git_repos "$workspace_root" 1)

echo "Store    : $store_id ($store_root)"
echo "Workspace: $workspace_root"
echo "Schema   : $schema_name"
echo "Repo      : $covered_repos repo Git di bawah workspace"
echo ""

if [ "$covered_repos" -eq 0 ]; then
  echo "PERINGATAN: tidak ditemukan satu pun repo Git di bawah $workspace_root." >&2
  echo "PERINGATAN: pointer akan dibuat, tetapi kemungkinan besar tidak menaungi repo kode mana pun." >&2
  echo "PERINGATAN: bila store ini di-clone terpisah dari repo kode, ulangi dengan folder yang benar:" >&2
  echo "PERINGATAN:   ./scripts/setup.sh --workspace-root <folder yang memuat repo kode>" >&2
  echo "PERINGATAN: repo yang tersebar di beberapa folder induk: jalankan sekali per folder induk." >&2
  echo ""
fi

# --- 1. Registrasi store ----------------------------------------------------
echo "[1/3] Mendaftarkan store '$store_id'..."

registered=0
if list_json=$(openspec store list --json 2>/dev/null); then
  case "$list_json" in *"\"$store_id\""*) registered=1 ;; esac
fi

if [ "$registered" -eq 1 ]; then
  echo "      sudah terdaftar, dilewati."
else
  if ! openspec store register "$store_root" --id "$store_id"; then
    echo "Error: registrasi store gagal. Bila id sudah dipakai checkout lain," >&2
    echo "jalankan 'openspec store unregister $store_id' lebih dulu." >&2
    exit 1
  fi
fi

# --- 2. Pointer di root workspace -------------------------------------------
echo "[2/3] Menulis pointer di root workspace..."

pointer_dir="$workspace_root/openspec"
pointer_path="$pointer_dir/config.yaml"

# Pointer hanya dibaca bila folder openspec/ bersifat config-only. Folder yang
# sudah punya specs/ atau changes/ adalah root planning sungguhan.
for shape in specs changes; do
  if [ -d "$pointer_dir/$shape" ]; then
    echo "Error: $pointer_dir sudah berisi '$shape' sehingga merupakan root OpenSpec" >&2
    echo "sungguhan, bukan pointer. Hentikan dan periksa manual." >&2
    exit 1
  fi
done

pointer_content="# Pointer OpenSpec untuk workspace ini.
#
# File ini menunjuk seluruh repo di bawah folder ini ke store '$store_id',
# sehingga perintah openspec dapat dijalankan dari dalam repo kode tanpa
# flag --store dan tanpa menambah file apa pun di repo tersebut.
#
# Dihasilkan oleh script setup di store $store_id - bersifat lokal per mesin,
# jangan di-commit ke repo mana pun.
schema: $schema_name
store: $store_id"

# Normalisasi sebelum membandingkan: BOM dan CRLF tidak boleh dianggap
# perbedaan isi, supaya pointer yang ditulis versi PowerShell tidak dilaporkan
# berbeda oleh versi ini.
normalize() {
  sed '1s/^\xEF\xBB\xBF//' "$1" | tr -d '\r'
}

if [ -f "$pointer_path" ]; then
  if [ "$(normalize "$pointer_path")" = "$(printf '%s' "$pointer_content" | tr -d '\r')" ]; then
    echo "      sudah sesuai, dilewati."
  elif [ "$force" -eq 1 ]; then
    printf '%s\n' "$pointer_content" > "$pointer_path"
    echo "      ditimpa (--force)."
  else
    echo "PERINGATAN: pointer sudah ada dengan isi berbeda: $pointer_path" >&2
    echo "PERINGATAN: periksa isinya, lalu jalankan ulang dengan --force bila memang ingin ditimpa." >&2
  fi
else
  mkdir -p "$pointer_dir"
  printf '%s\n' "$pointer_content" > "$pointer_path"
  echo "      dibuat: $pointer_path"
fi

if [ -e "$workspace_root/.git" ]; then
  echo "PERINGATAN: root workspace adalah repo Git. Tambahkan 'openspec/' ke .gitignore" >&2
  echo "PERINGATAN: atau .git/info/exclude agar pointer tidak ikut ter-commit." >&2
fi

# --- 3. Asset Claude Code di root workspace ---------------------------------
echo "[3/3] Memasang asset Claude Code di root workspace..."

if [ "$skip_claude_assets" -eq 1 ]; then
  echo "      dilewati (--skip-claude-assets)."
else
  workspace_claude="$workspace_root/.claude"
  installed=0
  skipped=0
  conflicts=""

  install_asset() {
    local source="$1" target="$2" label="$3"
    [ -d "$source" ] || return 0
    if [ -d "$target" ]; then
      if diff -r -q "$source" "$target" >/dev/null 2>&1; then
        skipped=$((skipped + 1)); return 0
      fi
      if [ "$force" -ne 1 ]; then
        conflicts="$conflicts $label"; return 0
      fi
      rm -rf "$target"
    fi
    mkdir -p "$(dirname "$target")"
    cp -r "$source" "$target"
    installed=$((installed + 1))
  }

  install_asset "$store_root/.claude/commands/opsx" "$workspace_claude/commands/opsx" "commands/opsx"
  for skill_dir in "$store_root"/.claude/skills/openspec-*/; do
    [ -d "$skill_dir" ] || continue
    skill_dir="${skill_dir%/}"
    skill_name=$(basename "$skill_dir")
    install_asset "$skill_dir" "$workspace_claude/skills/$skill_name" "skills/$skill_name"
  done

  echo "      dipasang: $installed, sudah sesuai: $skipped"
  if [ -n "$conflicts" ]; then
    echo "PERINGATAN: asset berikut sudah ada dengan isi berbeda dan dibiarkan apa adanya:$conflicts" >&2
    echo "PERINGATAN: jalankan ulang dengan --force bila ingin menimpanya dengan versi dari store ini." >&2
  fi

  if [ -e "$workspace_root/.git" ]; then
    echo "PERINGATAN: root workspace adalah repo Git. Tambahkan '.claude/' ke .gitignore" >&2
    echo "PERINGATAN: atau .git/info/exclude agar asset ini tidak ikut ter-commit." >&2
  fi

  # Asset lama di ~/.claude (versi setup.sh sebelum ini memasang di sana) TETAP
  # MENGALAHKAN mirror yang baru saja dipasang di atas, karena Claude Code selalu
  # resolve command/skill ke ~/.claude dulu bila ada sebelum fallback ke .claude/
  # milik proyek. Cuma warning, tidak dihapus otomatis - folder ini global lintas
  # semua workspace OpenSpec di mesin ini, mungkin masih dipakai workspace lain
  # yang belum pindah ke skema root-workspace ini.
  legacy_global_claude="$HOME/.claude"
  legacy_global_command="$legacy_global_claude/commands/opsx"
  legacy_global_skills=""
  for skill_dir in "$legacy_global_claude"/skills/openspec-*/; do
    [ -d "$skill_dir" ] || continue
    legacy_global_skills="$legacy_global_skills ${skill_dir%/}"
  done
  if [ -d "$legacy_global_command" ] || [ -n "$legacy_global_skills" ]; then
    echo "PERINGATAN: ditemukan asset OpenSpec lama di user-level ($legacy_global_claude) -" >&2
    echo "PERINGATAN: INI AKAN MENGALAHKAN mirror yang baru saja dipasang di $workspace_claude, selama masih ada." >&2
    echo "PERINGATAN: hapus manual (pastikan tidak ada workspace OpenSpec lain di mesin ini yang" >&2
    echo "PERINGATAN: masih mengandalkannya) supaya /opsx:* memakai versi workspace ini:" >&2
    [ -d "$legacy_global_command" ] && echo "PERINGATAN:   rm -rf '$legacy_global_command'" >&2
    for skill_path in $legacy_global_skills; do
      echo "PERINGATAN:   rm -rf '$skill_path'" >&2
    done
  fi
fi

echo ""
echo "Selesai. Verifikasi dengan menjalankan dari dalam salah satu repo kode:"
echo "  openspec context"
echo "Keluarannya harus menyebut: Using OpenSpec root: $store_id"
echo ""
echo "Di sesi Claude Code berikutnya, /opsx:propose dan seterusnya sudah tersedia."
