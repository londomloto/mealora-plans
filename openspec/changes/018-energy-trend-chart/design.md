## Context

Lihat `proposal.md` untuk motivasi dan `specs/energy-trend/spec.md` untuk perilaku. Kondisi kode `mealora-apps/mealora-mobile` yang relevan:

- Total energi per tanggal sudah tersedia per satu hari (`DiaryRepository.dailyTotal`, `dailyNutritionTotalProvider`), belum ada pembacaan per rentang.
- `ProgramProgressSnapshot` menyimpan `consumedEnergyKcal` per hari, tetapi terikat ke satu `userProgramId` dan hanya ada untuk hari ketika program berjalan.
- Ruang Program sudah punya `WeeklyConsistencyCard` (`features/program/widgets/progress_section.dart`) yang menghitung tujuh hari minggu berjalan memakai `WeekStart`.
- Grafik berat (`features/weight/widgets/weight_trend_chart.dart`) digambar tanpa library chart.
- Riwayat (`features/history/history_screen.dart`) menyimpan tanggal terpilih di state lokal dan belum bisa dibuka pada tanggal tertentu dari luar.

## Goals / Non-Goals

**Goals:**
- Satu sumber data rentang energi harian yang dipakai kartu Program dan layar pantauan.
- Garis yang benar-benar terputus pada hari kosong, dan pembedaan yang tegas antara "belum dicatat", "energi tidak diketahui", dan nilai energi.

**Non-Goals:**
- Grafik makronutrien atau berat pada layar yang sama.
- Penanda kelengkapan per hari (diputuskan tidak dipakai).
- Preset rentang (7/30 hari/bulan ini); hanya rentang bebas dengan bawaan 7 hari.
- Ekspor atau berbagi grafik.

## Decisions

**D1. Sumber energi harian dari buku harian, bukan potret kemajuan.**
Tambahkan pembacaan total energi per tanggal untuk rentang (satu kueri agregat per rentang di repositori buku harian) yang mengembalikan, per tanggal, salah satu dari: tidak ada catatan, ada catatan tetapi energi tidak diketahui, atau nilai kkal.
Alternatif: memakai `ProgramProgressSnapshot.consumedEnergyKcal`. Ditolak karena potret hanya ada selama program berjalan dan per program, sehingga rentang yang melintasi pergantian program atau sebelum program pertama akan bolong secara keliru. Buku harian adalah sumber kebenaran konsumsi.

**D2. Target per tanggal diturunkan dari riwayat program.**
Target energi untuk setiap tanggal diambil dari program (dan revisi target) yang berlaku pada tanggal itu, memakai riwayat program dan event yang sudah tersimpan. Tanggal tanpa program yang berlaku tidak punya target. Tidak ada tabel atau kolom baru.
Alternatif: memakai target program aktif hari ini untuk seluruh rentang. Ditolak karena keliru untuk rentang yang melintasi revisi atau pergantian program.

**D3. Satu widget grafik garis custom, dipakai dua tempat.**
Widget grafik garis energi dibuat dengan `CustomPainter`: segmen garis dipecah di setiap tanggal tanpa nilai; garis target digambar putus-putus dan bertangga bila target berubah; skala sumbu-Y dari min/maks nilai dan target dengan rentang tampilan minimum agar fluktuasi kecil tidak tampak dramatis (pola sama dengan grafik berat). Kartu Program memakai mode ringkas tujuh slot; layar pantauan memakai mode penuh dengan lebar slot tetap dan `SingleChildScrollView` mendatar bila jumlah tanggal melebihi lebar layar, digulir ke ujung kanan (tanggal terbaru) saat dibuka.
Alternatif: menambah `fl_chart`. Ditolak sesuai kesepakatan tanpa dependency baru dan agar gaya konsisten dengan grafik berat.

**D4. Interaksi ketuk lewat lapisan semantik per slot.**
Setiap slot tanggal adalah area ketuk dengan `Semantics` sendiri (tanggal + nilai / belum dicatat). Ketukan memilih tanggal dan menampilkan tooltip di atas grafik; tooltip berisi tindakan "buka Riwayat".

**D5. Riwayat menerima tanggal awal.**
Rute Riwayat menerima tanggal awal opsional; tanpa parameter perilakunya tetap seperti sekarang (hari ini). Tanggal masa depan diabaikan dan jatuh ke hari ini.

**D6. Pemilih rentang sebagai lembar bawah custom.**
Kalender bulanan dalam bottom sheet sesuai layar `81`: ketuk pertama memilih mulai, ketuk kedua memilih akhir (bila lebih awal dari mulai, keduanya ditukar), tanggal setelah hari ini dinonaktifkan, awal minggu mengikuti `WeekStart`, dan tombol Terapkan menampilkan jumlah hari. Batas paling awal yang bisa dipilih: tanggal catatan makan pertama pengguna (atau hari ini bila belum ada catatan).
Alternatif: `showDateRangePicker` bawaan. Ditolak karena tampil layar penuh bergaya Material yang tidak sesuai desain Mealora.

**D7. Rentang tidak disimpan.**
Rentang terpilih hidup di state layar saja; membuka ulang layar kembali ke tujuh hari terakhir, sesuai spec.

## Risks / Trade-offs

- [Rentang sangat panjang (berbulan-bulan) membuat kueri dan painter berat] → agregasi satu kueri per rentang di database; lebar slot tetap dengan scroll mendatar sehingga painter hanya menggambar lebar konten; uji performa dengan rentang 365 hari.
- [Penurunan target per tanggal dari event program bisa salah untuk kasus jeda/lanjut] → uji unit khusus: program dijeda, revisi target, pergantian program, dan tanggal sebelum program pertama.
- [Kalender custom menambah permukaan aksesibilitas] → label semantik per tanggal, uji ukuran teks besar, target ketuk minimal 40 px sesuai desain.
- [Kartu baru memperpanjang ruang Program] → kartu ringkas setinggi kartu kebiasaan; diverifikasi di ukuran layar kecil.

## Migration Plan

Tidak ada migrasi data. Perubahan murni tampilan dan pembacaan. Rollback cukup dengan menghapus kartu dan rute baru.
