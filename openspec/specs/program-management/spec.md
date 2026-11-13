# program-management Specification

## Purpose
Apa yang dapat dilihat dan dilakukan pengguna terhadap programnya sendiri: keadaan program yang sedang berjalan, penjelasan dari mana targetnya berasal, kendali untuk menjeda, mengganti, dan menyelesaikan, riwayat program yang tetap dapat dijelaskan, serta persetujuan atas revisi target ketika data profil berubah.

## Requirements

### Requirement: Ruang Program menampilkan keadaan program yang berjalan

Ruang Program SHALL menampilkan nama program, keadaannya, target energi harian beserta label perkiraan, kemajuan yang berlaku bagi program tersebut, berat badan terbaru bila ada, tanggal perhitungan terakhir, serta kendali untuk menjeda, mengganti, dan membuka riwayat.

Nilai yang datanya belum ada SHALL ditampilkan sebagai belum diketahui. Sistem SHALL TIDAK menampilkan nol, grafik kosong tanpa keterangan, atau nilai yang dikarang sebagai pengganti data yang belum tersedia.

#### Scenario: Program aktif ditampilkan

- **WHEN** pengguna membuka ruang Program sementara satu program berjalan
- **THEN** sistem menampilkan nama program, keadaannya, target harian berlabel perkiraan, tanggal perhitungan terakhir, dan kendali jeda, ganti, serta riwayat

#### Scenario: Kemajuan belum memiliki data

- **WHEN** program baru saja diaktifkan dan belum ada catatan makanan maupun berat
- **THEN** kemajuan ditampilkan sebagai belum diketahui, bukan nol atau grafik kosong tanpa keterangan

#### Scenario: Program Makan Sehat

- **WHEN** program yang berjalan adalah Makan Sehat
- **THEN** kemajuan ditampilkan sebagai kelengkapan pencatatan, dan tidak ada persentase kemajuan berat di layar itu

### Requirement: Penjelasan asal-usul target tersedia untuk program yang berjalan

Sistem SHALL menyediakan rincian yang menjelaskan asal-usul target program yang sedang berjalan, memuat masukan yang dipakai saat perhitungan, tingkat aktivitas, asumsi, peringatan yang berlaku, tanggal perhitungan terakhir, versi kalkulator, dan versi kebijakan.

Rincian ini SHALL dapat dibuka dari ruang Program, dan SHALL menyajikan nilai sebagai perkiraan.

#### Scenario: Pengguna membuka penjelasan perhitungan

- **WHEN** pengguna membuka rincian "Bagaimana dihitung" dari ruang Program
- **THEN** sistem menampilkan masukan, tingkat aktivitas, asumsi, peringatan, tanggal perhitungan terakhir, serta kedua versi

#### Scenario: Peringatan ikut ditampilkan

- **WHEN** target yang berlaku dibuat dengan peringatan, misalnya batas bawah energi menaikkan target
- **THEN** peringatan itu tampil pada rincian penjelasan, bukan hanya pada saat pratinjau

### Requirement: Keadaan dijeda ditampilkan dan dibatasi dengan jelas

Ketika program berstatus dijeda, sistem SHALL menandai keadaan itu secara jelas tanpa bergantung pada warna saja, SHALL menyatakan sejak kapan dijeda, SHALL menyatakan bahwa hari jeda tidak dihitung sebagai hari aktif, dan SHALL menyatakan bahwa pencatatan makanan dan berat tetap tersedia.

Kendali yang tersedia pada keadaan ini SHALL berupa lanjutkan, ganti, dan selesaikan.

#### Scenario: Program dijeda

- **WHEN** pengguna membuka ruang Program sementara programnya dijeda
- **THEN** keadaan dijeda tampak jelas beserta tanggal mulai jeda, keterangan bahwa hari jeda tidak dihitung, keterangan bahwa pencatatan tetap jalan, dan kendali lanjutkan, ganti, serta selesaikan

#### Scenario: Mencatat saat dijeda

- **WHEN** pengguna mencatat makanan atau berat badan sementara program dijeda
- **THEN** catatan tersimpan seperti biasa dan hari itu tidak menambah hitungan hari aktif

### Requirement: Pergantian program ditinjau sebelum berlaku

Sebelum program diganti, sistem SHALL menampilkan pratinjau yang memuat program yang sedang berjalan, program pengganti beserta nilai targetnya, pernyataan bahwa program lama akan pindah ke riwayat, dan pernyataan bahwa catatan makanan serta berat badan tetap utuh.

Membatalkan pratinjau SHALL TIDAK mengubah apa pun. Menyetujui SHALL mengikuti aturan aktivasi yang berlaku, termasuk peninjauan ulang ketika masukan berubah sejak pratinjau.

#### Scenario: Pratinjau pergantian dibatalkan

- **WHEN** pengguna membuka pratinjau ganti program lalu membatalkannya
- **THEN** program lama tetap berjalan dengan target yang sama dan riwayat tidak bertambah

#### Scenario: Pergantian disetujui

- **WHEN** pengguna menyetujui program pengganti
- **THEN** program lama pindah ke riwayat dengan keadaan diganti, program baru berjalan, dan seluruh catatan makanan serta berat badan tetap ada

#### Scenario: Program pengganti tidak disetujui kebijakan

- **WHEN** kebijakan tidak menyetujui proposal program pengganti
- **THEN** sistem menjelaskan keadaannya tanpa menampilkan angka target, program lama tetap berjalan, dan tidak ada data yang berubah

### Requirement: Penyelesaian program memerlukan konfirmasi dan alasan

