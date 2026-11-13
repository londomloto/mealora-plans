## 1. mealora-mobile — Data energi per rentang

- [x] 1.1 Baca ulang `specs/energy-trend/spec.md`, `design.md`, serta layar `05b`, `80`, `81` di `docs/mealora-v2.pen` sebelum mulai
- [x] 1.2 Tambahkan pembacaan energi harian per rentang di repositori buku harian (satu kueri agregat) yang membedakan tiga keadaan per tanggal: tidak ada catatan, energi tidak diketahui, dan nilai kkal
- [x] 1.3 Tambahkan penurunan target energi per tanggal dari riwayat dan event program; tanggal tanpa program yang berlaku tidak punya target
- [x] 1.4 Tambahkan pembacaan tanggal catatan makan pertama pengguna untuk batas awal pemilih rentang
- [x] 1.5 Uji unit: hari kosong, hari energi tidak diketahui, hari sebagian, rata-rata hanya dari hari bernilai
- [x] 1.6 Uji unit target: program dijeda, revisi target di tengah rentang, pergantian program, tanggal sebelum program pertama

## 2. mealora-mobile — Widget grafik garis energi

- [x] 2.1 Bangun widget grafik garis dengan `CustomPainter` (tanpa dependency baru): segmen terputus di tanggal tanpa nilai, titik per tanggal bernilai, garis target putus-putus yang bertangga bila target berubah
- [x] 2.2 Terapkan skala sumbu-Y dengan rentang tampilan minimum seperti grafik berat
- [x] 2.3 Tandai tanggal belum dicatat dengan label teks dan penanda bentuk, bukan hanya warna
- [x] 2.4 Sediakan mode ringkas (tujuh slot, untuk kartu) dan mode penuh (lebar slot tetap, scroll mendatar, posisi awal di tanggal terbaru)
- [x] 2.5 Tambahkan area ketuk dan label pembaca layar per tanggal (tanggal + energi atau belum dicatat)
- [x] 2.6 Uji widget: garis terputus, label semantik, tidak ada nilai 0 untuk hari kosong

## 3. mealora-mobile — Kartu "Energi minggu ini"

- [x] 3.1 Bangun kartu di ruang Program di bawah "Kebiasaan minggu ini" sesuai layar `05b`, memakai minggu berjalan dari `WeekStart`
- [x] 3.2 Tampilkan ringkasan rata-rata, target, dan jumlah hari tercatat; tanggal setelah hari ini tanpa titik dan tanpa keterangan
- [x] 3.3 Ketuk kartu membuka layar pantauan energi
- [x] 3.4 Uji widget: awal minggu Senin dan Minggu, pertengahan minggu, minggu tanpa catatan

## 4. mealora-mobile — Riwayat pada tanggal tertentu

- [x] 4.1 Izinkan Riwayat dibuka dengan tanggal awal opsional; tanpa parameter tetap hari ini; tanggal masa depan jatuh ke hari ini
- [x] 4.2 Uji: membuka Riwayat dengan tanggal lampau memilih tanggal itu

## 5. mealora-mobile — Layar "Pantauan energi"

- [x] 5.1 Bangun layar sesuai `80`: baris rentang dengan tindakan ubah, kartu ringkasan rata-rata dan target, grafik mode penuh, keterangan hari belum dicatat
- [x] 5.2 Rentang bawaan tujuh hari terakhir termasuk hari ini; rentang hanya disimpan di state layar
- [x] 5.3 Ringkasan menyatakan target berubah bila target berbeda di dalam rentang
- [x] 5.4 Keadaan kosong seluruh rentang: keterangan belum ada catatan beserta tindakan mencatat, tanpa garis dan tanpa rata-rata
- [x] 5.5 Tooltip tanggal terpilih dengan tindakan membuka Riwayat pada tanggal itu

## 6. mealora-mobile — Pemilih rentang tanggal

- [x] 6.1 Bangun lembar bawah kalender sesuai `81`: navigasi bulan, awal minggu dari `WeekStart`, pita rentang, tanggal mulai dan akhir ditandai
- [x] 6.2 Ketuk pertama memilih mulai, ketuk kedua memilih akhir; tukar bila akhir lebih awal; rentang satu hari diterima
- [x] 6.3 Nonaktifkan tanggal setelah hari ini dan sebelum catatan makan pertama
- [x] 6.4 Tampilkan rentang dan jumlah hari sebelum Terapkan; Terapkan memperbarui layar pantauan
- [x] 6.5 Uji widget: pemilihan, penukaran, tanggal nonaktif, label semantik tanggal

## 7. mealora-mobile — Bahasa, aksesibilitas, verifikasi

- [x] 7.1 Tambahkan string l10n baru; periksa kalimat per kalimat bahwa tidak ada pujian, teguran, atau warna peringatan
- [x] 7.2 Uji widget kartu dan layar pada ukuran teks normal dan besar
- [x] 7.3 Uji performa rentang 365 hari: kueri dan scroll tetap lancar
- [x] 7.4 Jalankan `flutter analyze` dan `flutter test` sampai bersih
- [x] 7.5 Jalankan skenario FRS §5 secara manual di emulator dengan hot reload
