# weight-tracking Specification

## Purpose
Pencatatan berat badan pengguna sepanjang waktu: menambah, menyunting, dan menghapus catatan, melihat berat terbaru beserta arah perubahannya, dan bagaimana catatan itu memengaruhi program yang sedang berjalan — tanpa menjadikan angka berat sebagai penilaian atas pengguna.

## Requirements

### Requirement: Mencatat berat badan tanpa koneksi

Sistem SHALL memungkinkan pengguna mencatat berat badan beserta tanggal catatannya dan catatan bebas opsional, sepenuhnya tanpa koneksi jaringan, dan SHALL menyimpannya di perangkat seketika.

Sistem SHALL menyatakan bahwa catatan berat hanya tersimpan di perangkat.

#### Scenario: Mencatat berat dalam mode pesawat

- **WHEN** pengguna menyimpan catatan berat dengan koneksi dimatikan
- **THEN** catatan tersimpan dan tampil pada daftar catatan tanpa pesan kesalahan jaringan

#### Scenario: Catatan bebas dikosongkan

- **WHEN** pengguna menyimpan berat tanpa mengisi catatan bebas
- **THEN** catatan tersimpan tanpa keterangan tambahan

### Requirement: Pencatatan berat tidak diwajibkan setiap hari

Sistem SHALL memungkinkan pencatatan berat pada frekuensi mana pun yang dipilih pengguna, dan SHALL TIDAK menandai hari tanpa catatan berat sebagai kegagalan, kelalaian, atau pelanggaran.

#### Scenario: Beberapa hari tanpa catatan berat

- **WHEN** pengguna tidak mencatat berat selama beberapa hari
- **THEN** sistem tidak menampilkan penanda kegagalan maupun teguran atas hari-hari itu

### Requirement: Nilai berat yang tidak masuk akal ditolak

Sistem SHALL menolak nilai berat yang mustahil atau di luar rentang yang masuk akal, dan SHALL menjelaskan rentang yang diterima. Sistem SHALL menyimpan berat dalam kilogram sebagai satuan kanonis.

Sistem SHALL menolak tanggal catatan di masa depan.

#### Scenario: Nilai berat mustahil

- **WHEN** pengguna memasukkan berat 0 kg atau nilai negatif
- **THEN** sistem menolak dengan penjelasan dan tidak menyimpan catatan

#### Scenario: Tanggal di masa depan

- **WHEN** pengguna memilih tanggal catatan di masa depan
- **THEN** sistem menolak dengan penjelasan dan tidak menyimpan catatan

### Requirement: Menyunting dan menghapus catatan berat

Sistem SHALL memungkinkan pengguna menyunting nilai, tanggal, dan catatan bebas pada sebuah catatan berat, serta menghapus catatan tersebut.

Penyuntingan dan penghapusan SHALL berlaku hanya pada catatan itu, dan SHALL memperbarui berat terbaru, tren, serta kemajuan program yang terpengaruh.

#### Scenario: Memperbaiki salah ketik

- **WHEN** pengguna menyunting sebuah catatan berat yang salah ketik
- **THEN** nilai berat terbaru, tren, dan kemajuan program yang terpengaruh menyesuaikan

#### Scenario: Menghapus catatan berat

- **WHEN** pengguna menghapus catatan berat terakhirnya
- **THEN** berat terbaru kembali menunjuk pada catatan sebelumnya, atau dinyatakan belum ada bila tidak ada catatan lain

### Requirement: Berat terbaru dan arah perubahan

Sistem SHALL menampilkan berat terbaru beserta tanggalnya, dan SHALL menampilkan perubahan terhadap berat awal program ketika sebuah program dengan berat awal sedang berjalan atau pernah berjalan.

Perubahan SHALL disajikan sebagai arah dan besaran apa adanya, tanpa penilaian atas pengguna.

#### Scenario: Berat terbaru tampil

- **WHEN** pengguna membuka pemantauan berat setelah beberapa catatan
- **THEN** sistem menampilkan berat terbaru beserta tanggalnya dan perubahannya terhadap berat awal program bila berlaku

#### Scenario: Belum ada catatan berat

- **WHEN** pengguna membuka pemantauan berat sebelum pernah mencatat
- **THEN** sistem menyatakan belum ada catatan beserta tindakan untuk menambahkannya, bukan menampilkan 0 kg atau grafik kosong tanpa keterangan

#### Scenario: Program tanpa berat awal

- **WHEN** program yang berjalan tidak memakai berat awal, misalnya Makan Sehat
- **THEN** sistem menampilkan berat terbaru tanpa perbandingan terhadap berat awal program

