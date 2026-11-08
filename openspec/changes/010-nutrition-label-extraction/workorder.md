# Work Order

## Ringkasan

Change ini membangun jalur pembacaan label gizi di dua repositori, ditambah satu komponen operasional baru. Di `mealora-plans`, disusun evaluasi penyedia model dengan himpunan uji label Indonesia yang berizin, dan dirancang proksi inferensi beserta batas biayanya. Di `mealora-apps/mealora-mobile`, dibangun klien penyedia di balik antarmuka, pengaturan persetujuan dan retensi gambar, serta tiga layar: foto label, tinjau ekstraksi, dan isi label manual. Proksi inferensi adalah satu-satunya komponen sisi server dalam MVP 1 dan cakupannya dibatasi pada inferensi. Estimasi 11–15 hari-orang dalam empat tahap, di luar waktu pengumpulan himpunan uji.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Kumpulkan himpunan uji 30–50 label kemasan Indonesia yang berizin, dengan ragam format dan kondisi foto | 1,5 | spike (timebox 2 hari) | §50.6 mensyaratkan ini sebelum penyedia dipilih |
| 2 | Susun protokol evaluasi: metrik, cara pencatatan hasil, dan ambang kelulusan | 0,5 | pasti | Akurasi basis dan sajian per kemasan, akurasi energi dan protein, beban koreksi, latensi, biaya per catatan diterima |
| 3 | Jalankan evaluasi pada kandidat penyedia dan dokumentasikan hasilnya beserta versi model, versi perintah, tanggal, wilayah, dan kasus kegagalan | 1,5 | spike | Penyedia tidak dipilih sebelum paket ini selesai |
| 4 | Rancang proksi inferensi: cakupan, batas permintaan, batas biaya, perilaku saat batas terlampaui, dan apa yang tidak disimpan | 0,75 | pasti | Tidak menyimpan gambar, hasil, maupun data pengguna |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 5 | Antarmuka penyedia model dan klien yang memanggil proksi, beserta implementasi tiruan untuk uji | 1,0 | pasti | Penggantian penyedia tidak menyentuh layar |
| 6 | Alur persetujuan unggah gambar per pengiriman, beserta pengaturan privasi tanya setiap kali | 0,75 | pasti | Mengikuti rancangan `35` |
| 7 | Pengaturan dan penerapan retensi gambar sumber: simpan atau hapus setelah dicatat | 0,5 | pasti | Bawaan menghapus |
| 8 | Penanganan kegagalan layanan: luring, waktu tunggu, kuota habis, penolakan — tanpa menghilangkan draf | 1,0 | pasti | Bahasa tanpa istilah teknis |
| 9 | Layar foto label (`23`) beserta panduan pemotretan dan panel persetujuan unggah | 1,0 | pasti | Jalur manual tersedia dari layar ini |
| 10 | Layar tinjau ekstraksi (`24`): foto berdampingan nilai, penanda keyakinan per nilai, basis label, penyuntingan nilai | 2,0 | pasti | Bagian terberat; konfirmasi tertahan sampai nilai penting beres |
| 11 | Layar isi label manual luring (`37`) beserta pemilihan basis dan pengingat aritmetika kemasan | 1,25 | pasti | Jalur setara, bukan cadangan |
| 12 | Penyimpanan hasil pada tabel produk change 009 beserta asal-usul ekstraksi dan migrasi skema 6 → 7 | 0,75 | pasti | Perubahan skema minimal |
| 13 | Penyambungan ke pencatatan dan pemakaian ulang aritmetika basis takaran change 009 | 0,5 | pasti | Jangan menulis aritmetika kedua |
| 14 | Aksesibilitas, pemeriksaan bahasa, dan gate verifikasi repo | 1,0 | pasti | Termasuk pemeriksaan bahwa tidak ada kredensial di paket aplikasi |

**Subtotal:** 11,0–15,0 hari-orang, di luar waktu pengumpulan himpunan uji yang bergantung pada ketersediaan kemasan.

## Dependensi Antar-Paket

- Change 007 dan 009 memblokir seluruh paket di `mealora-mobile`.
- Paket 1 mendahului paket 2 dan 3; paket 3 mendahului pemilihan penyedia untuk rilis, tetapi **tidak** memblokir paket 5 sampai 14 — seluruh layar dan jalur manual dapat dibangun dan diuji dengan penyedia tiruan.
- Paket 4 mendahului penyiapan proksi di lingkungan uji.
- Paket 5 mendahului paket 8 dan 10.
- Paket 6 mendahului paket 9.
- Paket 12 mendahului paket 13.
- Paket 14 mengakhiri pekerjaan.
- Change ini memblokir change foto makanan, yang memakai ulang seluruh kapabilitas akses gambar.

