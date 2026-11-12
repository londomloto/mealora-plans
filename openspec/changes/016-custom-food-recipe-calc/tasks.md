## 1. mealora-mobile — Kalkulator & skema

- [ ] 1.1 Pastikan change 007 sudah diarsipkan sebelum mengarsipkan change ini; tentukan urutan rilis terhadap 015 untuk nomor versi migrasi
- [ ] 1.2 Buat `lib/domain/food/recipe_calculator.dart` (fungsi murni): kontribusi gram = nutrisi_takaran × gram / gramEquivalent, kontribusi kelipatan = nutrisi_takaran × kelipatan, total, per porsi, per 100 g hasil, daftar zat tidak lengkap beserta bahan penyebab
- [ ] 1.3 Test unit kalkulator: contoh spec (358 kkal, 300 kkal/porsi, 150 kkal/100 g), bahan dengan nilai null, bahan tanpa data, validasi jumlah/porsi/berat ≤ 0
- [ ] 1.4 Migrasi skema: tabel `recipe_ingredients` (dengan CHECK tepat-satu untuk gram/kelipatan dan food/nama bebas), `foods.nutritionOrigin`, `foods.recipeYieldServings`, `foods.recipeYieldGrams`; isi `nutritionOrigin = 'manual'` untuk makanan buatan pengguna lama
- [ ] 1.5 Test migrasi: makanan buatan pengguna lama utuh dan bertanda `manual`, catatan makan tidak berubah

## 2. mealora-mobile — Repository

- [ ] 2.1 Perluas `FoodRepository`: buat/sunting makanan resep beserta bahannya dalam satu transaksi; baca resep untuk layar sunting
- [ ] 2.2 Takaran makanan resep: "1 porsi" (gizi per sajian); bila berat jadi diisi, tambah takaran "100 g" dan isi `gramEquivalent` porsi
- [ ] 2.3 Tolak penghapusan makanan yang dipakai sebagai bahan resep, dengan pesan yang menyebut resepnya
- [ ] 2.4 Test repository untuk 2.1–2.3, termasuk catatan lama tidak berubah setelah resep disunting

## 3. mealora-mobile — UI

- [ ] 3.1 Rancang layar resep (bagian "Hitung dari bahan", daftar bahan, hasil resep, rincian) di `docs/mealora-v2.pen` dan minta persetujuan pemilik produk
- [ ] 3.2 Layar buat/sunting makanan sendiri: isi manual tetap bawaan; tambah bagian "Hitung dari bahan"
- [ ] 3.3 Pemilihan bahan: pakai ulang `showFoodComponentPickerSheet`; tambah "buat bahan baru" dengan pengisian per 100 g dan "tambah tanpa data gizi"
- [ ] 3.4 Masukan jumlah per bahan: gram hanya untuk takaran ber-`gramEquivalent`, selain itu kelipatan takaran; tampilkan bentuk bahan bila tersedia (`foods.form` dari 015)
- [ ] 3.5 Hasil resep (porsi dan opsional berat jadi), rincian kontribusi tiap bahan, total per sajian, penanda "tidak lengkap" beserta bahan penyebab, pengingat minyak goreng
- [ ] 3.6 Hasil mengisi kolom gizi; koreksi manual mengubah asal menjadi `manual`; saat sunting tawarkan "hitung ulang dari bahan" dengan konfirmasi
- [ ] 3.7 Teks UI baru di `AppText` (Bahasa Indonesia)

## 4. mealora-mobile — Verifikasi

- [ ] 4.1 Test widget untuk skenario spec: isi manual tanpa bahan, menjumlahkan bahan, takaran "1 butir", bahan tanpa data, membuat bahan baru dari pemilihan, koreksi hasil, sunting resep
- [ ] 4.2 Jalankan skenario uji FRS 1–9 di emulator Android (`flutter run -d emulator-5554`)
- [ ] 4.3 Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`; laporkan hasil dan risiko tersisa

## 5. mealora-plans — Penutupan

- [ ] 5.1 Gate verifikasi: `openspec validate 016-custom-food-recipe-calc --strict` lolos
