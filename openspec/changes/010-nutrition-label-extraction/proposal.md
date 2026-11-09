# 010 · Ekstraksi label Informasi Nilai Gizi

## Why

Change 009 menutup jalur produk kemasan yang sudah dikenal, tetapi berakhir pada jalan sempit ketika produk tidak ditemukan: pengguna harus mengetik seluruh nilai dari kemasan. Padahal nilai itu sudah tercetak rapi di panel **Informasi Nilai Gizi** yang ada di tangannya.

Assessment §50.1 menjadikan pemotretan label sebagai jalur masukan MVP 1, dengan syarat yang tegas: hasil pembacaan mesin tidak pernah diperlakukan sebagai data terverifikasi. Pengguna melihat foto aslinya berdampingan dengan nilai yang terbaca, memeriksa setiap nilai penting, dan mengoreksi yang keliru sebelum apa pun masuk ke buku harian.

Change ini juga menetapkan fondasi yang dipakai bersama change foto makanan: bagaimana gambar diperlakukan, bagaimana izin unggah diminta, bagaimana penyedia model diakses, dan apa yang terjadi ketika layanan tidak tersedia.

Rancangannya sudah ada di `docs/mealora-v2.pen`: `23 · Foto label gizi`, `24 · Tinjau ekstraksi label`, dan `37 · Isi label manual offline`.

## What Changes

- **Pemotretan label gizi** (`23`) dengan panduan agar teks dan satuan terbaca jelas.
- **Izin unggah per gambar**: tidak ada gambar yang terkirim tanpa persetujuan eksplisit pengguna pada saat itu.
- **Antarmuka penyedia model yang dapat diganti**, dengan evaluasi penyedia sebagai gerbang sebelum rilis — bukan pilihan yang ditanam di kode.
- **Kunci API tidak pernah berada di aplikasi**: akses ke penyedia model berjalan lewat proksi minimal yang hanya melayani inferensi, tanpa mengubah SQLite sebagai sumber kebenaran dan tanpa mewajibkan akun.
- **Batas biaya dan permintaan** yang ditetapkan tegas pada proksi.
- **Tinjau hasil ekstraksi** (`24`): foto asli berdampingan dengan nilai yang terbaca, penanda tingkat keyakinan per nilai, basis label yang terbaca, dan kewajiban memeriksa sebelum melanjutkan.
- **Nilai yang tidak terbaca tetap "belum diketahui"**, tidak pernah menjadi nol, dan konfirmasi tidak dapat dilakukan selama nilai penting belum terisi atau belum diperiksa.
- **Isi label manual luring** (`37`): jalur penuh tanpa koneksi, dengan pemilihan basis nilai dan pengingat aritmetika kemasan.
- **Penyimpanan hasil**: produk yang dikonfirmasi tersimpan beserta barcode bila ada, varian kemasan, asal-usul sebagai hasil ekstraksi yang dikonfirmasi pengguna, dan tanggal verifikasi.
- **Retensi gambar** mengikuti pengaturan privasi pengguna: simpan atau hapus setelah dicatat.
- **Kegagalan layanan tidak menghilangkan draf**: koneksi putus, kuota habis, atau waktu tunggu lewat selalu bermuara pada jalur manual.

## Capabilities

### New Capabilities

- `image-ai-access`: bagaimana Mealora memperlakukan gambar yang diambil pengguna ketika sebuah layanan model diperlukan — persetujuan, kerahasiaan kredensial, batas biaya, perilaku saat gagal, retensi gambar, dan jalur luring yang selalu tersedia.
- `nutrition-label-extraction`: membaca panel Informasi Nilai Gizi dari foto menjadi nilai yang dapat dikoreksi pengguna, beserta basis takaran, penanganan nilai yang tidak terbaca, dan penyimpanan hasilnya.

### Modified Capabilities

Tidak ada. `packaged-food-barcode` dari change 009 dipakai apa adanya; jalur "produk tidak ditemukan" kini memiliki tujuan yang sudah tersedia.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: layar foto label, tinjau ekstraksi, dan isi label manual; klien penyedia model di balik antarmuka; pengaturan izin dan retensi gambar; penyimpanan hasil ekstraksi pada tabel produk change 009. Perubahan skema terbatas pada penandaan asal-usul hasil ekstraksi.
- **Repo `mealora-plans`**: dokumen evaluasi penyedia model beserta hasilnya, dan dokumen rancangan proksi inferensi beserta batas biayanya.
- **Infrastruktur baru**: proksi inferensi minimal. Ini satu-satunya komponen sisi server dalam MVP 1, dan cakupannya dibatasi tegas pada inferensi — bukan akun, bukan sinkronisasi, bukan penyimpanan data pengguna.
- **Bergantung pada** change 007 (buku harian, potret nilai gizi) dan 009 (tabel produk kemasan, jalur produk tidak ditemukan).
- **Memblokir** change foto makanan, yang memakai ulang seluruh `image-ai-access`.
- **Gerbang sebelum rilis**: evaluasi penyedia model dengan himpunan uji label kemasan Indonesia yang berizin, sesuai §50.6. Penyedia tidak dipilih sebelum evaluasi itu selesai.
