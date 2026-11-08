# Functional Requirements Specification

## Mealora — Membaca Label Informasi Nilai Gizi

| | |
|---|---|
| Change | 010-nutrition-label-extraction |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Memotret panel Informasi Nilai Gizi pada kemasan untuk membaca nilainya secara otomatis.
- Persetujuan pengguna sebelum gambar apa pun dikirim ke luar perangkat.
- Meninjau hasil pembacaan berdampingan dengan foto aslinya, dan mengoreksi nilai yang keliru.
- Perlakuan terhadap nilai yang tidak terbaca atau satuannya ambigu.
- Pembacaan basis nilai pada label: per sajian, jumlah sajian per kemasan, atau per 100 g.
- Mengisi nilai label secara manual, sepenuhnya tanpa koneksi.
- Menyimpan produk hasil konfirmasi agar dapat dipakai lagi tanpa koneksi.
- Perilaku ketika layanan pembacaan tidak tersedia: tidak ada koneksi, kuota habis, waktu tunggu lewat, atau layanan menolak.
- Pengaturan penyimpanan foto sumber: disimpan atau dihapus setelah dicatat.

### 1.2 Deferred Items (Not in This FRS Version)

- Pengenalan foto makanan di piring — pengiriman berikutnya.
- Pembacaan daftar bahan, klaim gizi, dan sertifikasi pada kemasan. Hanya panel Informasi Nilai Gizi yang dibaca.
- Pembacaan di perangkat tanpa koneksi. Pembacaan otomatis memerlukan koneksi pada pengiriman ini; jalur manual menggantikannya saat luring.
- Pembacaan label berbahasa selain yang diuji pada evaluasi penyedia.
- Masukan makanan lewat kalimat bebas.

## 2. Memotret dan Mengirim Label

### 2.1 User Story

As a pengguna yang memegang kemasan dengan label gizi,
I want memotretnya alih-alih mengetik seluruh angkanya,
So that mencatat produk baru tidak memakan waktu lima menit.

### 2.2 Functional Scope

- Pengguna dapat memotret panel Informasi Nilai Gizi, dengan panduan agar teks dan satuannya terbaca jelas.
- Sebelum gambar dikirim, Mealora meminta persetujuan pengguna dan menyatakan: bahwa gambar akan diunggah, untuk apa, bahwa pengunggahan memerlukan koneksi, dan bahwa tersedia jalur tanpa pengunggahan.
- Tidak ada gambar yang terkirim tanpa persetujuan pada saat itu. Persetujuan untuk satu gambar tidak berlaku otomatis untuk gambar berikutnya, kecuali pengguna menetapkan pilihan tetap pada pengaturan privasi.
- Pengguna dapat memilih jalur pengisian manual kapan saja, tanpa mengambil maupun mengirim gambar.
- Foto sumber disimpan atau dihapus setelah dicatat sesuai pengaturan privasi pengguna. Foto yang disimpan berada di perangkat dan ikut terhapus ketika pengguna menghapus seluruh data lokal.
- **Tidak termasuk:** pengunggahan otomatis, pengiriman foto ke pihak lain di luar pembacaan yang disetujui, dan penyimpanan foto di luar perangkat.

### 2.3 Acceptance Criteria

2.3.1. The system shall let the user photograph the nutrition information panel with guidance for legibility.

2.3.2. The system shall request the user's consent before sending any image off the device, stating what will be uploaded, why, that it requires a connection, and that a path without uploading exists.

2.3.3. The system shall send no image without consent given for that upload.

2.3.4. The system shall not carry consent over to a later image unless the user sets a standing preference in privacy settings.

2.3.5. The system shall offer manual entry at any point, without capturing or sending an image.

2.3.6. The system shall retain or delete the source photo after logging according to the user's privacy setting, keeping any retained photo on the device.

2.3.7. The system shall delete retained photos together with all other data when the user deletes all local data.

---

## 3. Meninjau Hasil Pembacaan

### 3.1 User Story

As a pengguna yang mengandalkan pembacaan otomatis,
I want melihat foto aslinya di sebelah angka yang terbaca,
So that saya bisa memeriksa dengan cepat dan tidak mencatat angka yang salah.

### 3.2 Functional Scope

