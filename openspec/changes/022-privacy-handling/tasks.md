## 1. mealora-mobile — Verifikasi codec (spike, timebox satu hari)

- [ ] 1.1 Pada emulator atau perangkat Android, kodekan ulang foto galeri yang memuat GPS dengan `flutter_image_compress` (`keepExif: false`), lalu pastikan berkas hasil tidak memuat EXIF, XMP, maupun thumbnail
- [ ] 1.2 Pastikan foto tegak dan foto miring (tag orientasi 6 dan 8) tampil benar setelah dikodekan ulang
- [ ] 1.3 Pastikan berkas HEIC, PNG, dan WebP dari galeri dapat didekode dan menghasilkan JPEG
- [ ] 1.4 Catat hasilnya di design.md D3, lalu putuskan pustaka akhir. Bila salah satu butir gagal, gunakan pustaka `image` di isolate

## 2. mealora-mobile — Langkah pembersihan gambar

- [ ] 2.1 Implementasikan `sanitizeForUpload(bytes, purpose)`: dekode, terapkan orientasi, perkecil ke batas tugas tanpa memperbesar, lalu kodekan ulang menjadi JPEG tanpa metadata
- [ ] 2.2 Tetapkan batas per tugas: foto makanan 1600 px kualitas 85; label gizi dan gambar nutrisi 2048 px kualitas 90
- [ ] 2.3 Jalankan pengolahan di luar isolate UI agar layar tidak tersendat
- [ ] 2.4 Lempar galat yang jelas bila dekode gagal atau hasil kosong; jangan pernah mengembalikan byte asli

## 3. mealora-mobile — Pemasangan di klien unggah

- [ ] 3.1 Panggil pembersihan di `vision_proxy_label_provider.dart` sebelum unggah ke `/extract-label`
- [ ] 3.2 Panggil pembersihan di `vision_proxy_food_component_provider.dart` sebelum unggah ke `/recognize-food-components`
- [ ] 3.3 Panggil pembersihan di `model_proxy_nutrition_reader.dart` sebelum unggah ke `/read-nutrition-image`
- [ ] 3.4 Petakan kegagalan pembersihan ke hasil "layanan tidak tersedia" yang sudah ada, dengan pesan umum yang sama dan tanpa membuat catatan
- [ ] 3.5 Tambahkan `maxWidth`/`imageQuality` pada `pickImage` galeri sebagai penghemat memori saja; jaminan privasi tetap di titik unggah

## 4. mealora-mobile — Uji otomatis

- [ ] 4.1 Uji pembersihan: masukan JPEG ber-EXIF dan ber-GPS menghasilkan berkas tanpa metadata
- [ ] 4.2 Uji ukuran: sisi terpanjang tidak melebihi batas tugas, perbandingan sisi tetap, gambar kecil tidak diperbesar
- [ ] 4.3 Uji orientasi: masukan dengan tag orientasi menghasilkan gambar yang sudah diputar tanpa tag
- [ ] 4.4 Uji kegagalan: byte rusak tidak menghasilkan permintaan jaringan apa pun, dan klien mengembalikan hasil "tidak tersedia"
- [ ] 4.5 Uji isi permintaan ketiga klien gambar dan dua klien teks: hanya berkas atau teks plus header `X-Proxy-Token`, tanpa data profil, target, riwayat, maupun pengenal perangkat

## 5. Verifikasi dan rilis

- [ ] 5.1 Jalankan himpunan uji label change 010 dengan gambar yang sudah diperkecil, dan pastikan keterbacaan tidak turun. Bila turun, naikkan batas label dan catat di design.md D4
- [ ] 5.2 Verifikasi di Android: foto galeri ber-GPS dan foto kamera terbaca lewat proksi, dan berkas yang dikirim (dicatat di build debug) tanpa metadata
- [ ] 5.3 Ukur waktu pembersihan di emulator untuk foto 12 MP dan catat hasilnya
- [ ] 5.4 Gate repo: `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test` lolos
- [ ] 5.5 Naikkan `version` di `pubspec.yaml`
- [ ] 5.6 Setelah build live di store, perbarui `latest_version` dan `release_notes` di `/app-config` `mealora-model-proxy` tanpa mengubah `min_supported_version`, dan minta konfirmasi sebelum deploy proksi
