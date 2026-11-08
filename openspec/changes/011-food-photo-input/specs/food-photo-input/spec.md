## Purpose

Mengusulkan komponen makanan dari sebuah foto piring, meminta pengguna memeriksa dan mengoreksi setiap komponen beserta porsinya, lalu mencatatnya sebagai makanan biasa di buku harian — dengan nilai gizi yang selalu berasal dari catatan makanan yang dapat ditelusuri, bukan dari penampilan makanan.

## ADDED Requirements

### Requirement: Foto mengusulkan komponen, bukan mencatat

Sistem SHALL memperlakukan hasil pengenalan foto sebagai usulan komponen yang wajib ditinjau pengguna. Sistem SHALL TIDAK membuat catatan makan apa pun sebelum pengguna mengonfirmasi hasil peninjauan.

Sistem SHALL menyatakan bahwa hasil dari foto adalah perkiraan dan porsinya perlu diperiksa.

#### Scenario: Hasil pengenalan tersedia

- **WHEN** pengenalan selesai dan komponen diusulkan
- **THEN** sistem menampilkan daftar komponen untuk ditinjau dan belum membuat satu pun catatan

#### Scenario: Peninjauan dibatalkan

- **WHEN** pengguna menutup peninjauan tanpa mengonfirmasi
- **THEN** tidak ada catatan yang dibuat, dan gambar diperlakukan sesuai pengaturan retensi yang berlaku

### Requirement: Nilai gizi berasal dari catatan makanan yang dapat ditelusuri

Nilai gizi setiap komponen SHALL berasal dari padanan pada katalog makanan, makanan buatan pengguna, atau produk yang pernah dikonfirmasi. Sistem SHALL TIDAK menurunkan nilai gizi dari penampilan makanan pada foto.

Ketika tidak ada padanan yang memadai, sistem SHALL meminta pengguna memilih atau membuat makanan, dan SHALL TIDAK mengarang nilai.

#### Scenario: Komponen tanpa padanan

- **WHEN** sebuah komponen yang dikenali tidak memiliki padanan pada katalog
- **THEN** sistem meminta pengguna mencari atau membuat makanan untuk komponen itu, dan tidak menampilkan nilai gizi apa pun untuknya

#### Scenario: Komponen dengan padanan

- **WHEN** sebuah komponen cocok dengan makanan pada katalog
- **THEN** nilai gizinya berasal dari makanan itu dan sistem menyatakan padanan yang dipakai

### Requirement: Beberapa komponen dalam satu foto

Sistem SHALL mendukung beberapa komponen makanan dalam satu gambar, dan SHALL menampilkan jumlah komponen yang dikenali.

Pengguna SHALL dapat menambah komponen yang tidak terdeteksi, menghapus komponen yang keliru, dan mengubah padanan makanan tiap komponen.

#### Scenario: Satu piring berisi beberapa makanan

- **WHEN** foto memuat nasi, lauk, dan sayur
- **THEN** sistem mengusulkan ketiganya sebagai komponen terpisah yang masing-masing dapat ditinjau

#### Scenario: Komponen yang tidak terdeteksi

- **WHEN** pengguna menyadari ada bahan yang tidak terdeteksi
- **THEN** pengguna dapat menambahkannya lewat pencarian katalog atau pembuatan makanan

#### Scenario: Komponen keliru dihapus

- **WHEN** pengguna menghapus komponen yang salah dikenali
- **THEN** komponen itu hilang dari daftar dan perkiraan total menyesuaikan

### Requirement: Porsi, metode masak, dan bahan tersembunyi dapat dikoreksi

Sistem SHALL memungkinkan pengguna mengubah porsi setiap komponen, menetapkan metode masak ketika itu memengaruhi nilai gizi, dan menambahkan bahan yang tidak terlihat pada foto seperti minyak, saus, atau gula.

Sistem SHALL menyatakan bahwa foto tidak dapat memastikan minyak, resep, bahan tersembunyi, maupun massa yang sebenarnya.

#### Scenario: Metode masak belum pasti

- **WHEN** sebuah komponen dapat digoreng atau direbus dan metodenya tidak pasti dari foto
- **THEN** sistem menandai ketidakpastian itu dan meminta pengguna menetapkannya

