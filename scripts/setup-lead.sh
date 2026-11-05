#!/usr/bin/env bash
#
# Menyiapkan store OpenSpec BARU dari checkout kosong (mis. tim lead baru saja
# membuat repo git plan kosong dan menyalin folder scripts/ ini dari repo
# template ini). Jalankan SEKALI per store, oleh satu orang, sebelum
# scripts/setup.sh bisa dipakai siapa pun (termasuk oleh orang yang sama).
# Padanan POSIX dari scripts/setup-lead.ps1 — perilaku dan keluarannya dijaga sama.
#
# scripts/setup.sh mengasumsikan store sudah punya struktur openspec/ dan
# identitas store (.openspec-store/store.yaml). Checkout yang benar-benar
# kosong tidak punya keduanya, sehingga setup.sh gagal dengan pesan
# "store tidak ada". Script ini yang mengerjakan bagian satu-kali itu:
#
#   1. openspec init — membuat struktur openspec/ (specs/, changes/,
#      config.yaml) bila belum ada.
#   2. Patch skill openspec-propose (.claude/ dan .agents/) supaya
#      /opsx:propose otomatis menghitung nomor urut change lewat
#      scripts/next-change.sh|.ps1, bukan membiarkan agent menebak atau
#      lupa memberi nomor.
#   3. Menyalin schema template dari scripts/schema-template/ ke
#      openspec/schemas/kct-spec-driven/ (default; bisa diganti via
#      --schema-name) dan mengarahkan config.yaml ke schema tersebut, supaya
#      store baru tidak terjebak dengan schema default "spec-driven" bawaan
#      OpenSpec.
#   4. openspec store register — mendaftarkan folder ini sebagai store lokal
#      dengan id yang diberikan.
#
# Setelah script ini selesai, scripts/setup.sh bisa dijalankan seperti biasa
# oleh siapa pun (termasuk Anda sendiri) yang meng-clone store ini di mesin
# masing-masing.
#
# --remote opsional: bila folder ini sudah punya remote git `origin` (repo
# plan sudah dibuat di server dan di-clone), remote itu terdeteksi otomatis.
# Isi manual hanya untuk folder yang benar-benar belum punya remote.
#
# Pemakaian:
#   ./scripts/setup-lead.sh --id bizcare-plans
#   ./scripts/setup-lead.sh --id bizcare-plans --remote git@git.kct.co.id:KCT/bizcare-plans.git
#   ./scripts/setup-lead.sh --id bizcare-plans --schema-name custom-name
#   ./scripts/setup-lead.sh --id bizcare-plans --force

set -euo pipefail

id=""
schema_name=""
remote=""
force=0

while [ $# -gt 0 ]; do
  case "$1" in
    --id)
      [ $# -ge 2 ] || { echo "Error: --id membutuhkan nilai." >&2; exit 1; }
      id="$2"; shift 2 ;;
    --id=*) id="${1#*=}"; shift ;;
    --schema-name)
      [ $# -ge 2 ] || { echo "Error: --schema-name membutuhkan nilai." >&2; exit 1; }
      schema_name="$2"; shift 2 ;;
    --schema-name=*) schema_name="${1#*=}"; shift ;;
    --remote)
      [ $# -ge 2 ] || { echo "Error: --remote membutuhkan nilai." >&2; exit 1; }
      remote="$2"; shift 2 ;;
    --remote=*) remote="${1#*=}"; shift ;;
    --force) force=1; shift ;;
    -h|--help) sed -n '2,39p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "Error: opsi tidak dikenal: $1" >&2; exit 1 ;;
  esac
done

if [ -z "$id" ]; then
  echo "Error: --id wajib diisi, mis. --id bizcare-plans" >&2
  exit 1
fi

script_dir=$(cd "$(dirname "$0")" && pwd)
store_root=$(dirname "$script_dir")

[ -n "$schema_name" ] || schema_name="kct-spec-driven"

# Bila folder ini sudah punya remote git (repo plan kosong sudah dibuat di
# server dan di-clone), pakai itu — --remote hanya perlu diisi manual untuk
# folder yang benar-benar belum punya remote.
if [ -z "$remote" ]; then
  remote=$(git -C "$store_root" remote get-url origin 2>/dev/null || true)
fi

echo "Store root : $store_root"
echo "Store id   : $id"
echo "Schema     : $schema_name"
[ -z "$remote" ] || echo "Remote     : $remote"
echo ""

# --- Guard: jangan jalankan di atas checkout yang sudah jadi store sungguhan -
existing_metadata="$store_root/.openspec-store/store.yaml"
if [ -f "$existing_metadata" ] && [ "$force" -ne 1 ]; then
  echo "Error: $existing_metadata sudah ada - folder ini sudah jadi store." >&2
  echo "Pakai scripts/setup.sh (setup per mesin), bukan setup-lead.sh." >&2
  echo "Bila memang ingin menulis ulang identitas store, jalankan ulang dengan --force." >&2
  exit 1
fi

# --- 1. openspec init (bila openspec/ belum berbentuk root sungguhan) -------
openspec_dir="$store_root/openspec"
has_real_root=0
[ -d "$openspec_dir/specs" ] || [ -d "$openspec_dir/changes" ] && has_real_root=1

echo "[1/4] openspec init..."
if [ "$has_real_root" -eq 1 ]; then
  echo "      openspec/specs atau openspec/changes sudah ada, dilewati."
