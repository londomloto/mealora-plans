## 1. mealora-plans — Rancangan layar dan bahasa

- [ ] 1.1 Rancang layar "masukan berubah sejak pratinjau" di `docs/mealora.pen` lewat MCP pen.dev, mengikuti bahasa visual `12 · Tinjau target`: pernyataan singkat, daftar nilai yang berubah beserta nilai lama dan baru, pratinjau target yang diperbarui, dan tindakan untuk meninjau serta menyetujui ulang
- [ ] 1.2 Pastikan nada layar itu netral — perubahan data bukan kesalahan pengguna — dan tidak memakai gaya dialog kesalahan
- [ ] 1.3 Tulis pemetaan setiap kode alasan penolakan ke kalimat Indonesia untuk kerangka layar `26`, melanjutkan hasil change 002
- [ ] 1.4 Periksa setiap kalimat terhadap tiga larangan: tidak mendiagnosis, tidak menjanjikan hasil, tidak menyalahkan pengguna; pastikan setiap kalimat menyebut bahwa tidak ada target yang dibuat dan tidak ada data yang berubah

## 2. mealora-mobile — Profil dan migrasi skema 2 → 3

- [ ] 2.1 Buat tabel profil sesuai assessment §11 dengan konvensi record pengguna change 001, ditambah penanda kelengkapan onboarding
- [ ] 2.2 Lengkapi rujukan profil pada tabel program menjadi foreign key sungguhan ke tabel profil
- [ ] 2.3 Naikkan `schemaVersion` dari 2 ke 3 satu kali untuk change ini; migrasi tidak membuat profil otomatis dan tidak mengaktifkan program apa pun
- [ ] 2.4 Implementasikan repositori profil yang menyimpan tinggi dalam sentimeter dan berat dalam kilogram sebagai satuan kanonis
- [ ] 2.5 Implementasikan validasi nilai profil beserta rentang yang diterima, mengembalikan kesalahan bertipe yang menyebut nilai mana yang bermasalah
- [ ] 2.6 Siapkan fixture migrasi: kosong, pembuatan langsung v3, v2 berisi data program, v2 berisi program tanpa profil, dan migrasi terputus
- [ ] 2.7 Putuskan dan catat perlakuan terhadap baris program tanpa profil pada basis data v2 saat fixture dibuat; dokumentasikan di catatan migrasi
- [ ] 2.8 Uji: migrasi mempertahankan seluruh data, pemeriksaan foreign key bersih, dan tidak ada profil maupun program yang dibuat otomatis

## 3. mealora-mobile — Wadah state onboarding

- [ ] 3.1 Buat satu wadah state untuk seluruh alur onboarding: masukan terkumpul, langkah saat ini, hasil perhitungan terakhir
- [ ] 3.2 Implementasikan penyimpanan bertahap: setiap langkah menyimpan masukannya begitu sah, sehingga penutupan aplikasi tidak menghilangkan isian
- [ ] 3.3 Implementasikan penanda kelengkapan onboarding, dan pastikan perhitungan target tidak pernah dijalankan atas profil yang belum lengkap
- [ ] 3.4 Implementasikan navigasi maju-mundur antar langkah tanpa kehilangan isian, beserta indikator langkah keberapa dari berapa
- [ ] 3.5 Uji: menutup aplikasi di tiap langkah lalu membukanya kembali melanjutkan dari langkah yang benar dengan isian utuh

## 4. mealora-mobile — Layar pengumpulan masukan

- [ ] 4.1 Bangun layar sambutan (`07`): pernyataan tanpa akun, bisa luring, data tersimpan di perangkat
- [ ] 4.2 Bangun layar profil awal (`08`): nama panggilan opsional, tanggal lahir, tinggi badan, berat saat ini, masukan biologis
- [ ] 4.3 Tampilkan keterangan bahwa masukan biologis dipakai hanya untuk persamaan estimasi energi, bukan sebagai identitas gender
- [ ] 4.4 Implementasikan penolakan nilai tidak masuk akal dengan penjelasan rentang, dan penahanan langkah selama isian wajib belum sah
- [ ] 4.5 Bangun layar tingkat aktivitas (`09`): tiga pilihan dengan penjelasan sehari-hari dan keterangan bahwa pilihan memengaruhi perkiraan serta dapat diubah
- [ ] 4.6 Bangun layar pemilihan program (`10`): empat program, keterangan bahwa program dapat diganti, dan keterangan bahwa rekomendasi berat memerlukan kebijakan tervalidasi
- [ ] 4.7 Bangun layar detail program (`11`): masukan tambahan sesuai program, fokus kebiasaan untuk Makan Sehat, dan pengakuan bahwa hasil adalah perkiraan
- [ ] 4.8 Implementasikan penahanan langkah bila pengakuan perkiraan belum diberikan
- [ ] 4.9 Bangun layar target berat (`25`) untuk Turun Berat dan Naik Berat: berat awal, berat tujuan, tanggal tujuan opsional, dan keterangan bahwa tanggal tidak mengesampingkan aturan keselamatan
- [ ] 4.10 Pastikan Makan Sehat dan Pertahankan tidak pernah menampilkan isian berat tujuan di seluruh alur
- [ ] 4.11 Uji widget setiap layar pada ukuran teks normal dan besar

