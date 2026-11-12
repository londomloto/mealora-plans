# Functional Requirements Specification

## Mealora - Hitung Gizi Makanan Buatan Sendiri dari Bahan

| | |
|---|---|
| Change | 016-custom-food-recipe-calc |
| Versi | v0.1-draft |
| Tanggal | 2026-11-12 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Pilihan "Hitung dari bahan" saat membuat atau menyunting makanan sendiri.
- Penjumlahan gizi dari bahan katalog atau makanan buatan sendiri, berdasarkan gram atau takaran.
- Pembagian per porsi atau per 100 g hasil masakan.
- Penanganan bahan yang belum ada di katalog.
- Penyimpanan resep agar bisa disunting dan dihitung ulang.
- Isi manual tetap tersedia sebagai cara bawaan.

### 1.2 Deferred Items (Not in This FRS Version)

- Usulan bahan otomatis dari nama masakan atau foto. Bisa dijadikan pengembangan berikutnya.
- Perkiraan perubahan berat atau zat gizi akibat memasak. Berat jadi diisi pengguna.
- Berbagi resep dengan pengguna lain.

## 2. Membuat Makanan Sendiri: Dua Cara Mengisi Gizi

### 2.1 User Story

As a pengguna yang mencatat masakan rumahan,
I want memilih antara mengisi gizi sendiri atau menghitungnya dari bahan,
So that saya tetap bisa memakai data gizi yang saya punya, tapi tidak perlu menebak kalau tidak punya.

### 2.2 Functional Scope

- Layar buat makanan sendiri tetap menampilkan isian manual sebagai cara bawaan.
- Pilihan "Hitung dari bahan" tersedia di layar yang sama.
- Makanan buatan sendiri yang tersimpan ditandai apakah gizinya diisi manual atau dihitung dari bahan.
- Makanan buatan sendiri yang sudah ada tetap bisa dipakai seperti biasa.

### 2.3 Acceptance Criteria

2.3.1. The system shall let the user enter nutrition values manually and save without adding any ingredients.

2.3.2. The system shall offer a "calculate from ingredients" option on the same screen.

2.3.3. The system shall record whether a user-created food's nutrition was entered manually or calculated from ingredients.

2.3.4. The system shall store empty nutrition values as unknown, not zero.

---

## 3. Menghitung Gizi dari Bahan

### 3.1 User Story

As a pengguna,
I want memasukkan bahan masakan beserta jumlahnya,
So that aplikasi menghitungkan gizi per porsi untuk saya.

### 3.2 Functional Scope

- Pengguna menambah bahan, lalu mengisi jumlahnya dalam gram atau dalam takaran (mis. "1 butir", "2 sdm").
- Pengguna mengisi hasil resep: jumlah porsi, dan opsional berat jadi.
- Aplikasi menampilkan kontribusi gizi tiap bahan dan total per porsi.
- Hasil hitungan mengisi kolom gizi dan masih bisa dikoreksi. Kalau dikoreksi, makanan dicatat sebagai diisi manual.
- Aplikasi mengingatkan agar minyak goreng yang terserap dimasukkan sebagai bahan, dan menampilkan bentuk bahan (mentah, kering, siap makan) bila diketahui.
- Jumlah bahan, jumlah porsi, dan berat jadi harus lebih dari nol.

### 3.3 Acceptance Criteria

3.3.1. The system shall calculate each nutrient as the sum of every ingredient's nutrition scaled by its amount.

3.3.2. The system shall offer gram entry only for ingredients with a known weight equivalent.

3.3.3. The system shall divide the recipe total by the number of portions to obtain nutrition per serving.

3.3.4. The system shall provide nutrition per 100 g of the finished dish when the finished weight is given.

3.3.5. The system shall reject an ingredient amount, portion count, or finished weight of zero or less with an explanation.

3.3.6. The system shall show each ingredient's contribution and the per-serving total before saving.

3.3.7. The system shall let the user correct calculated values and then record the food as manually entered.

3.3.8. The system shall remind the user to add absorbed frying oil as an ingredient.

---

## 4. Bahan yang Belum Ada di Katalog

### 4.1 User Story

As a pengguna yang memakai bahan yang tidak ada di katalog,
I want tetap bisa memasukkannya ke resep,
So that resep saya lengkap dan saya tahu bagian mana yang belum ada datanya.

### 4.2 Functional Scope

- Pencarian bahan mencakup katalog dan makanan buatan sendiri.
- Kalau bahan tidak ditemukan, pengguna bisa langsung membuatnya, misalnya dengan gizi per 100 g dari label kemasan. Bahan itu langsung masuk resep dan bisa dipakai ulang.
- Pengguna juga bisa menambah bahan dengan nama saja tanpa data gizi. Total resep kemudian ditandai "tidak lengkap" dan menyebut bahan tersebut.
- Aplikasi tidak pernah menebak gizi bahan yang tidak dikenal.

### 4.3 Acceptance Criteria

4.3.1. The system shall include both catalog foods and user-created foods when choosing ingredients.

4.3.2. The system shall offer to create a new food when an ingredient is not found and add it to the recipe once saved.

4.3.3. The system shall allow adding an ingredient by name only, without nutrition data.

4.3.4. The system shall mark any nutrient total as incomplete, naming the responsible ingredient, when that nutrient is unknown for any ingredient.

4.3.5. The system shall never estimate nutrition values for an ingredient.

---

## 5. Resep Tersimpan

### 5.1 User Story

As a pengguna,
I want resep masakan saya tersimpan,
So that saya bisa mengubah bahannya nanti tanpa mengulang dari awal.

### 5.2 Functional Scope

- Daftar bahan, jumlah, dan hasil resep tersimpan bersama makanan.
- Saat disunting, resep tampil dan gizinya dihitung ulang.
- Catatan makan yang sudah tersimpan tidak berubah.

### 5.3 Acceptance Criteria

5.3.1. The system shall save the ingredient list, amounts, and recipe yield with the food.

5.3.2. The system shall show the saved recipe and recalculate nutrition when the food is edited.

5.3.3. The system shall leave previously saved meal entries unchanged when a recipe changes.

## 6. High Level Test Scenarios

| # | Kondisi awal | Aksi | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Pengguna punya data gizi dari label | Isi manual lalu simpan | Tersimpan tanpa bahan, ditandai diisi manual |
| 2 | — | Hitung dari bahan: nasi 150 g + telur 1 butir, 1 porsi | Total = jumlah kontribusi kedua bahan, rincian tampil |
| 3 | Total resep 1.200 kkal | Isi 4 porsi | 300 kkal per porsi |
| 4 | Total resep 1.200 kkal | Isi berat jadi 800 g | 150 kkal per 100 g |
| 5 | Bahan tidak ada di katalog | Buat bahan baru dari pemilihan bahan | Bahan masuk resep dan tersimpan untuk dipakai lagi |
| 6 | — | Tambah "bumbu racik" tanpa data gizi | Total ditandai tidak lengkap dan menyebut "bumbu racik" |
| 7 | Hasil hitungan tampil | Ubah energi lalu simpan | Tersimpan dengan nilai koreksi, ditandai diisi manual |
| 8 | Makanan resep pernah dicatat | Ubah resep | Catatan lama tetap sama |
| 9 | — | Isi jumlah bahan 0 g | Ditolak dengan penjelasan |
