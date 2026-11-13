# program-onboarding Specification

## Purpose
Perjalanan pengguna dari pemasangan pertama sampai sebuah program berjalan: pengumpulan masukan bertahap, pratinjau target beserta dasarnya, konfirmasi yang tidak bisa dilewati, penolakan yang aman ketika kebijakan tidak mengizinkan, dan keadaan ketika pengguna belum memiliki program sama sekali.

## Requirements

### Requirement: Onboarding berjalan tanpa akun dan tanpa koneksi

Seluruh langkah onboarding sampai aktivasi program SHALL dapat diselesaikan tanpa pendaftaran, login, atau koneksi jaringan. Layar pertama SHALL menyatakan bahwa aplikasi dapat dipakai tanpa akun, dapat dipakai luring, dan menyimpan data pribadi di perangkat.

#### Scenario: Onboarding lengkap dalam mode pesawat

- **WHEN** pengguna memasang aplikasi dan menyelesaikan seluruh langkah onboarding dengan koneksi dimatikan
- **THEN** sebuah program dapat diaktifkan tanpa satu pun permintaan jaringan dan tanpa diminta membuat akun

### Requirement: Langkah onboarding terlihat kemajuannya

Sistem SHALL menampilkan langkah keberapa dari berapa pada setiap layar onboarding, dan SHALL mengizinkan pengguna kembali ke langkah sebelumnya tanpa kehilangan masukan yang sudah diisi.

#### Scenario: Kembali ke langkah sebelumnya

- **WHEN** pengguna menekan kembali dari langkah tingkat aktivitas ke langkah profil
- **THEN** seluruh masukan profil yang sudah diisi masih ada dan dapat disunting

#### Scenario: Onboarding ditinggalkan di tengah jalan

- **WHEN** pengguna menutup aplikasi sebelum menyelesaikan onboarding, lalu membukanya kembali
- **THEN** masukan yang sudah tersimpan tidak hilang dan pengguna dapat melanjutkan tanpa mengulang dari awal

### Requirement: Pemilihan program menyajikan empat pilihan

Sistem SHALL menampilkan empat program beserta maksud masing-masing dalam bahasa sehari-hari, SHALL menyatakan bahwa program dapat diganti di kemudian hari, dan SHALL menyatakan bahwa rekomendasi berat tertentu memerlukan kebijakan gizi tervalidasi.

Masukan tambahan yang diminta setelah pemilihan SHALL mengikuti program yang dipilih: berat tujuan untuk Turun Berat dan Naik Berat, fokus kebiasaan untuk Makan Sehat, dan tidak ada masukan berat tujuan untuk Makan Sehat maupun Pertahankan.

#### Scenario: Memilih Makan Sehat

- **WHEN** pengguna memilih Makan Sehat
- **THEN** sistem meminta fokus kebiasaan dan tidak pernah meminta berat tujuan

#### Scenario: Memilih Turun Berat

- **WHEN** pengguna memilih Turun Berat
- **THEN** sistem meminta berat awal dan berat tujuan, sementara tanggal tujuan ditandai opsional

### Requirement: Pengakuan bahwa hasil adalah perkiraan

Sebelum pratinjau target ditampilkan, sistem SHALL meminta pengguna mengakui bahwa target dan data makanan merupakan perkiraan dan bukan nasihat medis. Sistem SHALL TIDAK melanjutkan ke pratinjau sebelum pengakuan itu diberikan.

#### Scenario: Pengakuan belum diberikan

- **WHEN** pengguna mencoba melanjutkan ke pratinjau tanpa memberi pengakuan
- **THEN** sistem menahan langkah tersebut dan menjelaskan apa yang perlu diakui

### Requirement: Pratinjau target menampilkan dasarnya

Pratinjau target SHALL menampilkan nilai target energi harian, dasar perkiraan berupa data profil dan tingkat aktivitas yang dipakai, asumsi, peringatan yang berlaku, versi kalkulator, dan versi kebijakan. Pratinjau SHALL menyatakan bahwa belum ada program aktif sebelum pengguna menyetujui.

Nilai pada pratinjau SHALL disebut sebagai perkiraan, dan SHALL TIDAK disajikan sebagai hasil pengukuran, diagnosis, atau jaminan hasil.

#### Scenario: Pratinjau ditampilkan

- **WHEN** masukan lengkap dan kebijakan menyetujui proposal
- **THEN** pengguna melihat target energi harian, dasar perkiraan, asumsi, peringatan, kedua versi, dan pernyataan bahwa belum ada program aktif

#### Scenario: Pratinjau ditutup tanpa persetujuan

