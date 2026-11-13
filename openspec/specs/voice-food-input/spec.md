# voice-food-input Specification

## Purpose
Mencatat makanan dengan berbicara: merekam ucapan, mengubahnya menjadi teks yang dapat disunting pengguna, menguraikan teks itu menjadi komponen makanan beserta jumlahnya, lalu mencatatnya lewat jalur buku harian yang sama dengan makanan lain — dengan nilai gizi yang selalu berasal dari catatan makanan yang dapat ditelusuri.

## Requirements

### Requirement: Suara hanya dipakai untuk mencatat makanan

Jalur suara SHALL terbatas pada pencatatan apa yang dimakan pengguna. Sistem SHALL TIDAK menyediakan masukan suara untuk fungsi lain mana pun, termasuk pencatatan berat badan, pengelolaan program, penyuntingan profil, pengaturan, maupun navigasi aplikasi.

Sistem SHALL menguraikan ucapan hanya sebagai daftar makanan beserta jumlah dan satuannya. Ucapan yang berisi perintah atau permintaan di luar pencatatan makanan SHALL TIDAK dijalankan; sistem SHALL menyatakan bahwa jalur suara hanya untuk mencatat makanan dan SHALL mengarahkan pengguna ke tempat yang tepat.

Mikrofon SHALL diaktifkan hanya pada jalur pencatatan makanan, dan SHALL TIDAK tersedia sebagai cara masukan pada layar lain.

#### Scenario: Ucapan berisi perintah di luar pencatatan makanan

- **WHEN** pengguna mengucapkan permintaan yang bukan tentang makanan yang dimakan, misalnya meminta mencatat berat badan atau mengganti program
- **THEN** sistem tidak menjalankan permintaan itu, menyatakan bahwa jalur suara hanya untuk mencatat makanan, dan menunjukkan tempat untuk melakukannya

#### Scenario: Tidak ada mikrofon di layar lain

- **WHEN** pengguna membuka layar pencatatan berat badan, pengaturan, atau pengelolaan program
- **THEN** tidak ada kendali masukan suara di layar tersebut

#### Scenario: Ucapan bercampur

- **WHEN** ucapan pengguna memuat makanan sekaligus hal lain di luar pencatatan makanan
- **THEN** sistem hanya menguraikan bagian makanannya dan mengabaikan sisanya, tanpa menjalankan perintah apa pun

### Requirement: Merekam ucapan sebagai jalur pencatatan

Sistem SHALL menyediakan pencatatan lewat suara pada pilihan cara pencatatan, di samping jalur yang sudah ada.

Sistem SHALL meminta izin mikrofon hanya ketika pengguna memilih jalur ini, dan SHALL menjelaskan untuk apa izin itu dipakai.

Sistem SHALL menampilkan dengan jelas kapan perekaman sedang berlangsung dan menyediakan cara menghentikannya.

#### Scenario: Izin diminta pada waktunya

- **WHEN** pengguna membuka pilihan cara pencatatan tanpa memilih jalur suara
- **THEN** sistem tidak meminta izin mikrofon

#### Scenario: Izin mikrofon ditolak

- **WHEN** pengguna menolak izin mikrofon
- **THEN** sistem menjelaskan keadaannya dan menawarkan pengetikan kalimat serta pencarian katalog, bukan layar yang gagal

#### Scenario: Perekaman terlihat sedang berlangsung

- **WHEN** perekaman sedang berjalan
- **THEN** sistem menandainya dengan jelas tanpa bergantung pada warna saja dan menyediakan cara menghentikan perekaman

### Requirement: Pengenalan ucapan mendahulukan perangkat

Sistem SHALL memakai pengenalan ucapan di perangkat bila tersedia, dan SHALL TIDAK mengirimkan rekaman suara ke luar perangkat ketika pengenalan di perangkat mencukupi.

Ketika pengenalan ucapan tidak tersedia di perangkat, sistem SHALL menyatakan keadaannya dan SHALL menawarkan pengetikan kalimat. Sistem SHALL TIDAK mengirimkan rekaman suara ke layanan luar tanpa persetujuan eksplisit pengguna untuk pengiriman itu.

#### Scenario: Pengenalan tersedia di perangkat

