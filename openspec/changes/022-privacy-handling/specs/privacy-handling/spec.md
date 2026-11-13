## Purpose

Menetapkan bagaimana aplikasi memperlakukan data pribadi yang meninggalkan perangkat, sehingga hanya data yang benar-benar dibutuhkan sebuah fitur yang dikirim ke layanan luar, tanpa identitas pengguna dan tanpa metadata yang tidak diperlukan.

## ADDED Requirements

### Requirement: Gambar dibersihkan dari metadata sebelum meninggalkan perangkat

Sebelum gambar dikirim ke layanan pembacaan (label gizi, foto makanan, atau gambar nutrisi), sistem SHALL mengodekannya ulang menjadi berkas baru yang tidak memuat metadata, termasuk lokasi, waktu pemotretan, informasi perangkat, dan gambar pratinjau tertanam. Aturan ini SHALL berlaku sama untuk gambar dari kamera maupun dari galeri.

Orientasi tampilan gambar SHALL tetap benar setelah metadata dibuang.

#### Scenario: Foto galeri dengan lokasi

- **WHEN** pengguna memilih foto dari galeri yang memuat koordinat GPS dan mengizinkan pengunggahan
- **THEN** gambar yang diterima layanan tidak memuat koordinat, waktu pemotretan, maupun informasi perangkat

#### Scenario: Foto dari kamera aplikasi

- **WHEN** pengguna memotret lewat kamera aplikasi dan mengizinkan pengunggahan
- **THEN** gambar yang diterima layanan tidak memuat metadata apa pun

#### Scenario: Foto dengan orientasi tegak

- **WHEN** foto yang diambil dalam posisi tegak dibersihkan dari metadata
- **THEN** gambar yang diterima layanan tetap tampil tegak, tidak terputar

### Requirement: Gambar diperkecil secukupnya sebelum dikirim

Sistem SHALL membatasi sisi terpanjang gambar yang dikirim sesuai kebutuhan tugasnya, dan SHALL TIDAK memperbesar gambar yang sudah lebih kecil dari batas itu. Pengecilan SHALL tidak membuat tulisan pada label gizi yang terbaca jelas di foto asli menjadi tidak terbaca.

#### Scenario: Foto beresolusi tinggi

- **WHEN** gambar yang akan dikirim lebih besar dari batas tugasnya
- **THEN** gambar dikirim dengan sisi terpanjang tidak melebihi batas tersebut, dengan perbandingan sisi yang sama

#### Scenario: Foto yang sudah kecil

- **WHEN** gambar yang akan dikirim sudah lebih kecil dari batas tugasnya
- **THEN** ukurannya tidak diperbesar

### Requirement: Kegagalan pembersihan tidak pernah mengirim gambar asli

Bila gambar tidak dapat dibersihkan, sistem SHALL TIDAK mengirim gambar asli. Sistem SHALL memperlakukannya seperti pembacaan yang tidak tersedia: pengguna diarahkan ke jalur yang sudah berlaku untuk kegagalan layanan, dengan pesan tanpa istilah teknis, dan tidak ada catatan yang dibuat.

#### Scenario: Berkas tidak dapat dibaca

- **WHEN** gambar yang dipilih tidak dapat didekode atau dikodekan ulang
- **THEN** tidak ada gambar yang dikirim, dan pengguna melihat jalur yang sama seperti ketika pembacaan tidak tersedia

### Requirement: Kiriman ke layanan tidak membawa identitas pengguna

Permintaan ke layanan pembacaan SHALL memuat hanya data yang dibutuhkan tugasnya (gambar atau teks yang disetujui pengguna, serta token aplikasi). Permintaan SHALL TIDAK memuat identitas pengguna, profil, target gizi, riwayat catatan, maupun pengenal perangkat.

#### Scenario: Membaca foto makanan

- **WHEN** aplikasi mengirim foto makanan untuk dibaca
- **THEN** permintaan tidak memuat nama, surel, profil, target gizi, riwayat, atau pengenal perangkat pengguna

#### Scenario: Membaca teks nutrisi

- **WHEN** aplikasi mengirim teks nutrisi atau kalimat makanan untuk dibaca
- **THEN** permintaan hanya memuat teks tersebut dan token aplikasi