### Requirement: Tren berat menampilkan tujuh jalur, diisi dari catatan terakhir apa adanya

Sistem SHALL menampilkan tren berat sebagai tujuh jalur (track) tetap, berjarak sama tanpa memperhitungkan selisih hari sebenarnya antar catatan — bukan rentang kalender. Jalur diisi dari kiri, berurutan dari catatan terlama ke terbaru. Bila catatan yang ada belum sampai tujuh, jalur di sisi kanan (mewakili catatan yang belum ada) SHALL tampak kosong/netral — tidak diisi nilai yang dikarang, nilai sebelumnya, maupun nol. Setiap jalur yang terisi SHALL mewakili satu catatan asli.

Konsekuensi yang disadari: selisih waktu antara dua catatan yang berjauhan (tapi sama-sama sudah tercatat) SHALL TIDAK tampak sebagai celah pada grafik ini — hanya kekosongan di sisi kanan (karena catatan belum sebanyak tujuh) yang tampak kosong. Ini berbeda dari ruang Riwayat (lihat spec `daily-history`), yang tetap menyatakan hari tanpa catatan secara eksplisit sebagai ketiadaan data.

Sistem SHALL TIDAK menampilkan proyeksi kapan berat tertentu akan tercapai.

#### Scenario: Catatan terlalu sedikit untuk tren

- **WHEN** hanya ada satu catatan berat
- **THEN** sistem menampilkan catatan itu dan menyatakan tren belum dapat ditampilkan, bukan menggambar tren dari satu titik

#### Scenario: Kurang dari tujuh catatan

- **WHEN** pengguna punya antara dua sampai enam catatan berat
- **THEN** grafik tetap menampilkan tujuh jalur; jalur di sisi kanan yang belum ada catatannya tampak kosong/netral, dan jalur sisanya (dari kiri) berisi catatan yang ada apa adanya

#### Scenario: Label indeks jalur tren dibacakan bermakna

- **WHEN** pembaca layar mengumumkan sebuah jalur tren berisi catatan, yang berlabel visual indeks urutan
- **THEN** yang diumumkan adalah tanggal dan berat catatan sebenarnya pada jalur itu, bukan angka indeks lepas

- **WHEN** pembaca layar mengumumkan sebuah jalur tren yang masih kosong
- **THEN** yang diumumkan menyatakan belum ada catatan, bukan angka indeks lepas maupun nilai yang dikarang

### Requirement: Catatan berat memperbarui kemajuan program

Ketika sebuah program berjalan, penambahan, penyuntingan, dan penghapusan catatan berat SHALL tercermin pada potret kemajuan program untuk tanggal yang bersangkutan.

Ketika perubahan berat melewati ambang hitung ulang yang ditetapkan kebijakan, sistem SHALL mengusulkan peninjauan target baru. Target baru SHALL TIDAK berlaku sebelum pengguna menyetujuinya.

#### Scenario: Berat baru memperbarui kemajuan

- **WHEN** pengguna mencatat berat sementara sebuah program berjalan
- **THEN** potret kemajuan program untuk tanggal itu mencerminkan berat tersebut

#### Scenario: Perubahan berat melewati ambang

- **WHEN** berat terbaru berbeda dari berat yang dipakai target yang berlaku melebihi ambang kebijakan
- **THEN** sistem mengusulkan peninjauan target baru, sementara target lama tetap berlaku sampai pengguna menyetujui

### Requirement: Bahasa pemantauan berat tidak menghakimi

Teks pada pencatatan dan pemantauan berat SHALL menyajikan angka sebagai catatan, bukan sebagai nilai diri pengguna. Sistem SHALL TIDAK memakai pujian atas penurunan berat, teguran atas kenaikan berat, maupun istilah yang menilai tubuh pengguna.

#### Scenario: Berat naik dari catatan sebelumnya

- **WHEN** catatan berat terbaru lebih tinggi daripada sebelumnya
- **THEN** sistem menyajikan perubahannya secara netral tanpa teguran, peringatan, atau penanda negatif

### Requirement: Data berat tidak meninggalkan perangkat

Sistem SHALL menyimpan seluruh catatan berat di perangkat, SHALL TIDAK mengirimkannya ke layanan mana pun, dan SHALL menyertakannya ketika pengguna menghapus seluruh data lokal.

#### Scenario: Penghapusan data lokal

- **WHEN** pengguna menghapus seluruh data lokal
- **THEN** seluruh catatan berat ikut terhapus
