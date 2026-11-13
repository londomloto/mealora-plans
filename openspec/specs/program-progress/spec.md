# program-progress Specification

## Purpose
Ketahanan dan kemajuan program di perangkat: program beserta targetnya bertahan melewati penutupan aplikasi, kemajuan tercatat per tanggal lokal dan dapat dibangun ulang tanpa menggandakan nilai, riwayat program tetap dapat dijelaskan dengan nilai aslinya, dan hari yang datanya belum ada ditampilkan sebagai belum diketahui alih-alih nol.

## Requirements

### Requirement: Program bertahan melewati penutupan aplikasi

Program yang diaktifkan pengguna beserta target, asumsi, peringatan, salinan masukan, dan versinya SHALL tetap ada setelah aplikasi ditutup sepenuhnya dan dibuka kembali, tanpa koneksi jaringan. Keadaan siklus hidup terakhir SHALL dipulihkan apa adanya, termasuk keadaan dijeda beserta waktu mulai jedanya.

#### Scenario: Program aktif setelah aplikasi dibuka kembali

- **WHEN** pengguna mengaktifkan sebuah program, menutup aplikasi sepenuhnya, lalu membukanya kembali dalam mode pesawat
- **THEN** program yang sama tampil sebagai program berjalan dengan target, asumsi, dan versi yang sama persis

#### Scenario: Program dijeda setelah aplikasi dibuka kembali

- **WHEN** pengguna menjeda program lalu menutup dan membuka kembali aplikasi
- **THEN** program tetap berstatus dijeda dengan waktu mulai jeda yang sama, dan pencatatan makanan serta berat tetap tersedia

### Requirement: Satu program berjalan ditegakkan di penyimpanan

Penyimpanan SHALL menolak keadaan yang memuat lebih dari satu program berstatus `active` atau lebih dari satu program berstatus `paused` untuk satu profil, terlepas dari jalur mana perintah itu datang. Penolakan SHALL berupa kegagalan bertipe yang tidak meninggalkan perubahan sebagian.

#### Scenario: Percobaan menyimpan dua program aktif

- **WHEN** sebuah penulisan mencoba menjadikan program kedua `active` sementara satu program `active` masih ada
- **THEN** penulisan ditolak, tidak ada perubahan yang tersimpan, dan profil tetap memiliki tepat satu program berjalan

#### Scenario: Perintah aktivasi yang diulang

- **WHEN** perintah aktivasi yang sama dijalankan dua kali berturut-turut
- **THEN** hanya ada satu program berjalan dan tidak ada baris program ganda yang tersimpan

### Requirement: Aktivasi dan pergantian tersimpan secara utuh

Aktivasi program SHALL menulis seluruh akibatnya sebagai satu kesatuan: program baru aktif, program lama yang sedang berjalan ditandai `changed` beserta waktu berakhir dan tautan dua arah, peristiwa siklus hidup tersisip, dan potret progres awal terbentuk.

Kegagalan pada langkah mana pun SHALL membatalkan seluruh perubahan. Setelah kegagalan, keadaan tersimpan SHALL sama persis seperti sebelum perintah dijalankan.

#### Scenario: Kegagalan di tengah pergantian

- **WHEN** penulisan pergantian gagal setelah program lama ditandai tetapi sebelum program baru tersimpan
- **THEN** program lama kembali berjalan seperti semula, program baru tidak ada, dan tidak ada peristiwa yang tersisip

#### Scenario: Riwayat makanan tidak tersentuh

- **WHEN** sebuah pergantian program tersimpan
- **THEN** seluruh catatan makanan dan berat badan tetap ada dengan kepemilikan dan nilai yang sama

### Requirement: Potret kemajuan per tanggal lokal

Sistem SHALL menyimpan kemajuan program sebagai potret per tanggal lokal, memuat sekurang-kurangnya: berat badan bila ada, perubahan berat terhadap berat awal program bila berlaku, energi yang tercatat bila ada, kesesuaian terhadap target bila dapat dihitung, jumlah waktu makan yang tercatat, penanda kelengkapan buku harian, dan nomor hari aktif program.

Tanggal lokal yang dipakai pengelompokan SHALL tetap seperti saat dicatat meskipun zona waktu perangkat berubah di kemudian hari.

Catatan makanan dan berat badan SHALL tetap menjadi sumber kebenaran; potret kemajuan SHALL merupakan turunan yang dapat dibangun ulang kapan saja.

#### Scenario: Kemajuan tersimpan per hari

- **WHEN** pengguna mencatat makanan pada sebuah tanggal
- **THEN** potret kemajuan untuk tanggal itu memuat energi yang tercatat, jumlah waktu makan, dan nomor hari aktif program

#### Scenario: Zona waktu berubah

- **WHEN** pengguna berpindah zona waktu setelah beberapa hari mencatat
- **THEN** potret kemajuan hari-hari sebelumnya tetap berada pada tanggal lokal yang sama seperti saat dicatat

