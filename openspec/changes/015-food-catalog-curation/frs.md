# Functional Requirements Specification

## Mealora - Kurasi Katalog Makanan: Takaran Sehari-hari & Akurasi Gizi

| | |
|---|---|
| Change | 015-food-catalog-curation |
| Versi | v0.1-draft |
| Tanggal | 2026-11-12 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Takaran sehari-hari Indonesia (gelas, sendok, centong, potong, piring, dll.) untuk makanan katalog bawaan, lengkap dengan padanan beratnya.
- Penanda asal-usul untuk setiap takaran, termasuk penanda "perkiraan" bila beratnya tidak berasal dari sumber terukur.
- Koreksi nilai gizi seluruh katalog terhadap Tabel Komposisi Pangan Indonesia (TKPI) 2017 dari Kementerian Kesehatan.
- Pencatatan jumlah langsung dalam gram atau mililiter.
- Pemisahan makanan siap konsumsi dari bahan mentah atau kering di hasil pencarian.
- Pencarian yang mengenali ejaan sehari-hari (mis. "telor", "mie").
- Pemeriksaan mutu data katalog otomatis sebelum setiap rilis.

### 1.2 Deferred Items (Not in This FRS Version)

- Pembaruan katalog lewat internet. Katalog tetap ikut terpasang bersama aplikasi.
- Penimbangan porsi oleh tim di lapangan. Bila dilakukan nanti, hasilnya bisa dimasukkan tanpa perubahan fitur.
- Penambahan zat gizi baru (vitamin, mineral) di luar yang sudah ditampilkan.
- Perubahan pada makanan buatan pengguna dan makanan kemasan (barcode/label gizi).

## 2. Takaran Saji Sehari-hari

### 2.1 User Story

As a pengguna Mealora,
I want memilih takaran yang biasa saya pakai seperti "1 centong" atau "1 gelas",
So that saya bisa mencatat makanan dengan cepat tanpa harus menebak beratnya dalam gram.

### 2.2 Functional Scope

- Saat membuka makanan dari katalog, pengguna melihat daftar takaran beserta padanan beratnya, misalnya "1 centong · 100 g".
- Takaran yang terpilih lebih dulu adalah takaran sehari-hari yang paling lazim untuk makanan itu. Takaran "100 g" tetap tersedia.
- Takaran yang beratnya berupa perkiraan diberi tanda "perkiraan" di samping beratnya.
- Pengguna yang sebelumnya mencatat dengan takaran "100 g" tetap melihat takaran itu di bagian "terakhir dicatat".
- Catatan makan yang sudah tersimpan tidak berubah sama sekali.

### 2.3 Acceptance Criteria

2.3.1. The system shall show every serving option of a catalog food with its everyday label and weight equivalent.

2.3.2. The system shall preselect the most common everyday serving for catalog foods that have one, while keeping the 100 g option available.

2.3.3. The system shall label a serving as "perkiraan" when its weight equivalent is an estimate.

2.3.4. The system shall keep offering the last-used serving in the recently-logged section even after new servings are added.

2.3.5. The system shall leave previously saved meal entries unchanged when the catalog is updated.

---

## 3. Asal-usul dan Akurasi Data

### 3.1 User Story

As a pemilik produk,
I want setiap angka di katalog dapat ditelusuri ke sumbernya,
So that pengguna dapat mempercayai angka yang mereka lihat dan kesalahan data dapat dilacak.

### 3.2 Functional Scope

- Nilai gizi makanan katalog berasal dari TKPI 2017 dan tidak pernah dikarang.
- Berat setiap takaran memiliki salah satu dari tiga tingkat asal-usul: dari sumber resmi atau penimbangan, hasil hitungan dari data terukur, atau perkiraan yang realistis beserta dasarnya.
- Perkiraan hanya dipakai untuk berat takaran, tidak pernah untuk nilai gizi.
- Nilai gizi yang tidak diketahui disimpan sebagai "belum diketahui", bukan nol.
- Makanan atau takaran tanpa asal-usul yang lengkap tidak dimasukkan ke katalog.

### 3.3 Acceptance Criteria

3.3.1. The system shall show the data source of a catalog food in its detail view.

3.3.2. The system shall exclude any built-in food or serving that lacks complete source information.

3.3.3. The system shall never use an estimate for nutrition values per unit of weight.

3.3.4. The system shall store unconfirmed nutrition values as unknown rather than zero.

