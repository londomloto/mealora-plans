# Functional Requirements Specification

## Mealora — Penanganan Privasi

| | |
|---|---|
| Change | 022-privacy-handling |
| Versi | v0.1-draft |
| Tanggal | 2026-11-13 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Membersihkan setiap foto yang dikirim untuk dibaca (label gizi, foto makanan, gambar nutrisi) dari informasi tersembunyi seperti lokasi, waktu pemotretan, dan jenis perangkat, baik foto dari kamera maupun dari galeri.
- Memperkecil foto secukupnya sebelum dikirim, tanpa membuat tulisan pada label menjadi tidak terbaca.
- Memastikan foto asli tidak pernah terkirim bila pembersihan gagal.
- Menegaskan bahwa kiriman ke layanan pembacaan tidak membawa identitas maupun data pribadi pengguna.

### 1.2 Deferred Items (Not in This FRS Version)

- Pembersihan foto di sisi server untuk pengguna yang belum memperbarui aplikasi. Pengguna versi lama tetap mengirim foto asli sampai mereka memperbarui aplikasi.
- Aturan privasi lain di luar kiriman ke layanan pembacaan (misalnya ekspor data, penghapusan akun, atau berbagi). Aturan-aturan ini akan ditambahkan pada versi FRS berikutnya.
- Perubahan pada penyimpanan foto di perangkat. Pengaturan penyimpanan yang sudah ada tetap berlaku.

## 2. Foto Bersih Sebelum Dikirim

### 2.1 User Story

As a pengguna yang memotret makanan atau label gizi,
I want foto yang dikirim untuk dibaca tidak membawa lokasi, waktu, maupun informasi perangkat saya,
So that layanan pembacaan hanya menerima apa yang memang dibutuhkan untuk membaca makanan.

### 2.2 Functional Scope

- Berlaku untuk semua foto yang dikirim untuk dibaca: foto makanan, foto label gizi, dan gambar nutrisi.
- Berlaku sama untuk foto dari kamera aplikasi maupun foto dari galeri.
- Foto yang dikirim adalah salinan baru tanpa informasi tersembunyi. Foto tetap tampil tegak seperti aslinya.
- Foto berukuran besar diperkecil sebelum dikirim. Foto yang sudah kecil tidak diperbesar. Untuk label gizi, batas ukurannya lebih longgar supaya tulisan kecil tetap terbaca.
- Pengguna tidak melihat langkah tambahan apa pun. Persetujuan unggah tetap sama seperti sekarang.
- Bila foto tidak dapat diproses, foto tidak dikirim sama sekali. Pengguna melihat pesan yang sama seperti ketika pembacaan sedang tidak tersedia dan diarahkan ke pengisian manual. Tidak ada catatan yang dibuat.

### 2.3 Acceptance Criteria

2.3.1. The system shall remove location, capture time, device information, and embedded previews from every image before sending it to a reading service.

2.3.2. The system shall apply the same cleaning to images taken with the in-app camera and images chosen from the gallery.

2.3.3. The system shall keep the image's upright orientation after cleaning.

2.3.4. The system shall limit the longest side of a sent image according to its task and shall not enlarge smaller images.

2.3.5. The system shall keep text on nutrition labels that is legible in the original photo legible after resizing.

2.3.6. The system shall not send the original image when cleaning fails, and shall show the same unavailable-reading path used for service failures without creating any entry.

---

## 3. Kiriman Tanpa Identitas

### 3.1 User Story

As a pengguna,
I want layanan pembacaan tidak mengetahui siapa saya,
So that apa yang saya makan tidak dapat dikaitkan dengan diri saya di luar aplikasi.

### 3.2 Functional Scope

- Kiriman ke layanan pembacaan hanya berisi foto atau teks yang disetujui pengguna.
- Kiriman tidak berisi nama, surel, profil, target gizi, riwayat catatan, maupun pengenal perangkat.

### 3.3 Acceptance Criteria

3.3.1. The system shall send only the approved image or text to a reading service, together with the application token.

3.3.2. The system shall not include the user's name, email, profile, nutrition targets, entry history, or device identifier in any request to a reading service.

## 4. High Level Test Scenarios

| # | Kondisi awal | Aksi | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Galeri berisi foto makanan yang memuat lokasi | Pilih foto itu dan izinkan unggah | Makanan terbaca. Foto yang diterima layanan tidak memuat lokasi, waktu, maupun jenis perangkat |
| 2 | Kamera aplikasi terbuka | Potret label gizi dalam posisi tegak | Label terbaca seperti sebelumnya. Foto yang diterima tegak dan tanpa informasi tersembunyi |
| 3 | Foto label gizi beresolusi tinggi dengan tulisan kecil | Kirim untuk dibaca | Angka gizi terbaca setara dengan versi sebelum perubahan |
| 4 | Berkas gambar rusak di galeri | Pilih berkas itu | Tidak ada yang dikirim. Muncul pesan pembacaan tidak tersedia dan pilihan isi manual |
| 5 | Pengguna masuk dengan profil lengkap | Kirim foto makanan dan kalimat makanan | Kiriman tidak memuat data profil, target, riwayat, maupun pengenal perangkat |
