## Purpose

Perjalanan sebuah program dalam pemakaian seorang pengguna: dari proposal target menjadi program berjalan, lalu dijeda, dilanjutkan, diganti, diselesaikan, atau dibatalkan — beserta jaminan bahwa hanya ada satu program berjalan, bahwa pergantian tidak pernah setengah jadi, dan bahwa catatan makanan serta berat tidak pernah ikut terpengaruh.

## ADDED Requirements

### Requirement: Keadaan program dan perpindahan yang sah

Sebuah program pengguna SHALL berada pada tepat satu keadaan: `draft`, `active`, `paused`, `completed`, `changed`, atau `cancelled`.

Perpindahan yang sah:

```text
draft    → active | cancelled
active   → paused | completed | changed | cancelled
paused   → active | completed | changed | cancelled
```

`completed`, `changed`, dan `cancelled` SHALL merupakan keadaan akhir. Sistem SHALL TIDAK mengizinkan perpindahan keluar dari keadaan akhir, termasuk melanjutkan program yang sudah selesai.

Setiap perpindahan yang tidak sah SHALL mengembalikan kesalahan bertipe yang menyebut keadaan saat ini dan perpindahan yang diminta, dan SHALL TIDAK mengubah keadaan apa pun.

#### Scenario: Melanjutkan program yang sudah selesai

- **WHEN** pengguna mencoba melanjutkan program berstatus `completed`
- **THEN** sistem mengembalikan kesalahan bertipe yang menyebut bahwa program sudah selesai, dan tidak ada keadaan yang berubah

#### Scenario: Menjeda program yang masih draf

- **WHEN** sebuah perintah jeda dikirim untuk program berstatus `draft`
- **THEN** sistem mengembalikan kesalahan bertipe dan program tetap berstatus `draft`

### Requirement: Satu program berjalan per profil

Sebuah profil SHALL memiliki paling banyak satu program berstatus `active` atau `paused` pada satu waktu. Program berstatus `draft` SHALL TIDAK memengaruhi program yang sedang berjalan.

Invarian ini SHALL bertahan terhadap perintah yang diulang maupun perintah yang dikirim bersamaan: percobaan aktivasi berkali-kali SHALL TIDAK menghasilkan lebih dari satu program berjalan.

#### Scenario: Aktivasi dikirim dua kali

- **WHEN** perintah aktivasi untuk proposal yang sama dikirim dua kali berturut-turut
- **THEN** profil tetap memiliki tepat satu program berjalan, dan perintah kedua dikenali sebagai pengulangan alih-alih membuat program kedua

#### Scenario: Draf tidak mengganggu program berjalan

- **WHEN** pengguna membuat proposal program baru sementara satu program sedang `active`
- **THEN** program yang `active` tetap berjalan tanpa perubahan sampai pengguna menyetujui aktivasi yang baru

### Requirement: Aktivasi memerlukan proposal yang disetujui dan konfirmasi pengguna

Sistem SHALL mengaktifkan sebuah program hanya bila proposal targetnya berstatus disetujui oleh kebijakan yang berlaku dan pengguna telah mengonfirmasi secara eksplisit setelah meninjau nilai target, asumsi, peringatan, serta versi kebijakan dan kalkulator.

Sebelum mengaktifkan, sistem SHALL membaca ulang fakta profil terkini dan memastikan proposal masih sesuai. Bila fakta yang dipakai proposal sudah berubah, sistem SHALL membatalkan aktivasi, SHALL memberi tahu pengguna bahwa masukan telah berubah sejak pratinjau, dan SHALL meminta peninjauan ulang.

Sistem SHALL TIDAK mengaktifkan program atas dasar hasil `needs_user_correction`, `needs_professional_review`, `unsupported_profile`, atau `missing_validated_policy`, meskipun perintah aktivasi datang tanpa melewati antarmuka pengguna.

#### Scenario: Aktivasi tanpa konfirmasi

- **WHEN** perintah aktivasi datang tanpa konfirmasi pengguna atas proposal
- **THEN** sistem menolak dengan kesalahan bertipe dan tidak ada program yang aktif

#### Scenario: Profil berubah setelah pratinjau

- **WHEN** berat badan profil berubah setelah proposal ditampilkan dan sebelum pengguna mengonfirmasi
- **THEN** sistem membatalkan aktivasi, menjelaskan bahwa masukan telah berubah sejak pratinjau, dan meminta pengguna meninjau proposal yang diperbarui

#### Scenario: Aktivasi atas hasil yang tidak disetujui

- **WHEN** perintah aktivasi dikirim untuk proposal berhasil `unsupported_profile`
- **THEN** sistem menolak aktivasi dan tidak ada program yang aktif, meskipun perintah tidak melewati antarmuka pengguna

### Requirement: Pergantian program berlangsung utuh

Ketika pengguna mengaktifkan program baru sementara satu program sedang berjalan, sistem SHALL melakukan seluruh langkah berikut sebagai satu kesatuan: menandai program lama `changed`, mencatat waktu berakhirnya, menautkan program lama dan program baru dua arah, mencatat peristiwa siklus hidup, dan mengaktifkan program baru.

Bila salah satu langkah gagal, sistem SHALL mengembalikan seluruh keadaan seperti sebelum perintah dijalankan: program lama tetap berjalan dan program baru tidak pernah ada.

