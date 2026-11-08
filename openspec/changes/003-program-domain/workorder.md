# Work Order

## Ringkasan

Change ini membangun lapisan domain program sebagai Dart murni di satu repositori, `mealora-apps/mealora-mobile`: value object bersatuan, `NutritionCalculator`, katalog empat program, `ProgramEngine` dengan kelayakan dan guardrail kebijakan `np-1.0.0`, mesin keadaan siklus hidup, serta perintah aktivasi dan pergantian yang utuh. Tidak ada basis data dan tidak ada layar. Estimasi 7,5–10 hari-orang dalam dua tahap: mesin perhitungan lebih dulu, lalu siklus hidup. Seluruh pekerjaan diverifikasi lewat uji otomatis, karena belum ada yang bisa dilihat di layar.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Value object bersatuan: energi, massa, panjang, tanggal lokal, persentase; konversi dan pembulatan kanonis | 1,0 | pasti | Mencegah kilogram tertukar dengan kilokalori |
| 2 | Tipe hasil tertutup lima keadaan beserta kode alasan dari `nutrition-policy` | 0,5 | pasti | Menambah keadaan baru harus menggagalkan kompilasi di pemanggil |
| 3 | `NutritionCalculator`: validasi masukan, energi istirahat, energi harian, asumsi, peringatan, `calculator_version` | 1,0 | pasti | Tidak mengetahui program maupun kebijakan |
| 4 | Uji golden energi dari vektor change 002, termasuk kasus batas masukan | 0,5 | pasti | Gagal bila aritmetika meleset satu pun kasus |
| 5 | Katalog empat program sebagai data acuan domain beserta aturan masukan per program | 0,5 | pasti | Kode program harus sama dengan yang dipakai change 004 |
| 6 | `ProgramEngine` — kelayakan: usia, kehamilan dan menyusui, IMT, kondisi yang dinyatakan, perubahan berat cepat, masukan kurang | 1,0 | pasti | Seluruhnya gagal tertutup |
| 7 | `ProgramEngine` — kebijakan target: defisit, surplus, pemeliharaan, Makan Sehat, lantai energi, makro, serat, laju dan tanggal tujuan | 1,5 | pasti | Bagian paling padat aturan; nilainya dari change 002 |
| 8 | Uji regresi `ProgramEngine` terhadap seluruh vektor uji emas change 002, termasuk setiap kode alasan | 1,0 | pasti | Menjadi jaring regresi tiap kali kebijakan berubah versi |
| 9 | Mesin keadaan siklus hidup sebagai tabel perpindahan + uji matriks seluruh pasangan (keadaan, perintah) | 1,0 | pasti | Perpindahan yang terlupakan tampak sebagai lubang di tabel |
| 10 | Perintah aktivasi: verifikasi ulang fakta, penolakan atas hasil tidak-disetujui, konfirmasi wajib | 0,75 | pasti | Diuji terhadap penyimpanan tiruan dalam memori |
| 11 | Perintah pergantian sebagai satu kesatuan: tandai lama, tautkan dua arah, catat peristiwa, aktifkan baru, batalkan seluruhnya saat gagal | 0,75 | pasti | Diuji dengan kegagalan yang disuntikkan di tiap langkah |
| 12 | Jeda, lanjutkan, selesaikan, batalkan; jejak peristiwa sebagai rentang; idempotensi perintah berulang | 0,75 | pasti | Hari jeda tidak dihitung sebagai hari aktif |
| 13 | Uji properti: target tidak pernah melewati batas kebijakan, tidak ada NaN atau tak hingga, tidak pernah ada dua program berjalan | 0,5 | pasti | Menjaring kasus yang tidak terpikirkan saat menulis uji satuan |
| 14 | Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`, serta uji arsitektur bahwa domain tidak mengimpor Flutter, Drift, atau jaringan | 0,5 | pasti | Dijalankan di akhir tiap tahap |

**Subtotal:** 7,5–10,0 hari-orang.

## Dependensi Antar-Paket

- Change 001 memblokir seluruh paket: proyek, aturan lint antar-lapisan, sumber waktu dan pengenal yang di-inject harus ada lebih dulu.
- Change 002 memblokir paket 4, 7, dan 8 dalam arti **nilai**: strukturnya boleh ditulis, tetapi angka dan vektor hasilnya berasal dari kebijakan `np-1.0.0`. Bila kebijakan belum disetujui, jalur yang diuji adalah `missing_validated_policy`.
- Paket 1 dan 2 memblokir hampir semua paket lain — satuan dan tipe hasil dipakai di mana-mana.
- Paket 3 mendahului paket 7: mesin program menerima hasil kalkulator sebagai masukan.
- Paket 5 mendahului paket 6 dan 7: aturan masukan per program menentukan apa yang divalidasi.
- Paket 9 mendahului paket 10, 11, dan 12: seluruh perintah bekerja di atas tabel perpindahan.
- Paket 13 dan 14 mengakhiri pekerjaan, bukan mendahuluinya.
- Change ini memblokir change persistensi program, onboarding dan aktivasi di layar, serta progres dan riwayat program.

## Urutan Rilis

Keduanya bukan rilis ke pengguna — tidak ada yang terlihat di aplikasi pada change ini. "Tahap" di sini berarti titik henti yang dapat diverifikasi dan di-review tersendiri.

### Tahap 1 — Perhitungan dan kelayakan

**Isi:** paket 1, 2, 3, 4, 5, 6, 7, 8.
**Prasyarat:** change 001 selesai; vektor uji emas change 002 tersedia, meski kebijakannya masih berstatus draf.
**Gate verifikasi:** `flutter analyze` dan `dart format` bersih; `flutter test` hijau; seluruh vektor uji emas change 002 lolos tanpa kecuali; setiap kode alasan punya sekurang-kurangnya satu uji; uji membuktikan bahwa `NutritionCalculator` tidak mengetahui kode program maupun status program; uji membuktikan `missing_validated_policy` dikembalikan ketika kebijakan belum disetujui, termasuk ketika perintah datang tanpa melewati antarmuka pengguna.

### Tahap 2 — Siklus hidup

**Isi:** paket 9, 10, 11, 12, 13, 14.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** uji matriks mencakup seluruh pasangan (keadaan, perintah) tanpa lubang; uji membuktikan pergantian yang gagal di setiap langkah selalu kembali ke keadaan semula; uji membuktikan tidak pernah ada dua program berjalan meski perintah diulang; uji membuktikan hari jeda tidak dihitung sebagai hari aktif dan pencatatan tetap tersedia; uji properti berjalan tanpa menemukan pelanggaran batas; uji arsitektur membuktikan domain tetap bebas Flutter, Drift, jam global, dan pembangkit pengenal langsung.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Kebijakan `np-1.0.0` berubah setelah peninjauan gizi | Paket 7 dan 8 perlu dihitung ulang | Vektor uji disusun dari aturan, bukan dari angka hasil; yang berubah hanya berkas data dan kolom hasil yang diharapkan |
| Kebijakan belum disetujui saat change ini dikerjakan | Jalur "disetujui" tidak dapat diuji dengan nilai final | Kerjakan dengan nilai draf dan jalankan ulang seluruh vektor setelah persetujuan; jalur fail-closed justru diuji penuh sejak awal |
| Bentuk masukan dan keluaran domain ternyata tidak cocok dengan kebutuhan layar | Rework di change onboarding | Turunkan bentuknya dari use case assessment §44 dan dari layar `10`–`12`, `25`–`28`, `36`, `39` di `docs/mealora.pen` sebelum menulis kode |
| Uji matriks membengkak dan lambat | Siklus umpan balik melambat | Hasilkan kasus dari tabel perpindahan, bukan tulis tangan |
| Paket 7 lebih padat dari perkiraan karena interaksi antar-aturan (lantai energi memotong defisit, lalu makro ikut berubah) | Tahap 1 melar | Kerjakan berurutan mengikuti urutan aturan di spec dan uji setiap aturan sebelum menyambungkannya |
| Godaan menggabungkan kalkulator dan mesin program karena terasa berlebihan | Melanggar §39 dan menyulitkan penggantian kebijakan | Uji khusus yang memastikan pemisahan, dijalankan sebagai bagian gate |
