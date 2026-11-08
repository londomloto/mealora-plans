## 1. mealora-plans — Rancangan layar rincian target

- [ ] 1.1 Rancang layar rincian "Bagaimana dihitung" untuk program yang sedang berjalan di `docs/mealora.pen` lewat MCP pen.dev, mengikuti struktur `30 · Detail program selesai`
- [ ] 1.2 Muat bagian: target yang berlaku, masukan yang dipakai, tingkat aktivitas, asumsi, peringatan, tanggal perhitungan terakhir, versi kalkulator, dan versi kebijakan
- [ ] 1.3 Pastikan peringatan yang menyertai pembuatan target punya tempat tetap di layar ini, bukan hanya muncul saat pratinjau
- [ ] 1.4 Pastikan seluruh nilai berlabel perkiraan dan tidak ada istilah teknis internal di teks pengguna

## 2. mealora-mobile — Ruang Program

- [ ] 2.1 Bangun ruang Program sebagai satu layar yang menampilkan keadaan berjalan maupun dijeda (`05`, `27`), dengan susunan sama dan perbedaan terbatas pada penanda keadaan serta daftar kendali
- [ ] 2.2 Tampilkan nama program, keadaan, target energi harian berlabel perkiraan, kemajuan yang sesuai jenis program, berat terbaru bila ada, dan tanggal perhitungan terakhir
- [ ] 2.3 Tampilkan kemajuan Makan Sehat sebagai kelengkapan pencatatan; pastikan tidak ada persentase kemajuan berat di layar itu
- [ ] 2.4 Tampilkan nilai yang datanya belum ada sebagai belum diketahui; pastikan tidak ada nol, grafik kosong tanpa keterangan, atau angka yang dikarang
- [ ] 2.5 Tandai keadaan dijeda tanpa bergantung pada warna saja, sertakan tanggal mulai jeda, keterangan hari jeda tidak dihitung, dan keterangan pencatatan tetap tersedia
- [ ] 2.6 Sediakan kendali jeda, ganti, dan riwayat pada keadaan berjalan; lanjutkan, ganti, dan selesaikan pada keadaan dijeda
- [ ] 2.7 Uji widget kedua keadaan pada ukuran teks normal dan besar

## 3. mealora-mobile — Keadaan khusus

- [ ] 3.1 Bangun keadaan belum ada program berjalan dengan ajakan memilih program dan penegasan catatan lama tetap ada
- [ ] 3.2 Bangun keadaan profil belum lengkap dengan tindakan melengkapi profil
- [ ] 3.3 Bangun keadaan belum ada catatan berat dengan pernyataan apa adanya, bukan 0 kg
- [ ] 3.4 Bangun keadaan kebijakan tidak tersedia memakai kerangka penolakan change 005, tanpa satu pun angka target
- [ ] 3.5 Uji: masing-masing keadaan muncul pada jalurnya dan menjelaskan tindakan yang tersedia

## 4. mealora-mobile — Rincian asal-usul target

- [ ] 4.1 Bangun layar rincian sesuai rancangan task 1.1, dapat dibuka dari ruang Program
- [ ] 4.2 Baca nilai dari program pengguna yang tersimpan; jangan menghitung ulang apa pun
- [ ] 4.3 Tampilkan peringatan yang tersimpan bersama target, termasuk peringatan batas bawah energi
- [ ] 4.4 Uji: target yang dibuat dengan peringatan tetap menampilkan peringatan itu setelah aplikasi ditutup dan dibuka kembali

## 5. mealora-mobile — Jeda, lanjutkan, dan selesaikan

- [ ] 5.1 Sambungkan kendali jeda dan lanjutkan ke perintah siklus hidup change 003 dan 004
- [ ] 5.2 Bangun layar selesaikan program (`39`): pemilihan alasan, pernyataan bahwa ringkasan akhir disimpan, pernyataan bahwa program selesai tidak dapat dilanjutkan, dan jalan batal
- [ ] 5.3 Pastikan layar penyelesaian berupa peninjauan, bukan dialog konfirmasi singkat
- [ ] 5.4 Pastikan program yang sudah selesai tidak menampilkan kendali melanjutkan di mana pun
- [ ] 5.5 Uji integrasi: jeda → catat makanan dan berat → lanjutkan; hari jeda tidak menambah hari aktif dan catatan tetap tersimpan
- [ ] 5.6 Uji: membatalkan layar penyelesaian tidak mengubah apa pun

