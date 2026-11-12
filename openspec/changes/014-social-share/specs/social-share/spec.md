## Purpose

Memungkinkan pengguna membagikan ringkasan gizi harian dan makanan yang baru difoto sebagai kartu gambar bertanda Mealora ke aplikasi pilihan mereka, tanpa mengunggah data ke server.

## ADDED Requirements

### Requirement: Bagikan ringkasan harian
Ruang Hari ini SHALL menyediakan tombol Bagikan yang membuat kartu ringkasan untuk tanggal hari ini. Kartu berisi tanggal, energi tercatat dan target energi harian (mis. 1.650 / 2.000 kkal), persentase target, serta protein, karbohidrat, dan lemak dalam gram.

#### Scenario: Ringkasan dengan catatan
- **WHEN** pengguna sudah mencatat 1.650 kkal dengan target 2.000 kkal lalu mengetuk Bagikan di ruang Hari ini
- **THEN** sistem menampilkan pratinjau kartu yang memuat 1.650 / 2.000 kkal, 83%, dan gram protein, karbohidrat, serta lemak hari ini

#### Scenario: Belum ada catatan
- **WHEN** belum ada makanan yang dicatat hari ini
- **THEN** tombol Bagikan ringkasan tidak dapat digunakan dan sistem menjelaskan bahwa ringkasan dapat dibagikan setelah ada catatan

### Requirement: Bagikan makanan dari jalur foto
Setelah konfirmasi foto makanan berhasil disimpan, sistem SHALL menampilkan layar "Tersimpan" yang memuat tombol Bagikan. Kartu makanan berisi foto makanan tersebut, nama dan porsi setiap komponen, estimasi energi per komponen, dan total energi. Tombol Bagikan makanan MUST NOT tersedia di jalur pencatatan lain.

#### Scenario: Bagikan setelah konfirmasi foto
- **WHEN** pengguna mengonfirmasi hasil foto berisi nasi goreng dan telur ceplok lalu mengetuk Bagikan di layar "Tersimpan"
- **THEN** sistem menampilkan pratinjau kartu dengan foto tersebut, kedua komponen beserta porsi dan estimasi energinya, serta total energi

#### Scenario: Lewati berbagi
- **WHEN** pengguna menutup layar "Tersimpan" tanpa membagikan
- **THEN** sistem kembali ke halaman awal, dan catatan makan tetap tersimpan

#### Scenario: Jalur lain
- **WHEN** pengguna mencatat makanan lewat pencarian katalog atau barcode
- **THEN** tidak ada tombol Bagikan makanan yang ditampilkan

### Requirement: Watermark Mealora
Setiap kartu yang dibagikan SHALL memuat logo dan nama Mealora yang terlihat jelas, dan watermark itu tidak dapat dimatikan.

#### Scenario: Watermark ada
- **WHEN** pengguna membagikan kartu apa pun
- **THEN** gambar yang dibagikan memuat logo dan nama Mealora

### Requirement: Pratinjau dan lembar berbagi sistem
Sistem SHALL menampilkan pratinjau kartu sebelum dibagikan, lalu menyerahkan gambar ke lembar berbagi bawaan sistem operasi. Sistem MUST NOT mengunggah kartu, foto, atau data gizi ke server mana pun dalam proses ini, dan fitur ini SHALL berfungsi tanpa koneksi internet.

#### Scenario: Offline
- **WHEN** perangkat tidak terhubung ke internet dan pengguna membagikan ringkasan harian
- **THEN** pratinjau dan lembar berbagi tetap muncul

#### Scenario: Batal di lembar berbagi
- **WHEN** pengguna menutup lembar berbagi tanpa memilih aplikasi
- **THEN** sistem kembali ke layar sebelumnya tanpa pesan galat

### Requirement: Kartu tidak memuat data sensitif
Kartu MUST NOT memuat berat badan, tinggi, usia, nama program, atau data profil lainnya. Copy pada kartu MUST mengikuti aturan copy nutrition-policy-v1, yaitu tanpa klaim medis dan tanpa nada menghakimi.

#### Scenario: Isi kartu ringkasan
- **WHEN** pengguna dengan program Turun Berat membagikan ringkasan harian
- **THEN** kartu tidak menampilkan berat badan maupun nama program

### Requirement: Tanpa penyimpanan tambahan
Fitur berbagi MUST NOT membuat salinan foto atau kartu yang permanen. Gambar kartu sementara SHALL dihapus setelah proses berbagi selesai atau dibatalkan. Foto draf makanan SHALL tetap tersedia sampai layar "Tersimpan" ditutup, lalu diperlakukan sesuai pengaturan retensi gambar pengguna.

#### Scenario: Retensi "hapus setelah dicatat"
- **WHEN** pengaturan retensi adalah hapus setelah dicatat, dan pengguna membagikan lalu menutup layar "Tersimpan"
- **THEN** foto draf dan gambar kartu sementara terhapus dari perangkat

#### Scenario: Retensi "simpan di perangkat"
- **WHEN** pengaturan retensi adalah simpan di perangkat, dan pengguna menutup layar "Tersimpan"
- **THEN** foto makanan tetap tersimpan seperti sebelum change ini, sedangkan gambar kartu sementara terhapus
