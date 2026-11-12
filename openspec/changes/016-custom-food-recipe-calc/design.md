## Context

Kondisi saat ini di `mealora-mobile` (motivasi ada di proposal.md, bagian Why):

- `custom_food_screen.dart` mengisi nama, label sajian, energi, protein, karbohidrat, dan lemak, lalu memanggil `createUserFood` dengan `ServingSizeInput(amount: 1, unit: 'porsi')` tanpa `gramEquivalent`. Ada juga `updateUserFood` di `FoodRepository`.
- Gizi disimpan **per takaran** (`nutrition_values` unik per `servingId`), bukan per 100 g. Gizi per gram sebuah bahan katalog didapat secara matematis dari takaran yang punya `gramEquivalent`: `nutrisi_takaran / gramEquivalent`. Seluruh 1.346 item katalog sekarang punya takaran 100 g dengan `gramEquivalent = 100`.
- `NutritionProfile` memakai nilai nullable, jadi "belum diketahui" sudah terwakili.
- `showFoodComponentPickerSheet` (change 011) memakai ulang `foodSearchProvider` untuk memilih makanan, termasuk membuat makanan baru. Pola ini dipakai ulang untuk memilih bahan.
- `meal_entry_items` menyimpan snapshot gizi, sehingga riwayat aman dari perubahan resep.

## Goals / Non-Goals

**Goals:**
- Hitungan deterministik dan dapat dites. Fungsi hitungnya murni, tanpa I/O.
- Tidak mengubah jalur isi manual maupun makanan buatan pengguna yang sudah ada.
- Memakai ulang pencarian dan pembuatan makanan yang sudah ada untuk pemilihan bahan.

**Non-Goals:**
- Faktor perubahan berat karena memasak (*yield factor*) atau retensi zat gizi. Berat jadi diisi pengguna, tidak diperkirakan sistem.
- Usulan bahan otomatis dari nama masakan (AI). Bisa jadi change lanjutan dengan pola foto/suara, di mana usulan selalu dikonfirmasi pengguna.
- Berbagi resep antar-pengguna atau sinkronisasi.
- Resep bertingkat lebih dari satu level dihitung otomatis. Makanan hasil hitungan boleh dipakai sebagai bahan, tapi diperlakukan sebagai bahan biasa memakai gizi yang tersimpan, tanpa membuka resep di dalamnya.

## Decisions

### D1. Fungsi hitung murni `RecipeCalculator` di domain

Lokasinya `lib/domain/food/recipe_calculator.dart`. Masukannya daftar `RecipeIngredient` berisi (gizi per takaran, `gramEquivalent` takaran atau null, jumlah gram atau kelipatan takaran) dan hasil resep (jumlah porsi dan/atau berat jadi). Keluarannya total, per sajian, opsional per 100 g hasil, serta daftar zat gizi yang tidak lengkap beserta bahan penyebabnya.

- Kontribusi bahan untuk jumlah gram: `nutrisi_takaran × gram / gramEquivalent`. Untuk takaran 100 g, ini sama dengan rumus per 100 g di spec.
- Kontribusi bahan untuk kelipatan takaran: `nutrisi_takaran × kelipatan`.
- Zat yang null pada bahan mana pun ditandai tidak lengkap. Totalnya tetap dihitung dari bahan yang diketahui, tapi ditampilkan sebagai "tidak lengkap", tidak pernah sebagai angka yang tampak lengkap.
- Pembulatan hanya dilakukan saat tampil (1 desimal). Nilai disimpan tanpa pembulatan antara.

*Alternatif: menghitung langsung di widget.* Ditolak karena tidak bisa dites unit dan menduplikasi logika di layar sunting.

### D2. Tabel baru `recipe_ingredients` + kolom `nutritionOrigin` di `foods`

