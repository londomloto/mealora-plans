# Design — 001 · Fondasi aplikasi Mealora

## Context

Lihat `proposal.md` — Why untuk motivasinya. Keadaan saat ini: `mealora-apps/mealora-mobile` hanya berisi `README.md` dan belum punya proyek Flutter; tidak ada kapabilitas di `openspec/specs/`, sehingga change ini yang pertama.

Batasan yang mengikat dari `docs/mealora_product_assessment_v1.1.md`:

- MVP 1 lokal dan offline sepenuhnya; tanpa akun, backend, Supabase, atau AI (§6, §8, §31).
- Domain Dart murni tidak boleh mengimpor Flutter, Drift, jaringan, jam global, atau pembangkit ID acak (§48.4).
- Perubahan skema wajib disertai migrasi, fixture, dan uji migrasi (§48.7).
- Record milik pengguna memakai UUID, jejak waktu, soft delete, dan metadata siap-sinkron (§12, §42).
- Satuan kanonis disimpan apa adanya; konversi hanya di batas tampilan (§48.10).

Sumber rancangan visual: `docs/mealora-v2.pen` (±40 layar, variabel warna terdefinisi, komponen navigasi kapsul `Component · floating navigation`, splash `06 · Splash Mealora`), serta aset merek di `docs/brand-assets/`.

Toolchain yang tersedia di mesin pengembang: Flutter SDK terpasang; device yang terdeteksi hanya Windows, Chrome, dan Edge — belum ada emulator Android atau `adb` di PATH.

## Goals / Non-Goals

**Goals**

- Satu perintah menjalankan aplikasi yang bisa dinavigasi, di Chrome (debug/preview) maupun Android.
- Batas lapisan ditegakkan oleh perkakas, bukan sekadar kesepakatan lisan.
- Fondasi penyimpanan lokal lengkap dengan harness migrasi dan uji yang hijau sejak change pertama.
- Token desain yang menjadi satu-satunya sumber nilai gaya di seluruh aplikasi.
- Sumber waktu dan pengenal yang bisa diganti saat pengujian.

**Non-Goals**

- Tidak ada tabel domain produk (profil, program, makanan, buku harian, berat) — itu milik change berikutnya; change ini hanya menetapkan konvensi dan membuktikannya lewat harness.
- Tidak ada perhitungan gizi sama sekali, termasuk konstanta atau placeholder angka.
- Tidak ada CI terkelola, penandatanganan rilis, atau publikasi store.
- Tidak ada dukungan iOS yang diverifikasi (arsitektur tetap netral, tetapi tidak diuji).
- Tidak ada dark mode di change ini; token disiapkan agar bisa ditambahkan belakangan tanpa menyentuh layar.

## Decisions

### D1 — Flutter + Drift/SQLite + Riverpod

Mengikuti keputusan yang sudah disetujui di assessment §9 dan §34. Drift memberi kueri bertipe, migrasi, transaksi, dan kueri reaktif di atas SQLite. Riverpod dipakai sebagai satu-satunya solusi state; tidak dicampur dengan BLoC atau yang lain.

*Alternatif:* `sqflite` mentah (migrasi dan tipe harus ditulis sendiri), `sqlite_async`/`Isar` (menyimpang dari keputusan yang sudah diambil dan dari kesiapan sync berbasis SQL). Ditolak.

### D2 — Struktur folder dan penegakan batas lapisan

Struktur mengikuti §10: `app/ core/ database/ domain/ data/ features/`. Arah dependensi: `features → domain ← data`, `database` hanya dipakai `data`.

Batas ditegakkan dengan aturan lint impor pada analisis statis, sehingga pelanggaran menggagalkan `flutter analyze`, bukan hanya ditegur saat review. Setiap lapisan juga punya uji arsitektur sederhana yang memindai impor terlarang — berguna sebagai jaring kedua bila aturan lint tidak menjangkau suatu pola.

*Alternatif:* paket Dart terpisah per lapisan (melting point lebih tegas, tetapi menambah beban build dan versioning untuk satu aplikasi). Ditolak untuk MVP; struktur folder cukup selama lint menegakkannya.

