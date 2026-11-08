## 1. mealora-plans — Himpunan uji dan evaluasi pengenalan komponen

- [ ] 1.1 Kumpulkan 30–50 foto makanan Indonesia yang berizin, mencakup ragam hidangan, jumlah komponen per piring, pencahayaan, dan sudut ambil (timebox dua hari)
- [ ] 1.2 Catat kunci jawaban untuk setiap foto: komponen yang benar-benar ada, porsi sebenarnya bila diketahui, dan metode masaknya
- [ ] 1.3 Tulis protokol evaluasi di `docs/food-photo-evaluation.md` beserta ambang kelulusan, ditetapkan sebelum evaluasi dijalankan
- [ ] 1.4 Jalankan evaluasi pada kandidat penyedia; ukur ketepatan identifikasi komponen, kewajaran perkiraan porsi, beban koreksi pengguna, latensi, dan biaya per catatan yang diterima
- [ ] 1.5 Jangan mengukur "akurasi gizi" sebagai metrik penyedia — nilai gizi berasal dari katalog, bukan dari model
- [ ] 1.6 Catat untuk setiap penyedia: versi model, versi perintah dan skema keluaran, tanggal uji, wilayah penyedia, dan kasus kegagalan
- [ ] 1.7 Simpulkan penyedia mana yang memenuhi ambang, atau nyatakan bahwa belum ada yang memenuhi dan jalur foto ditunda

## 2. mealora-mobile — Klien pengenalan dan pemadanan

- [ ] 2.1 Implementasikan klien pengenalan komponen di atas antarmuka penyedia change 010; jangan menulis aturan gambar baru
- [ ] 2.2 Sediakan implementasi tiruan penyedia untuk pengujian tanpa jaringan, termasuk mode gagal
- [ ] 2.3 Implementasikan pemadanan komponen ke katalog makanan, makanan buatan pengguna, dan produk yang pernah dikonfirmasi
- [ ] 2.4 Pastikan nilai gizi setiap komponen hanya berasal dari padanan tersebut, tidak pernah dari keluaran model
- [ ] 2.5 Implementasikan keadaan komponen tanpa padanan: minta pengguna mencari atau membuat makanan, dan jangan tampilkan nilai gizi apa pun untuk komponen itu
- [ ] 2.6 Uji: keluaran model yang memuat angka gizi diabaikan dan tidak pernah masuk ke nilai komponen

## 3. mealora-mobile — Draf foto

- [ ] 3.1 Implementasikan penyimpanan draf foto beserta komponen yang sudah diisi, sejak sebelum pengiriman
- [ ] 3.2 Pastikan draf bertahan melewati kegagalan layanan, kehilangan koneksi, dan penutupan aplikasi
- [ ] 3.3 Terapkan pengaturan retensi gambar change 010 pada draf yang dibatalkan maupun yang selesai dicatat
- [ ] 3.4 Uji: menutup aplikasi di tengah peninjauan lalu membukanya kembali memulihkan draf beserta komponen yang sudah diisi

## 4. mealora-mobile — Layar foto makanan

- [ ] 4.1 Bangun layar foto makanan (`19`) beserta panel persetujuan unggah, mengikuti aturan persetujuan change 010
- [ ] 4.2 Nyatakan bahwa analisis memerlukan internet, foto hanya diunggah bila diizinkan, dan catatan tetap tersimpan lokal
- [ ] 4.3 Sediakan tautan pemilihan makanan manual yang tidak mengambil maupun mengirim gambar
- [ ] 4.4 Tangani penolakan izin kamera dengan mengarahkan ke pemilihan manual, bukan layar gagal

## 5. mealora-mobile — Tinjau dan koreksi komponen