#### Scenario: Pergantian berhasil

- **WHEN** pengguna menyetujui program pengganti
- **THEN** program lama berstatus `changed` dengan waktu berakhir dan tautan ke program baru, program baru berstatus `active` dengan tautan ke program lama, dan peristiwa pergantian tercatat

#### Scenario: Pergantian gagal di tengah jalan

- **WHEN** proses pergantian gagal setelah program lama ditandai tetapi sebelum program baru aktif
- **THEN** program lama kembali berstatus seperti semula dan program baru tidak ada, sehingga profil tetap memiliki tepat satu program berjalan

#### Scenario: Pembatalan sebelum konfirmasi

- **WHEN** pengguna membuka pratinjau pergantian lalu membatalkannya
- **THEN** tidak ada yang berubah: program lama tetap berjalan dengan target dan riwayat yang sama

### Requirement: Jeda dan lanjutkan

Menjeda program SHALL mencatat waktu mulai jeda beserta peristiwanya, dan SHALL menghentikan penambahan hari aktif serta perhitungan kesesuaian target selama jeda berlangsung. Pencatatan makanan dan berat badan SHALL tetap tersedia sepenuhnya selama program dijeda.

Melanjutkan program SHALL mengembalikan keadaan ke `active` dan mencatat peristiwanya. Rentang waktu jeda SHALL tetap dapat ditelusuri setelah program dilanjutkan.

#### Scenario: Hari jeda tidak dihitung

- **WHEN** sebuah program dijeda selama tiga hari lalu dilanjutkan
- **THEN** ketiga hari itu tidak menambah jumlah hari aktif program dan tidak diperhitungkan dalam kesesuaian target

#### Scenario: Pencatatan tetap jalan saat dijeda

- **WHEN** program berstatus `paused` dan pengguna mencatat makanan serta berat badan
- **THEN** kedua catatan tersimpan seperti biasa dan dapat dilihat kembali

### Requirement: Selesaikan dan batalkan

Menyelesaikan program SHALL mencatat alasan selesai, menyimpan ringkasan akhir berdasarkan data yang tersedia, dan memindahkan program ke keadaan `completed`. Program yang selesai SHALL TIDAK dapat dilanjutkan, dan pengguna SHALL dapat memulai program baru sesudahnya.

Membatalkan program yang masih `draft` SHALL TIDAK mengubah program yang sedang berjalan maupun data apa pun.

Seluruh data makanan dan berat badan SHALL tetap utuh pada setiap perpindahan keadaan.

#### Scenario: Program diselesaikan

- **WHEN** pengguna menyelesaikan program aktif dengan alasan yang dipilih
- **THEN** program berstatus `completed` dengan alasan dan ringkasan akhir tersimpan, dan pengguna dapat memilih program baru

#### Scenario: Riwayat makanan tidak terpengaruh

- **WHEN** sebuah program diselesaikan, diganti, atau dibatalkan
- **THEN** seluruh catatan makanan dan berat badan tetap ada dan tidak berpindah kepemilikan ke program lain

### Requirement: Jejak peristiwa siklus hidup

Setiap perpindahan keadaan SHALL mencatat peristiwa yang memuat jenis peristiwa, waktu kejadian, keadaan asal, keadaan tujuan, dan kode alasan bila ada. Jejak peristiwa SHALL cukup untuk menjelaskan kapan sebuah program dimulai, dijeda, dilanjutkan, diganti, atau diselesaikan, serta berapa lama setiap jeda berlangsung.

#### Scenario: Menjelaskan perjalanan program

- **WHEN** pengguna membuka detail sebuah program di riwayat
- **THEN** sistem dapat menunjukkan urutan peristiwa program itu beserta waktunya, termasuk setiap rentang jeda

### Requirement: Perintah berulang bersifat idempoten

Perintah siklus hidup yang diulang dengan maksud yang sama SHALL TIDAK menghasilkan keadaan ganda atau peristiwa ganda. Menjeda program yang sudah dijeda, melanjutkan program yang sudah berjalan, atau menyelesaikan program yang sudah selesai SHALL mengembalikan hasil yang menyatakan keadaan sudah sesuai, tanpa mengubah apa pun dan tanpa menimbulkan kesalahan yang membingungkan pengguna.

#### Scenario: Jeda dikirim dua kali

- **WHEN** perintah jeda dikirim untuk program yang sudah berstatus `paused`
- **THEN** sistem menyatakan program memang sudah dijeda, tidak mencatat peristiwa kedua, dan tidak mengubah waktu mulai jeda

### Requirement: Program berjalan menyimpan dasar perhitungannya

Setiap program yang diaktifkan SHALL menyimpan salinan masukan yang dipakai saat perhitungan, nilai target yang disetujui, asumsi dan peringatan yang ditampilkan, versi kalkulator, dan versi kebijakan. Nilai-nilai ini SHALL TIDAK berubah oleh pembaruan kebijakan, pembaruan katalog, atau perubahan profil di kemudian hari.

#### Scenario: Menjelaskan target lama

- **WHEN** pengguna membuka program yang sudah selesai beberapa bulan lalu
- **THEN** sistem menampilkan masukan, target, asumsi, dan versi seperti saat program itu disetujui
