# Work Order

## Ringkasan

Change ini membangun fondasi aplikasi Mealora dari nol di satu repositori, `mealora-apps/mealora-mobile`: proyek Flutter dengan arsitektur berlapis, fondasi penyimpanan lokal (Drift/SQLite versi skema 1 beserta harness migrasi, sumber waktu dan pengenal yang dapat diuji, metadata siap-sinkron), design system yang diturunkan dari `docs/mealora-v2.pen`, splash bermerek, dan kerangka navigasi empat ruang berbahasa Indonesia. Tidak ada perilaku produk yang dikirim. Pekerjaan dibagi menjadi tiga tahap yang masing-masing dapat dijalankan dan diverifikasi sendiri; estimasi total 9–13 hari-orang, dengan penyiapan perangkat Android sebagai satu-satunya paket spike.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Inisialisasi proyek Flutter, struktur folder berlapis, konfigurasi lint/format, struktur test | 1,0 | pasti | Termasuk aturan lint impor antar-lapisan dan larangan nilai gaya harfiah |
| 2 | Sumber waktu dan pengenal yang di-inject (UUID v7, clock), beserta uji determinismenya | 0,5 | pasti | Paket UUID v7 dipilih saat implementasi; v4 sebagai cadangan |
| 3 | Fondasi penyimpanan: koneksi Drift per platform (SQLite native + WASM web), skema versi 1 | 1,5 | pasti | Konfigurasi WASM web adalah bagian paling tidak pasti dalam paket ini |
| 4 | Konvensi record pengguna: mixin metadata siap-sinkron, soft delete, validasi nilai, kesalahan bertipe | 1,0 | pasti | Diuji lewat tabel harness, bukan tabel produk |
| 5 | Harness migrasi dan fixture (database kosong, pembuatan langsung v1, migrasi terputus, pemeriksaan foreign key) | 1,0 | pasti | Dipakai ulang oleh seluruh change berikutnya |
| 6 | Token desain dan tema dari `docs/mealora-v2.pen` (warna, tipografi, jarak, radius) + uji kontras | 1,0 | pasti | Nilai warna sudah pasti; angka tipografi dibaca dari dokumen desain |
| 7 | Komponen dasar: tombol primer, chip, kartu, kolom isian, keadaan kosong, keadaan kesalahan | 1,0 | pasti | Hanya komponen yang dipakai kerangka; sisanya menyusul per fitur |
| 8 | Lokalisasi Indonesia, format angka/tanggal `id-ID`, satuan metrik | 0,5 | pasti | Semua string lewat lapisan lokalisasi sejak awal |
| 9 | Splash bermerek dengan aset dari `docs/brand-assets/`, termasuk keadaan gagal inisialisasi | 0,5 | pasti | |
| 10 | Navigasi kapsul mengambang empat ruang + empat layar kerangka berkeadaan kosong + rute tidak dikenal | 1,5 | pasti | Mengikuti `Component · floating navigation` di dokumen desain |
| 11 | Pemeriksaan aksesibilitas: skala teks besar, label pembaca layar, target sentuh, status non-warna | 0,5 | pasti | Sebagian ditegakkan uji otomatis, sebagian pemeriksaan manual |
| 12 | Alur preview/debug web terdokumentasi (`flutter run -d chrome`) + README repo | 0,5 | pasti | |
| 13 | Penyiapan perangkat/emulator Android dan verifikasi rilis debug di Android | 1,0 | spike (timebox 1 hari) | `adb` dan emulator belum ada di mesin; bila gagal, pakai perangkat fisik |
| 14 | Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed`, `flutter test` | 0,5 | pasti | Dijalankan di akhir tiap tahap, bukan hanya di akhir change |

**Subtotal:** 9,0–13,0 hari-orang (rentang mencerminkan ketidakpastian paket 3 dan 13).

## Dependensi Antar-Paket

- Paket 1 memblokir semua paket lain — tanpa proyek dan aturan lint, sisanya tidak punya tempat berdiri.
- Paket 2 mendahului paket 4 dan 5: konvensi record dan uji migrasi membutuhkan waktu serta pengenal yang deterministik.
- Paket 3 mendahului paket 4 dan 5: koneksi per platform harus ada sebelum skema dan migrasi dapat diuji.
- Paket 6 mendahului paket 7, 9, dan 10: komponen dan layar tidak boleh menulis nilai gaya sendiri.
- Paket 8 mendahului paket 9 dan 10: layar tidak boleh memuat teks harfiah.
- Paket 10 mendahului paket 11: aksesibilitas diperiksa pada layar yang sudah ada.
- Paket 12 dan 13 mendahului penutupan change: verifikasi web dan Android adalah bukti bahwa fondasi benar-benar berjalan.
- Seluruh change lanjutan (domain program, persistensi program, onboarding, katalog & buku harian, input foto/barcode) diblokir oleh tahap 2 change ini.

## Urutan Rilis

### Tahap 1 — Kerangka proyek dan fondasi penyimpanan

**Isi:** paket 1, 2, 3, 4, 5.
**Prasyarat:** Flutter SDK terpasang di mesin pengembang; repositori `mealora-apps/mealora-mobile` tersedia.
**Gate verifikasi:** `flutter analyze` tanpa peringatan; `dart format --set-exit-if-changed` bersih; `flutter test` hijau, mencakup uji determinisme waktu/pengenal, uji konvensi record (metadata siap-sinkron, soft delete, penolakan nilai mustahil, keutuhan penulisan ganda), serta seluruh fixture migrasi termasuk pemeriksaan foreign key; aplikasi kosong berhasil dibuka di Chrome dan membuat basis data lokal.

### Tahap 2 — Bahasa visual dan kerangka yang bisa dinavigasi

**Isi:** paket 6, 7, 8, 9, 10, 11.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** `flutter analyze` dan `flutter test` hijau, termasuk uji widget untuk splash, perpindahan antar empat ruang, keadaan kosong, rute tidak dikenal, dan uji kontras token; pemeriksaan manual di Chrome pada viewport 390×844 untuk kelima layar; pemeriksaan skala teks besar dan pembaca layar; perbandingan visual terhadap `docs/mealora-v2.pen` (`06 · Splash Mealora` dan `Component · floating navigation`).

### Tahap 3 — Verifikasi Android dan penutupan

**Isi:** paket 12, 13, 14.
**Prasyarat:** tahap 2 selesai; perangkat atau emulator Android tersedia.
**Gate verifikasi:** rilis debug terpasang dan berjalan di Android; alur mode pesawat (buka aplikasi, jelajahi empat ruang, tutup, buka kembali, data dan ruang terpilih bertahan) lolos di perangkat Android; pengamatan lalu lintas jaringan menunjukkan tidak ada permintaan keluar; README berisi langkah menjalankan, menguji, dan preview debug.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Konfigurasi Drift/`sqlite3.wasm` di web memakan waktu lebih lama dari perkiraan | Paket 3 membengkak, tahap 1 tertunda | Timebox setengah hari; bila belum beres, web memakai penyimpanan in-memory untuk debug UI sementara Android memakai SQLite nyata, dan WASM diselesaikan terpisah |
| Emulator/`adb` belum ada di mesin dan penyiapannya bermasalah | Tahap 3 tertunda, verifikasi Android tertahan | Timebox satu hari; alternatif perangkat Android fisik; tahap 1 dan 2 tetap bisa diverifikasi di Chrome |
| Angka tipografi dan jarak harus dibaca manual dari dokumen desain | Paket 6 dan 7 melar, hasil visual meleset dari rancangan | Baca nilai langsung dari `docs/mealora-v2.pen` lewat MCP pen.dev saat implementasi, bukan menebak dari tangkapan layar |
| Aturan lint impor antar-lapisan tidak menjangkau semua pola pelanggaran | Batas arsitektur bocor diam-diam dan baru ketahuan di change berikutnya | Tambahkan uji arsitektur yang memindai impor terlarang sebagai jaring kedua |
| Scope merembet ke fitur produk karena kerangka terasa "kosong" | Change tidak selesai-selesai, review membengkak | Keempat layar sengaja hanya berkeadaan kosong; permintaan fitur dialihkan ke change berikutnya |
| Preview web dianggap cukup sebagai bukti kelayakan | Masalah khusus Android baru muncul jauh di belakang | Tahap 3 bersifat wajib sebelum change ditutup |