## Urutan Rilis

### Tahap 1 — Evaluasi dan rancangan proksi

**Isi:** paket 1, 2, 3, 4.
**Prasyarat:** change 009 selesai.
**Gate verifikasi:** himpunan uji memenuhi jumlah dan ragam yang disyaratkan serta berizin; protokol evaluasi menetapkan metrik dan ambang kelulusan sebelum evaluasi dijalankan; hasil evaluasi tercatat lengkap dengan versi model, versi perintah, tanggal, wilayah penyedia, dan kasus kegagalan; rancangan proksi menyatakan batas permintaan, batas biaya, dan daftar hal yang tidak disimpan.

### Tahap 2 — Fondasi akses gambar

**Isi:** paket 5, 6, 7, 8, 12.
**Prasyarat:** tahap 1 selesai untuk paket 4; paket 3 boleh berjalan paralel.
**Gate verifikasi:** `flutter analyze`, `dart format`, dan `flutter test` bersih; fixture migrasi lolos; tidak ada gambar terkirim tanpa persetujuan, diuji termasuk dengan pengamatan permintaan jaringan; persetujuan satu gambar tidak terbawa ke gambar berikutnya; retensi gambar diterapkan sesuai pengaturan dan ikut terhapus saat penghapusan data lokal; seluruh keadaan kegagalan layanan menyisakan draf utuh dan menawarkan jalur manual; tidak ada kredensial penyedia di paket aplikasi.

### Tahap 3 — Layar label

**Isi:** paket 9, 10, 11, 13.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** uji widget seluruh layar pada ukuran teks normal dan besar; foto asli tampil berdampingan dengan nilai yang terbaca; setiap nilai dapat disunting dan punya penanda keyakinan; basis label ditampilkan untuk diperiksa dan tidak pernah ditebak saat tidak terbaca; konfirmasi tertahan selama ada nilai penting yang belum beres, dengan penyebutan nilai mana; pengguna dapat menyatakan sebuah nilai memang tidak tercantum; pengisian manual bekerja penuh dalam mode pesawat; aritmetika kemasan memakai implementasi change 009, dibuktikan lewat uji yang sama.

### Tahap 4 — Pengerasan dan verifikasi perangkat

**Isi:** paket 14.
**Prasyarat:** tahap 3 selesai dan gate-nya lolos.
**Gate verifikasi:** menutup peninjauan tanpa konfirmasi tidak meninggalkan catatan maupun rekaman produk; produk hasil ekstraksi dapat ditemukan luring lewat barcode dan nama; catatan lama tidak berubah setelah koreksi; pemeriksaan bahasa memastikan hasil tidak disebut sebagai data terverifikasi; alur inti dijalankan penuh dalam mode pesawat; verifikasi di perangkat Android untuk jalur kamera; pemeriksaan skala teks besar dan pembaca layar.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Himpunan uji berizin sulit dikumpulkan | Tahap 1 melar dan pemilihan penyedia tertunda | Timebox dua hari; paket 5–14 tetap berjalan dengan penyedia tiruan; bila belum cukup saat rilis, jalur ekstraksi ditunda sementara jalur manual tetap dikirim |
| Akurasi penyedia tidak memenuhi ambang | Fitur ekstraksi tidak layak rilis | Ambang ditetapkan sebelum evaluasi; jalur manual berdiri sendiri sehingga change tetap bernilai; penyedia lain dapat dicoba tanpa mengubah layar |
| Proksi menjadi beban operasional yang tidak diperhitungkan | Biaya dan pemeliharaan di luar rencana | Cakupan dibatasi pada inferensi; batas biaya ditetapkan di rancangan sebelum dibangun; produk tetap berfungsi penuh tanpa proksi |
| Biaya inferensi melonjak karena pemakaian | Tagihan tak terduga | Batas permintaan dan biaya pada proksi, dengan perilaku yang dinyatakan kepada pengguna saat batas terlampaui |
| Layar peninjauan membengkak karena banyak keadaan per nilai | Paket 10 melar | Keadaan per nilai dibatasi pada tiga: yakin, perlu diperiksa, tidak terbaca |
| Pengguna menyetujui tanpa memeriksa | Angka keliru masuk ke buku harian | Foto berdampingan, penanda per nilai, konfirmasi tertahan; diterima bahwa risiko ini dikurangi, bukan dihapus |