---

## 4. Mencatat dalam Gram atau Mililiter

### 4.1 User Story

As a pengguna yang menimbang makanan atau membaca volume minuman,
I want memasukkan jumlah langsung dalam gram atau mililiter,
So that catatan saya sesuai dengan yang benar-benar saya konsumsi.

### 4.2 Functional Scope

- Untuk makanan yang beratnya diketahui, pengguna dapat mengetik jumlah dalam gram, atau mililiter untuk minuman.
- Nilai gizi dihitung sebanding dengan jumlah tersebut.
- Jumlah nol atau negatif ditolak dengan penjelasan.
- Bila berat sebuah takaran tidak diketahui, masukan gram tidak ditawarkan untuk takaran itu.

### 4.3 Acceptance Criteria

4.3.1. The system shall allow entering an amount in grams, or millilitres for drinks, for foods with a known weight equivalent.

4.3.2. The system shall calculate nutrition proportionally to the entered amount.

4.3.3. The system shall reject an amount of zero or less with an explanation.

4.3.4. The system shall not offer gram entry for a serving without a known weight equivalent.

---

## 5. Pencarian yang Lebih Manusiawi

### 5.1 User Story

As a pengguna,
I want hasil pencarian menampilkan makanan dalam bentuk yang biasa saya konsumsi dan mengenali ejaan sehari-hari,
So that saya tidak salah memilih bahan mentah atau kering.

### 5.2 Functional Scope

- Makanan siap konsumsi (mis. "Teh manis (seduh)") terpisah dari bahan mentah atau keringnya (mis. "Teh (daun kering)") dan tampil lebih dulu.
- Nama makanan menyatakan bentuknya.
- Ejaan sehari-hari yang lazim dikenali, misalnya "telor" untuk telur dan "mie" untuk mi.

### 5.3 Acceptance Criteria

5.3.1. The system shall list ready-to-eat entries before raw or dry entries when a search matches both.

5.3.2. The system shall name such entries so that their form is clear.

5.3.3. The system shall match common everyday spellings to the same catalog food.

---

## 6. Pemeriksaan Mutu Katalog

### 6.1 User Story

As a pemilik produk,
I want data katalog diperiksa otomatis sebelum rilis,
So that kesalahan angka tidak sampai ke pengguna.

### 6.2 Functional Scope

- Sebelum rilis, katalog diperiksa untuk kesesuaian kalori dengan protein, karbohidrat, dan lemak; berat takaran yang wajar; makanan ganda; dan takaran utama yang tunggal.
- Bila ada pelanggaran, rilis tertahan dan laporan menyebut makanan serta aturan yang dilanggar.
- Pengecualian (mis. minuman beralkohol) hanya diterima bila alasannya tercatat.

### 6.3 Acceptance Criteria

6.3.1. The system shall block a release when any catalog item fails a quality rule and name the item and rule.

6.3.2. The system shall flag foods whose calories are inconsistent with protein, carbohydrate, and fat unless a documented exception exists.

6.3.3. The system shall flag servings whose weight is outside the reasonable range for their unit.

6.3.4. The system shall flag duplicate food names.

6.3.5. The system shall flag foods that do not have exactly one default serving.

## 7. High Level Test Scenarios

| # | Kondisi awal | Aksi | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Aplikasi diperbarui ke versi ini | Cari "nasi putih" dan buka | Takaran "1 centong" terpilih, "100 g" tersedia, berat tampil di setiap takaran |
| 2 | Pengguna pernah mencatat nasi 100 g sebelum pembaruan | Buka pencarian | "Terakhir dicatat" menawarkan nasi dengan takaran 100 g. Catatan lama tidak berubah |
| 3 | Makanan dengan takaran perkiraan | Pilih takaran itu | Tanda "perkiraan" tampil di samping beratnya |
| 4 | Makanan katalog terbuka | Ketik 150 g lalu simpan | Nilai gizi = 1,5 × nilai per 100 g |
| 5 | Makanan katalog terbuka | Ketik 0 g | Ditolak dengan penjelasan dan tidak tersimpan |
| 6 | — | Cari "teh" | Teh seduh tampil sebelum daun teh kering |
| 7 | — | Cari "telor ceplok" | Telur ceplok muncul di hasil |
| 8 | Data katalog berisi nama ganda | Jalankan proses rilis | Rilis tertahan dan laporan menyebut kedua entri |
