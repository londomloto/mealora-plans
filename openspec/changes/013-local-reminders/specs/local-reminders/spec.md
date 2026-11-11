## Purpose

Mengingatkan pengguna untuk mencatat makanan dan menimbang berat badan melalui notifikasi yang dijadwalkan sepenuhnya di perangkat, tanpa jaringan.

## ADDED Requirements

### Requirement: Pengingat jam makan
Sistem SHALL menyediakan empat pengingat jam makan, yaitu sarapan, makan siang, camilan, dan makan malam. Masing-masing dapat dinyalakan atau dimatikan secara terpisah dan memiliki jam lokal yang dapat diatur. Semua pengingat MUST mati secara default. Default jamnya adalah 07:00, 12:00, 15:30, dan 19:00.

#### Scenario: Menyalakan pengingat makan siang
- **WHEN** pengguna menyalakan pengingat makan siang dengan jam 12:30 dan izin notifikasi sudah diberikan
- **THEN** sistem menampilkan notifikasi pengingat makan siang setiap hari sekitar pukul 12:30 waktu lokal

#### Scenario: Mematikan pengingat
- **WHEN** pengguna mematikan pengingat sarapan yang sebelumnya menyala
- **THEN** sistem tidak lagi menampilkan notifikasi sarapan, dan pengingat lain tidak terpengaruh

#### Scenario: Pengingat biasa tidak memeriksa diary
- **WHEN** pengguna sudah mencatat sarapan sebelum jam pengingat sarapan
- **THEN** sistem tetap menampilkan notifikasi sarapan sesuai jadwal

### Requirement: Pengingat timbang mingguan
Sistem SHALL menyediakan satu pengingat timbang mingguan dengan hari dan jam lokal yang dapat diatur. Pengingat ini MUST mati secara default. Defaultnya adalah Senin pukul 07:00.

#### Scenario: Pengingat timbang muncul pada hari terpilih
- **WHEN** pengguna menyalakan pengingat timbang untuk hari Sabtu pukul 06:30
- **THEN** sistem menampilkan notifikasi pengingat timbang setiap Sabtu sekitar pukul 06:30 waktu lokal, dan tidak pada hari lain

### Requirement: Membuka aplikasi dari notifikasi
Mengetuk notifikasi pengingat SHALL membuka aplikasi. Untuk pengingat jam makan, aplikasi membuka ruang Hari ini. Untuk pengingat timbang, aplikasi membuka layar tambah berat.

#### Scenario: Ketuk pengingat timbang
- **WHEN** pengguna mengetuk notifikasi pengingat timbang
- **THEN** aplikasi terbuka pada layar tambah berat

### Requirement: Izin notifikasi diminta saat dibutuhkan
Sistem SHALL meminta izin notifikasi hanya ketika pengguna menyalakan pengingat dan izin belum diberikan, dan MUST NOT memintanya saat onboarding. Bila izin ditolak, sistem SHALL tetap menyimpan pengaturan pengingat, menampilkan bahwa notifikasi tidak dapat muncul, dan menyediakan jalan ke pengaturan sistem.

#### Scenario: Izin ditolak
- **WHEN** pengguna menyalakan pengingat makan malam lalu menolak izin notifikasi
- **THEN** pengingat tetap tercatat menyala dan layar Pengingat menampilkan keterangan bahwa notifikasi diblokir, beserta tombol untuk membuka pengaturan sistem

#### Scenario: Onboarding tidak meminta izin
- **WHEN** pengguna baru menyelesaikan onboarding
- **THEN** tidak ada permintaan izin notifikasi yang muncul

### Requirement: Jadwal tetap berlaku
Pengingat yang menyala SHALL tetap terjadwal setelah perangkat dinyalakan ulang, setelah aplikasi diperbarui, dan setelah zona waktu perangkat berubah. Setelah zona waktu berubah, pengingat mengikuti jam lokal yang baru sejak aplikasi dibuka kembali.

#### Scenario: Setelah restart
- **WHEN** perangkat dinyalakan ulang dan pengguna belum membuka aplikasi
- **THEN** pengingat yang menyala tetap muncul pada jadwal berikutnya

#### Scenario: Zona waktu berubah
- **WHEN** pengguna dengan pengingat makan siang 12:00 berpindah dari WIB ke WITA lalu membuka aplikasi
- **THEN** pengingat makan siang berikutnya muncul sekitar pukul 12:00 WITA

### Requirement: Ketepatan waktu bersifat perkiraan
Sistem SHALL menjadwalkan pengingat tanpa meminta izin alarm tepat waktu. Notifikasi dapat tertunda beberapa menit karena penghematan daya perangkat, sehingga layar Pengingat MUST NOT menjanjikan ketepatan sampai menit.

#### Scenario: Tidak meminta izin alarm tepat waktu
- **WHEN** pengguna menyalakan pengingat apa pun
- **THEN** sistem tidak meminta izin alarm tepat waktu

### Requirement: Data pengingat tetap lokal
Pengaturan pengingat SHALL disimpan hanya di perangkat, dan isi notifikasi MUST NOT menampilkan angka kalori, berat badan, atau data kesehatan lain.

#### Scenario: Isi notifikasi
- **WHEN** notifikasi pengingat makan malam muncul di layar kunci
- **THEN** teksnya hanya berupa ajakan mencatat, tanpa angka kalori atau berat badan