- Mealora menampilkan foto label asli berdampingan dengan nilai yang terbaca, tanpa pengguna perlu berpindah layar.
- Setiap nilai dapat disunting dan disertai penanda: terbaca dengan yakin, perlu diperiksa, atau tidak terbaca.
- Mealora menampilkan basis nilai yang terbaca — per sajian beserta ukurannya, jumlah sajian per kemasan, atau per 100 g — untuk diperiksa sebelum dipakai. Bila basis tidak terbaca, Mealora meminta pengguna menetapkannya dan tidak menebak.
- Ketika satu sajian dan satu kemasan sama-sama diketahui, Mealora menyatakan hubungannya, misalnya bahwa satu kemasan sama dengan dua kali nilai per sajian.
- Nilai yang tidak terbaca, keyakinannya rendah, atau satuannya ambigu ditandai belum diketahui atau perlu diperiksa — tidak pernah diganti nol atau tebakan.
- Konfirmasi tertahan selama ada nilai penting yang belum terisi atau belum diperiksa, dan Mealora menyebut nilai mana yang menahan.
- Pengguna dapat menyatakan bahwa sebuah nilai memang tidak tercantum pada kemasan; nilai itu lalu tersimpan sebagai belum diketahui.
- Hasil pembacaan disebut sebagai bacaan yang perlu diperiksa, bukan data terverifikasi atau nilai resmi produk.
- Menutup layar peninjauan tanpa mengonfirmasi tidak membuat catatan maupun rekaman produk apa pun.
- **Tidak termasuk:** menyimpan hasil pembacaan secara otomatis, dan melanjutkan tanpa pemeriksaan pengguna.

### 3.3 Acceptance Criteria

3.3.1. The system shall display the original label photo alongside the extracted values on the same screen.

3.3.2. The system shall make every extracted value editable and mark it as confidently read, needing checking, or not read.

3.3.3. The system shall display the label basis for the user to check before the values are used.

3.3.4. The system shall ask the user to set the basis, rather than guessing, when it cannot be read.

3.3.5. The system shall state the relationship between one serving and one package when both are known.

3.3.6. The system shall mark unread, low-confidence, or ambiguous values as unknown or needing checking, and shall never substitute zero or a guess.

3.3.7. The system shall withhold confirmation while an essential value is unfilled or unchecked, and shall name the values that are withholding it.

3.3.8. The system shall let the user state that a value is genuinely absent from the package, storing it as unknown.

3.3.9. The system shall describe extracted values as a reading to be checked, not as verified data or official product values.

3.3.10. The system shall create no record and no product entry when the review screen is closed without confirmation.

---

## 4. Mengisi Label Secara Manual

### 4.1 User Story

As a pengguna yang sedang tidak punya kuota atau tidak ingin mengunggah foto,
I want mengisi nilai dari kemasan sendiri dengan panduan yang jelas,
So that saya tetap bisa mencatat produk itu hari ini juga.

### 4.2 Functional Scope

- Pengisian manual tersedia sepenuhnya tanpa koneksi dan tanpa izin kamera.
- Pengguna mengisi nama produk, basis nilai, ukuran sajian, jumlah sajian per kemasan, energi, protein, karbohidrat, dan lemak.
- Mealora menyatakan aritmetika kemasan yang berlaku, misalnya bahwa satu kemasan sama dengan dua kali nilai per sajian, dan bahwa nilai itu bukan nilai per 100 g.
- Nilai yang mustahil ditolak dengan penjelasan. Nilai yang dikosongkan tersimpan sebagai belum diketahui, bukan nol.
- Jalur ini setara dengan jalur pembacaan otomatis — bukan cadangan yang terbatas.
- **Tidak termasuk:** keharusan menunggu sampai ada koneksi.

### 4.3 Acceptance Criteria

4.3.1. The system shall make manual label entry fully available without a network connection and without camera permission.

4.3.2. The system shall collect product name, value basis, serving size, servings per package, energy, protein, carbohydrate, and fat.

4.3.3. The system shall state the package arithmetic that applies to the chosen basis.

4.3.4. The system shall reject implausible values with an explanation and store omitted values as unknown.

---

## 5. Ketika Pembacaan Tidak Tersedia

### 5.1 User Story

As a pengguna yang koneksinya putus di tengah jalan,
I want tidak kehilangan apa yang sudah saya kerjakan,
So that satu gangguan tidak memaksa saya mengulang dari awal.

### 5.2 Functional Scope

- Ketika layanan pembacaan tidak tersedia — tidak ada koneksi, waktu tunggu lewat, kuota habis, atau layanan menolak — Mealora menyatakan keadaannya dalam bahasa yang dapat dimengerti, tanpa istilah teknis.
- Foto dan nilai yang sudah diisi tidak hilang. Mealora menawarkan jalur manual yang setara.
- Ketika batas pemakaian layanan terlampaui, Mealora menyatakan layanan sedang tidak tersedia dan mengarahkan ke jalur manual.
- Alur inti aplikasi — buku harian, program, berat badan, dan riwayat — tetap bekerja sepenuhnya tanpa koneksi.
- Mealora menyatakan dengan jelas kemampuan mana yang memerlukan koneksi.
- **Tidak termasuk:** antrean pengunggahan otomatis yang mengirim foto begitu koneksi kembali tanpa persetujuan baru.

### 5.3 Acceptance Criteria

5.3.1. The system shall state, in plain language, that reading is unavailable when the service cannot be reached, times out, is out of quota, or refuses the request.

5.3.2. The system shall preserve the captured photo and any entered values through such a failure.

5.3.3. The system shall offer an equivalent manual path in every such case.

