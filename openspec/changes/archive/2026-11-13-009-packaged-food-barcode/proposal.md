# 009 · Produk kemasan lewat barcode

## Why

Mencatat makanan kemasan lewat pencarian nama adalah pekerjaan yang melelahkan: pengguna harus mengetik nama produk, menebak variannya, lalu memastikan nilai gizinya cocok dengan kemasan di tangannya. Barcode menghilangkan seluruh langkah menebak itu dalam satu pindaian.

Assessment §50 menaikkan barcode dari pekerjaan masa depan menjadi **jalur masukan wajib MVP 1**, dengan satu syarat yang tidak boleh dilanggar: barcode adalah pengenal produk, bukan sumber nilai gizi. Nilai tetap harus berasal dari sumber yang dapat ditelusuri, dan pengguna tetap mengonfirmasi sebelum apa pun masuk ke buku harian.

Rancangannya sudah ada di `docs/mealora-v2.pen`: `21 · Pindai barcode`, `22 · Barcode tidak ditemukan`, dan `04 · Tinjau produk kemasan`.

## What Changes

- **Pemindaian barcode** (`21`) lewat kamera, dengan pencarian ke produk tersimpan di perangkat lebih dulu.
- **Masukan barcode manual**: nomor barcode dapat diketik ketika kamera tidak tersedia, izin kamera ditolak, atau kode tidak terbaca. **Layar ini belum ada di rancangan** — `21` baru memuat tautannya. Change ini merancang dan membangunnya.
- **Cache produk di perangkat**: produk yang pernah dikonfirmasi pengguna tersimpan dan dapat ditemukan kembali tanpa koneksi.
- **Pencarian daring opsional** ke sumber data produk yang disetujui, hanya ketika produk tidak ada di perangkat dan pengguna sedang daring.
- **Tinjau produk** (`04`): nama, merek, ukuran kemasan, takaran saji, jumlah sajian per kemasan, energi dan zat gizi makro, penanda asal data, dan tanggal verifikasi — seluruhnya ditinjau sebelum dicatat.
- **Aritmetika basis takaran**: konsumsi satu sajian, beberapa sajian, atau satu kemasan penuh dihitung dari nilai per sajian dikalikan jumlah sajian. Nilai per 100 g dikonversi memakai gram yang benar-benar dimakan. Basis label tidak pernah tertukar.
- **Produk tidak ditemukan** (`22`): jalur lanjutan berupa foto label gizi, yang dikirim pada change berikutnya, dan pengisian nilai secara manual yang tersedia sepenuhnya luring.
- **Provenans produk**: jenis sumber, pengenal sumber, versi sumber, tanggal verifikasi, barcode, basis takaran, dan penanda apakah nilainya pernah dikoreksi pengguna.
- **Koreksi pengguna menang**: ketika pengguna mengoreksi nilai karena berbeda dengan kemasan di tangannya, koreksi itu yang dipakai dan ditandai sebagai koreksi pengguna.
- **Potret nilai gizi** pada catatan tetap berlaku seperti change 007: nilai dibekukan saat pencatatan.

## Capabilities

### New Capabilities

- `packaged-food-barcode`: menemukan produk kemasan lewat barcode, meninjau nilainya terhadap kemasan yang ada di tangan pengguna, menghitung jumlah yang dimakan dengan basis takaran yang benar, dan menyimpannya untuk dipakai lagi tanpa koneksi.

### Modified Capabilities

Tidak ada. `food-catalog`, `food-diary`, dan `daily-dashboard` dari change 007 dipakai apa adanya; produk kemasan masuk ke buku harian lewat jalur yang sama dengan makanan lain.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: tabel produk kemasan beserta provenans dan migrasi skema versi 5 ke 6, pemindai barcode beserta izin kamera, klien sumber data produk yang dapat diganti, layar pindai, masukan manual, produk tidak ditemukan, dan tinjau produk.
- **Repo `mealora-plans`**: rancangan layar masukan barcode manual, dan dokumen sumber data produk beserta kewajiban lisensinya.
- **Bergantung pada** change 007 (katalog, buku harian, potret nilai gizi, lembar pilihan pencatatan).
- **Memblokir** change label gizi, karena jalur "produk tidak ditemukan" bermuara ke sana.
- **Keputusan terbuka yang harus ditutup**: sumber data produk kemasan yang dipakai beserta kewajiban lisensinya. Assessment §50.4 menyebut Open Food Facts sebagai kandidat dengan kewajiban ODbL dan lisensi gambar, serta mencatat bahwa rekaman komunitas memerlukan peninjauan.
- **Batas yang dinyatakan sejak awal**: kamera tidak tersedia pada target web yang dipakai untuk pratinjau pengembangan, sehingga verifikasi jalur pindai hanya sah di perangkat Android.