## 6. mealora-mobile — Pergantian program

- [ ] 6.1 Bangun pratinjau ganti program (`28`): program sekarang, program pengganti beserta targetnya, penegasan program lama pindah ke riwayat, penegasan catatan tetap utuh
- [ ] 6.2 Sambungkan ke alur pratinjau target dan perintah aktivasi change 005; jangan membangun jalur aktivasi kedua
- [ ] 6.3 Pastikan layar "masukan berubah sejak pratinjau" dari change 005 juga berlaku pada jalur pergantian
- [ ] 6.4 Tangani penolakan kebijakan atas program pengganti: jelaskan tanpa angka target, biarkan program lama berjalan
- [ ] 6.5 Uji: membatalkan pratinjau tidak mengubah program, target, maupun riwayat
- [ ] 6.6 Uji: pergantian yang disetujui memindahkan program lama ke riwayat dengan keadaan diganti, menjalankan program baru, dan menjaga catatan makanan serta berat tetap utuh
- [ ] 6.7 Uji: uji aktivasi yang sama dijalankan untuk kedua jalur masuk — onboarding dan pergantian

## 7. mealora-mobile — Riwayat dan detail program

- [ ] 7.1 Bangun daftar riwayat program (`29`) berurutan menurut waktu beserta keadaan akhir dan rentang tanggal
- [ ] 7.2 Bangun detail program (`30`): masukan, target, asumsi, peringatan, kedua versi, alasan berakhir, dan kemajuan akhir yang tersedia
- [ ] 7.3 Baca nilai tersimpan apa adanya; jangan menghitung ulang dan jangan mengisi celah dengan nilai terakhir yang diketahui
- [ ] 7.4 Tampilkan nilai yang tidak pernah tercatat sebagai pernyataan apa adanya, seperti "belum ada data di hari terakhir"
- [ ] 7.5 Tampilkan penegasan bahwa riwayat program tidak mengubah catatan makanan dan berat badan
- [ ] 7.6 Uji: mengganti versi kebijakan di lingkungan uji tidak mengubah satu pun nilai pada entri riwayat

## 8. mealora-mobile — Ubah profil dan revisi target

- [ ] 8.1 Bangun layar ubah profil (`34`) dengan pernyataan bahwa perubahan tidak langsung mengubah target yang berlaku
- [ ] 8.2 Sambungkan ke peninjauan target baru memakai layar pratinjau target change 005, ditambah perbandingan terhadap target yang berjalan
- [ ] 8.3 Tampilkan selisih apa adanya tanpa penilaian; pastikan guardrail kebijakan tetap berlaku penuh
- [ ] 8.4 Tangani keadaan ketika profil yang diperbarui tidak lagi disetujui kebijakan: jelaskan tanpa angka target, biarkan target lama berlaku
- [ ] 8.5 Uji: menutup peninjauan tanpa menyetujui membiarkan target lama berlaku dan riwayat tidak berubah
- [ ] 8.6 Uji: menyetujui revisi membuat target baru berlaku sementara target sebelumnya tetap tersimpan apa adanya di riwayat

## 9. mealora-mobile — Penyambungan, aksesibilitas, dan penutupan

- [ ] 9.1 Sambungkan butir Program saya dan Riwayat program pada ruang Profil (`33`); biarkan butir lain belum aktif
- [ ] 9.2 Lengkapi label pembaca layar pada seluruh kendali siklus hidup, keadaan program, dan entri riwayat
- [ ] 9.3 Pastikan keadaan program dapat dikenali tanpa bergantung pada warna saja
- [ ] 9.4 Uji seluruh layar pada skala teks besar: tidak ada teks terpotong, tertindih, atau kendali yang tidak terjangkau
- [ ] 9.5 Verifikasi di Chrome pada viewport 390×844 dan bandingkan seluruh layar dengan `docs/mealora.pen`
- [ ] 9.6 Verifikasi alur siklus hidup penuh di perangkat Android: aktif → jeda → lanjutkan → ganti → selesaikan → riwayat
- [ ] 9.7 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
