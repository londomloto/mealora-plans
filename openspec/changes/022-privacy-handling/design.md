## Context

Lihat proposal.md — Why.

Kondisi saat ini di `mealora-apps/mealora-mobile`:

- Gambar masuk lewat dua jalur: kamera aplikasi (`CameraController.takePicture()`) dan galeri (`ImagePicker().pickImage(source: ImageSource.gallery)` tanpa `maxWidth`/`imageQuality`), di `food_photo_screen.dart` dan `nutrition_label_photo_screen.dart`. Keduanya membaca byte berkas asli.
- Tiga klien mengunggah byte itu apa adanya: `vision_proxy_label_provider.dart` (`/extract-label`), `vision_proxy_food_component_provider.dart` (`/recognize-food-components`), dan `model_proxy_nutrition_reader.dart` (`/read-nutrition-image`). Ketiganya selalu menandai berkas sebagai `image/jpeg`, padahal berkas galeri bisa berupa HEIC, PNG, atau WebP.
- Permintaan hanya membawa berkas dan header `X-Proxy-Token`. Proksi tidak menyimpan apa pun dan hanya mencatat metadata permintaan.
- Belum ada pustaka pengolah gambar di `pubspec.yaml` selain `image_picker` dan `camera`.

## Goals / Non-Goals

**Goals:**

- Satu titik pembersihan yang dilewati setiap gambar sebelum diunggah, apa pun sumbernya, termasuk jalur gambar yang ditambahkan nanti.
- Hasil yang dapat diuji secara otomatis: tidak ada metadata, ukuran dalam batas, dan orientasi benar.

**Non-Goals:**

- Pembersihan di sisi proksi (ditunda; lihat Risks).
- Mengubah salinan gambar yang disimpan lokal untuk draf atau retensi. Salinan itu tidak meninggalkan perangkat dan tetap diatur oleh `image-ai-access`.
- Mengubah kontrak, endpoint, atau batas ukuran proksi.

## Decisions

### D1. Pembersihan di titik unggah, bukan di picker

Satu fungsi `sanitizeForUpload(bytes, purpose)` dipanggil ketiga klien tepat sebelum `MultipartFile.fromBytes`.

- Alternatif: memberi `maxWidth`/`imageQuality` pada `pickImage`. Ditolak sebagai satu-satunya mekanisme karena tidak mencakup jalur kamera, dan perilaku penyalinan EXIF `image_picker` berbeda per platform. Opsi picker boleh tetap dipasang sebagai penghemat memori, tetapi tidak dijadikan jaminan.
- Dengan titik unggah, jaminan "tidak ada metadata yang keluar" berada di satu tempat yang bisa diuji, dan jalur gambar baru otomatis tercakup selama memakai klien yang sama.

### D2. Kodekan ulang ke JPEG, bukan menghapus segmen EXIF

Gambar didekode, diputar sesuai tag orientasi, diperkecil, lalu dikodekan ulang menjadi JPEG baru tanpa metadata.

- Alternatif: menghapus segmen APP1/EXIF dari JPEG asli. Ditolak karena tidak mencakup HEIC, PNG, atau WebP, mudah meninggalkan segmen lain (XMP, IPTC, thumbnail), dan tidak memperkecil ukuran.
- Kodekan ulang sekaligus membuat label `image/jpeg` pada ketiga klien menjadi benar.

### D3. Pustaka: `flutter_image_compress`, fallback pustaka `image` murni Dart

`flutter_image_compress` memakai codec native (cepat untuk foto 12 MP), mendukung HEIC di iOS dan Android, membuang EXIF secara bawaan (`keepExif: false`), dan menerapkan rotasi dari tag orientasi.

- Alternatif: pustaka `image` (murni Dart). Lebih portabel dan mudah diuji tanpa perangkat, tetapi mendekode foto besar di Dart jauh lebih lambat dan harus dipindah ke isolate. Disimpan sebagai fallback bila codec native gagal pada format tertentu, dan dipakai di uji unit untuk memeriksa keluaran.
- Keputusan akhir pustaka diambil setelah tugas verifikasi 1.1 di tasks.md. Bila ternyata EXIF tetap tersalin atau rotasi salah di salah satu platform, gunakan pustaka `image` untuk seluruh jalur.

### D4. Batas per tugas

| Tugas | Sisi terpanjang maks | Kualitas JPEG |
|---|---|---|
| Foto makanan (`/recognize-food-components`) | 1600 px | 85 |
| Label gizi dan gambar nutrisi (`/extract-label`, `/read-nutrition-image`) | 2048 px | 90 |

Label memerlukan resolusi lebih tinggi karena tulisannya kecil. Angka ini titik awal. Tugas verifikasi memastikan keterbacaan label tidak turun pada himpunan uji label change 010. Gambar yang lebih kecil dari batas tidak diperbesar.

### D5. Gagal tertutup

Bila pembersihan melempar galat atau menghasilkan berkas kosong, klien mengembalikan hasil "layanan tidak tersedia" yang sudah ada, dengan alasan baru yang dipetakan ke pesan umum yang sama. Gambar asli tidak pernah dikirim sebagai cadangan.

### D6. Identitas pengguna

Tidak ada perubahan kode. Requirement "tanpa identitas pengguna" dijaga lewat uji yang memeriksa isi permintaan ketiga klien gambar dan dua klien teks (hanya berkas atau teks, plus header token).

## Risks / Trade-offs

- [Versi aplikasi lama tetap mengirim foto asli] → Diterima untuk change ini. Pembersihan di sisi proksi dapat ditambahkan belakangan sebagai change terpisah bila dibutuhkan. Proksi tidak menyimpan gambar, sehingga paparan terbatas pada penyedia.
- [Pengecilan menurunkan keterbacaan label] → Batas label lebih longgar (2048 px, kualitas 90) dan diverifikasi dengan himpunan uji change 010 sebelum rilis.
- [Codec native berperilaku beda per platform] → Uji otomatis memeriksa keluaran (tanpa EXIF, ukuran, orientasi). Verifikasi manual dilakukan di perangkat Android dengan foto yang memuat GPS.
- [Waktu proses tambahan sebelum unggah] → Diperkirakan ratusan milidetik di perangkat menengah dan diimbangi unggahan yang jauh lebih kecil. Diukur saat verifikasi.

## Migration Plan

- Rilis bersama kenaikan versi aplikasi berikutnya, setelah review APK 1.0.0 selesai.
- Saat versi naik, perbarui `latest_version` dan `release_notes` di `/app-config` proksi. `min_supported_version` tidak diubah, jadi tidak ada pembaruan paksa.
- Rollback: rilis ulang versi sebelumnya. Kontrak proksi tidak berubah, jadi kedua versi tetap kompatibel.
