## Purpose

Memberi tahu pengguna secara lembut dan informatif ketika mereka mencatat makanan menjelang atau setelah jam tidur, tanpa memblokir pencatatan dan tanpa nada menghakimi.

## ADDED Requirements

### Requirement: Pengaturan jam tidur
Sistem SHALL menyediakan pengaturan jam tidur lokal di layar Pengingat. Defaultnya 22:00. Pengaturan ini tidak memerlukan izin notifikasi.

#### Scenario: Mengubah jam tidur
- **WHEN** pengguna mengubah jam tidur menjadi 23:30
- **THEN** rentang peringatan makan menjelang tidur dihitung dari 23:30

### Requirement: Rentang peringatan
Rentang peringatan SHALL dimulai 2 jam sebelum jam tidur dan berakhir pukul 04:00 waktu lokal berikutnya. Bila jam tidur jatuh antara 00:00 dan 04:00, rentang tetap dimulai 2 jam sebelum jam tidur dan berakhir pukul 04:00 malam itu.

#### Scenario: Jam tidur 22:00
- **WHEN** jam tidur 22:00 dan pengguna mencatat makanan pukul 20:30
- **THEN** pencatatan itu berada di dalam rentang peringatan

#### Scenario: Di luar rentang
- **WHEN** jam tidur 22:00 dan pengguna mencatat makanan pukul 19:45
- **THEN** pencatatan itu berada di luar rentang peringatan

#### Scenario: Jam tidur lewat tengah malam
- **WHEN** jam tidur 01:00 dan pengguna mencatat makanan pukul 23:30
- **THEN** pencatatan itu berada di dalam rentang peringatan

### Requirement: Peringatan setelah mencatat menjelang tidur
Ketika pengguna berhasil menyimpan makanan untuk tanggal hari ini dan waktu saat ini berada di dalam rentang peringatan, sistem SHALL menampilkan pesan informatif yang tidak memblokir. Catatan MUST tetap tersimpan apa pun respons pengguna terhadap pesan itu. Pesan MUST NOT memakai kata "berbahaya", klaim medis, atau nada menghakimi, dan mengikuti aturan copy nutrition-policy-v1.

#### Scenario: Peringatan tampil
- **WHEN** jam tidur 22:00 dan pengguna menyimpan camilan untuk hari ini pukul 21:15
- **THEN** catatan tersimpan dan sistem menampilkan pesan bahwa sudah dekat jam tidur beserta saran memilih porsi ringan

#### Scenario: Pencatatan gagal
- **WHEN** penyimpanan makanan gagal
- **THEN** sistem tidak menampilkan peringatan makan menjelang tidur

### Requirement: Tidak untuk tanggal lampau
Sistem MUST NOT menampilkan peringatan ketika makanan disimpan untuk tanggal selain hari ini, misalnya saat mengisi riwayat.

#### Scenario: Mengisi catatan kemarin
- **WHEN** pukul 21:30 pengguna mencatat makan malam untuk tanggal kemarin dari Riwayat
- **THEN** catatan tersimpan tanpa peringatan makan menjelang tidur

### Requirement: Paling banyak sekali per malam
Sistem SHALL menampilkan peringatan paling banyak sekali dalam satu rentang peringatan. Pencatatan berikutnya dalam rentang yang sama tidak menampilkan peringatan lagi.

#### Scenario: Pencatatan kedua di malam yang sama
- **WHEN** peringatan sudah tampil pukul 21:00, lalu pengguna mencatat makanan lagi pukul 21:40 untuk hari ini
- **THEN** catatan kedua tersimpan tanpa peringatan

#### Scenario: Malam berikutnya
- **WHEN** peringatan tampil pada malam Senin, lalu pengguna mencatat makanan di dalam rentang pada malam Selasa
- **THEN** peringatan tampil lagi pada malam Selasa
