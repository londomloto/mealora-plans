## Context

Kondisi saat ini di `mealora-mobile` (lihat proposal.md, bagian Why, untuk motivasi):

- `foods` menyimpan nama, kategori, dan asal-usul makanan (`sourceType`/`sourceRef`/`sourceVersion`/`verifiedAt`).
- `food_servings` sudah mendukung banyak takaran per makanan (`label`, `amount`, `unit`, `gramEquivalent`, `isDefault`).
- `nutrition_values` menyimpan gizi **per takaran** (unik per `servingId`), bukan per 100 g.
- `meal_entry_items` mereferensikan `foodId` dan `servingId` dengan `onDelete: restrict`, serta menyimpan snapshot nama, label takaran, dan gizi. Riwayat aman dari pembaruan katalog, tapi baris makanan atau takaran yang pernah dipakai tidak bisa dihapus.
- Seed (`lib/database/seeds/food_catalog_seed.dart`, 1.346 item, `kFoodCatalogSeedVersion`) ditulis dengan `insertAllOnConflictUpdate` berdasarkan ID stabil `food-tkpi-<n>` dan `food-tkpi-<n>-default`. Seed dijalankan ulang bila versi seed berubah.
- Input suara (`voice_draft_builder.dart`) mencocokkan satuan ucapan ke `serving.unit` lewat `_unitAliases`.
- Skema saat ini `kSchemaVersion = 9`.

Kendala sumber data:

- TKPI 2017 resmi tersedia di repository Kemenkes.
- DBMP/URT resmi dan Buku Foto Makanan SKMI belum didapat dalam versi resmi.
- Hak pakai TKPI masih menunggu izin. Risiko ini diterima di 007 dan tidak berubah.

## Goals / Non-Goals

**Goals:**
- Kurasi seluruh katalog bawaan tanpa menduplikasi baris makanan, dan tanpa mengubah catatan maupun riwayat pengguna.
- Setiap angka bisa ditelusuri ke sumbernya atau ke rumusnya. Estimasi selalu terlihat sebagai estimasi.
- Mutu data dijaga oleh pemeriksaan otomatis yang berjalan di `flutter test`.

**Non-Goals:**
- Sinkronisasi atau pembaruan katalog lewat jaringan. Katalog tetap bawaan aplikasi.
- Mikronutrien baru di luar kolom `nutrition_values` yang sudah ada.
- Mengubah makanan buatan pengguna atau makanan kemasan (barcode/label).
- Penimbangan lapangan oleh tim. Kalau dilakukan nanti, hasilnya cukup ditambahkan sebagai sumber tingkat "resmi" tanpa perubahan desain.

## Decisions

### D1. Perbarui baris yang ada, tambah takaran baru. Tidak membuat baris katalog paralel

ID makanan `food-tkpi-<n>` dipertahankan. Takaran `food-tkpi-<n>-default` (100 g) dipertahankan sebagai **takaran asal**, tapi `isDefault`-nya dipindah ke takaran sehari-hari. Takaran sehari-hari baru diberi ID stabil `food-tkpi-<n>-<slug-satuan>` (mis. `-centong`, `-gelas`). Koreksi gizi dilakukan di tempat.

- *Alternatif: baris katalog baru yang terkurasi.* Ditolak. Pencarian akan menampilkan dua entri untuk makanan yang sama, riwayat "terakhir dicatat" tetap menunjuk baris lama yang belum dikurasi, dan ukuran katalog menjadi dua kali lipat. Keamanan riwayat yang dicari sudah dijamin oleh snapshot di `meal_entry_items`.
- *Alternatif: kolom "nilai asal TKPI" di `foods`.* Ditolak. Takaran 100 g dengan gizinya sudah merupakan nilai asal itu.

### D2. Migrasi skema v10: kolom provenans per takaran, bentuk makanan, status aktif

- `food_servings`: `provenanceTier` (`official` | `derived` | `estimate`, wajib untuk baris katalog dan nullable untuk takaran buatan pengguna), `provenanceRef` (rujukan dokumen beserta halaman, atau rumus), dan `provenanceNote` (dasar perkiraan).
- `foods`: `form` (`ready` | `raw` | `dry`, nullable) untuk mengurutkan bentuk siap konsumsi di atas bahan.
- `foods`: `isActive` (default `true`) untuk menyembunyikan duplikat dari pencarian. Duplikat yang pernah dicatat tidak bisa dihapus karena relasi `restrict`, jadi baris itu dinonaktifkan dan pencarian hanya membaca baris aktif.

