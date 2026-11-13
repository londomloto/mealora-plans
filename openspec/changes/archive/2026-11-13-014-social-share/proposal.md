# 014 · Berbagi ringkasan harian dan foto makanan

## Why

Pengguna ingin memamerkan konsistensi dan menu mereka ke WhatsApp Status, Instagram Story, atau media sosial lain ("mode pamer"). Setiap kartu yang dibagikan juga membawa watermark Mealora, sehingga menjadi promosi organik tanpa biaya. Semua data yang dibutuhkan sudah ada di perangkat (diary dari change 007, foto makanan dari change 011), jadi fitur ini dapat dibangun offline dan tanpa kuota layanan AI.

## What Changes

- **Share Daily Summary**: tombol Bagikan di ruang Hari ini. Tombol ini membuat kartu gambar berisi tanggal, energi tercatat dibanding target, persentase target, protein, karbohidrat, dan lemak, beserta watermark Mealora.
- **Share Meal**: setelah alur foto makanan (change 011) berhasil dikonfirmasi, pengguna melihat layar "Tersimpan" dengan tombol Bagikan. Kartunya berisi foto makanan, nama makanan, porsi, estimasi energi per komponen dan totalnya, serta watermark. Share Meal hanya tersedia di jalur foto.
- **Pratinjau sebelum membagikan**, lalu lembar berbagi bawaan sistem. Pengguna memilih sendiri aplikasi tujuan, dan Mealora tidak mengunggah apa pun ke server.
- **Tanpa penyimpanan tambahan**: foto untuk kartu memakai foto draf yang sudah ada. Gambar kartu hanya dibuat sementara lalu dihapus. Pengaturan retensi gambar (change 010) tetap dihormati.
- **Tanpa data sensitif**: kartu tidak pernah memuat berat badan, data profil, atau program.

## Capabilities

### New Capabilities

- `social-share`: membuat kartu gambar ringkasan harian dan kartu makanan dari jalur foto, beserta watermark, pratinjau, dan penyerahan ke lembar berbagi sistem.

### Modified Capabilities

Tidak ada perubahan requirement. Alur konfirmasi foto (change 011) mendapat layar "Tersimpan" sebelum kembali ke halaman awal. Ini adalah tambahan UI yang dicakup oleh `social-share`, dan perilaku pencatatannya tidak berubah.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: dependensi berbagi (`share_plus`), komponen kartu (9:16), perender kartu ke PNG, tombol Bagikan di ruang Hari ini, layar "Tersimpan" di jalur foto, penundaan penghapusan foto draf sampai layar itu ditutup, dan copy l10n. Tidak ada migrasi skema.
- **Aset**: logo Mealora yang sudah ada (`mealora-symbol.png`) dipakai sebagai watermark.
- **Di luar cakupan**: Share Progress (berat/konsistensi 7–30 hari) tidak dikerjakan. Berbagi dari jalur katalog, barcode, label, dan suara, berbagi dari Riwayat, serta tautan unduh atau deep link juga tidak termasuk.
