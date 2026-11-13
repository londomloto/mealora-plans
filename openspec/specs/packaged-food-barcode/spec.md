# packaged-food-barcode Specification

## Purpose
Menemukan produk kemasan lewat barcode, meninjau nilai gizinya terhadap kemasan yang benar-benar ada di tangan pengguna, menghitung jumlah yang dimakan dengan basis takaran yang benar, dan menyimpan produk itu agar dapat dipakai lagi tanpa koneksi.

## Requirements

### Requirement: Barcode adalah pengenal produk, bukan sumber nilai gizi

Sistem SHALL memperlakukan barcode semata-mata sebagai pengenal untuk menemukan rekaman produk. Sistem SHALL TIDAK menurunkan nilai gizi apa pun dari angka barcode itu sendiri.

Setiap nilai gizi yang ditampilkan SHALL berasal dari rekaman produk yang memiliki asal-usul, atau dari nilai yang dimasukkan pengguna sendiri.

#### Scenario: Barcode terbaca tanpa rekaman produk

- **WHEN** sebuah barcode terbaca tetapi tidak ada rekaman produk yang cocok
- **THEN** sistem menyatakan produk belum ditemukan dan tidak menampilkan satu pun nilai gizi

### Requirement: Pencarian mendahulukan produk di perangkat

Ketika sebuah barcode terbaca, sistem SHALL mencari rekaman produk di perangkat lebih dulu. Hanya bila tidak ditemukan dan perangkat sedang daring, sistem MAY mencari ke sumber data produk yang disetujui.

Pemindaian dan pencocokan terhadap produk di perangkat SHALL bekerja tanpa koneksi jaringan.

#### Scenario: Produk tersimpan dipindai luring

- **WHEN** pengguna memindai barcode produk yang pernah ia konfirmasi sebelumnya, dengan koneksi dimatikan
- **THEN** sistem menampilkan produk itu beserta nilainya untuk ditinjau, tanpa pesan kesalahan jaringan

#### Scenario: Produk tidak tersimpan dan perangkat luring

- **WHEN** pengguna memindai barcode yang tidak ada di perangkat sementara koneksi dimatikan
- **THEN** sistem menyatakan produk belum ditemukan dan menawarkan pengisian nilai secara manual yang tersedia luring

### Requirement: Masukan barcode manual selalu tersedia

Sistem SHALL memungkinkan pengguna mengetik nomor barcode secara manual, tanpa bergantung pada kamera.

Jalur ini SHALL tersedia ketika kamera tidak ada, izin kamera ditolak, atau kode tidak terbaca. Sistem SHALL menolak nomor yang tidak memenuhi bentuk barcode yang berlaku dengan penjelasan.

#### Scenario: Izin kamera ditolak

- **WHEN** pengguna menolak izin kamera
- **THEN** sistem menjelaskan keadaannya dan menawarkan pengetikan nomor barcode serta pencarian katalog, bukan layar yang gagal

#### Scenario: Nomor barcode tidak sah

- **WHEN** pengguna mengetik nomor yang tidak memenuhi bentuk barcode yang berlaku
- **THEN** sistem menolak dengan penjelasan dan tidak melakukan pencarian

### Requirement: Produk ditinjau sebelum dicatat

Sebelum sebuah produk masuk ke buku harian, sistem SHALL menampilkan nama produk, merek, ukuran kemasan, takaran saji, jumlah sajian per kemasan, energi dan zat gizi makro, penanda asal data, dan tanggal verifikasi.

Sistem SHALL meminta pengguna memilih jumlah yang dimakan dan mengonfirmasi sebelum catatan dibuat. Sistem SHALL TIDAK membuat catatan secara otomatis setelah pemindaian.

#### Scenario: Produk ditemukan lalu dikonfirmasi

- **WHEN** pengguna memindai produk yang ditemukan, memilih satu sajian, dan mengonfirmasi
- **THEN** catatan dibuat dengan nilai sesuai pilihan itu dan ringkasan hari menyesuaikan

#### Scenario: Pemindaian dibatalkan

- **WHEN** pengguna memindai produk lalu menutup layar peninjauan tanpa mengonfirmasi
- **THEN** tidak ada catatan yang dibuat

### Requirement: Basis takaran dihitung dengan benar

Sistem SHALL menghitung nilai yang dicatat dari basis takaran rekaman produk:

- Nilai per sajian dikalikan jumlah sajian yang dimakan.
- Satu kemasan penuh dihitung sebagai nilai per sajian dikalikan jumlah sajian per kemasan.
- Nilai per 100 g dikonversi memakai jumlah gram yang benar-benar dimakan.

Sistem SHALL menampilkan basis yang dipakai bersama nilainya, dan SHALL TIDAK mencampuradukkan nilai per 100 g, per sajian, dan per kemasan.

Sistem SHALL menyimpan basis asli rekaman produk apa adanya dan melakukan konversi hanya saat menghitung jumlah yang dimakan.

#### Scenario: Satu kemasan berisi dua sajian

- **WHEN** rekaman produk menyatakan 150 kkal per sajian dengan dua sajian per kemasan, dan pengguna mencatat satu kemasan penuh
- **THEN** catatan bernilai 300 kkal dan sistem menyatakan bahwa satu kemasan sama dengan dua sajian