### D3 — Target web sebagai lingkungan debug/preview, Android sebagai target rilis

`flutter run -d chrome` dipakai untuk iterasi UI dan debug harian (hot reload, DevTools, bisa dilihat bersama di browser pane). Android tetap target rilis dan gate verifikasi.

Konsekuensi: Drift harus dikonfigurasi untuk kedua platform — sqlite3 native di Android, `sqlite3.wasm` + worker di web — lewat satu titik pembuka koneksi yang berbeda implementasi per platform. Kode fitur tidak boleh mengetahui perbedaan ini.

Fitur yang tidak tersedia di web (kamera, pemindaian barcode) akan muncul di change berikutnya; kontraknya harus berupa antarmuka yang di web mengembalikan keadaan "tidak tersedia di lingkungan ini", bukan membuat aplikasi gagal dimuat.

*Alternatif:* hanya Android (butuh emulator yang belum tersedia dan tidak bisa dilihat agen secara langsung); Flutter desktop Windows (tidak merepresentasikan layar 390×844 dan perilaku sentuh). Keduanya ditolak sebagai lingkungan debug utama.

### D4 — UUID v7 untuk identitas record

Pengenal dibuat aplikasi, bukan basis data, memakai UUID v7 agar terurut secara waktu — ini memberi lokalitas indeks yang baik di SQLite sekaligus unik lintas perangkat untuk sync di MVP 2. Pembangkit ID berada di balik antarmuka yang di-inject sehingga uji bisa memakai urutan tetap.

*Alternatif:* UUID v4 (acak, fragmentasi indeks lebih tinggi), `AUTOINCREMENT` (dilarang §31). v4 tetap menjadi cadangan bila dukungan paket v7 bermasalah — keputusan ini hanya menyentuh satu kelas pembangkit.

### D5 — Waktu UTC + zona waktu + tanggal lokal eksplisit

Instan disimpan sebagai epoch UTC; zona waktu IANA dan tanggal lokal (`YYYY-MM-DD`) disimpan terpisah pada record yang dikelompokkan per hari. Dengan begitu, pengguna yang berpindah zona waktu tidak membuat catatan lama berpindah hari. Jam diakses lewat antarmuka `Clock` yang di-inject.

### D6 — Metadata siap-sinkron pada seluruh record pengguna

Setiap tabel milik pengguna memuat `id`, `created_at`, `updated_at`, `deleted_at`, `sync_status`, dan `revision`. Di MVP 1 `sync_status` selalu `local`. Repositori menyembunyikan kolom ini dari domain sehingga tidak ada kode fitur yang bergantung pada detail sinkronisasi. Mixin tabel bersama memastikan tidak ada tabel yang lupa salah satu kolom.

*Trade-off:* kolom tambahan yang belum terpakai di MVP 1. Diterima karena menambahkannya belakangan berarti migrasi dan backfill pada data pengguna sungguhan.

### D7 — Soft delete sebagai default untuk record pengguna

Pembacaan standar selalu menyaring `deleted_at IS NULL`. Agar tidak ada kueri yang lupa, penyaringan ini disediakan pada lapisan akses data bersama dan diuji; kueri yang sengaja membaca record terhapus harus menyatakannya eksplisit.

### D8 — Token desain diturunkan dari `docs/mealora-v2.pen`

Nilai warna diambil persis dari variabel dokumen desain: `background #F7FAF5`, `primary #258747`, `accent #F5D35C`, `peach #FF8A50`, `ink #203D2D`, `muted #687D70`, `soft-green #DEF3DE`, `line #DFE9DE`. Token diekspresikan satu kali sebagai tema aplikasi; widget tidak boleh menulis nilai warna, ukuran font, atau radius secara harfiah — dilarang lewat aturan lint.

Pasangan warna teks/latar diverifikasi kontrasnya oleh uji otomatis, bukan hanya diperiksa mata, karena `muted` di atas `background` adalah pasangan paling berisiko.

### D9 — Harness migrasi sejak versi 1

