# Work Order

## Ringkasan

Change ini membuka kapabilitas penanganan privasi dengan isi pertama: setiap gambar dibersihkan dari metadata dan diperkecil sebelum meninggalkan perangkat. Pekerjaan utamanya ada di `mealora-apps/mealora-mobile`: satu langkah pembersihan di titik unggah yang dipakai ketiga klien pembacaan gambar, penanganan kegagalan yang tertutup, dan uji isi permintaan. `mealora-apps/mealora-model-proxy` hanya mendapat pembaruan konfigurasi `/app-config` saat versi aplikasi naik, tanpa perubahan kode. Estimasi 3–4 hari-orang dalam dua tahap, dimulai setelah review APK 1.0.0 selesai.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Verifikasi perilaku codec per platform: EXIF hilang, rotasi benar, HEIC/PNG/WebP terdekode | 0,5 | spike (timebox 1 hari) | Menentukan pustaka akhir (design D3) |
| 2 | Langkah pembersihan gambar (dekode, putar, perkecil, kodekan ulang JPEG) dengan batas per tugas | 0,75 | pasti | Batas dari design D4 |
| 3 | Pasang pembersihan di ketiga klien unggah gambar, dengan kegagalan tertutup | 0,5 | pasti | Tidak ada fallback ke gambar asli |
| 4 | Uji otomatis: tanpa EXIF, ukuran dalam batas, orientasi, berkas rusak, dan isi permintaan tanpa identitas | 0,75 | pasti | Mencakup dua klien teks untuk requirement identitas |
| 5 | Verifikasi keterbacaan label dengan himpunan uji change 010 setelah pengecilan | 0,5 | pasti | Bila turun, longgarkan batas label |
| 6 | Verifikasi perangkat Android, kenaikan versi, dan gate repo | 0,5 | pasti | Foto galeri dengan GPS sebagai bahan uji |

### mealora-model-proxy

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 7 | Perbarui `latest_version` dan `release_notes` di `/app-config` setelah build live di store | 0,1 | pasti | `min_supported_version` tidak diubah; deploy perlu konfirmasi |

## Dependensi Antar-Paket

- Paket 1 mendahului paket 2, karena pilihan pustaka ditentukan oleh hasil verifikasi.
- Paket 2 mendahului paket 3 dan 4.
- Paket 5 dan 6 membutuhkan paket 3.
- Paket 7 hanya dijalankan setelah build baru live di store.
- Seluruh change menunggu review APK 1.0.0 selesai.

## Urutan Rilis

### Tahap 1 — Pembersihan gambar di aplikasi

**Isi:** paket 1–6
**Prasyarat:** review APK 1.0.0 selesai
**Gate verifikasi:** `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` lolos. Di emulator atau perangkat Android, foto galeri ber-GPS terkirim tanpa metadata (diperiksa dari berkas yang dikirim pada build debug). Pembacaan label dan foto makanan tetap berhasil lewat proksi production.

### Tahap 2 — Rilis dan konfigurasi versi

**Isi:** paket 7
**Prasyarat:** build Tahap 1 live di store
**Gate verifikasi:** `GET /app-config` mengembalikan `latestVersion` baru dan catatan rilis, dengan `minSupportedVersion` tetap.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Codec native menyalin EXIF atau salah memutar gambar di salah satu platform | Paket 2 memakai pustaka lain dan waktu proses lebih lama | Fallback ke pustaka `image` di isolate, sudah disiapkan di design D3 |
| Pengecilan menurunkan keterbacaan label | Batas label harus dinaikkan dan ukuran unggahan membesar | Paket 5 mengukur sebelum rilis |
| Review store untuk versi baru lama | Tahap 2 tertunda | Tidak ada ketergantungan dari proksi; versi lama tetap berjalan |
