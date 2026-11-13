## 1. Fondasi berbagi (mealora-apps/mealora-mobile)

- [x] 1.1 Tambah `share_plus` ke `pubspec.yaml`
- [x] 1.2 Buat perender kartu: widget → `RepaintBoundary.toImage` (360×640, pixelRatio 3) → PNG di cache `share-cards/`
- [x] 1.3 Buat layanan berbagi: buka lembar berbagi sistem, hapus PNG setelah selesai/batal, bersihkan `share-cards/` saat start
- [x] 1.4 Buat bingkai kartu dasar (9:16, area aman, watermark logo + nama Mealora yang tidak bisa dimatikan)
- [x] 1.5 Buat layar pratinjau kartu dengan tombol Bagikan

## 2. Share Daily Summary

- [x] 2.1 Buat kartu ringkasan (tanggal, energi/target, persentase bulat, protein/karbohidrat/lemak) memakai format angka yang ada
- [x] 2.2 Tambah tombol Bagikan di header ruang Hari ini; nonaktif + keterangan bila belum ada catatan
- [x] 2.3 Test widget: isi kartu, tombol nonaktif, tanpa berat/program

## 3. Share Meal (jalur foto)

- [x] 3.1 Buat `FoodPhotoSavedScreen` (Bagikan, Selesai) dan arahkan `_confirm()` ke layar ini setelah `logFoodEntries` berhasil
- [x] 3.2 Pindahkan penghapusan berkas foto ke penutupan layar "Tersimpan" (Selesai/back/dispose); draf DB tetap dibuang segera
- [x] 3.3 Bersihkan berkas yatim di `food-photo-drafts/` saat start bila retensi `deleteAfterLogging`
- [x] 3.4 Buat kartu makanan (foto dengan `cacheWidth`, komponen + porsi + energi, total)
- [x] 3.5 Test widget: layar "Tersimpan" share/selesai, retensi hapus vs simpan, regresi alur foto 011

## 4. Copy

- [x] 4.1 Tambah copy kartu, layar "Tersimpan", dan keterangan tombol nonaktif ke ARB; tinjau terhadap nutrition-policy-v1

## 5. Verifikasi

- [x] 5.1 `flutter analyze` dan `flutter test` hijau
- [ ] 5.2 Uji manual di emulator: share ringkasan (online/offline), batal di lembar berbagi, `share-cards/` bersih
- [ ] 5.3 Uji manual alur foto end-to-end + share, serta matikan aplikasi saat layar "Tersimpan" (setelah kuota Gemini tersedia atau dengan mock)
