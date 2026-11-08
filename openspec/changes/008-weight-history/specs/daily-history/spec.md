## Purpose

Menelusuri hari-hari yang sudah lewat: memilih tanggal, membaca ringkasan gizi dan catatan makan hari itu, dan memahami hari yang tidak memiliki catatan — tanpa menjadikan hari kosong tampak seperti kegagalan.

## ADDED Requirements

### Requirement: Memilih tanggal dari kalender

Ruang Riwayat SHALL menampilkan kalender bulanan yang memungkinkan pengguna memilih tanggal dan berpindah antar bulan. Tanggal yang dipilih SHALL ditandai jelas tanpa bergantung pada warna saja.

Sistem SHALL TIDAK memungkinkan pemilihan tanggal di masa depan.

#### Scenario: Memilih tanggal sebelumnya

- **WHEN** pengguna memilih sebuah tanggal pada kalender
- **THEN** sistem menampilkan ringkasan dan catatan makan tanggal itu

#### Scenario: Tanggal di masa depan

- **WHEN** pengguna mencoba memilih tanggal di masa depan
- **THEN** tanggal itu tidak dapat dipilih

### Requirement: Hari yang memiliki catatan ditandai

Kalender SHALL menandai tanggal yang memiliki catatan makan, dan penandaan itu SHALL dapat dikenali tanpa bergantung pada warna saja.

Penandaan SHALL bersifat informatif, dan sistem SHALL TIDAK memakainya sebagai penilaian, nilai, atau peringkat atas pengguna.

#### Scenario: Membedakan hari tercatat dan tidak

- **WHEN** pengguna melihat kalender bulan berjalan
- **THEN** tanggal yang memiliki catatan dapat dibedakan dari yang tidak, tanpa penilaian atas hari yang kosong

### Requirement: Ringkasan tanggal terpilih

Untuk tanggal yang dipilih, sistem SHALL menampilkan energi yang tercatat, zat gizi makro yang tercatat, dan daftar catatan makan pada hari itu beserta waktu makannya.

Sistem SHALL menampilkan berat badan yang tercatat pada tanggal itu bila ada.

Seluruh nilai SHALL diberi label perkiraan.

#### Scenario: Tanggal dengan catatan

- **WHEN** pengguna memilih tanggal yang memiliki beberapa catatan makan
- **THEN** sistem menampilkan total energi, zat gizi makro, dan daftar catatan beserta waktu makannya

#### Scenario: Berat tercatat pada tanggal itu

- **WHEN** pengguna memilih tanggal yang juga memiliki catatan berat
- **THEN** berat itu ditampilkan bersama ringkasan hari tersebut

### Requirement: Hari tanpa catatan dinyatakan belum diketahui

Ketika tanggal yang dipilih tidak memiliki catatan, sistem SHALL menyatakan konsumsi sebagai belum diketahui. Sistem SHALL TIDAK menampilkan nol sebagai pengganti dan SHALL TIDAK menandai hari itu sebagai hari yang gagal, terlewat, atau rusak.

Sistem SHALL menyediakan tindakan untuk mencatat pada tanggal tersebut bila tanggal itu masih dapat dicatat.

#### Scenario: Tanggal kosong dipilih

- **WHEN** pengguna memilih tanggal yang tidak memiliki catatan
- **THEN** sistem menyatakan hari itu belum tercatat dengan konsumsi belum diketahui, bukan 0 kkal, dan tidak menandainya sebagai gagal

#### Scenario: Hari yang hanya sebagian tercatat

- **WHEN** tanggal yang dipilih hanya memiliki catatan sarapan
- **THEN** sistem menampilkan total dari yang tercatat tanpa menyiratkan hari itu sudah lengkap

### Requirement: Nilai riwayat tidak berubah di kemudian hari

Ringkasan sebuah tanggal SHALL dihitung dari nilai yang dibekukan pada catatan hari itu. Pembaruan katalog makanan, penyuntingan makanan buatan pengguna, perubahan profil, dan perubahan program SHALL TIDAK mengubah ringkasan hari yang sudah lewat.

Tanggal sebuah catatan SHALL tetap seperti saat dicatat meskipun zona waktu perangkat berubah.

#### Scenario: Katalog diperbarui

- **WHEN** nilai gizi sebuah makanan di katalog diperbarui setelah dicatat
- **THEN** ringkasan hari ketika makanan itu dicatat tidak berubah

#### Scenario: Program diganti

- **WHEN** pengguna mengganti program setelah beberapa minggu mencatat
- **THEN** ringkasan hari-hari sebelumnya tetap sama dan catatan makannya tidak berpindah

#### Scenario: Zona waktu berubah

- **WHEN** pengguna berpindah zona waktu
- **THEN** catatan lama tetap berada pada tanggal yang sama seperti saat dicatat

### Requirement: Menyunting catatan dari riwayat

Sistem SHALL memungkinkan pengguna membuka dan menyunting catatan makan pada tanggal sebelumnya dengan aturan yang sama seperti pada hari berjalan, dan ringkasan tanggal itu SHALL menyesuaikan segera.

Perubahan pada tanggal sebelumnya SHALL tercermin pada potret kemajuan program untuk tanggal tersebut.

#### Scenario: Menyunting catatan lama

- **WHEN** pengguna menyunting sebuah catatan pada tanggal minggu lalu
- **THEN** ringkasan tanggal itu menyesuaikan dan potret kemajuan program untuk tanggal itu ikut diperbarui

### Requirement: Riwayat tidak memberi penilaian

Sistem SHALL menyajikan riwayat sebagai catatan perjalanan, dan SHALL TIDAK memakai skor harian, peringkat, rangkaian hari berturut-turut sebagai penilaian, maupun bahasa yang menyalahkan pengguna atas hari yang kosong atau melampaui target.

#### Scenario: Bahasa riwayat diperiksa

- **WHEN** pengguna menelusuri beberapa tanggal termasuk hari kosong dan hari yang melampaui target
- **THEN** tidak ada teks yang menilai, menyalahkan, atau menghukum pengguna

### Requirement: Riwayat dapat diakses

Kalender, ringkasan, dan daftar catatan SHALL dapat dijelajahi pembaca layar dengan nama yang bermakna, SHALL tetap terbaca utuh pada skala teks besar, dan SHALL TIDAK menyampaikan keadaan lewat warna saja.

#### Scenario: Pembaca layar pada kalender

- **WHEN** pengguna menjelajah kalender memakai pembaca layar
- **THEN** setiap tanggal diumumkan beserta keterangan apakah hari itu memiliki catatan dan apakah sedang terpilih