5.3.4. The system shall state that the service is unavailable and direct the user to the manual path when usage limits are exceeded.

5.3.5. The system shall keep the diary, program, weight, and history flows fully functional without a connection.

5.3.6. The system shall state clearly which capabilities require a connection.

---

## 6. Menyimpan dan Memakai Ulang

### 6.1 User Story

As a pengguna yang sering membeli produk yang sama,
I want produk yang sudah saya konfirmasi tersimpan,
So that saya cukup memeriksanya sekali seumur produk itu.

### 6.2 Functional Scope

- Produk yang dikonfirmasi tersimpan di perangkat beserta barcode bila ada, varian kemasan, basis takaran, tanggal verifikasi, dan keterangan bahwa nilainya berasal dari pembacaan label yang dikonfirmasi pengguna.
- Produk itu dapat ditemukan kembali tanpa koneksi, baik lewat pemindaian barcode maupun pencarian nama.
- Nilai pada catatan yang sudah tersimpan tidak berubah ketika pengguna kemudian mengoreksi nilai produk itu.
- **Tidak termasuk:** mengirimkan koreksi pengguna ke layanan mana pun.

### 6.3 Acceptance Criteria

6.3.1. The system shall store a confirmed product with its barcode where available, package variant, serving basis, verification date, and an origin stating that the values came from a user-confirmed label reading.

6.3.2. The system shall make that product findable offline by barcode scan and by name search.

6.3.3. The system shall leave stored records unchanged when the product's values are later corrected.

6.3.4. The system shall not send user corrections to any external service.

---

## 7. High Level Test Scenarios

7.1. **Memotret dan mengonfirmasi** — Pengguna memindai produk yang tidak ditemukan, memilih foto label, menyetujui unggah, meninjau hasil berdampingan dengan fotonya, mengoreksi satu nilai, lalu mengonfirmasi → produk tersimpan dan catatan dibuat sesuai pilihan jumlahnya.

7.2. **Menolak unggah** — Pengguna membuka foto label lalu tidak menyetujui unggah → tidak ada gambar terkirim dan Mealora membuka pengisian manual.

7.3. **Persetujuan tidak terbawa** — Pengguna menyetujui unggah satu gambar, lalu beberapa saat kemudian memotret label lain → Mealora meminta persetujuan lagi.

7.4. **Nilai tidak terbaca** — Hasil pembacaan tidak memuat nilai lemak → nilai itu ditandai belum diketahui, konfirmasi tertahan, dan Mealora menyebut nilai mana yang menahan.

7.5. **Nilai memang tidak tercantum** — Pengguna menyatakan lemak tidak tercantum pada kemasannya → nilai tersimpan sebagai belum diketahui dan konfirmasi dapat dilanjutkan.

7.6. **Satuan ambigu** — Sebuah nilai terbaca dengan satuan yang tidak pasti → ditandai perlu diperiksa dan harus dipastikan sebelum lanjut.

7.7. **Basis tidak terbaca** — Basis label tidak terbaca dari foto → Mealora meminta pengguna menetapkannya dan tidak menebak.

7.8. **Aritmetika kemasan** — Label per sajian 30 g dengan 2 sajian per kemasan → Mealora menyatakan satu kemasan sama dengan dua kali nilai per sajian, dan pencatatan satu kemasan menghasilkan dua kali nilai itu.

7.9. **Koneksi putus di tengah** — Koneksi terputus setelah pengguna menyetujui unggah → Mealora menyatakan pembacaan belum tersedia, foto dan isian tetap ada, dan jalur manual ditawarkan.

7.10. **Kuota habis** — Batas pemakaian layanan terlampaui → Mealora menyatakan layanan sedang tidak tersedia dan mengarahkan ke jalur manual, tanpa istilah teknis.

7.11. **Isi manual luring** — Mode pesawat → pengguna mengisi seluruh nilai label secara manual → produk tersimpan dan dapat dicatat saat itu juga.

7.12. **Memakai ulang produk** — Pengguna memindai barcode produk yang sebelumnya dikonfirmasi lewat label, tanpa koneksi → produk ditemukan beserta nilai terakhirnya dan keterangan asal-usulnya.

7.13. **Riwayat tidak berubah** — Pengguna mengoreksi nilai produk setelah pernah mencatatnya → catatan lama tetap menampilkan nilai saat dicatat.

7.14. **Peninjauan dibatalkan** — Pengguna menutup layar peninjauan tanpa mengonfirmasi → tidak ada catatan maupun rekaman produk, dan foto diperlakukan sesuai pengaturan retensi.

7.15. **Tidak ada kredensial di aplikasi** — Paket aplikasi yang didistribusikan diperiksa → tidak ditemukan kunci API maupun kredensial layanan.

7.16. **Alur inti tetap luring** — Seluruh alur buku harian, program, berat, dan riwayat dijalankan dalam mode pesawat → semuanya bekerja tanpa kecuali.