- **WHEN** pengguna menutup pratinjau tanpa menyetujui
- **THEN** tidak ada program yang aktif dan tidak ada data program yang tersimpan

### Requirement: Aktivasi hanya setelah konfirmasi dan verifikasi ulang

Sistem SHALL mengaktifkan program hanya setelah pengguna menyetujui pratinjau secara tegas. Sebelum menulis apa pun, sistem SHALL memverifikasi ulang bahwa fakta profil yang dipakai pratinjau masih berlaku.

Bila fakta telah berubah sejak pratinjau ditampilkan, sistem SHALL membatalkan aktivasi, SHALL menjelaskan bahwa masukan berubah sejak pratinjau, SHALL menunjukkan nilai mana yang berubah, dan SHALL menawarkan pratinjau yang diperbarui untuk ditinjau ulang. Sistem SHALL TIDAK mengaktifkan program berdasarkan nilai lama.

#### Scenario: Masukan berubah sejak pratinjau

- **WHEN** berat badan profil berubah setelah pratinjau ditampilkan dan sebelum pengguna menyetujui
- **THEN** sistem membatalkan aktivasi, menyebut nilai yang berubah, dan menampilkan pratinjau yang diperbarui

#### Scenario: Aktivasi berhasil

- **WHEN** pengguna menyetujui pratinjau dan fakta profil tidak berubah
- **THEN** program menjadi berjalan, pengguna mendarat di ruang Hari ini, dan program aktif terbaca di sana

### Requirement: Keadaan tidak dapat disetujui dijelaskan dengan aman

Ketika kebijakan tidak menyetujui sebuah proposal, sistem SHALL menjelaskan keadaannya tanpa menyampaikan diagnosis, SHALL menyatakan bahwa tidak ada target yang dibuat, SHALL menyatakan bahwa data dan program sebelumnya tidak berubah, dan SHALL menawarkan langkah berikutnya yang lebih aman.

Sistem SHALL TIDAK menampilkan angka target dalam keadaan ini, termasuk angka parsial atau angka contoh.

#### Scenario: Kebijakan belum tersedia

- **WHEN** kebijakan gizi yang berlaku belum disetujui
- **THEN** pengguna melihat penjelasan bahwa target otomatis belum dapat dibuat, pernyataan bahwa tidak ada defisit atau surplus yang dibuat, tawaran program tanpa target perubahan berat, dan tidak satu pun angka target

#### Scenario: Profil di luar cakupan

- **WHEN** profil berada di luar cakupan kebijakan
- **THEN** pengguna melihat penjelasan tanpa diagnosis beserta langkah berikutnya, dan tidak ada program yang aktif

#### Scenario: Laju yang diminta terlalu cepat

- **WHEN** kombinasi berat tujuan dan tanggal tujuan menuntut laju di luar batas yang diizinkan
- **THEN** sistem menjelaskan konfliknya, menyebut tanggal paling awal yang memenuhi batas, dan meminta pengguna mengubah masukan tanpa memotong target secara diam-diam

### Requirement: Keadaan belum ada program

Sistem SHALL menyediakan keadaan khusus bagi pengguna yang belum memiliki program berjalan, memuat ajakan memilih program dan penegasan bahwa catatan makanan serta berat badan yang lama tetap ada dan dapat dibuka.

Keadaan ini SHALL muncul bagi pengguna yang melewati pemilihan program, pengguna yang programnya sudah berakhir, dan pengguna yang datang dari versi aplikasi sebelum program ada.

#### Scenario: Pengguna melewati pemilihan program

- **WHEN** pengguna menutup onboarding sebelum mengaktifkan program, lalu membuka aplikasi kembali
- **THEN** pengguna melihat keadaan belum ada program beserta ajakan memilih, dan dapat membuka catatan lamanya

#### Scenario: Pengguna dari versi sebelumnya

- **WHEN** pengguna dengan catatan lama membuka aplikasi setelah fitur program tersedia
- **THEN** tidak ada program yang aktif, catatan lama tetap terbuka, dan pengguna diajak memilih program

### Requirement: Bahasa onboarding tidak menjanjikan hasil

Seluruh teks pada onboarding SHALL menyebut target sebagai perkiraan, SHALL TIDAK menjanjikan penurunan atau penambahan berat tertentu, SHALL TIDAK menyampaikan diagnosis, dan SHALL TIDAK menyalahkan pengguna atas keadaan tubuhnya.

#### Scenario: Teks diperiksa pada setiap layar onboarding

- **WHEN** pengguna melewati seluruh layar onboarding
- **THEN** tidak ada kalimat yang menjanjikan hasil tertentu pada tanggal tertentu, menyampaikan diagnosis, atau menyalahkan pengguna
