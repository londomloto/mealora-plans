# 022 · Penanganan privasi

## Why

Foto yang dipilih dari galeri saat ini dikirim ke proksi model apa adanya: berkas asli beresolusi penuh, lengkap dengan metadata EXIF yang dapat memuat lokasi GPS, waktu pemotretan, dan model perangkat. Proksi meneruskannya ke penyedia model pihak ketiga (rantai Gemini → Groq → GLM), sebagian di antaranya layanan gratis yang dapat memakai masukan untuk pengembangan produk. Isi label gizi dan foto makanan bukan data pribadi, dan proksi tidak mengirim identitas pengguna. Tetapi metadata yang menempel pada berkas foto adalah data pribadi yang tidak dibutuhkan untuk tugas apa pun.

Change ini menjadi wadah aturan privasi aplikasi. Isi pertamanya adalah pembersihan gambar sebelum meninggalkan perangkat. Aturan privasi berikutnya, yang tidak terbatas pada foto, ditambahkan ke kapabilitas yang sama belakangan.

## What Changes

- **Gambar dibersihkan sebelum meninggalkan perangkat**: setiap gambar yang dikirim ke layanan pembacaan (label gizi, foto makanan, gambar nutrisi) dikodekan ulang tanpa metadata, baik dari kamera maupun dari galeri.
- **Gambar diperkecil secukupnya**: sisi terpanjang dibatasi sesuai kebutuhan tugas, sehingga unggahan lebih kecil dan lebih cepat tanpa mengurangi keterbacaan.
- **Gagal tertutup**: bila pembersihan gagal, gambar asli tidak dikirim. Pengguna diarahkan ke jalur yang sama seperti ketika layanan tidak tersedia.
- **Kiriman tanpa identitas pengguna** ditetapkan sebagai aturan tertulis. Perilaku ini sudah berlaku sekarang dan kini dijaga oleh spesifikasi.
- Kontrak proksi tidak berubah. Pembersihan di sisi proksi, sebagai lapis kedua untuk versi aplikasi lama, berada di luar change ini.

## Capabilities

### New Capabilities

- `privacy-handling`: aturan perlakuan data pribadi pada data yang meninggalkan perangkat — dimulai dari pembersihan dan pengecilan gambar sebelum dikirim ke layanan pembacaan, serta jaminan kiriman tanpa identitas pengguna. Kapabilitas ini dimaksudkan untuk terus ditambah.

### Modified Capabilities

Tidak ada. `image-ai-access` dari change 010 (persetujuan unggah, kredensial, batas biaya, retensi gambar, jalur luring) tetap berlaku apa adanya. Change ini menambahkan aturan pada gambar yang diunggah, tanpa mengubah requirement yang sudah ada.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: satu langkah pembersihan gambar di titik unggah yang dipakai ketiga klien pembacaan gambar; penanganan kegagalan pembersihan; uji tanpa metadata; kenaikan versi aplikasi.
- **Repo `mealora-apps/mealora-model-proxy`**: tidak ada perubahan kode. `/app-config` (`latest_version`, `release_notes`) diperbarui saat versi aplikasi naik, sesuai aturan workspace. `min_supported_version` tidak diubah.
- **Ditunda sampai review APK 1.0.0 selesai.**
- **Versi aplikasi lama** tetap mengirim foto asli sampai pengguna memperbarui aplikasi. Penutupnya ada di pembersihan sisi proksi, yang ditunda.
