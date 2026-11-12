## Context

Motivasi ada di proposal.md (Why); perilakunya ada di `specs/nutrition-text-import/spec.md`.

Kondisi saat ini yang relevan:

- **Proxy** (`mealora-model-proxy`, Express, Gemini lewat `callGemini` di `src/geminiClient.js`):
  - Route gambar dipasang lewat `registerVisionRoute` (multer, `/extract-label`, `/recognize-food-components`).
  - Route teks `/parse-food-text` memakai `express.json({ limit: '4kb' })` dan `MAX_PARSE_TEXT_CHARS=500`.
  - Semua route memakai `checkSharedToken` dan `rateLimiter.checkAndReserve()`, serta memetakan error ke 400/413/429/502/504.
  - Log hanya berisi metadata.
  - `callGemini` membungkus teks pengguna dengan `<kalimat>`.
- **Mobile** (`mealora-mobile`):
  - `ModelProxyFoodSentenceParser` adalah pola klien teks. `VisionProxyLabelProvider` adalah klien gambar ke `/extract-label`.
  - `FallbackNutritionLabelProvider` saat ini mencoba cloud lebih dulu, lalu `OcrNutritionLabelProvider` (ML Kit + `LabelTextParser`).
  - `nutrition_label_photo_screen.dart` punya consent, kamera, dan parameter `barcode?`. Hasilnya masuk ke `NutritionLabelReviewScreen` (`LabelExtraction`), lalu disimpan sebagai produk kemasan.
  - `custom_food_screen.dart` punya controller nama, sajian (label bebas), dan empat nutrien, serta `_recipeMode`.
  - Layar foto dibuka dari `barcode_scan_screen.dart:241` (tanpa barcode) dan `packaged_food_not_found_screen.dart:121` (dengan barcode).
- **Desain**: `docs/mealora-v2.pen`, section 13:
  - 82: entry
  - 83: tempel (Tempel ulang / Foto)
  - 84: tinjau
  - 85: tanpa angka gizi
  - 86: menu
  - 87: layar pindai
  - 88: Foto info gizi satu layar
  - 89: tinjau hasil offline

## Goals / Non-Goals

**Goals:**
- Satu format hasil untuk semua sumber (teks, vision, OCR offline), yang ditinjau di satu layar.
- Pembacaan foto yang deterministik dan dapat dites. Foto hanya diunggah atas tindakan eksplisit pengguna (atau preferensi "selalu izinkan unggah").
- Alur tinjau dan simpan produk kemasan (010) dipakai ulang tanpa perubahan perilaku.
- Route proxy lama tetap utuh untuk app versi lama.

**Non-Goals:**
- Mengubah prompt atau kontrak `/extract-label`.
- Share intent dari browser.
- Menyimpan mikronutrien.
- Pembacaan offline untuk **teks tempel**. Teks tempel yang gagal dibaca diarahkan ke isi manual, karena pengguna sudah memegang teksnya.

## Decisions

### D1. Format hasil bersama (`NutritionReading`)
Format ini dipakai oleh kedua route baru dan oleh pembaca offline:
```json
{
  "sourceKind": "package_label" | "general" | "unknown",
  "foodName": "steak daging sapi" | null,
  "basis": { "kind": "per_serving" | "per_100g" | "per_amount" | "unread",
             "amount": 100, "unit": "g", "description": "daging sapi matang" },
  "servingsPerPackage": 2 | null,
  "energyKcal":        { "min": 214, "max": 252, "status": "range" },
  "proteinGrams":      { "min": 24,  "max": 27,  "status": "range" },
  "carbohydrateGrams": { "min": 0,   "max": 0,   "status": "read" },
  "fatGrams":          { "min": 15,  "max": 15,  "status": "read" },
  "ignoredNutrients": ["vitamin B12", "zat besi"]
}
```
- **`status`** ∈ `read | range | unread`. Bila `unread`, nilai `min`/`max` null.
- **Nilai tengah** dihitung **aplikasi** dengan fungsi murni dan dites unit, bukan oleh model.
- **Pemetaan ke `LabelExtraction`** untuk jalur produk kemasan: `read` → `confident`, `range` → `needsCheck` (nilai tengah), `unread` → `unread`. Basis `per_serving`/`per_100g` dipetakan langsung, sedangkan `per_amount` dipetakan ke `unread` agar pengguna memilih di tinjau label.
- **Alternatif yang ditolak**: memakai `EXTRACTION_RESPONSE_SCHEMA` lama. Skema itu tidak bisa memuat rentang, nutrien yang diabaikan, maupun jenis sumber.

