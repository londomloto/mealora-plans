## 1. mealora-mobile — Skema catatan berat

- [x] 1.1 Baca ulang assessment §6.10, §6.11, §11, spec change 004 dan 007, serta layar `18`, `31`, `32`, dan `40` di `docs/mealora-v2.pen` sebelum menulis tabel
- [x] 1.2 Buat tabel catatan berat sesuai §11: profil, waktu pencatatan, tanggal lokal, berat dalam kilogram, catatan bebas opsional, beserta konvensi record pengguna change 001
- [x] 1.3 Buat indeks catatan berat menurut profil dan tanggal lokal
- [x] 1.4 Naikkan `schemaVersion` dari 4 ke 5 satu kali untuk change ini; migrasi tidak menyentuh data versi 4
- [x] 1.5 Siapkan fixture migrasi: kosong, langsung v5, v4 berisi data makanan dan program, dan migrasi terputus
- [x] 1.6 Uji: migrasi mempertahankan seluruh data versi 4 dan pemeriksaan foreign key bersih

## 2. mealora-mobile — Repositori berat

- [x] 2.1 Implementasikan penambahan, penyuntingan, dan penghapusan catatan berat memakai penghapusan lunak change 001
- [x] 2.2 Implementasikan pembacaan berat terbaru sebagai catatan terbaru yang hidup; jangan menyimpan berat terkini sebagai kolom pada profil
- [x] 2.3 Implementasikan pembacaan catatan pada rentang waktu untuk keperluan tren dan daftar catatan terakhir
- [x] 2.4 Implementasikan validasi: tolak berat di luar rentang yang masuk akal dan tolak tanggal catatan di masa depan, dengan kesalahan bertipe
- [x] 2.5 Pakai tanggal lokal yang tersimpan saat pencatatan; jangan menghitung ulang dari instan UTC saat membaca
- [x] 2.6 Uji: berat terbaru tetap benar setelah penyuntingan dan setelah penghapusan catatan terakhir

## 3. mealora-mobile — Penyambungan ke program

- [x] 3.1 Picu pembangunan ulang potret kemajuan program change 004 pada setiap penambahan, penyuntingan, dan penghapusan catatan berat
- [x] 3.2 Implementasikan pemeriksaan ambang hitung ulang kebijakan `np-1.0.0` terhadap berat yang dipakai target yang berlaku
- [x] 3.3 Munculkan usulan peninjauan target di ruang Program ketika ambang terlewati; jangan menyela pengguna tepat setelah ia mencatat berat
- [x] 3.4 Pastikan target lama tetap berlaku sampai pengguna meninjau dan menyetujui target baru
- [x] 3.5 Uji: perubahan berat tercermin pada potret kemajuan tanpa penggandaan nilai
- [x] 3.6 Uji: usulan muncul hanya ketika ambang terlewati, dan tidak muncul ketika kebijakan belum disetujui
- [x] 3.7 Lengkapi pembangunan ulang potret kemajuan: hitung `weightChangeKg` dan `targetProgressRatio` (sebelumnya tidak pernah diisi, hanya `weightKg`), `null` untuk program tanpa berat tujuan
- [x] 3.8 Hapus `WeightProgressPlaceholderCard` (placeholder change 006 yang tekstualnya sudah salah); ruang Program menampilkan "Kebiasaan minggu ini" seragam untuk semua program, bukan kartu persentase berat terpisah (design D5b)

## 4. mealora-mobile — Layar berat