- [ ] 5.1 Bangun layar tinjau foto makanan (`03`): daftar komponen beserta jumlahnya, padanan makanan, perkiraan porsi, dan perkiraan total
- [ ] 5.2 Nyatakan bahwa saran dari foto adalah perkiraan dan porsinya perlu dicek
- [ ] 5.3 Bangun layar koreksi komponen (`38`): ubah padanan makanan, ubah porsi, tetapkan metode masak
- [ ] 5.4 Implementasikan penambahan bahan yang tidak terlihat — minyak, saus, gula — lewat jalur komponen biasa dengan pemilihan makanan dari katalog
- [ ] 5.5 Implementasikan penambahan komponen yang tidak terdeteksi dan penghapusan komponen yang keliru
- [ ] 5.6 Tandai ketidakpastian per komponen pada tiga sumbu: padanan makanan, porsi, dan metode masak
- [ ] 5.7 Nyatakan bahwa foto tidak dapat memastikan minyak, resep, bahan tersembunyi, maupun berat sebenarnya
- [ ] 5.8 Pastikan perkiraan total menyesuaikan seketika setiap kali komponen berubah
- [ ] 5.9 Pastikan menutup peninjauan tanpa konfirmasi tidak membuat catatan apa pun
- [ ] 5.10 Uji widget kedua layar pada ukuran teks normal dan besar

## 6. mealora-mobile — Kegagalan layanan dan jalur manual

- [ ] 6.1 Bangun layar draf foto dan kegagalan (`20`): nyatakan foto tersimpan sebagai draf dan belum ada catatan makan yang dibuat
- [ ] 6.2 Arahkan pengguna ke pemilihan makanan manual dengan pencarian katalog, penambahan bahan, dan pengaturan porsi sendiri
- [ ] 6.3 Tangani keadaan luring, kuota habis, waktu tunggu lewat, dan penolakan layanan memakai penanganan change 010
- [ ] 6.4 Pastikan pesan memakai bahasa yang dapat dimengerti, tanpa istilah teknis dan tanpa kode kesalahan
- [ ] 6.5 Uji seluruh keadaan kegagalan dengan penyedia tiruan yang disetel gagal, dan pastikan komponen yang sudah diisi tidak hilang

## 7. mealora-mobile — Pencatatan komponen

- [ ] 7.1 Implementasikan pencatatan satu catatan per komponen pada waktu makan dan tanggal yang dipilih
- [ ] 7.2 Bekukan potret nilai gizi tiap catatan sesuai aturan buku harian change 007
- [ ] 7.3 Tulis seluruh komponen dalam satu transaksi: berhasil semua atau tidak sama sekali
- [ ] 7.4 Picu pembangunan ulang potret kemajuan program untuk tanggal yang bersangkutan
- [ ] 7.5 Uji: kegagalan pada komponen terakhir tidak menyisakan satu pun catatan dan buku harian tidak berubah
- [ ] 7.6 Uji: setiap komponen dapat disunting, dipindahkan waktu makannya, dan dihapus sendiri setelah tercatat

## 8. mealora-mobile — Aksesibilitas, verifikasi, dan penutupan MVP 1

- [ ] 8.1 Lengkapi label pembaca layar pada seluruh kendali pemotretan, peninjauan, dan koreksi komponen
- [ ] 8.2 Pastikan penanda ketidakpastian dapat dikenali tanpa bergantung pada warna saja
- [ ] 8.3 Uji seluruh layar pada skala teks besar tanpa teks terpotong atau kendali yang tidak terjangkau
- [ ] 8.4 Periksa bahasa seluruh layar: nilai disebut berasal dari padanan katalog dan porsi perlu dicek, tanpa menyiratkan pengukuran atas makanan di foto
- [ ] 8.5 Verifikasi jalur kamera, unggah, dan kegagalan layanan di perangkat Android
- [ ] 8.6 Jalankan alur inti penuh dalam mode pesawat dan pastikan seluruhnya bekerja
- [ ] 8.7 Jalankan pemeriksaan kriteria penerimaan MVP 1 pada assessment §28 dan §50.5 secara menyeluruh, dan catat butir yang belum terpenuhi beserta alasannya
- [ ] 8.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
