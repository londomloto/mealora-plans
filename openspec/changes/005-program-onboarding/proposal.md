# 005 · Onboarding dan aktivasi program

## Why

Setelah change 001–004, Mealora punya kerangka yang bisa dijalankan, kebijakan gizi berversi, domain program yang teruji, dan penyimpanan yang tahan restart — tetapi belum ada satu pun jalan bagi pengguna untuk memakainya. Aplikasi masih menampilkan empat ruang kosong.

Change ini menyambungkan seluruhnya menjadi perjalanan pertama yang utuh: pengguna memasang aplikasi, memperkenalkan dirinya, memilih arah, meninjau perkiraan targetnya, lalu menyetujuinya. Inilah momen yang paling menentukan apakah produk ini terasa jujur atau tidak — di sinilah angka pertama muncul, dan di sinilah penolakan harus terasa membantu alih-alih menghukum.

Rancangannya sudah ada dan rinci di `docs/mealora.pen` (layar `07`–`12`, `25`, `26`, `36`), termasuk keadaan yang biasanya dilupakan orang: kebijakan belum tersedia, dan pengguna yang belum punya program sama sekali.

## What Changes

- **Layar sambutan** (`07`) yang menyatakan sejak awal bahwa Mealora bekerja tanpa akun, bisa dipakai offline, dan menyimpan data di perangkat.
- **Profil awal** (`08`): nama panggilan opsional, tanggal lahir, tinggi badan, berat saat ini, dan masukan biologis untuk persamaan energi — disertai keterangan bahwa masukan itu dipakai hanya untuk persamaan, bukan sebagai identitas gender.
- **Tingkat aktivitas** (`09`): tiga pilihan dengan penjelasan sehari-hari, ditambah pernyataan jujur bahwa faktor aktivitas memengaruhi perkiraan dan bisa diubah kemudian.
- **Pemilihan program** (`10`) dan **detail program** (`11`): empat program, fokus kebiasaan untuk Makan Sehat, dan pengakuan pengguna bahwa target serta data makanan adalah perkiraan, bukan nasihat medis.
- **Target berat** (`25`) untuk Turun Berat dan Naik Berat, dengan tanggal tujuan yang opsional dan pernyataan bahwa tanggal tidak pernah mengesampingkan aturan keselamatan.
- **Tinjau target** (`12`): nilai target, dasar perkiraan, asumsi, peringatan, versi kalkulator dan kebijakan, serta penegasan bahwa belum ada program aktif sebelum pengguna menyetujui.
- **Keadaan tidak dapat disetujui** (`26`): penjelasan aman tanpa diagnosis, pernyataan bahwa tidak ada target yang dibuat dan tidak ada data yang berubah, serta tawaran jalur yang lebih aman.
- **Belum ada program** (`36`): keadaan bagi pengguna yang melewati pemilihan atau yang datang dari versi sebelumnya, dengan catatan lama tetap terbuka.
- **Keadaan baru yang belum ada di rancangan**: masukan berubah sejak pratinjau. Domain (change 003) mewajibkan aktivasi dibatalkan bila fakta profil berubah setelah pratinjau ditampilkan, tetapi belum ada layar untuk itu — change ini merancang dan membangunnya.
- **Penyimpanan profil lokal** beserta tabel dan migrasinya, karena belum ada tempat menyimpan data profil.
- **Penyambungan ke ruang utama**: setelah aktivasi, pengguna mendarat di ruang Hari ini dengan program aktif terbaca, menggantikan keadaan kosong dari change 001.

## Capabilities

### New Capabilities

- `user-profile`: data diri yang dipakai Mealora untuk memperkirakan kebutuhan energi — apa yang diminta, apa yang opsional, bagaimana disimpan, dan bagaimana perubahannya memengaruhi target yang sedang berjalan.
- `program-onboarding`: perjalanan dari pemasangan pertama sampai sebuah program berjalan — pengumpulan masukan, pratinjau target, konfirmasi, penolakan yang aman, dan keadaan tanpa program.

### Modified Capabilities

Tidak ada. `program-catalog`, `program-lifecycle`, `nutrition-policy`, `program-progress`, `app-shell`, dan `local-data-foundation` dipakai apa adanya.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: fitur onboarding dan program (layar, state, navigasi antar-langkah), tabel profil beserta migrasi skema versi 2 ke 3, repositori profil, dan penyambungan ruang Hari ini ke program aktif.
- **Repo `mealora-plans`**: penambahan layar "masukan berubah sejak pratinjau" ke `docs/mealora.pen`, mengikuti bahasa visual yang sudah ada.
- **Bergantung pada** change 001 (kerangka, tema, navigasi), 002 (kebijakan — selama belum disetujui, onboarding berakhir di keadaan `26`), 003 (domain), dan 004 (penyimpanan program).
- **Memblokir** change berikutnya: siklus hidup program di layar (Program saya, jeda, ganti, riwayat, selesaikan), serta katalog makanan dan buku harian.
- **Belum tersentuh**: pencatatan makanan, berat badan, riwayat harian, dan seluruh jalur foto, barcode, maupun label gizi. Ruang Program, Riwayat, dan Profil tetap pada keadaan kosong kecuali bagian yang disebut di sini.
