# 006 · Mengelola program yang berjalan

## Why

Setelah change 005, pengguna bisa memulai program — tetapi tidak bisa melihat, menjeda, mengganti, atau menyelesaikannya. Ruang Program masih kosong, dan seluruh aturan siklus hidup yang sudah teruji di change 003 dan tersimpan rapi di change 004 belum punya satu pun jalan masuk bagi pengguna.

Ini bukan sekadar melengkapi tombol. Janji inti produk ada di sini: pengguna memegang kendali atas programnya sendiri, dan target lama tetap dapat dijelaskan berbulan-bulan kemudian. Assessment §45 menetapkan apa yang wajib tampil di ruang Program — termasuk tanggal perhitungan terakhir dan rincian "Bagaimana dihitung" — dan §46.14 menjadikan keterjelasan sebagai kriteria penerimaan, bukan nilai tambah.

Rancangannya sebagian besar sudah ada di `docs/mealora.pen`: `05`, `27`, `28`, `29`, `30`, `34`, dan `39`.

## What Changes

- **Program saya** (`05`): program aktif, target harian perkiraan, kemajuan beserta keadaan data yang belum ada, berat terbaru, dan kontrol jeda, ganti, serta riwayat.
- **Rincian "Bagaimana dihitung"** untuk program yang sedang berjalan: masukan yang dipakai, asumsi, peringatan, tanggal perhitungan terakhir, versi kalkulator, dan versi kebijakan. **Layar ini belum ada di rancangan** — §45 mewajibkannya, dan `30 · Detail program selesai` baru menyediakan padanannya untuk program yang sudah berakhir. Change ini merancang dan membangunnya.
- **Program dijeda** (`27`): penandaan keadaan yang jelas, penegasan bahwa hari jeda tidak dihitung, penegasan bahwa pencatatan tetap jalan, dan kontrol lanjutkan, ganti, serta selesaikan.
- **Pratinjau ganti program** (`28`): program sekarang, pratinjau pengganti, penegasan bahwa riwayat tetap utuh, dan penegasan bahwa membatalkan tidak mengubah apa pun.
- **Riwayat program** (`29`) dan **detail program selesai** (`30`): daftar berurutan beserta keadaan akhir, dan detail yang menampilkan masukan, target, asumsi, serta versi asli.
- **Selesaikan program** (`39`): pemilihan alasan, ringkasan akhir yang disimpan, penegasan bahwa program selesai tidak dapat dilanjutkan, dan jalan batal.
- **Ubah profil dan tinjau target baru** (`34`): penyuntingan data profil yang tidak mengubah target berjalan, lalu peninjauan serta persetujuan revisi target.
- **Pintu masuk dari ruang Profil**: butir Program saya dan Riwayat program pada layar pengaturan (`33`) menjadi hidup.

## Capabilities

### New Capabilities

- `program-management`: apa yang dapat dilihat dan dilakukan pengguna terhadap program yang sedang berjalan maupun yang sudah berakhir — keadaan yang ditampilkan, keterjelasan perhitungan, kendali siklus hidup, riwayat, dan persetujuan revisi target.

### Modified Capabilities

Tidak ada. Aturan siklus hidup (`program-lifecycle`), penyimpanan (`program-progress`), kebijakan (`nutrition-policy`), dan profil (`user-profile`) dipakai apa adanya.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: ruang Program beserta seluruh layarnya, layar riwayat dan detail program, alur ubah profil dan revisi target, serta penyambungan butir menu pada ruang Profil. Tidak ada perubahan skema basis data.
- **Repo `mealora-plans`**: penambahan layar "Bagaimana dihitung" untuk program berjalan ke `docs/mealora.pen`.
- **Bergantung pada** change 003 (aturan siklus hidup), 004 (penyimpanan, riwayat, potret kemajuan), dan 005 (profil, pratinjau target, aktivasi).
- **Tidak memblokir** katalog makanan dan buku harian — keduanya dapat dikerjakan paralel setelah change 005.
- **Belum tersentuh**: pencatatan makanan, berat badan, riwayat harian, dan jalur foto, barcode, maupun label gizi. Angka kemajuan yang bersumber dari buku harian tetap ditampilkan sebagai belum diketahui sampai change buku harian selesai.
