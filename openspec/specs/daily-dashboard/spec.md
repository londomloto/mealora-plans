# daily-dashboard Specification

## Purpose
Ringkasan sebuah hari bagi pengguna: berapa energi yang sudah tercatat, berapa sisa perkiraannya terhadap target, bagaimana kemajuan zat gizi makro, dan apa saja yang tercatat pada tiap waktu makan — termasuk cara menyampaikan hari yang belum dicatat tanpa membuatnya tampak seperti kegagalan.

## Requirements

### Requirement: Ringkasan harian menampilkan konsumsi, target, dan sisa

Ruang Hari ini SHALL menampilkan energi yang sudah tercatat pada hari itu, target energi harian yang berlaku bila ada, sisa perkiraan, kemajuan protein, karbohidrat, dan lemak terhadap targetnya, serta daftar waktu makan beserta energi masing-masing.

Seluruh nilai SHALL diberi label perkiraan. Sistem SHALL TIDAK menyajikannya sebagai hasil pengukuran atau penilaian atas pengguna.

#### Scenario: Hari dengan beberapa catatan

- **WHEN** pengguna telah mencatat beberapa makanan pada hari itu
- **THEN** ruang Hari ini menampilkan total energi tercatat, target, sisa perkiraan, kemajuan makro, dan daftar waktu makan beserta energinya

#### Scenario: Total berubah seketika

- **WHEN** pengguna menambah, menyunting, memindahkan, atau menghapus sebuah catatan
- **THEN** total energi, sisa, dan kemajuan makro pada ruang Hari ini menyesuaikan seketika tanpa perlu membuka ulang aplikasi

### Requirement: Hari tanpa catatan dinyatakan belum diketahui

Ketika sebuah hari belum memiliki catatan, sistem SHALL menyatakan konsumsi energi dan zat gizi sebagai belum diketahui. Sistem SHALL TIDAK menampilkan nol sebagai pengganti, dan SHALL TIDAK menandai hari itu sebagai target yang gagal.

#### Scenario: Hari yang belum dicatat

- **WHEN** pengguna membuka sebuah hari yang belum memiliki catatan
- **THEN** konsumsi tampil sebagai belum diketahui beserta ajakan mencatat, bukan 0 kkal dan bukan penanda gagal

#### Scenario: Hari yang baru sebagian dicatat

- **WHEN** pengguna baru mencatat sarapan pada hari itu
- **THEN** total yang tampil adalah total dari yang sudah tercatat, dan sistem tidak menyiratkan bahwa hari itu sudah lengkap

### Requirement: Keadaan tanpa target

Ketika tidak ada program berjalan atau kebijakan gizi tidak menghasilkan target, sistem SHALL tetap menampilkan konsumsi yang tercatat, dan SHALL menyatakan bahwa tidak ada target pembanding alih-alih menampilkan target nol atau target yang dikarang.

#### Scenario: Mencatat tanpa program berjalan

- **WHEN** pengguna mencatat makanan sementara tidak ada program yang berjalan
- **THEN** ruang Hari ini menampilkan total konsumsi tanpa sisa maupun persentase target, dan menyatakan bahwa belum ada target pembanding

### Requirement: Melampaui target bukan kegagalan

Ketika konsumsi melampaui target, sistem SHALL menyatakan keadaannya secara netral dan SHALL TIDAK memakai bahasa yang menyalahkan, menghukum, atau menilai pengguna.

Sisa perkiraan yang negatif SHALL disajikan sebagai kelebihan terhadap perkiraan, bukan sebagai pelanggaran.

#### Scenario: Konsumsi melampaui target

- **WHEN** energi tercatat melampaui target harian
- **THEN** sistem menyatakan kelebihannya secara netral tanpa bahasa yang menyalahkan pengguna

### Requirement: Pintu masuk pencatatan selalu tersedia

Ruang Hari ini SHALL menyediakan tindakan utama untuk mencatat makanan, dan tindakan itu SHALL membuka pilihan cara pencatatan.

Jalur pencarian katalog dan pembuatan makanan sendiri SHALL selalu tersedia, termasuk tanpa koneksi. Jalur yang memerlukan koneksi atau belum tersedia SHALL ditandai demikian, dan SHALL TIDAK tampil seolah-olah siap dipakai.

#### Scenario: Membuka pilihan pencatatan

- **WHEN** pengguna menekan tindakan catat makanan
- **THEN** sistem menampilkan pilihan cara pencatatan dengan jalur pencarian dan input manual yang tersedia

#### Scenario: Jalur yang belum tersedia

- **WHEN** sebuah jalur pencatatan belum tersedia pada versi ini
- **THEN** jalur itu ditandai belum tersedia dan tidak dapat dibuka, bukan membuka layar yang gagal

### Requirement: Ringkasan harian terhubung dengan kemajuan program

Ketika sebuah program berjalan, perubahan pada catatan makan SHALL tercermin pada potret kemajuan program untuk tanggal itu.

Hari dalam rentang jeda SHALL TIDAK menambah hitungan hari aktif maupun masuk ke perhitungan kesesuaian target, sementara catatannya tetap tersimpan dan tampil di buku harian.

#### Scenario: Catatan memperbarui kemajuan program

- **WHEN** pengguna mencatat makanan sementara sebuah program berjalan
- **THEN** potret kemajuan program untuk tanggal itu mencerminkan catatan tersebut

#### Scenario: Mencatat pada hari jeda

- **WHEN** pengguna mencatat makanan pada hari ketika program dijeda
- **THEN** catatan tampil di buku harian dan ringkasan hari itu, sementara hari tersebut tidak menambah hitungan hari aktif program

### Requirement: Ringkasan dapat diakses

Nilai dan kemajuan pada ringkasan harian SHALL dapat dibaca pembaca layar sebagai angka beserta maknanya, SHALL tetap terbaca utuh pada skala teks besar, dan SHALL TIDAK mengandalkan warna saja untuk menyampaikan keadaan.

#### Scenario: Pembaca layar membaca ringkasan

- **WHEN** pengguna menjelajah ruang Hari ini memakai pembaca layar
- **THEN** energi tercatat, target, sisa, dan kemajuan makro diumumkan beserta maknanya, bukan hanya sebagai angka lepas
