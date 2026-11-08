## Purpose

Kerangka aplikasi Mealora yang bisa dipasang, dibuka, dan dinavigasi pengguna tanpa akun maupun koneksi internet: splash bermerek, empat ruang utama (Hari ini, Program, Riwayat, Profil), bahasa Indonesia, serta dasar visual dan aksesibilitas yang dipakai ulang oleh semua fitur berikutnya.

## ADDED Requirements

### Requirement: Aplikasi berjalan tanpa akun dan tanpa koneksi

Aplikasi SHALL dapat dibuka dan dioperasikan sepenuhnya setelah pemasangan tanpa pendaftaran, login, atau koneksi jaringan. Aplikasi SHALL TIDAK menampilkan layar autentikasi, dan SHALL TIDAK melakukan permintaan jaringan apa pun pada alur peluncuran.

#### Scenario: Peluncuran pertama dalam mode pesawat

- **WHEN** pengguna memasang aplikasi dan membukanya untuk pertama kali dengan seluruh koneksi dimatikan
- **THEN** aplikasi menampilkan splash lalu ruang utama tanpa meminta akun, tanpa pesan kesalahan jaringan, dan tanpa layar yang gagal dimuat

#### Scenario: Tidak ada lalu lintas jaringan saat peluncuran

- **WHEN** aplikasi diluncurkan dengan perangkat terhubung internet
- **THEN** aplikasi tidak mengirimkan permintaan jaringan apa pun selama peluncuran dan navigasi antar ruang utama

### Requirement: Splash bermerek dengan janji privasi

Aplikasi SHALL menampilkan layar splash bermerek Mealora saat peluncuran, memuat simbol dan wordmark Mealora, tagline produk, serta pernyataan bahwa data pribadi tersimpan di perangkat. Splash SHALL berpindah otomatis ke ruang utama tanpa memerlukan interaksi pengguna.

#### Scenario: Splash berpindah otomatis

- **WHEN** aplikasi diluncurkan
- **THEN** splash tampil dengan identitas Mealora dan janji penyimpanan lokal, lalu berpindah sendiri ke ruang utama tanpa tindakan pengguna

#### Scenario: Splash tidak dapat membuat aplikasi tersangkut

- **WHEN** inisialisasi penyimpanan lokal gagal saat splash ditampilkan
- **THEN** aplikasi menampilkan keadaan kesalahan yang dapat dibaca pengguna beserta tindakan lanjutan, bukan splash yang berputar tanpa akhir

### Requirement: Navigasi empat ruang utama

Aplikasi SHALL menyediakan navigasi tetap ke empat ruang utama dengan label Indonesia **Hari ini**, **Program**, **Riwayat**, dan **Profil**. Navigasi SHALL menandai ruang yang sedang aktif dengan isyarat selain warna saja, dan SHALL mempertahankan ruang yang dipilih ketika aplikasi dibuka kembali setelah ditutup.

#### Scenario: Berpindah antar ruang

- **WHEN** pengguna memilih salah satu dari empat tujuan navigasi
- **THEN** aplikasi menampilkan ruang tersebut dan menandainya aktif melalui label, bentuk, atau ikon, bukan hanya perbedaan warna

#### Scenario: Tujuan navigasi tidak dikenal

- **WHEN** aplikasi diminta membuka rute yang tidak dikenal
- **THEN** aplikasi menampilkan keadaan "halaman tidak ditemukan" yang dapat dibaca pengguna dengan jalan kembali ke ruang utama, bukan layar kosong atau berhenti bekerja

### Requirement: Ruang utama menampilkan keadaan belum ada data

Setiap ruang utama SHALL menampilkan keadaan kosong yang menjelaskan apa yang akan muncul di sana dan tindakan apa yang tersedia, ketika belum ada data pengguna. Keadaan kosong SHALL TIDAK menampilkan angka nol yang mengesankan data sudah diketahui.

#### Scenario: Ruang utama sebelum ada data apa pun

- **WHEN** pengguna membuka salah satu ruang utama pada pemasangan baru
- **THEN** ruang itu menjelaskan isinya kelak dan menyebut keadaan sebagai "belum ada data", bukan menampilkan nilai nol atau grafik kosong tanpa penjelasan

### Requirement: Bahasa dan satuan tampilan

Seluruh teks yang dilihat pengguna SHALL berbahasa Indonesia dan SHALL mengikuti konvensi penulisan angka Indonesia (titik sebagai pemisah ribuan, koma sebagai pemisah desimal). Satuan tampilan awal SHALL metrik (kg, cm, kkal, g). Teks SHALL TIDAK dirangkai dari potongan kalimat yang membuat penerjemahan atau penyesuaian satuan tidak mungkin dilakukan belakangan.

#### Scenario: Format angka Indonesia

- **WHEN** aplikasi menampilkan nilai ribuan dan desimal
- **THEN** nilai tampil dalam konvensi Indonesia, misalnya "2.100 kkal" dan "68,4 kg"

### Requirement: Dasar aksesibilitas

Aplikasi SHALL menghormati skala ukuran teks sistem hingga tingkat pembesaran besar tanpa teks terpotong atau tertindih, SHALL memenuhi rasio kontras teks dan elemen interaktif yang berlaku, SHALL menyediakan target sentuh yang memadai untuk setiap kontrol, dan SHALL memberi label yang dapat dibaca pembaca layar pada setiap kontrol dan ikon bermakna.

#### Scenario: Teks sistem diperbesar

- **WHEN** pengguna menaikkan skala teks perangkat ke tingkat besar
- **THEN** seluruh layar kerangka tetap terbaca utuh tanpa teks terpotong, tertindih, atau kontrol yang tidak dapat dijangkau

#### Scenario: Navigasi dengan pembaca layar

- **WHEN** pengguna menjelajah aplikasi menggunakan pembaca layar
- **THEN** setiap tujuan navigasi dan kontrol diumumkan dengan nama yang bermakna beserta keadaan terpilihnya

### Requirement: Bahasa visual yang konsisten

Aplikasi SHALL menampilkan warna, tipografi, jarak, dan bentuk komponen yang konsisten dengan rancangan Mealora di seluruh layar. Nilai gaya SHALL berasal dari satu sumber token terpusat sehingga perubahan merek berlaku serentak, dan SHALL TIDAK ditulis ulang per layar.

#### Scenario: Perubahan token merek

- **WHEN** satu nilai token warna atau tipografi diubah
- **THEN** seluruh layar yang memakai token itu ikut berubah tanpa penyuntingan per layar
