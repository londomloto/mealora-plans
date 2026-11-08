# 004 · Persistensi program

## Why

Domain program (change 003) menetapkan aturan dan dapat diuji sepenuhnya, tetapi seluruhnya hidup di memori: tutup aplikasi, dan program pengguna lenyap. Padahal justru ketahanan inilah yang dijanjikan produk — layar `29 · Riwayat program` menjanjikan target lama tetap dapat dijelaskan berbulan-bulan kemudian, dan `05 · Program saya` menampilkan kemajuan harian yang harus bertahan melewati restart.

Assessment §42 dan §43 menetapkan bentuk tabel, indeks, migrasi, dan fixture yang diperlukan; §44 menetapkan bahwa aktivasi harus memuat ulang fakta terkini dan menulis seluruh perubahan dalam satu transaksi. Dikerjakan sekarang karena change berikutnya adalah layar onboarding dan aktivasi — layar itu memerlukan tempat menyimpan hasilnya, dan membangun UI di atas penyimpanan yang belum ada hanya memindahkan pekerjaan.

Change ini **tidak** membangun antarmuka pengguna.

## What Changes

- **Empat tabel baru** mengikuti §42: katalog program, program pengguna, progres program per tanggal, dan peristiwa siklus hidup — semuanya memakai konvensi record pengguna dari change 001 (pengenal UUID, jejak waktu, penghapusan lunak, keadaan sinkronisasi, revisi).
- **Seed katalog yang idempoten** untuk empat kode program, dengan pengenal tetap, sehingga menjalankannya berkali-kali tidak menggandakan baris maupun memutus tautan riwayat.
- **Penegakan satu program berjalan di tingkat basis data** lewat indeks unik parsial untuk baris `active` dan baris `paused`, ditambah penegakan dalam transaksi aktivasi — lapis kedua di bawah invarian domain.
- **Migrasi skema versi 1 ke versi 2** beserta fixture yang diwajibkan §43: basis data kosong, pembuatan langsung pada versi terkini, basis data berisi data, migrasi yang terputus, dan pemeriksaan foreign key.
- **Tidak ada pendaftaran otomatis**: pengguna lama tidak diikutkan ke program mana pun oleh migrasi. Setelah migrasi mereka melihat ajakan memilih program, dan seluruh catatan lama tetap terbuka — persis keadaan yang dirancang di layar `36 · Belum ada program`.
- **Repositori program** yang mengimplementasikan kontrak domain, menyembunyikan Drift dari lapisan atas, dan menyaring record yang terhapus lunak secara bawaan.
- **Transaksi aktivasi dan pergantian** yang memetakan satu perintah domain menjadi satu transaksi basis data: tandai program lama, tautkan dua arah, sisipkan peristiwa, aktifkan program baru, dan buat potret progres awal — seluruhnya berhasil atau seluruhnya batal.
- **Potret progres per tanggal lokal** yang dapat dibangun ulang secara idempoten: membangun ulang satu tanggal tidak pernah menggandakan nilai, dan data buku harian yang belum ada tetap tercatat sebagai belum diketahui, bukan nol.
- **Kueri riwayat** yang mengembalikan program berurutan beserta masukan, target, asumsi, dan versi aslinya.

Tidak ada perubahan BREAKING bagi pengguna — belum ada rilis publik. Perubahan skema bersifat maju saja; penurunan versi dinyatakan tidak didukung.

## Capabilities

### New Capabilities

- `program-progress`: ketahanan program melewati penutupan aplikasi, potret kemajuan per tanggal, riwayat program yang tetap dapat dijelaskan, serta perlakuan jujur terhadap hari yang datanya belum ada.

### Modified Capabilities

Tidak ada. `program-catalog` dan `program-lifecycle` dari change 003 diimplementasikan apa adanya tanpa perubahan requirement; `local-data-foundation` dari change 001 dipakai konvensinya tanpa diubah.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: tabel, DAO, repositori, seed, indeks, migrasi versi 1→2, fixture migrasi, dan uji basis data. Lapisan domain tidak berubah.
- **Bergantung pada** change 001 (kerangka penyimpanan, harness migrasi, konvensi record) dan change 003 (kontrak repositori, perintah siklus hidup, invarian).
- **Memblokir** change berikutnya: onboarding dan aktivasi program di layar, serta tampilan progres dan riwayat program.
- **Belum tersentuh**: antarmuka pengguna, katalog makanan, buku harian, dan perhitungan kemajuan yang bersumber dari catatan makanan — change ini menyiapkan tempatnya dan menetapkan bahwa data yang belum ada tetap "belum diketahui".
