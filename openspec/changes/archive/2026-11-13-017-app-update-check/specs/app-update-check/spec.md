## Purpose

Memberi tahu pengguna ketika versi baru app tersedia dan mewajibkan update ketika versi yang terpasang sudah tidak didukung, tanpa pernah memblokir app karena gangguan jaringan atau server.

## ADDED Requirements

### Requirement: Konfigurasi versi publik
Server SHALL menyediakan konfigurasi versi app yang dapat dibaca tanpa autentikasi. Konfigurasi ini berisi versi terbaru, versi minimum yang didukung, catatan rilis, dan tautan toko untuk Android dan iOS. Respons MUST NOT memuat rahasia, kunci API, atau konfigurasi internal server lainnya.

#### Scenario: Konfigurasi dibaca tanpa token
- **WHEN** klien meminta konfigurasi versi tanpa kredensial apa pun
- **THEN** server mengembalikan versi terbaru, versi minimum, catatan rilis, dan tautan toko per platform

#### Scenario: Tidak ada rahasia di respons
- **WHEN** konfigurasi versi dikembalikan
- **THEN** respons hanya berisi field konfigurasi versi, tanpa kunci API, token, atau pengaturan server lain

#### Scenario: Versi minimum tidak melebihi versi terbaru
- **WHEN** server dijalankan dengan versi minimum yang lebih tinggi dari versi terbaru, atau dengan format versi yang tidak valid
- **THEN** server menolak start dan menampilkan pesan kesalahan konfigurasi

### Requirement: Kapan app mengecek versi
App SHALL mengecek konfigurasi versi setiap kali app dibuka, dan saat app kembali ke depan setelah minimal satu jam sejak pengecekan berhasil terakhir. Pengecekan MUST NOT menunda tampilnya layar awal app.

#### Scenario: Cek saat app dibuka
- **WHEN** pengguna membuka app
- **THEN** app mengambil konfigurasi versi di latar belakang sementara layar awal tetap tampil seperti biasa

#### Scenario: Kembali dari background dalam batas waktu
- **WHEN** app kembali ke depan kurang dari satu jam setelah pengecekan berhasil terakhir
- **THEN** app tidak mengambil ulang konfigurasi versi

#### Scenario: Kembali dari background setelah batas waktu
- **WHEN** app kembali ke depan satu jam atau lebih setelah pengecekan berhasil terakhir
- **THEN** app mengambil ulang konfigurasi versi

### Requirement: Perbandingan versi
App SHALL membandingkan versi terpasang dengan konfigurasi secara numerik per bagian (mayor.minor.patch) dan mengabaikan nomor build. Versi yang tidak dapat diurai MUST diperlakukan sebagai konfigurasi tidak valid.

#### Scenario: Perbandingan numerik
- **WHEN** versi terpasang 1.9.0 dan versi terbaru 1.10.0
- **THEN** app menganggap versi terpasang lebih lama

#### Scenario: Nomor build diabaikan
- **WHEN** versi terpasang 1.2.0+15 dan versi terbaru 1.2.0
- **THEN** app menganggap versi terpasang sudah terbaru

### Requirement: Wajib update
Jika versi terpasang lebih rendah dari versi minimum yang didukung, app SHALL menampilkan layar wajib update yang menutupi seluruh app. Layar ini menampilkan catatan rilis bila ada dan menyediakan tombol untuk membuka halaman app di toko platform tersebut. Layar ini MUST NOT dapat ditutup, termasuk dengan tombol kembali.

#### Scenario: Versi di bawah minimum
- **WHEN** versi terpasang 1.0.0 dan versi minimum 1.1.0
- **THEN** app menampilkan layar wajib update dan pengguna tidak dapat mengakses fitur lain

#### Scenario: Membuka toko
- **WHEN** pengguna menekan tombol update di layar wajib update
- **THEN** app membuka tautan toko untuk platform perangkat tersebut

#### Scenario: Tombol kembali
- **WHEN** layar wajib update tampil dan pengguna menekan tombol kembali
- **THEN** layar wajib update tetap tampil

### Requirement: Update tersedia
Jika versi terpasang tidak lebih rendah dari versi minimum tetapi lebih rendah dari versi terbaru, app SHALL menampilkan dialog yang memberi tahu ada versi baru, lengkap dengan catatan rilis bila ada, tombol "Update" untuk membuka toko, dan tombol "Nanti". Setelah pengguna memilih "Nanti", dialog MUST NOT tampil lagi untuk versi terbaru yang sama.

#### Scenario: Dialog tampil
- **WHEN** versi terpasang 1.1.0, versi minimum 1.0.0, dan versi terbaru 1.2.0
- **THEN** app menampilkan dialog update tersedia untuk versi 1.2.0

#### Scenario: Pengguna memilih Nanti
- **WHEN** pengguna memilih "Nanti" pada dialog untuk versi 1.2.0 lalu app dibuka lagi
- **THEN** dialog tidak tampil lagi selama versi terbaru masih 1.2.0

#### Scenario: Versi terbaru naik lagi
- **WHEN** pengguna pernah memilih "Nanti" untuk 1.2.0 lalu versi terbaru berubah menjadi 1.3.0
- **THEN** dialog tampil lagi untuk versi 1.3.0

#### Scenario: Sudah terbaru
- **WHEN** versi terpasang sama dengan atau lebih tinggi dari versi terbaru
- **THEN** app tidak menampilkan dialog maupun layar update

### Requirement: Fail-open dan konfigurasi tersimpan
App SHALL tetap berjalan normal ketika konfigurasi versi tidak dapat diambil, entah karena tidak ada jaringan, waktu tunggu tiga detik habis, server error, respons tidak valid, atau alamat server tidak dikonfigurasi. App SHALL menyimpan konfigurasi terakhir yang valid. Jika pengambilan gagal, status wajib update dari konfigurasi tersimpan tetap berlaku, sedangkan dialog update tersedia hanya tampil dari konfigurasi yang baru diambil.

#### Scenario: Tanpa jaringan dan tanpa konfigurasi tersimpan
- **WHEN** pengambilan gagal dan belum pernah ada konfigurasi tersimpan
- **THEN** app berjalan normal tanpa pesan kesalahan

#### Scenario: Respons tidak valid
- **WHEN** server mengembalikan respons yang field-nya hilang atau versinya tidak dapat diurai
- **THEN** app mengabaikan respons itu, tidak menimpa konfigurasi tersimpan, dan berjalan normal

#### Scenario: Tautan toko platform kosong
- **WHEN** konfigurasi tidak memuat tautan toko yang valid untuk platform perangkat
- **THEN** app tidak menampilkan dialog maupun layar update dan berjalan normal

#### Scenario: Wajib update tetap berlaku saat offline
- **WHEN** konfigurasi tersimpan menyatakan versi terpasang di bawah minimum dan pengambilan berikutnya gagal
- **THEN** app tetap menampilkan layar wajib update

#### Scenario: Konfigurasi baru mencabut wajib update
- **WHEN** layar wajib update tampil dan konfigurasi baru yang berhasil diambil menurunkan versi minimum di bawah versi terpasang
- **THEN** layar wajib update hilang dan app dapat dipakai kembali