- **WHEN** pengguna merekam ucapan pada perangkat yang mendukung pengenalan ucapan
- **THEN** ucapan diubah menjadi teks di perangkat dan tidak ada rekaman suara yang dikirim ke layanan mana pun

#### Scenario: Pengenalan tidak tersedia di perangkat

- **WHEN** perangkat tidak mendukung pengenalan ucapan
- **THEN** sistem menyatakan keadaannya dan menawarkan pengetikan kalimat, tanpa mengirim rekaman tanpa persetujuan

### Requirement: Transkrip ditampilkan dan dapat disunting

Sistem SHALL menampilkan teks hasil pengenalan sebelum diurai, dan SHALL memungkinkan pengguna menyuntingnya.

Sistem SHALL menyatakan bahwa teks itu adalah hasil pengenalan yang dapat keliru.

#### Scenario: Satu kata salah dikenali

- **WHEN** hasil pengenalan memuat kata yang keliru
- **THEN** pengguna dapat memperbaiki kata itu tanpa mengulang perekaman

#### Scenario: Transkrip kosong

- **WHEN** pengenalan tidak menghasilkan teks apa pun
- **THEN** sistem menyatakannya dan menawarkan perekaman ulang atau pengetikan kalimat, tanpa membuat catatan

### Requirement: Rekaman suara tidak disimpan secara bawaan

Sistem SHALL menghapus rekaman suara setelah transkrip dihasilkan, kecuali pengguna menetapkan penyimpanan lewat pengaturan privasi.

Rekaman yang disimpan SHALL berada di perangkat, SHALL TIDAK dikirim ke layanan mana pun di luar pengiriman yang disetujui, dan SHALL ikut terhapus ketika pengguna menghapus seluruh data lokal.

#### Scenario: Rekaman dihapus setelah transkrip

- **WHEN** transkrip berhasil dihasilkan dan pengaturan retensi bernilai bawaan
- **THEN** rekaman suara dihapus dari perangkat

#### Scenario: Penghapusan data lokal

- **WHEN** pengguna menghapus seluruh data lokal
- **THEN** seluruh rekaman suara yang tersimpan ikut terhapus

### Requirement: Penguraian kalimat menghasilkan usulan komponen

Sistem SHALL menguraikan teks menjadi daftar komponen makanan beserta jumlah dan satuan yang disebut pengguna, dan SHALL memperlakukan hasilnya sebagai usulan yang wajib ditinjau.

Penguraian SHALL mengirimkan teks, bukan rekaman suara, ketika memakai layanan di luar perangkat.

Sistem SHALL TIDAK membuat catatan makan sebelum pengguna mengonfirmasi hasil peninjauan.

#### Scenario: Kalimat berisi beberapa makanan

- **WHEN** pengguna mengucapkan "nasi satu piring, ayam bakar satu potong, tempe dua"
- **THEN** sistem mengusulkan tiga komponen beserta jumlah dan satuannya untuk ditinjau, dan belum membuat satu pun catatan

#### Scenario: Yang dikirim adalah teks

- **WHEN** sistem memakai layanan di luar perangkat untuk menguraikan kalimat
- **THEN** yang dikirim hanyalah teks transkrip, bukan rekaman suara

#### Scenario: Peninjauan dibatalkan

- **WHEN** pengguna menutup peninjauan tanpa mengonfirmasi
- **THEN** tidak ada catatan yang dibuat

### Requirement: Nilai gizi berasal dari padanan katalog

Nilai gizi setiap komponen SHALL berasal dari padanan pada katalog makanan, makanan buatan pengguna, atau produk yang pernah dikonfirmasi. Sistem SHALL TIDAK memakai nilai gizi yang dihasilkan model penguraian.

Ketika sebuah komponen tidak memiliki padanan yang memadai, sistem SHALL meminta pengguna mencari atau membuat makanan, dan SHALL TIDAK menampilkan nilai gizi apa pun untuk komponen itu.

#### Scenario: Model mengembalikan angka gizi

- **WHEN** keluaran model penguraian memuat nilai gizi
- **THEN** nilai itu diabaikan dan sistem memakai nilai dari padanan katalog

#### Scenario: Komponen tanpa padanan

