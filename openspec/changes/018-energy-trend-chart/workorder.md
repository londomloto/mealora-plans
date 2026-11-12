# Work Order

## Ringkasan

Change ini menambahkan pantauan energi harian ke `mealora-mobile`: kartu minggu berjalan di halaman Program, halaman Pantauan energi dengan rentang tanggal bebas, dan pembukaan Riwayat pada tanggal tertentu (lihat `frs.md`). Hanya satu repo yang tersentuh. Tidak ada perubahan database, proxy, atau dependency. Pengiriman dibagi menjadi dua tahap.

## Breakdown per Repository

### mealora-apps/mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Pembacaan energi harian per rentang dan target per tanggal, beserta uji unit | 1,5 | pasti | Target per tanggal dari riwayat dan event program (design D2) |
| 2 | Widget grafik garis energi (ringkas dan penuh, segmen terputus, target bertangga, semantik per tanggal) | 2 | pasti | Pola mengikuti grafik berat |
| 3 | Kartu "Energi minggu ini" di halaman Program | 0,5 | pasti | |
| 4 | Halaman Pantauan energi, ringkasan, keadaan kosong, tooltip | 1,5 | pasti | |
| 5 | Lembar bawah pemilih rentang (kalender custom) | 1,5 | pasti | |
| 6 | Riwayat menerima tanggal awal dan navigasi dari grafik | 0,5 | pasti | |
| 7 | l10n, uji widget (teks normal/besar), uji performa rentang 365 hari, review bahasa | 1 | pasti | |

Total perkiraan: 8,5 hari-orang.

## Dependensi Antar-Paket

- Paket 1 harus selesai sebelum paket 3 dan 4.
- Paket 2 harus selesai sebelum paket 3 dan 4.
- Paket 5 harus selesai sebelum rentang bebas di paket 4 bisa diuji ujung ke ujung.
- Paket 6 tidak bergantung pada paket lain dan bisa dikerjakan paralel.

## Urutan Rilis

### Tahap 1 — Kartu energi di Program

**Isi:** paket 1, 2, 3, 6.
**Prasyarat:** tidak ada.
**Gate verifikasi:** `flutter analyze` bersih, `flutter test` hijau, cek manual di emulator: kartu tampil, hari kosong terputus, ketuk kartu belum perlu membuka apa-apa (atau membuka halaman pantauan versi 7 hari).

### Tahap 2 — Pantauan energi dengan rentang bebas

**Isi:** paket 4, 5, 7.
**Prasyarat:** tahap 1 selesai.
**Gate verifikasi:** `flutter analyze` dan `flutter test` hijau; skenario uji di FRS §5 dijalankan manual di emulator; rentang 365 hari tetap lancar digeser.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Kasus tepi target per tanggal (jeda, revisi, pergantian program) lebih rumit dari perkiraan | Paket 1 molor 1 hari | Tulis uji kasus tepi lebih dulu; bila tetap rumit, batasi garis target ke program yang berlaku dan tandai sisanya |
| Kalender custom butuh penyesuaian aksesibilitas | Paket 5 molor | Pakai ulang pola kalender Riwayat yang sudah ada |
| Performa painter pada rentang panjang | Paket 2/4 molor | Lebar slot tetap dan scroll mendatar; uji 365 hari sejak awal |
