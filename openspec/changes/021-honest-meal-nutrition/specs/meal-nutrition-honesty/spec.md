## Purpose

Menjaga agar total gizi yang dilihat dan dibagikan pengguna tidak pernah terlihat lebih lengkap dari kenyataannya. Komponen foto yang belum ada di katalog bisa dilengkapi dari tempat, dan makanan tetap bisa dibagikan tanpa angka yang menyesatkan.

## ADDED Requirements

### Requirement: Nilai yang belum diketahui tidak dihitung nol dalam total
Setiap total energi, protein, karbohidrat, atau lemak yang ditampilkan SHALL menjumlahkan hanya nilai yang diketahui. Bila ada bagian yang nilainya belum diketahui, total itu SHALL ditandai belum lengkap beserta jumlah bagian yang belum diketahui, mis. "7 kkal + 3 belum diketahui". Bila tidak ada satu pun nilai yang diketahui, total SHALL ditampilkan sebagai belum diketahui. Nilai yang belum diketahui SHALL NOT ditampilkan atau dihitung sebagai 0.

Aturan ini berlaku di tinjau foto makanan, ringkasan Hari ini, kartu makanan, kartu ringkasan harian, ringkasan Riwayat, dan grafik energi di Program. Pada grafik energi, tanggal yang hanya sebagian diketahui ditampilkan sebagai batas bawah ("≥") dan tidak ikut dihitung ke rata-rata.

#### Scenario: Riwayat dan grafik energi dengan catatan bernilai kosong
- **WHEN** suatu tanggal punya catatan 769 kkal dan satu catatan yang energinya belum diketahui
- **THEN** Riwayat menampilkan "≥ 769 kkal" dengan keterangan 1 catatan belum diketahui, dan grafik energi menggambar tanggal itu sebagai "≥ 769 kkal" tanpa memasukkannya ke rata-rata

#### Scenario: Tinjau foto dengan komponen tanpa padanan
- **WHEN** tinjau foto berisi kopi susu 7 kkal dan tiga komponen yang belum ada di katalog
- **THEN** total tertulis "7 kkal + 3 belum diketahui", bukan "7 kkal"

#### Scenario: Semua nilai diketahui
- **WHEN** semua komponen punya nilai energi
- **THEN** total ditampilkan seperti biasa, tanpa penanda belum lengkap

#### Scenario: Hari ini dengan catatan bernilai kosong
- **WHEN** hari ini ada catatan 1.200 kkal dan satu catatan yang energinya belum diketahui
- **THEN** ringkasan energi menunjukkan 1.200 kkal dengan penanda "+ 1 belum diketahui"

#### Scenario: Kartu ringkasan harian
- **WHEN** pengguna membagikan ringkasan hari dengan satu catatan yang energinya belum diketahui
- **THEN** kartu tidak menghitung catatan itu sebagai 0, dan menandai energinya belum lengkap

### Requirement: Komponen foto tanpa padanan dapat dilengkapi dari tinjau foto
Komponen foto tanpa padanan SHALL ditandai "belum ada di katalog" dan menyediakan aksi Lengkapi. Selama masih ada komponen seperti itu, tombol utama tinjau foto SHALL berbunyi "Lengkapi N bahan" dan membuka komponen pertama yang belum lengkap. Komponen tanpa padanan SHALL tetap tidak dapat dicatat.

#### Scenario: Tiga komponen belum ada di katalog
- **WHEN** tinjau foto berisi tiga komponen tanpa padanan
- **THEN** ketiganya bertanda "belum ada di katalog" dengan aksi Lengkapi, dan tombol utama berbunyi "Lengkapi 3 bahan"

#### Scenario: Semua komponen lengkap
- **WHEN** semua komponen sudah punya padanan
- **THEN** tombol utama kembali menjadi "Konfirmasi & catat"

