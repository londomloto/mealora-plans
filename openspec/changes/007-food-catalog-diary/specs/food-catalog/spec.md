## Purpose

Makanan yang tersedia bagi pengguna di perangkat: nilai gizi beserta asal-usulnya, takaran saji yang bermakna bagi orang Indonesia, cara menemukan makanan secara luring, dan cara pengguna menambahkan makanan yang belum ada di katalog.

## ADDED Requirements

### Requirement: Katalog tersedia sepenuhnya tanpa koneksi

Katalog makanan SHALL tersedia dan dapat dicari tanpa koneksi jaringan sejak aplikasi dipasang. Pencarian dan pembacaan nilai gizi SHALL TIDAK memerlukan permintaan jaringan apa pun.

#### Scenario: Mencari makanan dalam mode pesawat

- **WHEN** pengguna mencari makanan dengan seluruh koneksi dimatikan
- **THEN** hasil pencarian tampil dari katalog di perangkat tanpa pesan kesalahan jaringan

### Requirement: Setiap makanan katalog memiliki asal-usul data

Setiap makanan pada katalog bawaan SHALL menyimpan asal-usul nilai gizinya: jenis sumber, pengenal pada sumber tersebut, versi sumber, dan tanggal verifikasi terakhir. Sistem SHALL dapat menampilkan asal-usul itu kepada pengguna.

Nilai gizi SHALL berasal dari sumber yang dapat ditelusuri. Sistem SHALL TIDAK memuat nilai gizi yang dikarang, diperkirakan tanpa dasar, atau disalin dari sumber yang hak pakainya belum dipastikan.

#### Scenario: Pengguna memeriksa asal data

- **WHEN** pengguna membuka detail sebuah makanan katalog
- **THEN** sistem menampilkan penanda asal data makanan itu

#### Scenario: Makanan tanpa asal-usul ditolak masuk katalog

- **WHEN** sebuah makanan bawaan tidak memiliki asal-usul yang lengkap
- **THEN** makanan itu tidak disertakan dalam katalog bawaan

### Requirement: Takaran saji yang bermakna

Setiap makanan SHALL memiliki sekurang-kurangnya satu takaran saji dengan label yang dapat dimengerti pengguna, jumlah, satuan, dan bobot dalam gram bila diketahui. Satu takaran SHALL ditandai sebagai takaran bawaan.

Label takaran SHALL memakai istilah sehari-hari Indonesia jika sesuai, misalnya "1 mangkuk" atau "1 potong", dan SHALL menyertakan padanan beratnya bila diketahui.

#### Scenario: Memilih takaran saji

- **WHEN** pengguna membuka sebuah makanan yang memiliki beberapa takaran saji
- **THEN** seluruh takaran tampil dengan label dan padanan beratnya, dan takaran bawaan terpilih lebih dulu

### Requirement: Cakupan makanan Indonesia

Katalog bawaan SHALL memuat makanan yang lazim dikonsumsi di Indonesia, mencakup makanan pokok, lauk, sayur, jajanan, dan minuman yang umum.

#### Scenario: Mencari makanan Indonesia yang umum

- **WHEN** pengguna mencari "nasi"
- **THEN** hasil memuat beberapa makanan berbasis nasi yang lazim beserta takaran sajinya

### Requirement: Pencarian luring yang memaafkan

Pencarian SHALL mengabaikan perbedaan huruf besar dan kecil, SHALL mencocokkan bagian mana pun dari nama makanan, dan SHALL menampilkan hasil tanpa jeda yang terasa pada ukuran katalog yang wajar.

Hasil SHALL menampilkan nama makanan dan takaran sajinya. Pencarian yang tidak menemukan apa pun SHALL menyatakan demikian dan SHALL menawarkan pembuatan makanan sendiri.

#### Scenario: Pencarian tanpa hasil

- **WHEN** pencarian pengguna tidak cocok dengan satu pun makanan
- **THEN** sistem menyatakan tidak ada hasil dan menawarkan pembuatan makanan sendiri

#### Scenario: Huruf besar-kecil diabaikan

- **WHEN** pengguna mengetik "NASI" atau "nasi"
- **THEN** hasil yang ditampilkan sama

### Requirement: Makanan yang terakhir dicatat muncul lebih dulu

Sebelum pengguna mengetik apa pun, sistem SHALL menampilkan makanan yang terakhir ia catat sebagai pilihan cepat, beserta takaran yang terakhir dipakai untuk makanan itu.

#### Scenario: Membuka pencarian setelah pernah mencatat

- **WHEN** pengguna membuka pencarian makanan setelah sebelumnya mencatat beberapa makanan
- **THEN** makanan yang terakhir dicatat tampil lebih dulu beserta takaran yang terakhir dipakai

#### Scenario: Pengguna baru

- **WHEN** pengguna membuka pencarian sebelum pernah mencatat apa pun
- **THEN** bagian terakhir dicatat tidak ditampilkan atau dinyatakan masih kosong, bukan diisi contoh

### Requirement: Pengguna dapat membuat makanan sendiri

Sistem SHALL memungkinkan pengguna membuat makanan yang tidak ada di katalog, dengan masukan sekurang-kurangnya: nama, ukuran sajian, energi, protein, karbohidrat, dan lemak.

Sistem SHALL menyatakan bahwa nilai sebaiknya disalin dari sumber yang dipercaya pengguna, dan SHALL menyatakan bahwa nilai yang belum diketahui jangan diisi nol. Nilai yang dikosongkan SHALL disimpan sebagai belum diketahui.

Makanan buatan pengguna SHALL ditandai berbeda dari makanan katalog bawaan, dan SHALL dapat dicari serta dicatat seperti makanan lain.

#### Scenario: Membuat makanan sendiri

- **WHEN** pengguna menyimpan makanan buatan sendiri dengan nama, ukuran sajian, dan nilai gizi
- **THEN** makanan itu tersedia pada pencarian berikutnya dan ditandai sebagai makanan buatan pengguna

#### Scenario: Nilai gizi dikosongkan

- **WHEN** pengguna mengosongkan nilai lemak karena tidak mengetahuinya
- **THEN** nilai itu tersimpan sebagai belum diketahui dan tidak diubah menjadi nol

#### Scenario: Nilai tidak masuk akal

- **WHEN** pengguna memasukkan nilai gizi negatif atau ukuran sajian nol
- **THEN** sistem menolak dengan penjelasan dan tidak menyimpan makanan itu

### Requirement: Pembaruan katalog tidak mengubah catatan lama

Pembaruan nilai gizi pada katalog SHALL TIDAK mengubah nilai pada catatan makan yang sudah tersimpan.

#### Scenario: Nilai katalog diperbarui

- **WHEN** nilai gizi sebuah makanan katalog diperbarui setelah pengguna pernah mencatatnya
- **THEN** catatan lama tetap menampilkan nilai seperti saat dicatat