Migrasinya `addColumn` saja, tanpa salin ulang tabel. Pola ini sama dengan migrasi `food_catalog_verification`.

- *Alternatif: provenans disimpan sebagai teks di `label`.* Ditolak karena tidak bisa diperiksa otomatis dan tidak bisa dipakai UI untuk penanda "perkiraan".

### D3. Dataset kurasi sebagai sumber kebenaran, seed Dart dibangkitkan

Dataset kurasi disimpan di `mealora-mobile/tool/food_catalog/` dalam bentuk CSV agar mudah ditinjau lewat diff dan spreadsheet:

- `foods.csv`: id, nama, kategori, bentuk, aktif, gizi per 100 g, rujukan TKPI 2017 (kode/halaman), dan status verifikasi.
- `servings.csv`: id makanan, label, jumlah, satuan, gram, tingkat, rujukan, dan catatan.
- `unit_ranges.csv`: rentang gram atau ml per satuan beserta sumbernya.
- `synonyms.csv`

Skrip `tool/generate_food_catalog.dart` membangkitkan `food_catalog_seed.dart`. File hasil ditandai sebagai hasil bangkitan dan tidak disunting tangan. Dataset diletakkan di repo aplikasi, bukan di `mealora-plans`, supaya build dan test tidak bergantung pada repo lain. `docs/food-data-sources.md` merujuk ke sana.

- *Alternatif: tetap menyunting `food_catalog_seed.dart` (13.611 baris) langsung.* Ditolak karena tidak bisa ditinjau dan rawan galat.

### D4. Gizi per takaran dihitung, bukan dikurasi

Kurasi hanya menetapkan gizi per 100 g (dari TKPI) dan gram per takaran. Generator menghitung `nutrition_values` per takaran dengan rumus `nilai_100g × gram / 100`. Ini satu-satunya turunan yang diizinkan untuk gizi. Untuk minuman, gram = ml × massa jenis, dengan massa jenis dari `unit_ranges.csv` beserta sumbernya.

### D5. Masukan gram/ml memakai takaran 100 g/100 ml yang sudah ada

Saat pengguna memasukkan 150 g, entri disimpan dengan `servingId` takaran 100 g dan `quantity = 1,5`. Tidak ada perubahan pada tabel catatan maupun snapshot. UI menampilkan jumlah sebagai "150 g", bukan "1,5 × 100 g". Untuk minuman disediakan takaran asal `100 ml` dengan padanan gram.

- *Alternatif: kolom gram baru di `meal_entry_items`.* Ditolak karena mengubah kontrak catatan dan snapshot tanpa manfaat tambahan.

### D6. Tingkat sumber dan urutan prioritas

| Tingkat | Sumber yang diterima |
|---|---|
| `official` | TKPI 2017 (gizi); **Permenkes 41/2014 (Pedoman Gizi Seimbang), Lampiran hlm. 8–16 dan 41**: tabel penukar URT + gram (±170 bahan: makanan pokok, lauk nabati/hewani golongan A–C, buah, minyak/lemak; bersumber DBMP FKUI 1997); DBMP/URT Kemenkes versi resmi; Buku Foto Makanan SKMI; penimbangan lapangan terdokumentasi |
| `derived` | Rumus dari data `official` (skala, volume × massa jenis) |
| `estimate` | Perkiraan ukuran realistis dengan catatan dasar, harus masuk rentang di `unit_ranges.csv` |

Sumber dengan tingkat lebih tinggi selalu menggantikan yang lebih rendah. Kalau dua sumber `official` berbeda, keduanya dicatat di `provenanceNote` dan pilihannya ditinjau manusia, bukan dipilih otomatis.

### D7. Pemeriksaan mutu sebagai test

`test/database/food_catalog_quality_test.dart` membaca dataset kurasi dan memeriksa:

- konsistensi energi–makro dengan toleransi ±25% untuk energi >20 kkal/100 g, kecuali yang terdaftar di `foods.csv` dengan alasan;
- rentang gram per satuan;
- duplikat nama ternormalisasi di antara baris aktif;
- tepat satu takaran bawaan;
- kelengkapan provenans.

Test ini berjalan di gerbang `flutter test` yang sudah ada. Test kedua memastikan seed hasil bangkitan sinkron dengan dataset.

### D8. Sinonim dan satuan suara

Pencarian menormalisasi kueri dengan `synonyms.csv` sebelum mencocokkan. Label satuan takaran baru memakai nama kanonik yang sudah dikenal `_unitAliases` di input suara (mis. `sdm`, `gelas`, `centong`), dan alias yang kurang ditambahkan, supaya "dua centong nasi" langsung menemukan takarannya.