`schemaVersion` dimulai dari 1. Harness migrasi dan fixture dibangun sekarang meski belum ada migrasi yang berjalan, agar change berikutnya (yang menambah tabel program) tinggal menambah kasus uji. Fixture awal: database kosong, pembuatan langsung pada versi terkini, dan simulasi migrasi terputus. Verifikasi menyertakan pemeriksaan foreign key.

### D10 — Bahasa Indonesia lewat lapisan lokalisasi sejak awal

Seluruh string pengguna diambil dari berkas lokalisasi, bukan literal di widget, meski hanya ada satu bahasa. Format angka, tanggal, dan satuan memakai locale `id-ID`. Ini mencegah kalimat yang dirangkai dari potongan — pola yang membuat terjemahan dan perubahan satuan mustahil belakangan.

### D11 — Kesalahan bertipe, bukan exception umum

Operasi yang bisa gagal mengembalikan hasil bertipe dengan alasan yang dapat dipetakan ke pesan pengguna. Tidak ada `throw Exception('...')` sebagai mekanisme alur. Ini mengikuti §48.9 dan menjadi dasar untuk hasil `missing_validated_policy` dan sejenisnya di change program.

## Risks / Trade-offs

- **Drift di web butuh konfigurasi WASM** → risiko waktu terbuang di awal. Mitigasi: titik pembuka koneksi per platform dibuat dan diuji pada task tersendiri sebelum layar apa pun dibangun; bila WASM bermasalah, debug UI tetap bisa jalan dengan penyimpanan in-memory di web sementara Android memakai SQLite nyata.
- **Preview web tidak membuktikan perilaku Android** (penyimpanan, izin, kamera, performa) → mitigasi: Android menjadi gate verifikasi wajib sebelum change ditutup, dan uji database dijalankan terhadap SQLite nyata, bukan hanya in-memory di browser.
- **Emulator/`adb` belum tersedia di mesin** → menyiapkannya bisa memakan waktu di luar perkiraan. Mitigasi: dijadwalkan sebagai paket tersendiri di work order dengan timebox; bila gagal, verifikasi Android dilakukan di perangkat fisik.
- **Token desain bisa menyimpang dari `mealora-v2.pen`** seiring waktu → mitigasi: nilai disalin dari variabel dokumen desain dan dicatat sumbernya; perubahan merek mengubah token, bukan layar.
- **Over-engineering lapisan untuk aplikasi satu orang** → mitigasi: tidak ada paket terpisah, tidak ada abstraksi repositori ganda, tidak ada dependency injection manual yang rumit; hanya aturan impor dan satu wadah penyedia.
- **Kolom siap-sinkron yang belum dipakai** bisa dianggap beban mati oleh implementer berikutnya dan diam-diam dihapus → mitigasi: uji yang menegaskan keberadaan kolom pada setiap tabel pengguna.

## Migration Plan

Tidak ada data pengguna yang sudah ada — ini pemasangan pertama. Urutan penerapan:

1. Buat proyek Flutter dan konfigurasi kualitas (lint, format, struktur test) sebelum kode fitur apa pun.
2. Bangun fondasi penyimpanan (skema versi 1, harness migrasi, clock, pembangkit ID) beserta ujinya.
3. Bangun token desain dan komponen dasar.
4. Bangun splash dan kerangka navigasi empat ruang.
5. Verifikasi di Chrome lalu di Android.

Rollback: karena belum ada pengguna dan belum ada data, pemulihan cukup dengan membuang commit terkait. Tidak diperlukan migrasi mundur; versi skema 1 adalah titik awal.

## Open Questions

- Paket pembangkit UUID v7 mana yang dipakai (assessment §33 menandai ini sebagai keputusan terbuka). Tidak mengubah spesifikasi maupun pemecahan task — hanya satu kelas di balik antarmuka — jadi aman diputuskan saat implementasi, dengan v4 sebagai cadangan.
- Nilai persis skala tipografi (ukuran dan tinggi baris) perlu diambil dari `docs/mealora-v2.pen` saat implementasi; token warna sudah pasti, angka tipografi dibaca dari dokumen desain, bukan ditebak.
