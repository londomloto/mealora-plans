## Why

Pengguna sudah bisa melihat energi (kkal) per hari di Riwayat dan tren berat di layar pantau berat, tetapi belum ada cara melihat **arah konsumsi energi antarhari** dibanding target program. Tanpa itu pengguna harus membuka Riwayat satu per satu tanggal untuk menilai minggunya.

## What Changes

- Kartu baru **"Energi minggu ini"** di ruang Program, di bawah "Kebiasaan minggu ini": grafik garis kkal harian untuk minggu berjalan (mengikuti preferensi awal minggu), garis target program, dan ringkasan rata-rata.
- Layar baru **"Pantauan energi"** (dibuka dari kartu tersebut): rentang tanggal bebas yang dipilih pengguna, ringkasan rata-rata terhadap target, grafik garis kkal harian dengan garis target, dan keterangan hari tanpa catatan.
- **Pemilih rentang tanggal** dalam bentuk lembar bawah berisi kalender: memilih tanggal mulai dan akhir; tanggal masa depan tidak bisa dipilih. Bawaannya 7 hari terakhir sampai hari ini.
- Hari tanpa catatan makan ditampilkan sebagai **ketiadaan data** (garis terputus dan ditandai), tidak dihitung ke rata-rata, dan tidak pernah ditampilkan sebagai 0 kkal. Hari yang baru sebagian tercatat tampil apa adanya, tanpa penanda kelengkapan.
- Mengetuk titik hari memunculkan nilai hari itu dan dapat membuka Riwayat pada tanggal tersebut.
- Tidak ada dependency grafik baru; desain mengikuti gaya grafik yang sudah ada.

Desain acuan: `docs/mealora-v2.pen` layar `05b`, `80`, `81`.

## Capabilities

### New Capabilities

- `energy-trend`: tampilan tren energi harian terhadap target — kartu minggu berjalan di ruang Program, layar pantauan dengan rentang tanggal bebas, perlakuan hari tanpa catatan, dan navigasi ke Riwayat.

### Modified Capabilities

(tidak ada — kartu baru ditambahkan ke ruang Program tanpa mengubah requirement `program-management` atau `daily-history` yang ada)

## Impact

- `mealora-apps/mealora-mobile`: fitur Program (kartu baru), layar dan rute baru pantauan energi, pembacaan total energi harian per rentang dari buku harian, pembacaan target energi per tanggal, navigasi Riwayat ke tanggal tertentu, string l10n baru.
- Tidak ada perubahan skema database, proxy, atau versi kebijakan nutrisi.
- Tidak ada dependency baru.