### Requirement: Buat makanan ini menjadi padanan komponen
Sheet ubah komponen untuk komponen tanpa padanan SHALL menawarkan "Cari di katalog" dan "Buat makanan ini". "Buat makanan ini" SHALL membuka form Buat makanan yang sudah berisi nama komponen dan sajian perkiraannya, dengan alat Tempel teks dan Foto info gizi tersedia. Setelah pengguna menyimpan, makanan baru itu SHALL otomatis menjadi padanan komponen. Pengguna SHALL kembali ke tinjau foto, bukan ke pencatatan makanan terpisah. Bila pengguna batal, komponen SHALL tetap tanpa padanan.

#### Scenario: Membuat cheesecake dari komponen foto
- **WHEN** pengguna memilih "Buat makanan ini" untuk komponen cheesecake, mengisi gizinya lewat Tempel teks, lalu menyimpan
- **THEN** pengguna kembali ke tinjau foto, cheesecake memakai makanan baru itu sebagai padanan, dan totalnya ikut diperbarui

#### Scenario: Batal membuat makanan
- **WHEN** pengguna menutup form Buat makanan tanpa menyimpan
- **THEN** komponen tetap bertanda "belum ada di katalog"

### Requirement: Takaran komponen menampilkan satuan sajian
Jumlah takaran di sheet ubah komponen SHALL ditampilkan bersama label sajian padanannya, mis. "1 potong" atau "1,5 × 1 cangkir". Angka tanpa satuan SHALL NOT ditampilkan.

#### Scenario: Takaran kopi
- **WHEN** komponen kopi susu dengan sajian "1 cangkir" dibuka di sheet
- **THEN** takaran tertulis "1 × 1 cangkir" atau "1 cangkir", bukan "1,0"

### Requirement: Bagikan saja tanpa mencatat
Selama tinjau foto masih memuat komponen tanpa padanan, sistem SHALL menyediakan tautan "Bagikan saja tanpa mencatat". Tautan itu membuka pratinjau bagikan dengan kartu makanan tanpa total, beserta catatan bahwa makanan belum dicatat di buku harian. Tidak ada catatan makan yang dibuat. Setelah berbagi atau menutup pratinjau, pengguna SHALL kembali ke tinjau foto dengan draf yang tetap utuh.

#### Scenario: Berbagi tanpa melengkapi
- **WHEN** pengguna mengetuk "Bagikan saja tanpa mencatat" pada tinjau foto berisi komponen tanpa padanan
- **THEN** pratinjau bagikan menampilkan kartu tanpa kalori dan makro, dan buku harian tidak berubah

#### Scenario: Kembali setelah berbagi
- **WHEN** pengguna menutup pratinjau bagikan
- **THEN** pengguna kembali ke tinjau foto, dan semua komponen serta koreksinya masih ada

#### Scenario: Semua komponen lengkap
- **WHEN** semua komponen sudah punya padanan
- **THEN** tautan "Bagikan saja tanpa mencatat" tidak ditampilkan, dan berbagi dilakukan dari layar Tersimpan seperti biasa

### Requirement: Kartu makanan tanpa total
Kartu makanan tanpa total SHALL memuat foto, nama komponen, dan waktu makan. Kartu itu SHALL NOT memuat kalori, makro, maupun angka per komponen, dan SHALL memuat label "Dibagikan dari Mealora". Kartu ini SHALL dipakai untuk "Bagikan saja tanpa mencatat" dan untuk "Bagikan tanpa total".

#### Scenario: Isi kartu tanpa total
- **WHEN** kartu tanpa total dibuat untuk cheesecake, muffin, kue kering, dan kopi susu
- **THEN** kartu menampilkan foto dan keempat nama itu tanpa angka gizi apa pun

### Requirement: Tersimpan dengan nutrisi belum lengkap
Bila makanan yang dicatat dari foto memuat komponen yang energinya belum diketahui, layar Tersimpan SHALL menyebut jumlah komponen itu dan menawarkan "Lengkapi dulu" serta "Bagikan tanpa total". Pratinjau kartu SHALL NOT menampilkan total energi yang menghitung komponen itu sebagai 0.

#### Scenario: Padanan dengan energi kosong
- **WHEN** pengguna mencatat foto yang salah satu padanannya punya energi kosong di katalog
- **THEN** layar Tersimpan menampilkan "+ 1 belum diketahui" dengan pilihan Lengkapi dulu dan Bagikan tanpa total
