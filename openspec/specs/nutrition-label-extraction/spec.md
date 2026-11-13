# nutrition-label-extraction Specification

## Purpose
Membaca panel Informasi Nilai Gizi dari foto kemasan menjadi nilai yang ditinjau dan dikoreksi pengguna: basis takaran yang terbaca, penanganan nilai yang tidak terbaca, pengisian manual yang setara tanpa koneksi, dan penyimpanan hasil yang dikonfirmasi untuk dipakai lagi.

## Requirements

### Requirement: Memotret label dengan panduan

Sistem SHALL memungkinkan pengguna memotret panel Informasi Nilai Gizi dan SHALL memberi panduan agar teks dan satuan terbaca jelas.

Sebelum pengiriman apa pun, sistem SHALL meminta persetujuan unggah sesuai aturan persetujuan gambar yang berlaku, dan SHALL menawarkan jalur pengisian manual tanpa unggah.

#### Scenario: Pengguna memilih jalur manual

- **WHEN** pengguna membuka pemotretan label lalu memilih mengisi nilai secara manual
- **THEN** sistem membuka pengisian manual tanpa mengambil atau mengirim gambar

### Requirement: Hasil ekstraksi ditinjau berdampingan dengan foto

Sistem SHALL menampilkan foto label asli berdampingan dengan nilai yang terbaca, sehingga pengguna dapat membandingkan keduanya tanpa berpindah layar.

Setiap nilai hasil ekstraksi SHALL dapat disunting, dan SHALL disertai penanda apakah nilai itu terbaca dengan yakin, perlu diperiksa, atau tidak terbaca.

#### Scenario: Meninjau hasil ekstraksi

- **WHEN** ekstraksi selesai
- **THEN** sistem menampilkan foto asli beserta nilai energi, protein, karbohidrat, dan lemak yang dapat disunting, masing-masing dengan penandanya

#### Scenario: Nilai dikoreksi pengguna

- **WHEN** pengguna mengoreksi sebuah nilai hasil ekstraksi
- **THEN** nilai koreksi itu yang dipakai dan ditandai sebagai nilai yang dikonfirmasi pengguna

### Requirement: Basis label dibaca dan ditegaskan

Sistem SHALL membaca basis nilai pada label — per sajian beserta ukurannya, jumlah sajian per kemasan, atau per 100 g — dan SHALL menampilkannya kepada pengguna untuk diperiksa sebelum nilai dipakai.

Sistem SHALL menyatakan hubungan antara satu sajian dan satu kemasan ketika keduanya diketahui.

#### Scenario: Basis per sajian dengan dua sajian per kemasan

- **WHEN** label menyatakan nilai per 1 sajian 30 g dengan 2 sajian per kemasan
- **THEN** sistem menampilkan basis itu dan menyatakan bahwa satu kemasan sama dengan dua kali nilai per sajian

#### Scenario: Basis tidak terbaca

- **WHEN** basis label tidak dapat dibaca dari foto
- **THEN** sistem meminta pengguna menetapkan basisnya dan tidak menebak

### Requirement: Nilai yang tidak terbaca tetap belum diketahui

Nilai yang tidak terbaca, terbaca dengan keyakinan rendah, atau bersatuan ambigu SHALL ditandai belum diketahui atau perlu diperiksa. Sistem SHALL TIDAK menggantinya dengan nol maupun dengan nilai tebakan.

Sistem SHALL menahan konfirmasi selama nilai penting belum terisi atau belum diperiksa, dan SHALL menyatakan nilai mana yang menahan.

#### Scenario: Nilai lemak tidak terbaca

- **WHEN** nilai lemak tidak terbaca dari foto
- **THEN** nilai itu ditandai belum diketahui dengan tindakan untuk mengisinya, dan konfirmasi tertahan sampai pengguna mengisi atau menyatakan nilainya memang tidak tercantum

#### Scenario: Satuan ambigu

- **WHEN** satuan sebuah nilai tidak dapat dipastikan
- **THEN** sistem menandai nilai itu perlu diperiksa dan meminta pengguna memastikannya sebelum melanjutkan

### Requirement: Pengisian label manual setara dan luring

Sistem SHALL menyediakan pengisian nilai label secara manual yang bekerja sepenuhnya tanpa koneksi, memuat: nama produk, basis nilai, ukuran sajian, jumlah sajian per kemasan, energi, protein, karbohidrat, dan lemak.

Sistem SHALL menyatakan aritmetika kemasan yang berlaku, dan SHALL menolak nilai yang mustahil dengan penjelasan. Nilai yang dikosongkan SHALL tersimpan sebagai belum diketahui.

#### Scenario: Mengisi label tanpa koneksi

- **WHEN** pengguna mengisi nilai label secara manual dengan koneksi dimatikan
- **THEN** nilai tersimpan dan dapat dipakai untuk mencatat, tanpa pesan kesalahan jaringan

#### Scenario: Pengingat aritmetika kemasan

- **WHEN** pengguna menetapkan basis per sajian dengan dua sajian per kemasan
- **THEN** sistem menyatakan bahwa satu kemasan sama dengan dua kali nilai per sajian, dan bahwa nilai itu bukan nilai per 100 g

### Requirement: Hasil yang dikonfirmasi disimpan beserta asal-usulnya

Produk yang dikonfirmasi lewat jalur label SHALL tersimpan di perangkat beserta barcode bila ada, varian kemasan, basis takaran, tanggal verifikasi, dan asal-usul yang menyatakan bahwa nilainya berasal dari ekstraksi label yang dikonfirmasi pengguna.

Produk itu SHALL dapat ditemukan kembali tanpa koneksi, lewat pemindaian barcode maupun pencarian nama.

#### Scenario: Memakai ulang produk hasil ekstraksi

- **WHEN** pengguna memindai barcode produk yang sebelumnya dikonfirmasi lewat jalur label, tanpa koneksi
- **THEN** produk itu ditemukan beserta nilai yang terakhir dikonfirmasi dan penanda asal-usulnya

### Requirement: Pencatatan hanya setelah konfirmasi

Sistem SHALL TIDAK membuat catatan makan maupun rekaman produk terverifikasi sebelum pengguna mengonfirmasi hasil peninjauan.

Membatalkan peninjauan SHALL TIDAK meninggalkan catatan, dan SHALL mengikuti pengaturan retensi gambar yang berlaku.

#### Scenario: Peninjauan dibatalkan

- **WHEN** pengguna menutup layar peninjauan tanpa mengonfirmasi
- **THEN** tidak ada catatan maupun rekaman produk yang dibuat

### Requirement: Nilai historis tidak berubah oleh koreksi berikutnya

Catatan yang sudah tersimpan SHALL TIDAK berubah ketika pengguna kemudian mengoreksi nilai produk hasil ekstraksi.

#### Scenario: Koreksi setelah pencatatan

- **WHEN** pengguna mengoreksi nilai produk setelah pernah mencatatnya
- **THEN** catatan lama tetap menampilkan nilai seperti saat dicatat, dan nilai koreksi berlaku untuk pencatatan berikutnya

### Requirement: Bahasa peninjauan tidak menyiratkan kepastian

Sistem SHALL menyebut hasil ekstraksi sebagai pembacaan yang perlu diperiksa, dan SHALL TIDAK menyajikannya sebagai data terverifikasi, hasil pengukuran, atau nilai resmi produk.

#### Scenario: Teks peninjauan diperiksa

- **WHEN** pengguna membuka layar peninjauan hasil ekstraksi
- **THEN** teks menyatakan bahwa nilai perlu dikonfirmasi dan tidak menyebutnya sebagai data terverifikasi
