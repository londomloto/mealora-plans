# 001 · Fondasi aplikasi Mealora

## Why

Mealora belum punya basis kode sama sekali — `mealora-apps/mealora-mobile` masih berisi README saja — sementara desain UI/UX untuk ±40 layar sudah final di `docs/mealora-v2.pen` dan assessment v1.1 menuntut arsitektur yang spesifik sejak hari pertama: domain gizi murni Dart, penyimpanan lokal yang bisa dimigrasi, identitas record siap-sinkron, dan nol ketergantungan backend. Keputusan fondasi seperti ini mahal untuk diubah belakangan: skema database tanpa metadata sync, ID auto-increment, atau logika target yang nyangkut di widget akan memaksa penulisan ulang saat program, buku harian, dan (nanti) cloud sync masuk.

Change ini membangun kerangka yang bisa dijalankan dan diuji, lengkap dengan bahasa visual dari desain, supaya lima change berikutnya (domain program, persistensi program, onboarding, katalog & buku harian, input foto/barcode) bisa menambah perilaku tanpa menyentuh ulang pondasinya.

## What Changes

- **Proyek Flutter baru** di `mealora-apps/mealora-mobile`: target Android sebagai sasaran rilis, web (Chrome) sebagai sasaran debug/preview, arsitektur iOS-ready. Tidak ada autentikasi, backend, Supabase, atau AI.
- **Struktur berlapis** `app/ core/ database/ domain/ data/ features/` dengan aturan dependensi satu arah (UI → state → domain → kontrak repository; data layer yang mengimplementasikan kontrak). Lapisan domain dilarang mengimpor Flutter, Drift, jaringan, jam global, atau pembangkit ID acak.
- **Fondasi penyimpanan lokal**: Drift/SQLite dengan `schemaVersion` 1, harness migrasi beserta fixture database kosong, foreign key aktif, serta konvensi record milik pengguna: ID UUID, `created_at`, `updated_at`, `deleted_at` (soft delete), `sync_status` (hanya nilai `local` di MVP 1), dan `revision`. Belum ada tabel fitur — hanya kerangka, konvensi, dan pengujiannya.
- **Clock dan pembangkit ID yang di-inject** sehingga seluruh perilaku berwaktu dapat diuji secara deterministik; waktu disimpan UTC dengan ID zona waktu IANA dan tanggal lokal terpisah untuk pengelompokan harian.
- **Design system** dari `docs/mealora-v2.pen`: token warna (`background #F7FAF5`, `primary #258747`, `accent #F5D35C`, `peach #FF8A50`, `ink #203D2D`, `muted #687D70`, `soft-green #DEF3DE`, `line #DFE9DE`), skala tipografi dan spasi, komponen dasar (tombol primer, chip, kartu, kolom isian), serta navigasi kapsul mengambang empat tab **Hari ini · Program · Riwayat · Profil**.
- **Layar kerangka**: splash Mealora bermerek dan empat layar tab kosong berstatus "belum ada data", semuanya berbahasa Indonesia, sehingga aplikasi bisa dijalankan dan dinavigasi dari rilis pertama.
- **Kualitas & verifikasi**: lint ketat, format, struktur test (unit, widget, database/migrasi), dan alur preview debug `flutter run -d chrome` yang terdokumentasi.
- **Aksesibilitas sebagai default**: teks mengikuti skala sistem, kontras memenuhi ambang, target sentuh memadai, dan status tidak pernah dikomunikasikan lewat warna saja.

Tidak ada perubahan yang bersifat BREAKING — ini repositori baru.

## Capabilities

### New Capabilities

- `app-shell`: aplikasi yang bisa dipasang dan dijalankan tanpa akun maupun koneksi — splash, kerangka navigasi empat tab, bahasa Indonesia, bahasa visual Mealora, dan dasar aksesibilitas.
- `local-data-foundation`: penyimpanan di perangkat sebagai satu-satunya sumber kebenaran — identitas record, jejak waktu, soft delete, versi skema dan migrasi, integritas data, serta jaminan tidak ada data yang keluar dari perangkat.

### Modified Capabilities

Belum ada kapabilitas di `openspec/specs/` — ini change pertama.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: dibuat dari nol (proyek Flutter, dependensi, konfigurasi lint/test/CI lokal, aset merek dari `docs/brand-assets/`).
- **Dependensi baru**: Flutter SDK, Drift + sqlite3 (native Android, WASM untuk target web debug), Riverpod, pembangkit UUID, paket test/mocking. Tidak ada SDK analitik, iklan, atau pelacak pihak ketiga.
- **Change berikutnya** bergantung pada fondasi ini: domain program, persistensi program, onboarding & aktivasi, katalog & buku harian, input foto/barcode/label, serta kebijakan gizi tervalidasi.
- **Belum tersentuh**: seluruh perilaku produk (perhitungan energi, program, pencatatan makanan, berat, riwayat) sengaja berada di luar scope dan tidak boleh diimplementasikan di sini.