Sebelum program diselesaikan, sistem SHALL meminta pengguna memilih alasan selesai, SHALL menyatakan bahwa ringkasan akhir disimpan, SHALL menyatakan bahwa program yang selesai tidak dapat dilanjutkan, dan SHALL menyediakan jalan membatalkan yang tidak mengubah apa pun.

#### Scenario: Penyelesaian dibatalkan

- **WHEN** pengguna membuka layar selesaikan program lalu memilih tetap di program ini
- **THEN** program tetap berjalan tanpa perubahan apa pun

#### Scenario: Program diselesaikan

- **WHEN** pengguna memilih alasan dan menyelesaikan program
- **THEN** program berpindah ke riwayat dengan keadaan selesai beserta alasan dan ringkasan akhir, dan pengguna dapat memilih program baru

#### Scenario: Mencoba melanjutkan program yang selesai

- **WHEN** pengguna membuka program yang sudah selesai di riwayat
- **THEN** tidak ada kendali melanjutkan yang tersedia, dan sistem menjelaskan bahwa program selesai tidak dapat dilanjutkan

### Requirement: Riwayat program dapat ditelusuri dan dijelaskan

Sistem SHALL menampilkan seluruh program yang pernah dijalani pengguna berurutan menurut waktu, masing-masing beserta keadaan akhirnya dan rentang tanggal berjalannya.

Membuka salah satu entri SHALL menampilkan masukan, nilai target, asumsi, peringatan, versi kalkulator, versi kebijakan, alasan berakhir, dan kemajuan akhir yang tersedia — seluruhnya seperti saat program itu disetujui.

Sistem SHALL menyatakan bahwa riwayat program tidak mengubah catatan makanan dan berat badan yang pernah disimpan.

#### Scenario: Menelusuri riwayat

- **WHEN** pengguna membuka riwayat program setelah beberapa kali berganti program
- **THEN** seluruh program tampil berurutan beserta keadaan akhir dan rentang tanggalnya

#### Scenario: Membuka program lama

- **WHEN** pengguna membuka entri program yang selesai beberapa bulan sebelumnya
- **THEN** sistem menampilkan masukan, target, asumsi, dan versi seperti saat disetujui, meskipun kebijakan sudah diperbarui sejak itu

#### Scenario: Data kemajuan yang tidak lengkap pada program lama

- **WHEN** sebuah program lama tidak memiliki catatan berat pada hari terakhirnya
- **THEN** sistem menyatakan data itu belum ada, bukan menampilkan nol atau nilai terakhir yang diketahui seolah-olah itu nilai hari terakhir

### Requirement: Perubahan profil memerlukan persetujuan atas target baru

Ketika pengguna menyunting data profil, sistem SHALL menyatakan bahwa perubahan itu tidak langsung mengubah target yang berlaku, dan SHALL menawarkan peninjauan target baru.

Target hasil peninjauan SHALL berlaku hanya setelah pengguna menyetujuinya. Selama belum disetujui, target lama SHALL tetap berlaku dan riwayat SHALL TIDAK berubah.

Peninjauan target baru SHALL menampilkan nilai baru, dasar perhitungannya, asumsi, peringatan, dan kedua versi, sebagaimana pratinjau target pada onboarding.

#### Scenario: Profil disunting

- **WHEN** pengguna mengubah berat badan atau tingkat aktivitas pada profilnya
- **THEN** sistem menyatakan target yang berlaku tidak langsung berubah dan menawarkan peninjauan target baru

#### Scenario: Revisi target tidak disetujui

- **WHEN** pengguna membuka peninjauan target baru lalu menutupnya tanpa menyetujui
- **THEN** target lama tetap berlaku dan tidak ada nilai riwayat yang berubah

#### Scenario: Revisi target tidak disetujui kebijakan

- **WHEN** profil yang diperbarui membuat kebijakan tidak lagi menyetujui target otomatis
- **THEN** sistem menjelaskan keadaannya tanpa angka target, dan target lama tetap berlaku sampai pengguna mengambil tindakan

### Requirement: Keadaan khusus pada ruang Program

Sistem SHALL menyediakan keadaan yang dapat dibaca pengguna untuk: belum ada program berjalan, profil belum lengkap, belum ada catatan berat, dan kebijakan tidak tersedia.

Setiap keadaan SHALL menjelaskan apa yang terjadi dan tindakan apa yang tersedia, dan SHALL TIDAK menampilkan angka yang dikarang maupun nol sebagai pengganti data yang belum ada.

#### Scenario: Belum ada program

- **WHEN** pengguna membuka ruang Program tanpa program berjalan
- **THEN** sistem menampilkan ajakan memilih program beserta penegasan bahwa catatan lama tetap ada

#### Scenario: Belum ada catatan berat

- **WHEN** program berjalan tetapi belum ada satu pun catatan berat badan
- **THEN** bagian berat menyatakan belum ada catatan beserta tindakan untuk menambahkannya, bukan menampilkan 0 kg

### Requirement: Kendali program dapat diakses dan dapat dibaca pembaca layar

Seluruh kendali siklus hidup SHALL memiliki nama yang bermakna bagi pembaca layar, SHALL memiliki target sentuh yang memadai, dan SHALL tetap terbaca utuh pada skala teks besar. Keadaan program SHALL dapat dikenali tanpa bergantung pada warna saja.

#### Scenario: Pembaca layar pada ruang Program

- **WHEN** pengguna menjelajah ruang Program memakai pembaca layar
- **THEN** keadaan program dan setiap kendali diumumkan dengan nama yang bermakna

#### Scenario: Skala teks besar

- **WHEN** pengguna menaikkan skala teks perangkat ke tingkat besar
- **THEN** seluruh layar program, riwayat, dan detail tetap terbaca utuh tanpa teks terpotong atau kendali yang tidak terjangkau