else
  init_args=(init . --tools claude,agents)
  [ "$force" -ne 1 ] || init_args+=(--force)
  # Fallback ke --tools claude saja kalau ini gagal: tool 'agents' baru ada
  # di rilis OpenSpec CLI yang lebih baru, dan sudah kejadian nyata seorang
  # lead kena "Invalid tool(s): agents" di CLI lamanya, membuat SELURUH
  # bootstrap gagal padahal --tools claude saja cukup untuk lanjut. Jangan
  # dihapus tanpa mengganti dengan penanganan versi CLI yang setara.
  if ! (cd "$store_root" && openspec "${init_args[@]}"); then
    echo "PERINGATAN: openspec init dengan --tools claude,agents gagal - kemungkinan versi OpenSpec CLI di mesin ini belum mendukung tool 'agents'. Mencoba ulang dengan --tools claude saja..." >&2
    init_args=(init . --tools claude)
    [ "$force" -ne 1 ] || init_args+=(--force)
    if ! (cd "$store_root" && openspec "${init_args[@]}"); then
      echo "Error: openspec init tetap gagal walau tanpa 'agents'. Periksa versi OpenSpec CLI ('openspec --version') dan error di atas." >&2
      exit 1
    fi
    echo "PERINGATAN: folder .agents/ (dukungan agent non-Claude) TIDAK dibuat karena versi OpenSpec CLI ini belum mendukung tool 'agents'. Upgrade OpenSpec CLI, lalu jalankan 'openspec init . --tools claude,agents --force' manual bila perlu." >&2
  fi
fi

# --- 2. Patch skill openspec-propose (nomor urut change otomatis) ----------
echo "[2/4] Menerapkan patch skill openspec-propose..."
"$script_dir/patch-propose-skill.sh"

# --- 3. Schema template ------------------------------------------------------
echo "[3/4] Menyalin schema template..."

template_src="$script_dir/schema-template"
if [ ! -d "$template_src" ]; then
  echo "Error: schema template tidak ditemukan di $template_src." >&2
  echo "Pastikan folder scripts/ disalin utuh dari repo template ini." >&2
  exit 1
fi

schema_dest="$openspec_dir/schemas/$schema_name"
if [ -d "$schema_dest" ] && [ "$force" -ne 1 ]; then
  echo "PERINGATAN: $schema_dest sudah ada, dilewati. Jalankan ulang dengan --force untuk menimpanya." >&2
else
  rm -rf "$schema_dest"
  mkdir -p "$schema_dest"
  cp -r "$template_src"/. "$schema_dest"/

  # schema.yaml datang dengan `name: kct-spec-driven` - selaraskan dengan nama
  # folder tujuan (biasanya sama persis, kecuali --schema-name di-override)
  # supaya `openspec schema which` konsisten.
  schema_yaml="$schema_dest/schema.yaml"
  sed -i "s/^name: kct-spec-driven\$/name: $schema_name/" "$schema_yaml"

  echo "      disalin ke $schema_dest"
fi

# Arahkan config.yaml ke schema ini, bukan default "spec-driven" hasil openspec init.
config_path="$openspec_dir/config.yaml"
if [ -f "$config_path" ]; then
  current_schema=$(sed -n 's/^schema:[[:space:]]*\(.*\)$/\1/p' "$config_path" | head -n1 | tr -d '"'"'"' \r')
  if [ "$current_schema" = "$schema_name" ]; then
    echo "      config.yaml sudah menunjuk schema '$schema_name'."
  else
    sed -i "s/^schema:.*\$/schema: $schema_name/" "$config_path"
    echo "      config.yaml diarahkan dari '$current_schema' ke '$schema_name'."
  fi
else
  echo "PERINGATAN: $config_path tidak ditemukan - lewati pengaturan schema, periksa manual setelah ini selesai." >&2
fi

# --- 4. Registrasi store ----------------------------------------------------
echo "[4/4] Mendaftarkan store '$id'..."

if ! openspec store register "$store_root" --id "$id" --yes; then
  echo "Error: registrasi store gagal. Bila id sudah dipakai checkout lain," >&2
  echo "jalankan 'openspec store unregister $id' lebih dulu." >&2
  exit 1
fi

# `store register` tidak punya flag --remote (itu cuma ada di `store setup`,
# yang membuat store dari nol, bukan mendaftarkan checkout yang sudah ada).
# Tulis manual ke metadata store bila remote diberikan.
if [ -n "$remote" ]; then
  metadata_path="$store_root/.openspec-store/store.yaml"
  if [ -f "$metadata_path" ]; then
    if grep -q '^remote:' "$metadata_path"; then
      sed -i "s#^remote:.*\$#remote: $remote#" "$metadata_path"
    else
      printf 'remote: %s\n' "$remote" >> "$metadata_path"
    fi
    echo "      remote dicatat di $metadata_path"
  fi
fi

echo ""
echo "Selesai. Langkah berikutnya:"
echo "  1. Jalankan scripts/setup.sh di mesin ini seperti biasa (menulis pointer workspace + asset Claude Code)."
echo "  2. Sesuaikan openspec/schemas/$schema_name/schema.yaml dan openspec/config.yaml dengan domain project ini"
echo "     (cari komentar '# CUSTOMIZE' di schema.yaml)."
echo "  3. Commit dan push store ini, lalu commit juga scripts/setup.sh / setup.ps1 apa adanya - teammate lain"
echo "     cukup clone dan jalankan scripts/setup.sh tanpa perlu setup-lead.sh."
