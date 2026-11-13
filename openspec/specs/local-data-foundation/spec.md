# local-data-foundation Specification

## Purpose
Aturan penyimpanan data di perangkat sebagai satu-satunya sumber kebenaran Mealora: identitas record, jejak waktu, penghapusan lunak, versi skema dan migrasi yang aman, integritas nilai, serta jaminan bahwa data pribadi tidak meninggalkan perangkat.

## Requirements

### Requirement: Perangkat adalah sumber kebenaran

Seluruh data pengguna SHALL disimpan di perangkat dan SHALL tetap dapat dibaca serta ditulis tanpa koneksi jaringan. Aplikasi SHALL TIDAK mengirimkan data pengguna ke layanan mana pun, dan SHALL TIDAK menyertakan SDK analitik, iklan, atau pelacak pihak ketiga.

#### Scenario: Data bertahan setelah aplikasi ditutup

- **WHEN** data tersimpan, lalu aplikasi ditutup sepenuhnya dan dibuka kembali
- **THEN** data yang sama tersedia kembali tanpa koneksi jaringan

#### Scenario: Tidak ada pengiriman data keluar

- **WHEN** pengguna memakai fungsi inti aplikasi
- **THEN** tidak ada data pengguna yang dikirim ke server, layanan pihak ketiga, atau berkas log di luar perangkat

### Requirement: Identitas record stabil dan unik global

Setiap record milik pengguna SHALL memiliki pengenal unik global yang dibuat aplikasi. Pengenal SHALL TIDAK berupa nomor urut basis data, SHALL TIDAK berubah sepanjang hidup record, dan SHALL tetap unik antar perangkat sehingga dua perangkat tidak dapat menghasilkan pengenal yang sama.

#### Scenario: Pengenal tidak berubah saat record diperbarui

- **WHEN** sebuah record diperbarui berkali-kali
- **THEN** pengenalnya tetap sama persis seperti saat dibuat

### Requirement: Jejak waktu dan penghapusan lunak

Setiap record milik pengguna SHALL mencatat waktu pembuatan dan waktu pembaruan terakhir, dan SHALL mendukung penandaan terhapus tanpa membuang barisnya. Record yang ditandai terhapus SHALL TIDAK muncul dalam pembacaan biasa maupun perhitungan, dan SHALL tetap dapat dibedakan dari record yang tidak pernah ada.

#### Scenario: Record dihapus pengguna

- **WHEN** pengguna menghapus sebuah record
- **THEN** record itu hilang dari seluruh tampilan dan perhitungan, sementara penandaan terhapusnya tetap tersimpan di perangkat

#### Scenario: Waktu pembaruan ikut berubah

- **WHEN** sebuah record diubah
- **THEN** waktu pembaruannya menjadi waktu perubahan tersebut, sedangkan waktu pembuatannya tidak berubah

### Requirement: Waktu disimpan dalam bentuk yang tidak berubah makna

Waktu kejadian SHALL disimpan dalam UTC disertai pengenal zona waktu dan tanggal lokal yang dipakai untuk pengelompokan harian. Perubahan zona waktu perangkat atau pengaturan tampilan SHALL TIDAK mengubah tanggal lokal yang sudah tercatat pada record lama.

#### Scenario: Perangkat berpindah zona waktu

- **WHEN** pengguna berpindah zona waktu setelah mencatat data
- **THEN** data lama tetap terkelompok pada tanggal lokal yang sama seperti saat dicatat

### Requirement: Versi skema dan migrasi yang teruji

Penyimpanan lokal SHALL menyimpan nomor versi skema. Setiap perubahan struktur penyimpanan SHALL disertai migrasi yang dijalankan otomatis saat aplikasi dibuka. Migrasi SHALL mempertahankan seluruh data pengguna yang sudah ada dan SHALL diverifikasi terhadap basis data kosong maupun basis data berisi data sebelum dianggap selesai.

#### Scenario: Pemasangan baru

- **WHEN** aplikasi dibuka pertama kali di perangkat tanpa data
- **THEN** penyimpanan lokal terbentuk pada versi skema terkini dan aplikasi dapat dipakai

#### Scenario: Migrasi gagal di tengah jalan

- **WHEN** proses migrasi terganggu sebelum selesai
- **THEN** data pengguna tidak rusak atau tersimpan sebagian; aplikasi menampilkan keadaan kesalahan yang dapat dibaca pengguna dan percobaan berikutnya menjalankan ulang migrasi dari keadaan yang konsisten

### Requirement: Penulisan yang melibatkan banyak record bersifat utuh

Operasi yang menulis lebih dari satu record SHALL berhasil seluruhnya atau tidak sama sekali. Kegagalan di tengah operasi SHALL TIDAK meninggalkan record sebagian, record yatim, atau relasi yang menunjuk ke data yang tidak ada.

#### Scenario: Kegagalan di tengah penulisan ganda

- **WHEN** satu operasi menulis beberapa record dan gagal pada record terakhir
- **THEN** tidak ada satu pun perubahan dari operasi itu yang tersimpan

### Requirement: Nilai yang tidak masuk akal ditolak

Penyimpanan SHALL menolak nilai yang mustahil secara fisik atau tidak bermakna, termasuk nilai gizi negatif, jumlah atau berat nol maupun negatif, dan nilai bukan-angka. Nilai yang belum diketahui SHALL disimpan sebagai tidak diketahui, dan SHALL TIDAK diubah menjadi nol.

#### Scenario: Nilai gizi negatif

- **WHEN** sebuah penulisan menyertakan nilai gizi negatif
- **THEN** penulisan ditolak dengan kesalahan bertipe dan tidak ada data yang tersimpan

#### Scenario: Nilai belum diketahui

- **WHEN** sebuah nilai gizi tidak diketahui saat record disimpan
- **THEN** nilai itu tetap tercatat sebagai belum diketahui dan dibedakan dari nilai nol

### Requirement: Kesiapan sinkronisasi tanpa ketergantungan server

Setiap record milik pengguna SHALL menyimpan penanda keadaan sinkronisasi dan nomor revisi yang bertambah setiap kali record berubah. Di MVP 1 keadaan sinkronisasi SHALL selalu bernilai lokal, dan perilaku aplikasi SHALL TIDAK bergantung pada server, akun, atau proses sinkronisasi apa pun.

#### Scenario: Record baru di MVP 1

- **WHEN** sebuah record dibuat
- **THEN** keadaan sinkronisasinya lokal, revisinya dimulai dari nilai awal, dan tidak ada proses yang mencoba mengirimkannya keluar perangkat

#### Scenario: Revisi bertambah saat record berubah

- **WHEN** sebuah record diperbarui
- **THEN** nomor revisinya bertambah dibanding nilai sebelumnya

### Requirement: Perilaku berwaktu dan pengenal dapat diuji

Waktu dan pembangkitan pengenal SHALL diperoleh melalui sumber yang dapat digantikan saat pengujian, sehingga perilaku yang bergantung pada waktu atau pengenal dapat diuji secara deterministik. Kode aplikasi SHALL TIDAK membaca jam sistem atau membuat pengenal acak secara langsung di tempat pemakaian.

#### Scenario: Pengujian dengan waktu tetap

- **WHEN** pengujian menjalankan alur yang mencatat waktu dengan sumber waktu yang ditetapkan
- **THEN** nilai waktu yang tersimpan sama persis pada setiap kali pengujian dijalankan