- **WHEN** sebuah komponen hasil penguraian tidak memiliki padanan yang memadai
- **THEN** sistem meminta pengguna mencari atau membuat makanan untuk komponen itu dan tidak menampilkan nilai gizi apa pun untuknya

### Requirement: Jumlah dan satuan yang tidak disebut ditanyakan

Ketika pengguna tidak menyebut jumlah atau satuan sebuah makanan, sistem SHALL menandainya sebagai belum ditentukan dan SHALL meminta pengguna menetapkannya.

Sistem SHALL TIDAK menebak jumlah, dan SHALL TIDAK memakai satu takaran bawaan sebagai jumlah yang dianggap disetujui pengguna tanpa ia menetapkannya.

#### Scenario: Jumlah tidak disebut

- **WHEN** pengguna mengucapkan "tadi makan tempe" tanpa menyebut jumlah
- **THEN** sistem menandai jumlah komponen itu belum ditentukan dan meminta pengguna menetapkannya sebelum konfirmasi

#### Scenario: Satuan tidak baku

- **WHEN** pengguna menyebut satuan yang tidak dikenali, misalnya "sepotong besar"
- **THEN** sistem menandai satuan itu perlu ditetapkan dan menawarkan takaran yang tersedia untuk makanan tersebut

### Requirement: Peninjauan dan pencatatan memakai jalur yang sama

Sistem SHALL meninjau komponen hasil penguraian memakai alur peninjauan komponen yang berlaku, termasuk pengubahan padanan makanan, pengubahan porsi, penambahan komponen, dan penghapusan komponen.

Ketika pengguna mengonfirmasi, sistem SHALL membuat satu catatan makan per komponen pada waktu makan dan tanggal yang dipilih, masing-masing dengan potret nilai gizi yang dibekukan. Penulisan seluruh komponen SHALL berhasil seluruhnya atau tidak sama sekali.

#### Scenario: Konfirmasi tiga komponen

- **WHEN** pengguna mengonfirmasi peninjauan berisi tiga komponen
- **THEN** tiga catatan dibuat pada waktu makan yang dipilih dan ringkasan hari menyesuaikan

#### Scenario: Kegagalan saat menyimpan

- **WHEN** penyimpanan gagal pada komponen terakhir
- **THEN** tidak ada satu pun komponen yang tersimpan dan buku harian tidak berubah

### Requirement: Jalur mengetik kalimat selalu tersedia

Sistem SHALL menyediakan pengetikan kalimat sebagai jalur setara, yang bekerja tanpa izin mikrofon dan tanpa pengenalan ucapan.

Sistem SHALL menyatakan dengan jelas bila penguraian memerlukan koneksi, dan SHALL menawarkan pencarian katalog sebagai jalur yang bekerja sepenuhnya luring.

#### Scenario: Pengguna memilih mengetik

- **WHEN** pengguna memilih mengetik kalimat alih-alih berbicara
- **THEN** sistem menerima teks itu dan menguraikannya dengan aturan yang sama, tanpa meminta izin mikrofon

#### Scenario: Penguraian tidak tersedia

- **WHEN** penguraian tidak tersedia karena luring, kuota habis, waktu tunggu lewat, atau layanan menolak
- **THEN** sistem mengurai kalimat di perangkat dengan aturan sederhana, menandai setiap komponen hasilnya perlu diperiksa, dan menyatakan bahwa kalimat diurai tanpa koneksi

#### Scenario: Penguraian di perangkat tidak menemukan makanan

- **WHEN** penguraian lewat layanan tidak tersedia dan penguraian di perangkat tidak menghasilkan satu komponen pun
- **THEN** sistem menyatakan keadaannya dalam bahasa yang dapat dimengerti, mempertahankan transkrip yang sudah ada, dan menawarkan pencarian katalog

### Requirement: Bahasa menyatakan hasil sebagai perkiraan

Sistem SHALL menyatakan bahwa hasil pengenalan ucapan dan penguraian kalimat adalah perkiraan yang perlu diperiksa, dan SHALL TIDAK menyajikannya sebagai catatan yang sudah pasti benar.

#### Scenario: Teks peninjauan diperiksa

- **WHEN** pengguna membuka peninjauan hasil penguraian
- **THEN** teks menyatakan bahwa hasilnya perlu diperiksa sebelum dicatat
