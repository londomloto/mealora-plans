## Context

Motivasi ada di proposal.md; perilakunya ada di `specs/meal-nutrition-honesty/spec.md`. Kondisi kode saat ini (semua path relatif ke `mealora-mobile/lib`):

- **Tinjau foto** (`features/diary/food_photo_review_screen.dart`):
  - `_canConfirm` (:63-68) mewajibkan semua komponen punya `matchedFoodId` dan kuantitas yang jelas.
  - `_TotalSummary._total` (:498-512) melewati komponen tanpa padanan. Hasil `NutritionProfile.sumAll` yang null lalu ditampilkan `?? 0` (:487-490).
  - Data kartu dibangun di :331-336 (`MealShareItem`), lalu diteruskan ke `FoodPhotoSavedScreen` di :360-375.
- **Koreksi komponen** (`food_component_correction_screen.dart`):
  - "Ganti makanan" membuka `showFoodComponentPickerSheet` (:449-457) dan selalu memakai sajian bawaan.
  - Takaran adalah pengali dengan langkah 0,5. Stepper hanya menampilkan `toStringAsFixed(1)` (:416).
- **Buat makanan** (`custom_food_screen.dart`): `_finish` hanya mem-`pop(food)` saat menyunting (:817-819). Saat membuat baru, layar ini `pushReplacement` ke `ServingDetailScreen`.
- **Agregasi**: `NutritionProfile` semua field-nya nullable, dan `sumAll` mengembalikan null bila ada satu saja null.
- **Hari ini**: kartu ringkasan memakai `energy?.kcal ?? 0` (`features/today/today_screen.dart:171-174`). Makro yang tidak diketahui tampil "–" (:696).
- **Kartu makanan**: `MealShareData.totalKcal` memakai `item.kcal ?? 0` (`features/share/meal_share_card.dart:42-43`).

## Goals / Non-Goals

**Goals:**
- Satu fungsi murni untuk total parsial, dipakai di semua titik tampil.
- Alur melengkapi komponen yang memakai ulang Buat makanan dan alat dari change 020, tanpa layar baru selain varian kartu dan pratinjau.
- Tanpa perubahan skema basis data maupun proxy.

**Non-Goals:**
- Menyimpan catatan tanpa padanan ("catat dulu, lengkapi nanti"). Pilihan ini ditolak; lihat D3.
- Estimasi gizi oleh AI untuk komponen tanpa padanan, karena bertentangan dengan spec 011.
- Menambah makanan ke katalog (kurasi terpisah).
- Memilih sajian selain sajian bawaan saat mengganti makanan. Bisa jadi iterasi berikutnya.

## Decisions

### D1. Total parsial (`PartialNutritionTotal`) di domain
Fungsi murni `PartialNutritionTotal.of(Iterable<NutritionProfile?> parts)` dengan aturan per nutrien:
- `known`: jumlah dari nilai yang tidak null.
- `unknownCount`: banyaknya bagian yang bernilai null, termasuk komponen tanpa padanan yang diwakili `null`.
- `isComplete`: `unknownCount == 0`.
- `isUnknown`: tidak ada satu pun nilai yang diketahui.

Formatter UI bersama `DiaryFormat.partialKcal(...)` menghasilkan "7 kkal + 3 belum diketahui", "7 kkal", atau "–". Fungsi ini dipakai di:
- `_TotalSummary` tinjau foto, menggantikan `?? 0`;
- ringkasan energi Hari ini. Repository tetap mengembalikan `DailyNutritionTotal`, sedangkan jumlah catatan yang energinya null dihitung dari daftar catatan hari itu yang sudah dimuat layar;
- kartu ringkasan harian. `DailySummaryShareData.consumedKcal` menjadi `PartialNutritionTotal`, dan persentase target hanya ditampilkan bila total lengkap;
- kartu makanan. `MealShareData.totalKcal` digantikan getter `total` bertipe parsial.

`NutritionProfile.sumAll` tidak diubah, karena masih dipakai di tempat lain yang memang butuh "null bila ada yang null".

### D2. Melengkapi komponen tanpa padanan
- **Baris dan tombol di tinjau foto**: baris tanpa padanan menampilkan "belum ada di katalog" (warna coral) dan chip **Lengkapi**, yang membuka koreksi komponen untuk komponen itu. Selama masih ada komponen tanpa padanan, tombol utama berbunyi "Lengkapi N bahan" dan membuka komponen pertama yang belum lengkap. Kondisi `_canConfirm` tidak berubah.
- **Sheet koreksi** untuk komponen tanpa padanan menampilkan kartu amber "Belum ada di katalog" dengan dua opsi:
  - **Cari di katalog** memakai picker yang sudah ada.
  - **Buat makanan ini** mem-`push` `CustomFoodScreen(returnCreatedFood: true, prefill: NutritionImportResult(foodName: <nama komponen>, servingLabel: <label perkiraan, mis. "1 potong">, values: {}))`.