### D9. Urutan kurasi

1. Koreksi gizi seluruh katalog terhadap TKPI 2017. Pekerjaan ini mekanis dan bisa diperiksa otomatis.
2. Takaran sehari-hari untuk daftar prioritas, ditinjau manual oleh pemilik produk per batch: sekitar 260 makanan paling lazim dicatat, ditambah seluruh entri siap konsumsi dan lauk hewani segar (±600 item, 12 batch). Cakupan diperluas atas keputusan pemilik produk (2026-11-12).
3. Sisa katalog: takaran sehari-hari diisi bila satuannya wajar. Bahan yang tidak lazim dicatat per takaran (mis. bumbu kering) cukup memakai takaran 100 g.

### D10. Draf foto memakai pencocokan satuan yang sama dengan suara

Sekarang draf foto selalu memakai takaran bawaan dengan jumlah dari pengenalan, tanpa melihat satuannya. Itu baru aman selama semua takaran 100 g. Setelah takaran bawaan dipindah ke takaran sehari-hari, draf foto memakai logika pencocokan satuan input suara:
- satuan yang cocok dengan takaran → takaran itu;
- gram/ml → takaran 100 g/100 ml, jumlah = nilai / 100;
- satuan tak dikenali atau kosong → takaran bawaan, porsi ditandai perlu dicek.

Pengguna tetap bisa mengganti takaran di layar tinjau. Logikanya diletakkan di satu tempat yang dipakai bersama oleh foto dan suara.

## Risks / Trade-offs

- [Item Kaggle yang tidak ada di TKPI 2017, karena berasal dari edisi lama atau nama berbeda] → Dicocokkan manual. Yang tidak ketemu tetap memakai nilai asal dengan `verifiedAt` kosong dan ditandai belum terverifikasi. Item tersebut tidak dihapus.
- [Estimasi gram per takaran meleset dari porsi nyata] → Ada rentang wajar per satuan, penanda "perkiraan" di UI, dan tinjauan manual untuk daftar prioritas (±600 item). Estimasi diganti begitu sumber resmi didapat.
- [Pengguna kaget takaran bawaan berubah dari 100 g] → Riwayat terakhir dicatat tetap memakai takaran lamanya (lihat spec, skenario "Takaran lama tetap berlaku"), dan 100 g tetap bisa dipilih.
- [Menonaktifkan duplikat yang ada di riwayat pengguna] → Catatan lama aman karena snapshot. Entri riwayat "terakhir dicatat" yang menunjuk baris nonaktif tetap ditampilkan agar tidak hilang tiba-tiba.
- [Ukuran seed membesar, sekitar 3–4 takaran per makanan] → Masih ribuan baris dan wajar untuk SQLite. Durasi seed pertama diukur di emulator.
- [Hak pakai TKPI] → Tidak berubah dari 007. Permohonan izin tetap berjalan.

## Migration Plan

1. Migrasi skema v9 → v10 (D2) menambahkan kolom dengan nilai bawaan yang aman.
2. `kFoodCatalogSeedVersion` dinaikkan. Saat aplikasi pertama dibuka setelah pembaruan, seed menulis ulang baris katalog (upsert berdasarkan ID), menambah takaran baru, memindahkan `isDefault`, dan menonaktifkan duplikat.
3. Rollback: rilis sebelumnya tidak bisa membaca skema v10 (konsisten dengan migrasi sebelumnya), jadi rollback dilakukan dengan rilis perbaikan maju. Data catatan pengguna tidak tersentuh sehingga risikonya rendah.

## Open Questions

- Permenkes 41/2014 (JDIH BPK) sudah didapat dan berisi tabel URT + gram. Ekstraksi teksnya kehilangan simbol pecahan (½, ¼, ¾, tampil sebagai "�"), jadi sel berpecahan wajib dicek visual ke halaman PDF, tidak boleh ditebak. Bahan yang tidak tercakup: makanan olahan/masakan, minuman, jajanan, dan sayuran (sayuran hanya "1 porsi ≈ 1 gelas setelah dimasak", tanpa gram per jenis).
- Versi resmi DBMP/URT dan Buku Foto Makanan SKMI belum didapat. Sampai tersedia, takaran sehari-hari bertingkat `estimate` atau `derived`. Begitu didapat, cukup dataset yang diperbarui. Desain, spec, dan task tidak berubah.
- Bentuk visual penanda "perkiraan" (ikon atau teks kecil) mengikuti desain di `docs/mealora-v2.pen` dan diputuskan saat implementasi UI.