#### Scenario: Menambahkan minyak atau saus

- **WHEN** pengguna menambahkan minyak goreng pada sebuah komponen
- **THEN** nilai komponen itu menyesuaikan berdasarkan makanan yang dipilih untuk minyak tersebut

#### Scenario: Porsi dikoreksi

- **WHEN** pengguna mengubah perkiraan porsi sebuah komponen
- **THEN** nilai komponen dan perkiraan total menyesuaikan seketika

### Requirement: Ketidakpastian dinyatakan per komponen

Sistem SHALL menandai pada setiap komponen apa yang belum pasti, sekurang-kurangnya: padanan makanan, porsi, dan metode masak.

Sistem SHALL TIDAK menyajikan hasil pengenalan sebagai nilai terukur, dan SHALL TIDAK menyembunyikan ketidakpastian dengan menampilkan angka tunggal tanpa keterangan.

#### Scenario: Komponen dengan porsi tidak pasti

- **WHEN** porsi sebuah komponen hanya dapat diperkirakan
- **THEN** sistem menandai porsi itu sebagai perkiraan yang perlu dicek

### Requirement: Jalur tanpa pengenalan selalu tersedia

Sistem SHALL menyediakan jalur pencatatan manual dari layar foto, tanpa mengambil maupun mengirim gambar.

Ketika pengenalan tidak tersedia — luring, kuota habis, waktu tunggu terlampaui, atau layanan menolak — sistem SHALL menyimpan foto sebagai draf, SHALL menyatakan bahwa belum ada catatan yang dibuat, dan SHALL mengarahkan pengguna ke pemilihan makanan secara manual.

Draf foto beserta komponen yang sudah diisi SHALL TIDAK hilang akibat kegagalan itu.

#### Scenario: Luring saat memotret

- **WHEN** pengguna memotret makanan tanpa koneksi
- **THEN** foto tersimpan sebagai draf, sistem menyatakan analisis belum tersedia dan belum ada catatan yang dibuat, lalu menawarkan pemilihan makanan manual

#### Scenario: Layanan gagal di tengah

- **WHEN** layanan pengenalan gagal setelah pengguna menyetujui unggah
- **THEN** draf foto dan komponen yang sudah diisi tetap ada, dan jalur manual ditawarkan

### Requirement: Pencatatan menghasilkan catatan per komponen

Ketika pengguna mengonfirmasi, sistem SHALL membuat satu catatan makan per komponen pada waktu makan dan tanggal yang dipilih, masing-masing dengan potret nilai gizi yang dibekukan sesuai aturan buku harian yang berlaku.

Penulisan seluruh komponen SHALL berhasil seluruhnya atau tidak sama sekali.

Setelah tercatat, setiap komponen SHALL dapat disunting dan dihapus sendiri seperti catatan makanan lain.

#### Scenario: Konfirmasi empat komponen

- **WHEN** pengguna mengonfirmasi peninjauan berisi empat komponen
- **THEN** empat catatan dibuat pada waktu makan yang dipilih, dan ringkasan hari menyesuaikan

#### Scenario: Kegagalan saat menyimpan

- **WHEN** penyimpanan gagal pada komponen terakhir
- **THEN** tidak ada satu pun komponen yang tersimpan dan buku harian tidak berubah

#### Scenario: Menyunting komponen setelah tercatat

- **WHEN** pengguna menyunting salah satu komponen hasil foto di buku harian
- **THEN** hanya catatan itu yang berubah, seperti catatan makanan lain

### Requirement: Bahasa peninjauan menyatakan keterbatasan foto

Sistem SHALL menyatakan bahwa nilai yang ditampilkan adalah perkiraan dari padanan makanan, bukan hasil pengukuran atas makanan di foto.

Sistem SHALL TIDAK memakai kalimat yang menyiratkan bahwa foto mengetahui kandungan gizi makanan secara pasti.

#### Scenario: Teks peninjauan diperiksa

- **WHEN** pengguna membuka peninjauan hasil foto
- **THEN** teks menyatakan bahwa nilai berasal dari padanan katalog dan porsinya perlu diperiksa, tanpa menyiratkan pengukuran
