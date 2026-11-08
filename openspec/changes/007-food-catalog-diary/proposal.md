# 007 · Katalog makanan, buku harian, dan dasbor harian

## Why

Setelah change 001–006, Mealora dapat menghitung target dan mengelola program — tetapi belum bisa mencatat satu suap makanan pun. Seluruh angka kemajuan masih "belum diketahui", dan ruang Hari ini menampilkan target tanpa konsumsi.

Ini adalah inti produk. Pertanyaan kedua dan ketiga dari visi produk — "apa yang sudah saya makan hari ini?" dan "bagaimana kemajuan saya?" — baru terjawab di sini. Assessment §6.4–§6.8 dan §14 menetapkan katalog, pencarian, makanan buatan sendiri, buku harian, potret nilai gizi, dan agregasi harian sebagai MUST HAVE MVP 1.

Rancangannya sudah ada di `docs/mealora.pen`: `01`, `02`, `13`, `14`, `15`, `16`, `17`, dan `40`.

## What Changes

- **Katalog makanan lokal** beserta takaran saji dan nilai gizinya, tersedia sepenuhnya luring, dengan cakupan makanan Indonesia yang disengaja.
- **Provenans data gizi**: setiap makanan katalog menyimpan sumber, pengenal sumber, versi sumber, dan tanggal verifikasi. Nilai gizi tidak boleh dikarang.
- **Pencarian makanan** (`13`) yang peka huruf besar-kecil, cepat secara luring, menampilkan takaran saji, serta memuat bagian "terakhir dicatat".
- **Detail sajian** (`14`): pemilihan takaran, jumlah, waktu makan, dan perkiraan gizi sebelum disimpan.
- **Makanan buatan sendiri** (`15`): nama, ukuran sajian, energi, protein, karbohidrat, lemak — dengan peringatan bahwa nilai yang belum diketahui jangan diisi nol.
- **Buku harian** (`16`) dengan empat waktu makan — Sarapan, Makan siang, Camilan, Makan malam — beserta ringkasan harian.
- **Potret nilai gizi** pada setiap catatan: nilai yang dipakai saat pencatatan dibekukan, sehingga pembaruan katalog di kemudian hari tidak mengubah riwayat.
- **Menyunting dan menghapus catatan** (`17`), termasuk memindahkan catatan ke waktu makan lain.
- **Dasbor Hari ini** (`01`) yang hidup: energi terkonsumsi, sisa perkiraan, kemajuan makro, dan daftar waktu makan.
- **Lembar tambah makanan** (`02`) sebagai pintu masuk pencatatan, dengan jalur pencarian dan input manual yang selalu tersedia luring.
- **Hari tanpa catatan** (`40`): konsumsi ditampilkan sebagai belum diketahui, bukan nol, dan bukan hari yang gagal.
- **Penyambungan ke kemajuan program**: potret kemajuan dari change 004 akhirnya punya sumber data sungguhan.

Dua jalur yang sudah terlihat di rancangan `02` — foto makanan dan pindai barcode — **tidak** termasuk change ini. Keduanya ditampilkan sebagai pintu yang belum aktif, dan dikirim pada change berikutnya.

## Capabilities

### New Capabilities

- `food-catalog`: makanan yang tersedia di perangkat beserta takaran saji, nilai gizi, dan asal-usul datanya, termasuk makanan yang dibuat pengguna sendiri dan cara menemukannya.
- `food-diary`: pencatatan apa yang dimakan pada suatu hari — menambah, menyunting, memindahkan, menghapus — beserta jaminan bahwa nilai gizi yang tercatat tidak berubah di kemudian hari.
- `daily-dashboard`: ringkasan sebuah hari — energi terkonsumsi, sisa perkiraan, kemajuan zat gizi makro, dan daftar waktu makan — termasuk perlakuan jujur terhadap hari yang belum dicatat.

### Modified Capabilities

Tidak ada. Kapabilitas program dari change 003–006 dipakai apa adanya; potret kemajuan `program-progress` kini terisi dari sumber sungguhan tanpa perubahan requirement.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: tabel makanan, takaran saji, nilai gizi, catatan makan, dan butir catatan beserta migrasi skema versi 3 ke 4; data awal katalog; pencarian luring; layar katalog, buku harian, dan dasbor; penyambungan pembangunan ulang potret kemajuan.
- **Repo `mealora-plans`**: dokumen sumber data gizi — dari mana nilai berasal, hak pakainya, dan bagaimana diverifikasi.
- **Bergantung pada** change 001 (kerangka, penyimpanan), 004 (potret kemajuan), 005 (profil, ruang Hari ini), dan secara longgar pada 002 (target yang ditampilkan dasbor; tanpa kebijakan yang disetujui, dasbor menampilkan konsumsi tanpa target).
- **Memblokir** tiga change input berikutnya: barcode, label gizi, dan foto makanan — ketiganya bermuara pada buku harian yang dibangun di sini.
- **Keputusan terbuka yang harus ditutup**: sumber data makanan Indonesia yang sah dipakai (assessment §33). Change ini menetapkan bahwa setiap nilai wajib punya provenans, dan melarang redistribusi data yang hak pakainya belum dipastikan.
- **Belum tersentuh**: pemantauan berat badan dan riwayat harian lintas tanggal (layar `18`, `31`, `32`), yang dikirim pada change tersendiri.