- [x] 4.1 Bangun layar tambah berat (`32`): nilai berat, tanggal catatan, catatan bebas opsional, dan penegasan bahwa data hanya tersimpan di perangkat
- [x] 4.2 Implementasikan penolakan nilai mustahil dan tanggal masa depan dengan penjelasan yang dapat dibaca pengguna
- [x] 4.3 Bangun layar pantau berat (`31`): berat terbaru beserta tanggal, perbandingan terhadap berat awal program bila berlaku, tren tujuh catatan terakhir, dan daftar catatan terakhir
- [x] 4.4 Tampilkan rentang tanpa catatan sebagai ketiadaan data; jangan menyambung garis dari nilai terakhir dan jangan mengisi nol
- [x] 4.5 Tampilkan keadaan satu catatan saja sebagai catatan tunggal dengan pernyataan bahwa tren belum dapat ditampilkan
- [x] 4.6 Tampilkan keadaan belum ada catatan beserta tindakan menambahkan; jangan menampilkan 0 kg atau grafik kosong tanpa keterangan
- [x] 4.7 Tampilkan berat terbaru tanpa perbandingan untuk program yang tidak memakai berat awal
- [x] 4.8 Implementasikan penyuntingan dan penghapusan catatan berat dari daftar catatan terakhir
- [x] 4.9 Periksa kalimat per kalimat: tidak ada pujian atas penurunan, teguran atas kenaikan, atau istilah yang menilai tubuh pengguna
- [x] 4.10 Uji widget kedua layar pada ukuran teks normal dan besar
- [x] 4.11 Gambar tiap titik tren sebagai jalur (track) kapsul berwarna netral berisi batang gradasi, sesuai rancangan `31`
- [x] 4.12 Ganti jendela tren dari rentang kalender (sempat empat minggu, lalu tujuh hari) menjadi selalu tujuh jalur diisi dari kiri (terlama ke terbaru), berjarak sama tanpa memperhitungkan selisih hari sebenarnya, ukuran 16×72 px sesuai rancangan `31`; jalur di sisi kanan tetap kosong/netral bila catatan belum sampai tujuh; tambahkan label indeks urutan di bawah tiap jalur, dengan label pembaca layar memakai tanggal dan berat catatan sebenarnya untuk jalur berisi, atau menyatakan belum ada catatan untuk jalur kosong
- [x] 4.13 Tampilkan jam pencatatan (bukan cuma tanggal) pada daftar "Catatan terakhir", supaya beberapa catatan di tanggal yang sama tetap bisa dibedakan

## 5. mealora-mobile — Ruang Riwayat

- [x] 5.1 Bangun ruang Riwayat (`18`) dengan kalender bulanan, perpindahan antar bulan, dan pemilihan tanggal
- [x] 5.2 Tandai tanggal yang memiliki catatan tanpa bergantung pada warna saja; jangan memakai penandaan itu sebagai nilai, peringkat, atau rangkaian
- [x] 5.3 Cegah pemilihan tanggal di masa depan
- [x] 5.4 Tampilkan ringkasan tanggal terpilih memakai ulang komponen ringkasan change 007; jangan membangun komponen ringkasan kedua
- [x] 5.5 Tampilkan daftar catatan makan tanggal itu beserta waktu makannya, dan berat badan yang tercatat pada tanggal itu bila ada
- [x] 5.6 Bangun keadaan hari tanpa catatan (`40`): konsumsi belum diketahui beserta tindakan mencatat, bukan 0 kkal dan bukan penanda gagal
- [x] 5.7 Tampilkan hari yang baru sebagian tercatat sebagai total dari yang ada, tanpa menyiratkan hari itu sudah lengkap
- [x] 5.8 Sambungkan penyuntingan catatan makan dari riwayat memakai aturan yang sama dengan hari berjalan
- [x] 5.9 Picu pembangunan ulang potret kemajuan untuk tanggal yang disunting
- [x] 5.10 Periksa bahwa tidak ada teks yang menilai, menyalahkan, atau menghukum pengguna atas hari kosong maupun hari yang melampaui target

## 6. mealora-mobile — Aksesibilitas, verifikasi, dan penutupan MVP jalur manual

- [x] 6.1 Pastikan kalender tetap utuh pada skala teks besar tanpa teks terpotong atau tanggal yang tidak terjangkau
- [x] 6.2 Pastikan pembaca layar mengumumkan setiap tanggal beserta keterangan ada atau tidaknya catatan dan keadaan terpilihnya
- [x] 6.3 Pastikan nilai berat dan ringkasan diumumkan beserta maknanya, bukan sebagai angka lepas
- [x] 6.4 Uji: ringkasan hari lampau tidak berubah setelah katalog makanan diperbarui, makanan buatan pengguna disunting, profil diubah, dan program diganti
- [x] 6.5 Uji: catatan lama tetap pada tanggal yang sama setelah zona waktu perangkat berubah
- [x] 6.6 Uji integrasi alur penuh dalam mode pesawat: catat berat → lihat tren → buka riwayat → pilih tanggal lampau → sunting catatan → ringkasan dan kemajuan menyesuaikan
- [x] 6.7 Verifikasi di Chrome pada viewport 390×844 dan bandingkan seluruh layar dengan `docs/mealora-v2.pen`
- [ ] 6.8 Verifikasi alur penuh di perangkat Android, termasuk ketahanan data setelah perangkat dimatikan dan dinyalakan
- [x] 6.9 Jalankan pemeriksaan kriteria penerimaan MVP assessment §28 untuk jalur manual, dan catat butir mana yang masih menunggu change input berikutnya
- [x] 6.10 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
