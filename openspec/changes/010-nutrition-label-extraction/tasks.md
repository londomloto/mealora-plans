## 1. mealora-plans — Himpunan uji dan evaluasi penyedia

- [ ] 1.1 Kumpulkan 30–50 foto label Informasi Nilai Gizi dari kemasan Indonesia dengan izin pemakaian, mencakup ragam format label, ukuran teks, dan kondisi pencahayaan (timebox dua hari)
- [ ] 1.2 Catat kunci jawaban untuk setiap label: basis nilai, ukuran sajian, jumlah sajian per kemasan, energi, protein, karbohidrat, dan lemak beserta satuannya
- [ ] 1.3 Tulis protokol evaluasi di `docs/label-extraction-evaluation.md`: metrik, cara pencatatan, dan ambang kelulusan — ditetapkan sebelum evaluasi dijalankan
- [ ] 1.4 Jalankan evaluasi pada kandidat penyedia; ukur akurasi basis dan jumlah sajian per kemasan, akurasi energi dan protein beserta satuan, beban koreksi, latensi, dan biaya per catatan yang diterima
- [ ] 1.5 Catat untuk setiap penyedia: versi model, versi perintah dan skema keluaran, tanggal uji, wilayah penyedia, dan kasus kegagalan
- [ ] 1.6 Simpulkan penyedia mana yang memenuhi ambang, atau nyatakan bahwa belum ada yang memenuhi dan jalur ekstraksi ditunda
- [ ] 1.7 Jangan memakai angka gizi hasil model tanpa sumber label yang dikonfirmasi, pada dokumen maupun implementasi

## 2. mealora-plans — Rancangan proksi inferensi

- [ ] 2.1 Tulis `docs/inference-proxy.md`: cakupan proksi terbatas pada inferensi, daftar tegas hal yang tidak disimpan — gambar, hasil, dan data pengguna
- [ ] 2.2 Tetapkan batas jumlah permintaan dan batas biaya beserta perilaku ketika batas terlampaui
- [ ] 2.3 Tetapkan bahwa proksi tidak mewajibkan akun dan tidak menjadi sumber kebenaran data pengguna
- [ ] 2.4 Tetapkan penanganan kredensial penyedia di sisi server dan larangan menyertakannya di aplikasi

## 3. mealora-mobile — Antarmuka penyedia dan akses gambar

- [ ] 3.1 Definisikan antarmuka penyedia model yang dapat diganti, beserta implementasi tiruan untuk pengujian tanpa jaringan
- [ ] 3.2 Implementasikan klien yang memanggil proksi inferensi; pastikan tidak ada kunci API atau kredensial penyedia di dalam aplikasi
- [ ] 3.3 Implementasikan alur persetujuan unggah per gambar beserta pernyataan: apa yang diunggah, untuk apa, bahwa perlu koneksi, dan bahwa ada jalur tanpa unggah
- [ ] 3.4 Pastikan persetujuan satu gambar tidak terbawa ke gambar berikutnya kecuali pengguna menetapkan pilihan tetap pada pengaturan privasi
- [ ] 3.5 Implementasikan pengaturan privasi izin unggah foto dengan bawaan tanya setiap kali, sesuai rancangan `35`
- [ ] 3.6 Implementasikan pengaturan dan penerapan retensi gambar sumber dengan bawaan hapus setelah dicatat
- [ ] 3.7 Pastikan gambar yang disimpan berada di perangkat dan ikut terhapus saat penghapusan seluruh data lokal
- [ ] 3.8 Uji: tidak ada gambar terkirim tanpa persetujuan, dibuktikan dengan pengamatan permintaan jaringan

## 4. mealora-mobile — Penanganan kegagalan layanan

- [ ] 4.1 Tangani keadaan luring, waktu tunggu terlampaui, kuota habis, dan penolakan penyedia sebagai keadaan yang dirancang
- [ ] 4.2 Nyatakan setiap keadaan itu dalam bahasa yang dapat dimengerti pengguna, tanpa istilah teknis dan tanpa kode kesalahan
- [ ] 4.3 Pastikan foto yang sudah diambil dan nilai yang sudah diisi tidak hilang akibat kegagalan
- [ ] 4.4 Tawarkan jalur manual yang setara pada setiap keadaan kegagalan
- [ ] 4.5 Pastikan alur inti — buku harian, program, berat, riwayat — tetap bekerja penuh tanpa koneksi
- [ ] 4.6 Uji seluruh keadaan kegagalan dengan penyedia tiruan yang disetel gagal

## 5. mealora-mobile — Penyimpanan hasil dan migrasi

- [ ] 5.1 Tambahkan nilai asal-usul untuk hasil ekstraksi label yang dikonfirmasi pengguna pada tabel produk change 009
- [ ] 5.2 Tambahkan rujukan opsional ke gambar sumber, dipakai hanya bila pengaturan retensi mengizinkan
- [ ] 5.3 Naikkan `schemaVersion` dari 6 ke 7 satu kali untuk change ini
- [ ] 5.4 Siapkan fixture migrasi dan uji: migrasi mempertahankan seluruh data versi 6 dan pemeriksaan foreign key bersih

