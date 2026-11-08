## Purpose

Data diri yang dipakai Mealora untuk memperkirakan kebutuhan energi seseorang: apa yang wajib, apa yang opsional, bagaimana data itu disimpan di perangkat, dan bagaimana perubahannya diperlakukan terhadap target yang sedang berjalan.

## ADDED Requirements

### Requirement: Profil lokal tanpa akun

Sistem SHALL menyimpan satu profil lokal per perangkat tanpa pendaftaran, login, maupun koneksi jaringan. Profil SHALL memiliki pengenal unik global meskipun hanya ada satu profil, dan SHALL tersimpan mengikuti konvensi record pengguna yang berlaku.

#### Scenario: Profil dibuat tanpa akun

- **WHEN** pengguna menyelesaikan pengisian profil pada pemasangan baru dalam mode pesawat
- **THEN** profil tersimpan di perangkat tanpa diminta mendaftar atau masuk, dan tetap ada setelah aplikasi ditutup dan dibuka kembali

### Requirement: Masukan profil yang wajib dan yang opsional

Sistem SHALL meminta data berikut sebagai masukan wajib: tanggal lahir, tinggi badan, berat badan saat ini, masukan biologis yang dipakai persamaan energi, dan tingkat aktivitas. Nama panggilan SHALL bersifat opsional.

Sistem SHALL menolak nilai yang mustahil atau di luar rentang yang masuk akal, dan SHALL menjelaskan nilai mana yang bermasalah beserta rentang yang diterima. Sistem SHALL TIDAK melanjutkan ke langkah berikutnya selama masukan wajib pada langkah itu belum sah.

#### Scenario: Nama panggilan dilewati

- **WHEN** pengguna mengosongkan nama panggilan dan melanjutkan
- **THEN** sistem menerima dan melanjutkan ke langkah berikutnya

#### Scenario: Tinggi badan tidak masuk akal

- **WHEN** pengguna memasukkan tinggi badan 15 cm
- **THEN** sistem menolak nilai tersebut, menjelaskan rentang yang diterima, dan tidak melanjutkan

#### Scenario: Masukan wajib dikosongkan

- **WHEN** pengguna mencoba melanjutkan tanpa mengisi berat badan
- **THEN** sistem menahan langkah tersebut dan menandai bahwa berat badan belum diisi

### Requirement: Masukan biologis dijelaskan maksudnya

Sistem SHALL menyatakan bahwa masukan biologis diminta semata-mata karena persamaan energi yang dipakai membedakannya, dan SHALL TIDAK menyajikannya sebagai identitas gender pengguna.

#### Scenario: Keterangan ditampilkan bersama isian

- **WHEN** pengguna melihat isian masukan biologis
- **THEN** keterangan yang menyatakan bahwa nilai itu dipakai hanya untuk persamaan estimasi energi tampil bersamanya

### Requirement: Tingkat aktivitas dipilih dari tiga pilihan yang dijelaskan

Sistem SHALL menawarkan tepat tiga tingkat aktivitas, masing-masing dengan penjelasan dalam bahasa sehari-hari, dan SHALL menyatakan bahwa pilihan itu memengaruhi perkiraan serta dapat diubah di kemudian hari.

#### Scenario: Pengguna memilih tingkat aktivitas

- **WHEN** pengguna membuka pemilihan tingkat aktivitas
- **THEN** tiga pilihan tampil beserta penjelasan masing-masing, dan keterangan bahwa pilihan ini memengaruhi perkiraan dan dapat diubah kemudian

### Requirement: Satuan kanonis dan tampilan

Sistem SHALL menyimpan tinggi badan dalam sentimeter dan berat badan dalam kilogram sebagai satuan kanonis. Perubahan satuan tampilan SHALL TIDAK mengubah nilai tersimpan maupun nilai pada target yang sudah disetujui.

#### Scenario: Satuan tampilan diubah

- **WHEN** pengguna mengubah satuan tampilan
- **THEN** nilai tersimpan tidak berubah dan target yang sudah disetujui tetap menunjukkan angka yang setara

### Requirement: Perubahan profil tidak mengubah target yang berjalan

Sistem SHALL membiarkan target program yang sedang berjalan tetap berlaku ketika data profil diubah. Sistem SHALL mengusulkan peninjauan target baru sesuai aturan hitung ulang yang berlaku, dan target baru SHALL TIDAK berlaku sebelum pengguna menyetujuinya.

#### Scenario: Pengguna menyunting berat badan

- **WHEN** pengguna mengubah berat badan pada profilnya sementara sebuah program sedang berjalan
- **THEN** target yang berlaku tidak berubah, dan sistem menawarkan peninjauan target baru yang harus disetujui lebih dulu

#### Scenario: Pengguna menolak target baru

- **WHEN** sistem menawarkan target hasil peninjauan dan pengguna tidak menyetujuinya
- **THEN** target lama tetap berlaku dan tidak ada nilai riwayat yang berubah

### Requirement: Data profil tidak meninggalkan perangkat

Sistem SHALL menyimpan seluruh data profil di perangkat, SHALL TIDAK mengirimkannya ke layanan mana pun, dan SHALL menyertakan data profil ketika pengguna menghapus seluruh data lokal.

#### Scenario: Penghapusan data lokal

- **WHEN** pengguna menghapus seluruh data lokal
- **THEN** data profil ikut terhapus bersama data lainnya