## 5. mealora-mobile — Pratinjau dan aktivasi

- [ ] 5.1 Bangun layar tinjau target (`12`): target energi harian, dasar perkiraan, asumsi, peringatan, versi kalkulator, versi kebijakan, dan pernyataan bahwa belum ada program aktif
- [ ] 5.2 Pastikan pratinjau murni perhitungan: tidak ada baris program yang ditulis, termasuk sebagai draf
- [ ] 5.3 Sambungkan tindakan setujui ke perintah aktivasi change 003 dan 004; biarkan perintah yang memverifikasi ulang fakta, jangan membandingkan di lapisan tampilan
- [ ] 5.4 Bangun layar "masukan berubah sejak pratinjau" sesuai rancangan task 1.1, menampilkan nilai yang berubah dan pratinjau diperbarui
- [ ] 5.5 Implementasikan pendaratan ke ruang Hari ini setelah aktivasi berhasil
- [ ] 5.6 Uji: menutup pratinjau tidak menyisakan data program apa pun
- [ ] 5.7 Uji: mengubah berat profil setelah pratinjau lalu menyetujui membatalkan aktivasi dan menampilkan pratinjau diperbarui, dan tidak ada program yang aktif dengan nilai lama

## 6. mealora-mobile — Keadaan tidak-disetujui dan belum ada program

- [ ] 6.1 Bangun satu kerangka layar keadaan tidak-disetujui (`26`) dengan judul, penjelasan, dan tawaran langkah berikutnya yang berbeda menurut kode alasan
- [ ] 6.2 Tanam pemetaan kode alasan ke kalimat hasil task 1.3 di lapisan tampilan, bukan di domain
- [ ] 6.3 Implementasikan penanganan laju terlalu cepat: jelaskan konflik, sebutkan tanggal paling awal yang memenuhi batas, minta masukan diubah
- [ ] 6.4 Bangun keadaan belum ada program (`36`) dengan ajakan memilih dan penegasan bahwa catatan lama tetap ada
- [ ] 6.5 Pastikan keadaan itu muncul pada ketiga jalurnya: melewati pemilihan, program berakhir, dan pengguna dari versi sebelumnya
- [ ] 6.6 Uji: tidak ada angka target yang muncul pada keadaan tidak-disetujui, termasuk setelah pengguna sempat melihat pratinjau pada sesi yang sama
- [ ] 6.7 Uji: setiap kode alasan menampilkan kalimat yang benar dan menyebut bahwa tidak ada target yang dibuat

## 7. mealora-mobile — Ruang Hari ini dan penutupan

- [ ] 7.1 Sambungkan ruang Hari ini ke program aktif: tampilkan chip program dan target energi harian menggantikan keadaan kosong change 001
- [ ] 7.2 Tampilkan konsumsi sebagai "belum diketahui", bukan nol, karena pencatatan makanan belum tersedia
- [ ] 7.3 Lengkapi label pembaca layar pada seluruh isian, pilihan, tombol, dan pesan kesalahan di alur onboarding
- [ ] 7.4 Pastikan pesan kesalahan dapat dikenali tanpa bergantung pada warna
- [ ] 7.5 Uji integrasi alur penuh dalam mode pesawat: pemasangan baru → onboarding → aktivasi → ruang Hari ini → tutup aplikasi → buka kembali → program masih aktif
- [ ] 7.6 Verifikasi di Chrome pada viewport 390×844 dan bandingkan seluruh layar dengan `docs/mealora.pen`
- [ ] 7.7 Verifikasi alur penuh di perangkat Android
- [ ] 7.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
