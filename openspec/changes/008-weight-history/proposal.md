# 008 · Pemantauan berat dan riwayat harian

## Why

Setelah change 007, pengguna dapat mencatat makanan dan melihat hari ini — tetapi tidak bisa melihat kemarin, dan tidak bisa mencatat berat badan sama sekali. Dua dari empat ruang utama masih kosong, dan pertanyaan ketiga dari visi produk, "bagaimana kemajuan saya?", baru terjawab separuh.

Berat badan juga bukan sekadar fitur tambahan: program Turun Berat dan Naik Berat memakai berat terbaru untuk kemajuan dan untuk ambang hitung ulang target (change 002), dan ruang Program (change 006) sudah menyiapkan tempat menampilkannya. Tanpa change ini, keduanya selamanya menampilkan "belum ada catatan".

Rancangannya sudah ada di `docs/mealora.pen`: `18 · Riwayat harian`, `31 · Pantau berat`, dan `32 · Tambah berat`.

## What Changes

- **Pencatatan berat badan** (`32`): nilai berat, tanggal catatan, dan catatan bebas opsional, dengan penegasan bahwa data hanya tersimpan di perangkat.
- **Pemantauan berat** (`31`): berat terbaru, perbandingan terhadap berat awal program bila ada, tren beberapa minggu terakhir, dan daftar catatan terakhir.
- **Menyunting dan menghapus catatan berat**, karena salah ketik pada angka berat adalah hal yang lumrah dan harus murah diperbaiki.
- **Riwayat harian** (`18`): kalender bulanan, pemilihan tanggal, ringkasan hari terpilih berupa energi dan zat gizi makro, serta daftar catatan makan pada hari itu.
- **Hari tanpa catatan di riwayat** (`40`): hari kosong dinyatakan belum diketahui dan tidak pernah ditandai sebagai hari yang gagal.
- **Penandaan hari yang memiliki catatan** pada kalender, tanpa menjadikannya penilaian atas pengguna.
- **Penyambungan ke kemajuan program**: catatan berat memperbarui potret kemajuan program untuk tanggal yang bersangkutan, dan memicu usulan peninjauan target ketika melewati ambang kebijakan.
- **Ruang Riwayat menjadi hidup**, menggantikan keadaan kosong dari change 001.

## Capabilities

### New Capabilities

- `weight-tracking`: pencatatan berat badan sepanjang waktu — menambah, menyunting, menghapus, melihat berat terbaru dan arah perubahannya — beserta perlakuannya terhadap program yang berjalan.
- `daily-history`: menelusuri hari-hari sebelumnya — memilih tanggal, membaca ringkasan gizi dan catatan makan hari itu, dan memahami hari yang tidak memiliki catatan.

### Modified Capabilities

Tidak ada. `program-progress`, `program-management`, `food-diary`, dan `daily-dashboard` dipakai apa adanya.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: tabel catatan berat beserta migrasi skema versi 4 ke 5, repositori berat, layar pantau berat dan tambah berat, ruang Riwayat beserta kalender dan ringkasan tanggal, serta penyambungan ke potret kemajuan program dan usulan peninjauan target.
- **Bergantung pada** change 004 (potret kemajuan), 006 (ruang Program yang menampilkan berat), dan 007 (ringkasan harian yang dipakai ulang di riwayat).
- **Menutup MVP 1 jalur manual**: setelah change ini, seluruh kriteria penerimaan MVP pada assessment §28 terpenuhi kecuali yang memerlukan jalur foto, barcode, dan label gizi.
- **Belum tersentuh**: pemindaian barcode, pembacaan label gizi, dan foto makanan — tiga change berikutnya. Ringkasan mingguan, streak, dan skor nutrisi tetap di luar MVP 1.
