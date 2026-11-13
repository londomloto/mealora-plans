# food-diary Specification

## Purpose
Pencatatan apa yang dimakan pengguna pada suatu hari: menambah, menyunting, memindahkan, dan menghapus catatan, dengan jaminan bahwa nilai gizi yang tercatat tidak berubah di kemudian hari dan bahwa pencatatan tetap bekerja sepenuhnya tanpa koneksi.

## Requirements

### Requirement: Empat waktu makan

Sistem SHALL mengelompokkan catatan makan ke dalam empat waktu makan dengan nama Indonesia: **Sarapan**, **Makan siang**, **Camilan**, dan **Makan malam**.

Setiap catatan SHALL berada pada tepat satu waktu makan dan tepat satu tanggal lokal.

#### Scenario: Mencatat ke waktu makan tertentu

- **WHEN** pengguna menyimpan sebuah makanan ke Makan siang
- **THEN** catatan itu muncul di bawah Makan siang pada tanggal yang berlaku

### Requirement: Pencatatan bekerja tanpa koneksi

Seluruh penambahan, penyuntingan, pemindahan, dan penghapusan catatan SHALL bekerja tanpa koneksi jaringan, dan hasilnya SHALL tersimpan di perangkat seketika.

#### Scenario: Mencatat dalam mode pesawat

- **WHEN** pengguna mencatat makanan dengan koneksi dimatikan
- **THEN** catatan tersimpan dan tampil pada ringkasan hari itu tanpa pesan kesalahan jaringan

### Requirement: Takaran dan jumlah dipilih sebelum disimpan

Sebelum menyimpan, sistem SHALL memungkinkan pengguna memilih takaran saji, menetapkan jumlah takaran, dan memilih waktu makan. Sistem SHALL menampilkan perkiraan nilai gizi hasil pilihan itu sebelum disimpan.

Jumlah takaran SHALL lebih besar dari nol. Sistem SHALL menolak jumlah nol atau negatif dengan penjelasan.

#### Scenario: Meninjau sebelum menyimpan

- **WHEN** pengguna memilih takaran dan jumlah
- **THEN** perkiraan energi dan zat gizi makro untuk pilihan itu tampil sebelum ia menyimpan

#### Scenario: Jumlah tidak sah

- **WHEN** pengguna menetapkan jumlah takaran nol
- **THEN** sistem menolak penyimpanan dengan penjelasan dan tidak membuat catatan

### Requirement: Nilai gizi dibekukan pada saat pencatatan

Setiap catatan SHALL menyimpan potret nilai yang dipakai saat pencatatan: nama makanan, label takaran, energi, protein, karbohidrat, dan lemak untuk takaran tersebut.

Potret itu SHALL TIDAK berubah ketika makanan di katalog diperbarui, ketika makanan buatan pengguna disunting, atau ketika makanan dihapus dari katalog. Potret SHALL berubah hanya ketika pengguna menyunting catatan itu sendiri.

#### Scenario: Makanan katalog diperbarui setelah dicatat

- **WHEN** nilai gizi sebuah makanan diperbarui setelah pengguna mencatatnya
- **THEN** catatan lama tetap menunjukkan nilai yang sama seperti saat dicatat

#### Scenario: Makanan buatan pengguna disunting

- **WHEN** pengguna menyunting nilai gizi makanan buatannya sendiri
- **THEN** catatan yang sudah ada tetap memakai nilai lama, dan nilai baru hanya berlaku untuk pencatatan berikutnya

#### Scenario: Pengguna menyunting catatannya

- **WHEN** pengguna mengubah jumlah takaran pada sebuah catatan
- **THEN** nilai pada catatan itu dihitung ulang dari potret yang tersimpan dan ringkasan hari itu menyesuaikan

### Requirement: Menyunting, memindahkan, dan menghapus catatan

Sistem SHALL memungkinkan pengguna mengubah takaran dan jumlah pada sebuah catatan, memindahkannya ke waktu makan lain, dan menghapusnya.

Penyuntingan SHALL berlaku hanya pada catatan tersebut, dan SHALL TIDAK mengubah catatan lain maupun makanan di katalog. Ringkasan harian SHALL menyesuaikan segera setelah perubahan.

Penghapusan SHALL menghilangkan catatan dari seluruh tampilan dan seluruh perhitungan.

#### Scenario: Memindahkan catatan antar waktu makan

- **WHEN** pengguna memindahkan sebuah catatan dari Camilan ke Makan malam
- **THEN** catatan itu muncul di bawah Makan malam, ringkasan kedua waktu makan menyesuaikan, dan total harian tidak berubah

#### Scenario: Menghapus catatan

- **WHEN** pengguna menghapus sebuah catatan
- **THEN** catatan hilang dari buku harian dan total harian berkurang sesuai nilai catatan itu

#### Scenario: Penyuntingan tidak merembet

- **WHEN** pengguna menyunting satu catatan dari makanan yang juga dicatat di hari lain
- **THEN** catatan di hari lain tidak berubah

### Requirement: Penulisan catatan bersifat utuh

Menyimpan sebuah catatan beserta butir-butirnya SHALL berhasil seluruhnya atau tidak sama sekali. Kegagalan SHALL TIDAK meninggalkan catatan tanpa butir, butir tanpa catatan, atau potret nilai gizi yang tidak lengkap.

#### Scenario: Kegagalan saat menyimpan

- **WHEN** penyimpanan sebuah catatan gagal di tengah jalan
- **THEN** tidak ada bagian dari catatan itu yang tersimpan dan buku harian tidak berubah

### Requirement: Buku harian menampilkan hari yang dipilih

Sistem SHALL menampilkan catatan sebuah tanggal yang dikelompokkan menurut waktu makan, masing-masing dengan perkiraan energinya, beserta ringkasan harian.

Tanggal sebuah catatan SHALL tetap seperti saat dicatat meskipun zona waktu perangkat berubah di kemudian hari.

#### Scenario: Membuka buku harian hari ini

- **WHEN** pengguna membuka buku harian
- **THEN** catatan hari itu tampil dikelompokkan menurut empat waktu makan beserta perkiraan energi masing-masing

#### Scenario: Zona waktu berubah

- **WHEN** pengguna berpindah zona waktu setelah mencatat
- **THEN** catatan lama tetap berada pada tanggal yang sama seperti saat dicatat

### Requirement: Pencatatan tetap tersedia tanpa program

Sistem SHALL memungkinkan pencatatan makanan meskipun tidak ada program yang berjalan maupun ketika program sedang dijeda. Ketiadaan program SHALL TIDAK menghalangi pencatatan atau pembacaan buku harian.

#### Scenario: Mencatat tanpa program

- **WHEN** pengguna mencatat makanan sementara tidak ada program yang berjalan
- **THEN** catatan tersimpan dan buku harian menampilkan totalnya tanpa perbandingan terhadap target

#### Scenario: Mencatat saat program dijeda

- **WHEN** pengguna mencatat makanan sementara program dijeda
- **THEN** catatan tersimpan seperti biasa dan hari itu tidak dihitung sebagai hari aktif program