#### Scenario: Label per 100 g

- **WHEN** rekaman produk memakai basis per 100 g dan pengguna menyatakan memakan 45 g
- **THEN** nilai dihitung dari 45 g, bukan dari satu sajian maupun satu kemasan

#### Scenario: Basis ditampilkan kepada pengguna

- **WHEN** pengguna meninjau sebuah produk
- **THEN** basis nilai yang berlaku tampil bersama angkanya sebelum ia memilih jumlah

### Requirement: Nilai yang tidak diketahui tetap tidak diketahui

Ketika rekaman produk tidak memuat sebuah nilai gizi, sistem SHALL menandainya belum diketahui dan SHALL TIDAK menggantinya dengan nol.

Sistem SHALL tetap memungkinkan pencatatan dengan nilai yang tersedia, dan SHALL menyatakan nilai mana yang belum diketahui pada catatan dan ringkasan.

#### Scenario: Rekaman produk tidak memuat lemak

- **WHEN** rekaman produk tidak memuat nilai lemak dan pengguna mencatatnya
- **THEN** catatan menyatakan lemak belum diketahui, bukan 0 g, dan ringkasan hari menyatakan ketidaklengkapan itu

### Requirement: Koreksi pengguna terhadap kemasan di tangannya

Sistem SHALL memungkinkan pengguna mengoreksi nilai produk ketika berbeda dengan kemasan yang ia miliki.

Nilai hasil koreksi SHALL dipakai untuk pencatatan, SHALL ditandai sebagai koreksi pengguna, dan SHALL tersimpan untuk pemakaian berikutnya. Sistem SHALL TIDAK menimpa koreksi pengguna dengan nilai dari sumber daring tanpa persetujuannya.

#### Scenario: Kemasan berbeda dengan rekaman

- **WHEN** pengguna mengoreksi nilai energi karena berbeda dengan kemasan di tangannya
- **THEN** nilai koreksi itu dipakai, ditandai sebagai koreksi pengguna, dan muncul pada pemindaian berikutnya atas barcode yang sama

#### Scenario: Sumber daring diperbarui setelah koreksi

- **WHEN** rekaman pada sumber daring berubah setelah pengguna mengoreksi nilainya
- **THEN** sistem tetap memakai nilai koreksi pengguna dan tidak menimpanya tanpa persetujuan

### Requirement: Produk tersimpan untuk pemakaian berikutnya

Produk yang dikonfirmasi pengguna SHALL tersimpan di perangkat beserta barcode, varian kemasan, asal-usul, basis takaran, dan tanggal verifikasi, sehingga dapat ditemukan kembali tanpa koneksi.

#### Scenario: Memindai ulang produk yang sama

- **WHEN** pengguna memindai barcode yang sama beberapa hari kemudian tanpa koneksi
- **THEN** produk itu ditemukan dari perangkat beserta nilai yang terakhir dikonfirmasi

### Requirement: Produk tidak ditemukan menawarkan jalur lanjutan

Ketika produk tidak ditemukan, sistem SHALL menampilkan barcode yang terbaca, menyatakan bahwa produk belum ada, dan menawarkan sekurang-kurangnya dua jalur: pengisian nilai label secara manual yang tersedia luring, dan pemotretan label gizi bila jalur itu tersedia.

Jalur yang memerlukan koneksi SHALL ditandai demikian. Jalur yang belum tersedia pada versi aplikasi SHALL ditandai belum tersedia dan SHALL TIDAK dapat dibuka.

#### Scenario: Produk belum ada di katalog

- **WHEN** pemindaian tidak menemukan produk
- **THEN** sistem menampilkan nomor barcode, menyatakan produk belum ada, dan menawarkan pengisian manual beserta jalur foto label dengan penandaan kebutuhan koneksinya

### Requirement: Nilai historis tidak berubah oleh pembaruan produk

Nilai gizi pada catatan yang sudah tersimpan SHALL TIDAK berubah ketika rekaman produk diperbarui, dikoreksi, atau dihapus di kemudian hari.

#### Scenario: Rekaman produk dikoreksi setelah dicatat

- **WHEN** pengguna mengoreksi nilai sebuah produk setelah pernah mencatatnya
- **THEN** catatan lama tetap menampilkan nilai seperti saat dicatat, dan nilai koreksi berlaku untuk pencatatan berikutnya

### Requirement: Kamera dan jaringan dipakai seperlunya

Sistem SHALL meminta izin kamera hanya ketika pengguna memilih jalur pemindaian, dan SHALL menjelaskan untuk apa izin itu dipakai.

Sistem SHALL TIDAK mengirimkan gambar apa pun ke layanan mana pun pada jalur barcode; yang dikirim pada pencarian daring hanyalah nomor barcode.

#### Scenario: Izin diminta pada waktunya

- **WHEN** pengguna membuka pilihan pencatatan tanpa memilih pemindaian
- **THEN** sistem tidak meminta izin kamera

#### Scenario: Pencarian daring

- **WHEN** sistem mencari produk ke sumber daring
- **THEN** yang dikirim hanya nomor barcode, dan tidak ada gambar maupun data pribadi pengguna yang ikut terkirim