### Requirement: Pembangunan ulang kemajuan bersifat idempoten

Membangun ulang kemajuan untuk sebuah tanggal SHALL menghasilkan satu potret untuk tanggal itu, berapa kali pun pembangunan ulang dijalankan. Nilai SHALL TIDAK terakumulasi atau tergandakan, dan potret hasil pembangunan ulang SHALL mencerminkan catatan terkini pada saat itu.

#### Scenario: Pembangunan ulang dijalankan berkali-kali

- **WHEN** kemajuan untuk satu tanggal dibangun ulang tiga kali berturut-turut
- **THEN** hanya ada satu potret untuk tanggal itu dan nilainya sama seperti sesudah pembangunan ulang pertama

#### Scenario: Catatan berubah setelah potret dibuat

- **WHEN** pengguna menyunting sebuah catatan makanan pada tanggal yang potretnya sudah ada, lalu kemajuan dibangun ulang
- **THEN** potret tanggal itu mencerminkan nilai terbaru tanpa menggandakan nilai sebelumnya

### Requirement: Hari tanpa data tetap "belum diketahui"

Ketika buku harian sebuah tanggal kosong atau tidak lengkap, sistem SHALL menandai nilai yang bersangkutan sebagai belum diketahui. Sistem SHALL TIDAK menyimpan atau menampilkan nol sebagai pengganti data yang belum ada, dan SHALL TIDAK memperlakukan hari seperti itu sebagai kegagalan memenuhi target.

#### Scenario: Hari tanpa catatan

- **WHEN** pengguna membuka sebuah tanggal yang belum memiliki catatan makanan
- **THEN** konsumsi energi dan zat gizi ditampilkan sebagai belum diketahui, bukan 0 kkal, dan hari itu tidak dihitung sebagai target yang gagal

#### Scenario: Hari dalam keadaan jeda

- **WHEN** sebuah tanggal berada dalam rentang jeda program
- **THEN** tanggal itu tidak menambah nomor hari aktif dan tidak ikut dalam perhitungan kesesuaian target, sementara catatan makanan pada tanggal itu tetap tersimpan dan dapat dilihat

### Requirement: Riwayat program dapat dijelaskan

Sistem SHALL menyimpan seluruh program yang pernah dijalani pengguna beserta keadaan akhirnya, dan SHALL dapat menampilkannya berurutan menurut waktu. Setiap entri riwayat SHALL memuat masukan, nilai target, asumsi, peringatan, versi kalkulator, versi kebijakan, alasan berakhir, serta rentang tanggal berjalannya.

Nilai pada entri riwayat SHALL TIDAK berubah akibat pembaruan kebijakan, pembaruan katalog, perubahan profil, maupun aktivasi program baru.

#### Scenario: Membuka program lama

- **WHEN** pengguna membuka sebuah program yang selesai beberapa bulan sebelumnya
- **THEN** sistem menampilkan masukan, target, asumsi, dan versi seperti saat program itu disetujui

#### Scenario: Urutan riwayat

- **WHEN** pengguna membuka riwayat program setelah beberapa kali berganti program
- **THEN** seluruh program tampil berurutan menurut waktu beserta keadaan akhir masing-masing, tanpa ada yang hilang

### Requirement: Peningkatan versi penyimpanan tidak mendaftarkan pengguna secara otomatis

Ketika struktur penyimpanan ditingkatkan untuk mendukung program, sistem SHALL mempertahankan seluruh data yang sudah ada — profil, catatan makanan, makanan buatan pengguna, favorit, dan riwayat berat — dan SHALL TIDAK mendaftarkan profil yang sudah ada ke program mana pun.

Setelah peningkatan versi, sistem SHALL menawarkan pemilihan program tanpa menghalangi akses ke data lama.

#### Scenario: Pengguna lama setelah peningkatan versi

- **WHEN** aplikasi dengan data lama dibuka setelah struktur penyimpanan ditingkatkan
- **THEN** seluruh catatan lama tetap ada dan dapat dibuka, tidak ada program yang aktif, dan pengguna diajak memilih program

#### Scenario: Peningkatan versi terputus

- **WHEN** peningkatan struktur penyimpanan terganggu sebelum selesai
- **THEN** data pengguna tidak rusak atau tersimpan sebagian, dan percobaan berikutnya menyelesaikan peningkatan dari keadaan yang konsisten

### Requirement: Target lama hasil konversi memerlukan konfirmasi

Bila sebuah target gizi lama dikonversi menjadi program, sistem SHALL meminta pengguna meninjau dan mengonfirmasinya lebih dulu, SHALL mencatat asal-usulnya sebagai hasil konversi yang dikonfirmasi, dan SHALL menyimpan salinan nilai aslinya.

#### Scenario: Konversi tanpa konfirmasi

- **WHEN** sebuah target lama tersedia untuk dikonversi dan pengguna belum mengonfirmasinya
- **THEN** tidak ada program yang aktif dan target lama tetap tersimpan tanpa perubahan