## 6. mealora-mobile — Layar foto label

- [ ] 6.1 Bangun layar foto label (`23`): panduan pemotretan agar teks dan satuan terbaca jelas
- [ ] 6.2 Tampilkan panel persetujuan unggah sebelum pengiriman, beserta keterangan kebutuhan koneksi
- [ ] 6.3 Sediakan tautan ke pengisian manual tanpa unggah dari layar ini
- [ ] 6.4 Pastikan memilih jalur manual tidak mengambil maupun mengirim gambar
- [ ] 6.5 Tangani penolakan izin kamera dengan mengarahkan ke pengisian manual, bukan layar gagal

## 7. mealora-mobile — Layar tinjau ekstraksi

- [ ] 7.1 Bangun layar tinjau ekstraksi (`24`) dengan foto label asli berdampingan dengan nilai yang terbaca, tanpa perpindahan layar
- [ ] 7.2 Tampilkan basis label yang terbaca untuk diperiksa; bila tidak terbaca, minta pengguna menetapkannya dan jangan menebak
- [ ] 7.3 Nyatakan hubungan satu sajian dan satu kemasan ketika keduanya diketahui
- [ ] 7.4 Buat setiap nilai dapat disunting dan beri penanda: terbaca yakin, perlu diperiksa, atau tidak terbaca
- [ ] 7.5 Tandai nilai yang tidak terbaca, keyakinannya rendah, atau satuannya ambigu sebagai belum diketahui atau perlu diperiksa; jangan pernah mengisi nol atau tebakan
- [ ] 7.6 Tahan konfirmasi selama ada nilai penting yang belum terisi atau belum diperiksa, dan sebutkan nilai mana yang menahan
- [ ] 7.7 Sediakan cara menyatakan bahwa sebuah nilai memang tidak tercantum pada kemasan, tersimpan sebagai belum diketahui
- [ ] 7.8 Periksa bahasa layar: hasil disebut bacaan yang perlu diperiksa, bukan data terverifikasi atau nilai resmi produk
- [ ] 7.9 Pastikan menutup layar tanpa konfirmasi tidak membuat catatan maupun rekaman produk, dan foto diperlakukan sesuai pengaturan retensi

## 8. mealora-mobile — Isi label manual dan pencatatan

- [ ] 8.1 Bangun layar isi label manual (`37`): nama produk, basis nilai, ukuran sajian, jumlah sajian per kemasan, energi, protein, karbohidrat, dan lemak
- [ ] 8.2 Nyatakan aritmetika kemasan yang berlaku, termasuk bahwa nilai per sajian bukan nilai per 100 g
- [ ] 8.3 Tolak nilai mustahil dengan penjelasan; simpan nilai yang dikosongkan sebagai belum diketahui
- [ ] 8.4 Pastikan jalur ini bekerja penuh tanpa koneksi dan tanpa izin kamera
- [ ] 8.5 Pakai ulang aritmetika basis takaran change 009; jangan menulis implementasi kedua
- [ ] 8.6 Sambungkan pencatatan ke buku harian change 007 dengan potret nilai gizi yang dibekukan
- [ ] 8.7 Simpan produk yang dikonfirmasi beserta barcode bila ada, varian kemasan, basis takaran, tanggal verifikasi, dan asal-usulnya
- [ ] 8.8 Uji: produk hasil ekstraksi dapat ditemukan luring lewat pemindaian barcode dan pencarian nama
- [ ] 8.9 Uji: catatan lama tidak berubah setelah nilai produk dikoreksi

## 9. mealora-mobile — Aksesibilitas, verifikasi, dan penutupan

- [ ] 9.1 Lengkapi label pembaca layar pada seluruh kendali pemotretan, peninjauan, penyuntingan nilai, dan pengisian manual
- [ ] 9.2 Pastikan penanda keyakinan per nilai dapat dikenali tanpa bergantung pada warna saja
- [ ] 9.3 Uji seluruh layar pada skala teks besar tanpa teks terpotong atau kendali yang tidak terjangkau
- [ ] 9.4 Periksa paket aplikasi yang didistribusikan dan pastikan tidak ada kunci API maupun kredensial penyedia di dalamnya
- [ ] 9.5 Jalankan alur inti penuh dalam mode pesawat dan pastikan seluruhnya bekerja
- [ ] 9.6 Verifikasi jalur kamera dan unggah di perangkat Android, termasuk penolakan izin dan kegagalan layanan
- [ ] 9.7 Verifikasi layar yang tidak memerlukan kamera di Chrome pada viewport 390×844 dan bandingkan dengan `docs/mealora.pen`
- [ ] 9.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