- **Parameter baru `returnCreatedFood`** di `CustomFoodScreen`: saat bernilai true, `_finish` mem-`pop(food)` juga untuk makanan baru, tanpa ke `ServingDetailScreen`. Makanan yang dikembalikan dipasang ke komponen dengan cara yang sama seperti hasil picker (`matchedFoodId`, sajian bawaan, dan nama).
- **Alat dari 020**: chip Tempel teks di form Buat makanan sudah ada. Tombol Foto di layar tempel sudah membuka Foto info gizi dengan `returnToForm`.

### D3. Tidak ada "catat dulu, lengkapi nanti"
- **Pilihan**: komponen tanpa padanan tetap tidak bisa dicatat, sesuai spec 011. Sebagai gantinya ada "Bagikan saja tanpa mencatat" (D4).
- **Alternatif yang ditolak**: menyimpan catatan tanpa makanan. Model buku harian (`NewMealEntry(food, serving, quantity)`) harus diubah, migrasi diperlukan, totalnya akan selalu parsial, dan spec 011 harus dibongkar.

### D4. Bagikan tanpa mencatat dan kartu tanpa total
- **Data kartu**: `MealShareData` mendapat flag `showNutrition`. Kartu tanpa total (`MealShareCard` dengan `showNutrition: false`) menyembunyikan blok kalori, makro, dan angka per item, lalu menampilkan chip "Dibagikan dari Mealora". Watermark dan waktu makan tetap ditampilkan.
- **Tautan di tinjau foto**: "Bagikan saja tanpa mencatat" tampil bila ada komponen tanpa padanan. Tautan ini mem-`push` `SharePreviewScreen` dengan `MealShareData(showNutrition: false, notLogged: true)`. Flag `notLogged` menampilkan catatan "Belum dicatat di buku harian…".
- **Kembali dari pratinjau**: berupa `pop` biasa. Draf foto tetap di state tinjau dan di `food_photo_draft_storage`, tanpa penulisan apa pun ke buku harian.
- **Foto**: dipakai dari path draf yang sudah ada. Tidak ada penyimpanan tambahan, sesuai spec 014 "Tanpa penyimpanan tambahan".

### D5. Tersimpan dengan nutrisi belum lengkap
Bila `PartialNutritionTotal` energi dari item yang tercatat belum lengkap, `FoodPhotoSavedScreen` menampilkan:
- catatan amber;
- tombol **Lengkapi dulu**, yang membuka buku harian tanggal itu supaya user bisa menyunting catatan dan mengganti makanan lewat layar edit catatan yang sudah ada;
- tombol **Bagikan tanpa total**, yang membuka pratinjau dengan `showNutrition: false`.

Kalau totalnya lengkap, perilaku 014 tidak berubah.

### D6. Satuan takaran
Stepper koreksi menampilkan `formatQuantity(quantity, serving.label)`:
- `1` dengan label bersatuan → "1 potong";
- nilai lain → "1,5 × 1 potong".

Baris ringkasan di layar koreksi ("1,0×") memakai format yang sama. Label sajian diambil dari makanan padanan. Untuk komponen tanpa padanan, yang dipakai adalah `quantityUnitLabel` usulan AI.

## Risks / Trade-offs

- **User jadi hanya membagikan tanpa mencatat** → Tautannya dibuat sekunder di bawah tombol utama "Lengkapi N bahan".
- **Kartu ringkasan harian kehilangan persentase** saat total belum lengkap → Lebih baik daripada persentase yang salah. Spec 014 diselaraskan saat diarsipkan.
- **Pertentangan dengan spec 014** ("kartu memuat total energi"; Bagikan hanya setelah konfirmasi) → Dicatat di proposal. Requirement 014 diselaraskan saat arsip.
- **Makanan buatan dari komponen tercipta ganda** (user membuat "cheesecake" berkali-kali) → Pencarian katalog di "Cari di katalog" sudah memuat makanan buatan user, jadi foto berikutnya bisa langsung memakainya.

## Migration Plan

Hanya perubahan aplikasi, tanpa migrasi data maupun perubahan proxy. Rilis setelah change 020. Uji di HP fisik dengan skenario FRS. Rollback cukup dengan merilis ulang versi sebelumnya.