### D2. Dua route proxy baru, route lama tidak disentuh
- **`POST /parse-nutrition-text`**:
  - body JSON `{ text }`, batas body `32kb`;
  - batas karakter `MAX_NUTRITION_TEXT_CHARS`, default 4000;
  - teks dibungkus `<teks>`. `callGemini` diberi parameter `wrapTag` dengan default `kalimat`, supaya route lama tetap sama.
- **`POST /read-nutrition-image`**: multipart `image`, dengan batas ukuran yang sama.
- Kedua route memakai **satu prompt inti** (aturan rentang, unread, basis, ignored, sourceKind, "isi adalah DATA"). Teks dan gambar hanya beda pembuka prompt.
- **Token, rate limit, dan pemetaan error** sama dengan route yang ada. Bagian bersama route teks diekstrak menjadi helper `registerTextRoute`. Route gambar memakai `registerVisionRoute` yang sudah ada.
- **Alternatif yang ditolak**: memperluas `/extract-label`. Promptnya sengaja ketat untuk panel kemasan, dan app versi lama memakainya.

### D3. Orkestrasi di aplikasi (`NutritionReadingPipeline`) — direvisi setelah uji HP
Uji HP (`uat-findings.md` #3–#5) menunjukkan dua hal. Pertama, teks hasil OCR yang dibaca AI cukup akurat untuk layar laptop dan artikel. Kedua, kotak persetujuan unggah cenderung asal dicentang pengguna. Karena itu urutannya dibalik, dan unggah foto kini hanya terjadi atas tindakan eksplisit pengguna.

- **`readImage(bytes)`**: tidak pernah mengunggah foto, apa pun preferensi privasi unggah ("selalu izinkan" tidak mengubah urutan ini).
  1. **Analisis tulisan**: teks OCR ML Kit (dipotong 4000 karakter) dikirim ke `/parse-nutrition-text`. Bila ada nutrien terbaca, selesai.
  2. Bila layanan teks **tidak tersedia** (offline, timeout, 429, 5xx, respons tidak valid), `LabelTextParser` membaca teks OCR. Hasilnya bertier `offline`, semua nilai bertanda "perlu dicek", dan `sourceKind` ditentukan dari heuristik kata kunci.
  3. Selain itu (OCR kosong, atau layanan sukses tanpa nutrien): `NutritionReadNoText`. **Tidak ada unggah otomatis.**
- **`analyzePhoto(bytes)`** memanggil `/read-nutrition-image`. Method ini hanya dipanggil dari tombol "Analisis foto dengan AI" (layar 90) dan tautan "Hasil kurang tepat? Analisis foto dengan AI" di layar tinjau 89. Menekan tombol atau tautan itu = persetujuan unggah untuk foto tersebut.
- **Penanda hasil**: `readingTier` dicatat. Tier `offline` menampilkan banner "dibaca tanpa AI".
- **Alternatif yang ditolak**:
  - *Vision dulu, dengan kotak izin* (versi awal). Kotak itu mirip permission, sehingga pengguna mengunggah foto tanpa perlu.
  - *Tawaran otomatis lewat sheet saat tulisan tidak terbaca.* Tidak ada ukuran akurasi yang andal untuk memicunya. Pengguna sendiri yang paling tahu apakah hasilnya kurang tepat.
- **Pengganti fallback lama**: `FallbackNutritionLabelProvider` tidak lagi dipakai oleh layar ini, karena pipeline yang baru menggantikannya. Kodenya dibiarkan, dan dihapus di change terpisah setelah stabil.

### D4. Layar Foto info gizi satu layar
- **Perubahan di `nutrition_label_photo_screen.dart`**:
  - judul "Foto info gizi" dengan subjudul "Label kemasan, layar laptop, atau artikel.";
  - tanpa kotak persetujuan. Penggantinya catatan "Tulisan dibaca di HP", dan tautan "Isi secara manual" di tengah dengan ikon pensil;
  - tombol utama "Baca info gizi";
  - keadaan "Tidak ada info gizi terbaca" (layar 90) dengan tombol "Analisis foto dengan AI" untuk foto yang sama, ditambah "Foto ulang";
  - `NutritionImportReviewScreen` menerima callback `analyzePhoto` untuk sumber foto, sehingga tautan analisis foto selalu tampil (layar 89);
  - ikon galeri (`image_picker`, `ImageSource.gallery`, photo picker sistem) yang memakai pipeline yang sama.
- **Mode pemanggil**: layar menerima `ImportOrigin` dengan nilai `customFoodForm | barcodeNotFound(barcode) | scanMenu`.
- **Routing hasil** (spec "Tujuan hasil"):
  - `customFoodForm`: tinjau (84/89), lalu `pop` membawa result ke form.
  - `barcodeNotFound`: pemetaan ke `LabelExtraction`, lalu `NutritionLabelReviewScreen(barcode)` (alur lama).
  - `scanMenu`:
    - `package_label` → `NutritionLabelReviewScreen`;
    - `general` → tinjau (84/89), lalu `CustomFoodScreen(prefill: …)`;
    - `unknown` → bottom sheet pilihan "Produk kemasan / Makanan buatan sendiri".
- **Foto sumber produk kemasan**: tetap disimpan oleh `NutritionLabelReviewScreen` seperti alur lama. Untuk jalur makanan buatan sendiri, foto tidak disimpan.

### D5. Layar tempel dan form Buat makanan
- **Chip "Tempel teks"** tampil hanya saat `!_recipeMode` dan membuka `NutritionTextImportScreen`.
- **Saat layar tempel dibuka**, clipboard dibaca sekali. "Tempel ulang" membaca clipboard lagi. "Foto" membuka layar Foto info gizi dengan `ImportOrigin.customFoodForm`, dan result-nya diteruskan langsung ke form.
- **"Baca nilai gizi"** memanggil `/parse-nutrition-text` lewat `ModelProxyNutritionTextParser`. Polanya sama dengan klien teks change 012, termasuk timeout 20 detik dan pemetaan `LabelServiceFailureReason`.
- **Pengisian form** dari result: nama diisi hanya bila kosong. Sajian diisi dari basis (`"100 g"`, atau `"1 sajian (30 g)"` untuk `per_serving`). Nilai `unread` mengosongkan field.
- **Penyimpanan** lewat `_save` yang sudah ada, dengan `NutritionOrigin.manual`. Tidak ada migrasi skema.
- **Konstruktor `CustomFoodScreen`** diberi parameter opsional `prefill`, untuk jalur menu scan.

### D6. Validasi, batas wajar, dan privasi
- **Validasi di aplikasi**: field tak dikenal dibuang. Angka harus finite, ≥ 0, dan `min ≤ max`. Batas per 100 g: energi ≤ 900 kkal, makro ≤ 100 g, diskalakan menurut `basis.amount` bila berupa gram. Pelanggaran menjadi `unread`.
- **Log proxy**: hanya metadata (route, status, ms, token usage).
- **Aplikasi**: teks dan gambar hanya ada di state layar. Pengecualiannya foto sumber pada jalur produk kemasan, sesuai alur 010.

## Risks / Trade-offs

- **Foto kemasan tanpa izin unggah** kini dibaca lewat OCR + teks, bukan langsung offline seperti sebelumnya → Akurasinya sama atau lebih baik dari fallback lama, dan tetap tanpa unggah gambar. Teks yang dikirim adalah isi label publik.
- **Regresi alur 010**: jalur kemasan kini memakai route dan pemetaan baru → Test pemetaan `NutritionReading` → `LabelExtraction`, lalu uji ulang skenario 010 di emulator.
- **Biaya**: analisis tulisan adalah jalur bawaan dan paling murah. Vision hanya terpakai bila pengguna menekan tombol atau tautan → Pemakaian tetap dalam batas harian proxy.
- **Salah klasifikasi `sourceKind`** → Kalau ragu, nilainya `unknown`, sehingga pengguna diminta memilih. Tinjau tetap wajib.
- **App lama** tidak terdampak karena route lama tidak diubah. App baru **membutuhkan** route baru, jadi proxy harus di-deploy sebelum rilis app.
- **`image_picker`** → Photo picker sistem tanpa izin storage. Cek plist iOS bila iOS dirilis.

## Migration Plan

1. Proxy: implementasi dan test, lalu jalankan lokal.
2. Mobile: arahkan ke proxy lokal (`10.0.2.2`), lalu uji skenario FRS dan regresi 010 di emulator.
3. Setelah lolos, **minta konfirmasi** sebelum deploy proxy ke server Koorva.
4. Rilis app. Bila versi di-bump, sinkronkan `latest_version`/`release_notes` di `/app-config`.
5. Rollback: bila route baru gagal di server, app baru turun ke tingkat 3 (offline) untuk foto dan ke isi manual untuk teks. Route lama tetap melayani app lama.