- `recipe_ingredients`: `id`, `recipeFoodId` (FK makanan buatan pengguna, `onDelete: cascade`), `ingredientFoodId` (FK makanan, nullable untuk bahan tanpa data, `onDelete: restrict`), `ingredientServingId` (FK takaran, nullable), `freeTextName` (nullable, untuk bahan tanpa data), `grams` (nullable), `servingMultiple` (nullable), `position`. Aturannya: tepat salah satu dari `grams` atau `servingMultiple` terisi, dan tepat salah satu dari `ingredientFoodId` atau `freeTextName` terisi. Aturan ini ditegakkan oleh CHECK constraint dan validasi domain.
- Hasil resep disimpan di kolom `foods`: `recipeYieldServings` dan `recipeYieldGrams` (nullable).
- `foods.nutritionOrigin`: `manual` | `recipe`, nullable. Untuk makanan buatan pengguna lama, nilainya diisi `manual` saat migrasi.
- Takaran makanan hasil hitungan: "1 porsi" (gizi per sajian). Bila berat jadi diisi, ditambah takaran "100 g" dengan `gramEquivalent = 100` dan takaran porsi diberi `gramEquivalent = beratJadi / porsi`. Dengan begitu makanan ini bisa dicatat dalam gram dan dipakai sebagai bahan resep lain.

*Alternatif: menyimpan resep sebagai JSON di satu kolom.* Ditolak karena FK ke bahan hilang dan pencegahan penghapusan bahan yang dipakai resep tidak bisa ditegakkan.

### D3. Hitung ulang hanya saat disunting

Gizi resep disimpan sebagai nilai takaran biasa, sama seperti makanan lain, sehingga pencarian, pencatatan, dan dashboard tidak berubah. Hitung ulang dari bahan dilakukan hanya saat pengguna membuka layar sunting resep, sesuai spec. Kalau nilai katalog berubah karena change 015, makanan resep tidak berubah diam-diam. Pengguna melihat angka baru saat menyunting dan menyimpan.

*Alternatif: hitung ulang otomatis setiap seed katalog berubah.* Ditolak karena angka makanan pengguna akan berubah tanpa sepengetahuannya.

### D4. Koreksi manual mengubah asal menjadi `manual`

Kalau pengguna mengubah nilai hasil hitungan di kolom gizi, `nutritionOrigin` menjadi `manual`. Resepnya tetap disimpan sebagai rujukan, tapi tidak lagi menjadi sumber angka. Saat disunting, sistem menawarkan "hitung ulang dari bahan", yang akan menimpa koreksi tersebut setelah dikonfirmasi pengguna.

### D5. Pemilihan bahan memakai ulang komponen foto

Lembar pemilihan bahan dibangun dengan memakai ulang `showFoodComponentPickerSheet` (pencarian dan pembuatan makanan baru). Tambahannya:

- Pilihan "tambah tanpa data gizi" (nama saja).
- Saat membuat bahan baru dari lembar ini, layar buat makanan menawarkan pengisian **per 100 g** (takaran 100 g dengan `gramEquivalent = 100`), supaya bahan bisa dipakai dengan gram.
- Setelah bahan dipilih, pengguna memasukkan jumlah: gram untuk takaran dengan `gramEquivalent`, atau kelipatan takaran untuk yang tidak.

### D6. Bentuk bahan dan pengingat minyak

Bentuk bahan ditampilkan dari kolom `foods.form` milik change 015. Kalau 016 dirilis sebelum 015, bentuk tidak ditampilkan, tanpa mengubah perilaku lain. Pengingat minyak berupa teks statis di layar resep dan tidak memaksa.

## Risks / Trade-offs

- [Pengguna memasukkan berat bahan mentah dengan bahan katalog bentuk matang, atau sebaliknya] → Bentuk bahan ditampilkan (D6), ditambah teks bantuan tentang mentah/matang. Sistem tidak bisa menebak niat pengguna.
- [Minyak goreng terlupa sehingga energi terlalu rendah] → Ada pengingat. Sistem tidak menambah minyak otomatis karena itu tebakan.
- [Bahan yang dipakai resep dihapus pengguna] → FK `restrict` menolak penghapusan, dan UI menjelaskan bahan itu dipakai di resep mana.
- [Konflik nomor versi migrasi dengan 015] → Migrasi ditulis dengan nomor berikutnya saat implementasi, mengikuti change mana yang dirilis lebih dulu.

## Migration Plan

1. Migrasi skema: buat `recipe_ingredients`, tambah `foods.nutritionOrigin`, `recipeYieldServings`, dan `recipeYieldGrams`. Isi `nutritionOrigin = 'manual'` untuk baris `isUserCreated = true`.
2. Tidak ada perubahan data katalog maupun catatan.
3. Rollback dilakukan dengan rilis maju, sama seperti migrasi sebelumnya. Data resep baru tidak dibaca versi lama.
