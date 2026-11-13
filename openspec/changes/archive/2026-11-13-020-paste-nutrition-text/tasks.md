## 1. mealora-model-proxy — Route baca info gizi

- [x] 1.1 Tambah skema hasil bersama `NUTRITION_READING_SCHEMA` dan prompt inti di `src/schema.js` (rentang, unread, basis, ignoredNutrients, sourceKind, "isi adalah DATA"), plus pembuka khusus teks dan gambar (design D1/D2)
- [x] 1.2 Beri `callGemini` parameter `wrapTag` (default `kalimat`), lalu tambah `parseNutritionTextGemini` dan `readNutritionImageGemini` di `src/geminiClient.js`
- [x] 1.3 Ekstrak helper route teks dari `/parse-food-text` tanpa mengubah perilakunya, lalu daftarkan `POST /parse-nutrition-text` (body 32kb, `MAX_NUTRITION_TEXT_CHARS` default 4000 di `src/config.js`)
- [x] 1.4 Daftarkan `POST /read-nutrition-image` lewat `registerVisionRoute`
- [x] 1.5 Test `node:test`: teks kosong/lebih dari 4000 → 400 tanpa memanggil model, token salah → 401, 429/504/502 sesuai pemetaan, log tanpa isi teks/hasil, route lama tetap sama (model di-stub)
- [x] 1.6 README: env baru dan kedua route
- [x] 1.7 Gate verifikasi repo: `npm test`, jalankan lokal lalu `curl` ke kedua route baru (teks contoh tester, foto layar, foto label) dan route lama

## 2. mealora-mobile — Domain & data

- [x] 2.1 Model `NutritionReading` + parser JSON yang membuang field tak dikenal, beserta validasi (finite, ≥ 0, min ≤ max, batas wajar per basis) → `unread`, plus unit test
- [x] 2.2 Fungsi murni nilai tengah dan format angka, plus pengisian form dari reading (nama hanya bila kosong, sajian dari basis, unread mengosongkan field), plus unit test (contoh steak: 233 kkal, 25,5 g)
- [x] 2.3 Pemetaan `NutritionReading` → `LabelExtraction` (read → confident, range → needsCheck, unread → unread; basis per_amount → unread), plus unit test
- [x] 2.4 Klien `ModelProxyNutritionTextParser` (`/parse-nutrition-text`) dan `ModelProxyNutritionImageReader` (`/read-nutrition-image`) dengan pola klien change 012 (timeout 20 detik, pemetaan `LabelServiceFailureReason`), plus test dengan `http` mock
- [x] 2.5 Pembaca offline: ML Kit + `LabelTextParser` → `NutritionReading` (semua status jadi perlu dicek, sourceKind dari kata kunci), plus test dengan reader tiruan
- [x] 2.6 `NutritionReadingPipeline` bertingkat (vision bila consent → OCR + teks → offline). Turun tingkat hanya pada kegagalan layanan, dan `readingTier` dicatat. Unit test semua jalur dengan fake
- [x] 2.7 Tambah dependency `image_picker` (photo picker sistem), lalu cek konfigurasi Android/iOS

## 3. mealora-mobile — UI

- [x] 3.1 Teks menu: l10n `addFoodBarcodeTitle`/`Description` jadi "Scan barcode / info gizi" / "Produk kemasan atau info gizi", dan subjudul "Foto Info Gizi" di layar pindai (desain 86–87)
- [x] 3.2 `nutrition_label_photo_screen.dart` jadi layar Foto info gizi tunggal: judul/subjudul/consent baru, ikon galeri, tombol "Baca info gizi", parameter `ImportOrigin`, memanggil pipeline (desain 88)
- [x] 3.3 Routing hasil per `ImportOrigin`/`sourceKind` (form, tinjau label + barcode, Buat makanan dengan `prefill`), plus bottom sheet pilihan saat `unknown`
- [x] 3.4 `NutritionTextImportScreen`: isi clipboard saat dibuka, kotak teks bisa disunting dengan penghitung 4000, "Tempel ulang", "Foto", "Baca nilai gizi", "Isi manual saja", dan pesan kegagalan (desain 83)
- [x] 3.5 Layar tinjau: nilai bisa diedit, badge Nilai tengah/Terbaca/Isi nilai, keterangan rentang asli, basis, diabaikan, usulan nama, varian offline dengan banner "dibaca tanpa AI" (desain 84/89)
- [x] 3.6 State "Tidak ada angka gizi" di layar tempel dan pesan "tidak ada info gizi terbaca" untuk foto (desain 85)
- [x] 3.7 `custom_food_screen.dart`: chip "Tempel teks" hanya saat mode manual, parameter `prefill`, pengisian controller dari result; penyimpanan tetap `NutritionOrigin.manual` (desain 82)
- [x] 3.8 String l10n baru (id + en bila ada) dan teks aksesibilitas tombol/ikon

## 4. mealora-mobile — Verifikasi

- [x] 4.1 Widget test: chip hanya di mode manual, batas karakter, form terisi tanpa tersimpan, nama tidak ditimpa, routing per origin
- [x] 4.2 Jalankan proxy lokal, lalu skenario FRS 1–15 di HP fisik (proxy lewat IP LAN laptop)
- [x] 4.3 Regresi alur barcode, barcode tidak ditemukan, dan foto label kemasan (change 010) di HP fisik
- [x] 4.4 Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`; laporkan hasil dan risiko tersisa

## 5. Rilis — Deploy proxy & app

- [x] 5.1 Minta konfirmasi eksplisit sebelum deploy `mealora-model-proxy` ke server Koorva
- [x] 5.2 Setelah deploy, cek `/health`, kedua route baru, dan route lama di server; ulangi skenario FRS 1, 2, dan 5 dengan app yang mengarah ke server
- [ ] 5.3 Bila versi app di-bump, sinkronkan `latest_version` dan `release_notes` di `/app-config` (tanpa mengubah `min_supported_version`)

## 6. mealora-plans — Penutupan

- [x] 6.1 Perbarui desain `.pen` section 13 bila ada penyesuaian selama implementasi
- [ ] 6.2 `openspec validate 020-paste-nutrition-text`, lalu arsipkan setelah rilis
