# 016 · Hitung gizi makanan buatan sendiri dari bahan

## Why

Saat membuat makanan sendiri (change 007), pengguna sekarang harus mengisi energi, protein, karbohidrat, dan lemak secara manual. Untuk masakan rumahan yang tidak punya label gizi, pengguna praktis tidak tahu angkanya. Akibatnya kolom diisi tebakan atau ditinggal kosong.

Katalog sudah berisi nilai gizi per 100 g dari TKPI. Kalau pengguna tahu bahan dan jumlahnya, gizi masakannya bisa dihitung secara matematis (Σ gizi per 100 g × gram / 100) tanpa menebak.

## What Changes

- **Pilihan "Hitung dari bahan"** di layar buat makanan sendiri. Pengguna menambah bahan dari katalog atau dari makanan buatannya sendiri, masing-masing dengan jumlah dalam gram atau takaran yang padanan beratnya diketahui. Sistem lalu menjumlahkan gizinya.
- **Jumlah porsi atau berat jadi** dipakai untuk membagi total gizi resep menjadi gizi per sajian.
- **Hasil hitungan mengisi kolom gizi**, yang tetap bisa dikoreksi pengguna sebelum disimpan.
- **Input manual tetap tersedia dan tetap menjadi cara bawaan** bagi pengguna yang sudah punya data gizinya. Perilaku sekarang tidak berubah.
- **Bahan yang belum ada di katalog**:
  - Bisa dibuat langsung dari lembar pemilihan bahan sebagai makanan buatan sendiri, misalnya dengan gizi per 100 g dari label kemasan, lalu dipakai ulang.
  - Bahan tanpa data gizi tetap boleh dimasukkan. Total resep kemudian ditandai tidak lengkap dan menyebut bahan mana yang belum ada datanya. Sistem tidak pernah menebak gizi bahan.
- **Daftar bahan tersimpan** bersama makanan, sehingga resep bisa dibuka dan dihitung ulang saat disunting.
- **Kejujuran hasil**:
  - Zat gizi yang tidak diketahui pada salah satu bahan membuat total zat itu ditandai tidak lengkap, bukan dianggap nol.
  - Bentuk bahan (mentah atau matang) ditampilkan jelas.
  - Pengguna diingatkan bahwa minyak goreng yang terserap perlu dimasukkan sebagai bahan.
- **Asal nilai ditandai**: makanan buatan pengguna mencatat apakah gizinya diisi manual atau dihitung dari bahan.

## Capabilities

### New Capabilities

- `custom-food-recipe`: menghitung gizi makanan buatan pengguna dari daftar bahan beserta jumlahnya, membaginya per sajian, menangani bahan yang datanya belum ada, dan menyimpan resepnya agar bisa disunting dan dihitung ulang.

### Modified Capabilities

- `food-catalog`: requirement "Pengguna dapat membuat makanan sendiri" berubah. Ada dua cara mengisi gizi (manual, yang tetap bawaan, atau hitung dari bahan), dan asal nilainya ditandai.

## Impact

- **mealora-mobile**:
  - Layar buat dan sunting makanan sendiri diubah (`custom_food_screen.dart`).
  - Ada lembar pemilihan bahan, yang memakai ulang pencarian katalog seperti jalur foto.
  - Tabel baru untuk bahan resep, ditambah satu kolom penanda asal nilai di makanan, lewat migrasi skema.
  - Fungsi hitung murni yang dites unit.
- **Ketergantungan**:
  - Bisa jalan tanpa change 015 karena inti hitungannya hanya butuh gram dan gizi per 100 g.
  - Pengalamannya jauh lebih baik setelah 015, karena takaran URT ("1 butir", "1 sdm") dan pemisahan bentuk mentah/siap konsumsi sudah tersedia.
  - Urutan rilis yang disarankan: 015 lalu 016. Nomor versi migrasi skema mengikuti urutan rilis yang sebenarnya.
  - Memodifikasi spec `food-catalog` dari 007, jadi 007 harus diarsipkan lebih dulu.
- **Data pengguna**: makanan buatan sendiri yang sudah ada tetap utuh, berstatus "diisi manual". Catatan makan lama tidak berubah.
