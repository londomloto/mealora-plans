## 1. mealora-mobile — Fondasi skema & dataset

- [ ] 1.1 Pastikan change 007 sudah diarsipkan (spec `food-catalog` ada di `openspec/specs/`) sebelum mengarsipkan change ini
- [x] 1.2 Migrasi skema v9 → v10: tambah `provenanceTier`, `provenanceRef`, `provenanceNote` di `food_servings`, serta `form` dan `isActive` (default true) di `foods`; naikkan `kSchemaVersion`
- [x] 1.3 Test migrasi v9 → v10: data lama utuh, kolom baru bernilai bawaan, catatan makan tidak berubah
- [x] 1.4 Ekspor seed sekarang ke `tool/food_catalog/foods.csv` dan `servings.csv` (takaran 100 g bertingkat `official`, rujukan baris sumber)
- [x] 1.5 Buat `tool/generate_food_catalog.dart`: CSV → `food_catalog_seed.dart`, gizi per takaran = nilai_100g × gram / 100, ID takaran stabil `food-tkpi-<n>-<slug-satuan>`
- [x] 1.6 Test sinkron: seed hasil bangkitan sama dengan keluaran generator dari dataset
- [x] 1.7 Seed: dukung pemindahan `isDefault`, takaran baru, dan penonaktifan makanan; naikkan `kFoodCatalogSeedVersion`

## 2. mealora-mobile — Pemeriksaan mutu katalog

- [x] 2.1 Buat `tool/food_catalog/unit_ranges.csv` (rentang gram/ml per satuan dan massa jenis minuman, masing-masing dengan sumber)
- [x] 2.2 Buat `test/database/food_catalog_quality_test.dart`: energi–makro ±25% (>20 kkal/100 g) dengan daftar pengecualian beralasan, rentang takaran, duplikat nama ternormalisasi di antara baris aktif, tepat satu takaran bawaan, provenans lengkap
- [x] 2.3 Jalankan pemeriksa pada dataset awal dan simpan laporan pelanggaran sebagai baseline

## 3. mealora-mobile — Koreksi gizi terhadap TKPI 2017

- [x] 3.1 Spike (timebox 1 hari): unduh TKPI 2017 dari repository Kemenkes, uji ekstraksi tabel, putuskan otomatis atau manual berbantuan
- [x] 3.2 Cocokkan setiap item ke TKPI 2017 (kode/halaman). Item yang tidak cocok ditandai belum terverifikasi (`verifiedAt` kosong)
- [x] 3.3 Koreksi nilai gizi per 100 g yang berbeda dari TKPI 2017. Catat rujukan halaman
- [x] 3.4 Karbohidrat (dan nilai lain) bernilai 0 yang tidak dikonfirmasi TKPI 2017 disimpan sebagai belum diketahui
- [x] 3.5 Tangani 86 item yang energi–makronya menyimpang: koreksi ke sumber, atau daftarkan pengecualian beralasan
- [x] 3.6 Rapikan duplikat (`Beras parboiled`, `Bika ambon`, `Terasi merah`): satu dipertahankan, sisanya dinonaktifkan
- [x] 3.7 Standardisasi nama (huruf kapital, penanda bentuk) dan isi kolom `form`

## 4. mealora-mobile — Takaran sehari-hari

- [x] 4.1 Susun daftar makanan prioritas (`tool/food_catalog/priority_foods.csv`): ~260 paling lazim dicatat (nasi, lauk, sayur, gorengan, minuman sehari-hari) ditambah seluruh entri siap konsumsi dan lauk hewani segar, ±600 item dalam 12 batch, dan minta persetujuan pemilik produk atas daftarnya
- [x] 4.2 Isi takaran sehari-hari untuk batch 1 (50 item) dengan tingkat dan rujukan atau catatan. Gunakan sumber `official` bila tersedia; `estimate` hanya bila tidak ada, dan wajib dalam rentang `unit_ranges.csv`
- [ ] 4.3 Tinjauan pemilik produk batch 1. Ulangi 4.2–4.3 untuk batch 2–12
- [x] 4.4 Tambah entri bentuk siap konsumsi yang belum ada (mis. "Teh manis (seduh)", "Kopi hitam (seduh)") dengan gizi turunan dari sumber terukur
- [x] 4.5 Isi takaran sehari-hari untuk sisa katalog bila satuannya wajar. Bahan yang tidak lazim dicatat per takaran tetap memakai 100 g
- [x] 4.6 Selaraskan label satuan dengan `_unitAliases` di `voice_draft_builder.dart` dan tambahkan alias yang kurang
- [x] 4.7 Draf foto makanan: cocokkan satuan hasil pengenalan ke takaran (logika sama dengan input suara). Gram/ml → takaran 100 g/100 ml × (jumlah/100); satuan tak dikenali → takaran bawaan dengan porsi ditandai perlu dicek. Tambah test unit untuk "150 g", "1 piring", dan satuan tak dikenali

## 5. mealora-mobile — UI & pencarian

- [x] 5.1 Tampilkan penanda "perkiraan" pada takaran bertingkat `estimate` di detail sajian dan ubah catatan, sesuai `docs/mealora-v2.pen`
- [x] 5.2 Masukan jumlah dalam gram/ml: simpan sebagai takaran 100 g/100 ml × (jumlah/100), tampilkan sebagai "150 g", tolak jumlah ≤ 0, sembunyikan bila padanan berat tidak diketahui
- [x] 5.3 Pencarian: hanya makanan aktif, bentuk siap konsumsi lebih dulu, normalisasi kueri dengan `synonyms.csv`
- [x] 5.4 Riwayat "terakhir dicatat" tetap menampilkan takaran yang terakhir dipakai, termasuk untuk makanan yang dinonaktifkan
- [x] 5.5 Test widget/unit untuk 5.1–5.4 serta skenario spec (takaran bawaan, takaran lama tetap berlaku, mencatat 150 g, 0 g ditolak, "teh", "telor ceplok")

## 6. mealora-mobile — Verifikasi

- [x] 6.1 Uji pembaruan di emulator Android (`flutter run -d emulator-5554`) dari build v9 berisi catatan: catatan lama tidak berubah, seed baru diterapkan, durasi seed pertama dicatat
- [x] 6.2 Jalankan skenario uji FRS 1–8 di emulator
- [x] 6.3 Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`; laporkan hasil dan risiko tersisa

## 7. mealora-plans — Dokumentasi

- [x] 7.1 Perbarui `docs/food-data-sources.md`: tingkat sumber per takaran, lokasi dataset kurasi, status TKPI 2017, keterbatasan yang tersisa (sumber URT resmi, izin TKPI)
- [x] 7.2 Gate verifikasi: `openspec validate 015-food-catalog-curation --strict` lolos
