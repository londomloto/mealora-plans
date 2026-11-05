#!/usr/bin/env bash
#
# Menghitung nomor urut change berikutnya untuk store ini.
# Padanan POSIX dari scripts/next-change.ps1 — perilaku dan keluarannya sama.
#
# Konvensi: setiap change diberi nomor urut tiga digit, 001-foo, 002-bar, dst.
# OpenSpec tidak punya penomoran otomatis, jadi nomor dihitung dari change yang
# sudah ada.
#
# Pemindaian mencakup DUA tempat, karena `openspec archive` memindahkan change
# ke folder arsip sambil menambahkan prefix tanggal:
#   openspec/changes/<NNN>-<slug>
#   openspec/changes/archive/<YYYY-MM-DD>-<NNN>-<slug>
# Tanpa memindai arsip, nomor yang sudah terpakai bisa terpakai ulang.
#
# --type opsional menyisipkan klasifikasi tipe change tepat setelah nomor:
#   fix        - memperbaiki perilaku yang sudah ada dan salah/rusak
#   perf       - kecepatan/efisiensi perilaku yang sudah ada, perilaku tidak berubah
#   workaround - solusi sementara/stopgap, root cause sengaja belum dibereskan
# Tanpa --type, change dianggap feature baru (default store ini) - tidak
# dapat tag. Klasifikasi ini best effort; salah tag tinggal rename manual
# folder-nya, tidak ada konsekuensi lain.
#
# Pemakaian:
#   ./scripts/next-change.sh                                 -> 003
#   ./scripts/next-change.sh <slug>                          -> 003-<slug>
#   ./scripts/next-change.sh <slug> --type fix                -> 003-fix-<slug>
#   ./scripts/next-change.sh <slug> --create                 -> jalankan openspec new change
#   ./scripts/next-change.sh <slug> --type perf --create

set -euo pipefail

slug=""
create=0
type=""
allowed_types="fix perf workaround"

while [ $# -gt 0 ]; do
  case "$1" in
    --create) create=1; shift ;;
    --type)
      [ $# -ge 2 ] || { echo "Error: --type membutuhkan nilai." >&2; exit 1; }
      type="$2"; shift 2 ;;
    --type=*) type="${1#*=}"; shift ;;
    -h|--help) sed -n '2,29p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) echo "Error: opsi tidak dikenal: $1" >&2; exit 1 ;;
    *)
      [ -z "$slug" ] || { echo "Error: slug sudah diberikan: $slug" >&2; exit 1; }
      slug="$1"; shift ;;
  esac
done

if [ -n "$type" ]; then
  case " $allowed_types " in
    *" $type "*) ;;
    *)
      echo "Error: --type '$type' tidak dikenal. Pilih salah satu: $allowed_types" >&2
      exit 1 ;;
  esac
  if [ -z "$slug" ]; then
    echo "Error: --type butuh slug juga, mis. --type $type nama-perubahan" >&2
    exit 1
  fi
fi

script_dir=$(cd "$(dirname "$0")" && pwd)
store_root=$(dirname "$script_dir")
changes_dir="$store_root/openspec/changes"
archive_dir="$changes_dir/archive"

if [ ! -d "$changes_dir" ]; then
  echo "Error: folder changes tidak ditemukan di $changes_dir." >&2
  echo "Jalankan script ini dari checkout store OpenSpec." >&2
  exit 1
fi

highest=0

# Change aktif: <NNN>-<slug>
for entry in "$changes_dir"/*/; do
  [ -d "$entry" ] || continue
  name=$(basename "${entry%/}")
  [ "$name" != "archive" ] || continue
  if printf '%s' "$name" | grep -Eq '^[0-9]{3}-'; then
    number=$(printf '%s' "$name" | cut -c1-3)
    number=$((10#$number))
    [ "$number" -le "$highest" ] || highest=$number
  fi
done

# Change terarsip: <YYYY-MM-DD>-<NNN>-<slug>
if [ -d "$archive_dir" ]; then
  for entry in "$archive_dir"/*/; do
    [ -d "$entry" ] || continue
    name=$(basename "${entry%/}")
    if printf '%s' "$name" | grep -Eq '^[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{3}-'; then
      number=$(printf '%s' "$name" | cut -c12-14)
      number=$((10#$number))
      [ "$number" -le "$highest" ] || highest=$number
    fi
  done
fi

next=$((highest + 1))
if [ "$next" -gt 999 ]; then
  echo "Error: nomor change sudah mencapai 999. Perluas konvensi ke empat digit." >&2
  exit 1
fi

padded=$(printf '%03d' "$next")

if [ -z "$slug" ]; then
  printf '%s\n' "$padded"
  exit 0
fi

if ! printf '%s' "$slug" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
  echo "Error: slug '$slug' tidak valid." >&2
  echo "Pakai kebab-case: huruf kecil, angka, dan tanda hubung tunggal." >&2
  exit 1
fi

if [ -n "$type" ]; then
  name="$padded-$type-$slug"
else
  name="$padded-$slug"
fi

if [ "$create" -eq 1 ]; then
  echo "Membuat change '$name'..."
  openspec new change "$name"
else
  printf '%s\n' "$name"
fi
