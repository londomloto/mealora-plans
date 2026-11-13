# Work Order

## Ringkasan

Change ini membangun inti produk di dua repositori. Di `mealora-plans`, ditelusuri dan didokumentasikan sumber data gizi beserta hak pakainya, lalu disusun himpunan katalog awal yang dikurasi dengan provenans lengkap. Di `mealora-apps/mealora-mobile`, dibangun tabel makanan dan buku harian beserta migrasi skema versi 3 ke 4, pencarian luring, layar pencarian, detail sajian, makanan buatan sendiri, buku harian, penyuntingan catatan, serta ruang Hari ini yang hidup. Estimasi 13–17 hari-orang dalam empat tahap. Ini change terbesar dalam rangkaian MVP 1.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Telusuri sumber data gizi dan hak pakainya; dokumentasikan mana yang boleh didistribusikan dalam aplikasi | 1,0 | spike (timebox 1 hari) | Hasilnya menentukan seberapa besar katalog bisa tumbuh |
| 2 | Susun himpunan katalog awal yang dikurasi: makanan Indonesia umum beserta takaran saji, nilai gizi, dan provenans lengkap | 2,0 | pasti | Lebih baik seratus makanan sah daripada dua ribu tanpa hak |
| 3 | Dokumentasikan proses verifikasi nilai dan penambahan makanan baru untuk change berikutnya | 0,5 | pasti | Agar katalog dapat tumbuh tanpa mengulang penelusuran |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 4 | Tabel makanan, takaran saji, nilai gizi, catatan makan, dan butir catatan beserta migrasi skema 3 → 4 | 1,5 | pasti | Mengikuti §11 dan konvensi record pengguna change 001 |
| 5 | Seed katalog idempoten dengan pengenal tetap dan provenans, dari hasil paket 2 | 0,75 | pasti | |
| 6 | Fixture migrasi dan ujinya: kosong, langsung v4, v3 berisi program, migrasi terputus | 0,75 | pasti | Pola sama dengan change 004 |
| 7 | Repositori makanan dan pencarian luring beserta indeksnya | 1,0 | pasti | Pencocokan substring tanpa peka huruf besar-kecil |
| 8 | Repositori buku harian: tambah, sunting, pindah, hapus, dengan potret nilai gizi dan transaksi | 1,5 | pasti | Potret dibekukan saat pencatatan |
| 9 | Agregasi harian dari potret, termasuk penanganan nilai belum diketahui per zat gizi | 1,0 | pasti | Dihitung, tidak disimpan ganda |
| 10 | Pemicu pembangunan ulang potret kemajuan program pada setiap perubahan catatan | 0,5 | pasti | Idempoten, aman dipicu berlebih |
| 11 | Layar pencarian makanan (`13`) beserta bagian terakhir dicatat dan keadaan tanpa hasil | 1,25 | pasti | Favorit ditandai belum tersedia |
| 12 | Layar detail sajian (`14`): takaran, jumlah, waktu makan, perkiraan gizi sebelum simpan | 1,0 | pasti | |
| 13 | Layar makanan buatan sendiri (`15`) beserta aturan nilai belum diketahui dan penolakan nilai mustahil | 1,0 | pasti | |
| 14 | Layar buku harian (`16`) dan penyuntingan catatan (`17`) termasuk pemindahan waktu makan dan penghapusan | 1,5 | pasti | |
| 15 | Ruang Hari ini (`01`) yang hidup dan lembar pilihan pencatatan (`02`) | 1,25 | pasti | Jalur foto dan barcode ditandai belum tersedia |
| 16 | Keadaan hari tanpa catatan (`40`), keadaan tanpa target, dan bahasa netral untuk kelebihan konsumsi | 0,75 | pasti | |
| 17 | Aksesibilitas dan gate verifikasi repo | 1,0 | pasti | Termasuk pengumuman angka ringkasan beserta maknanya |

**Subtotal:** 13,0–17,0 hari-orang.

## Dependensi Antar-Paket

- Change 001 dan 004 memblokir seluruh paket di `mealora-mobile`; change 005 memblokir paket 15 dan 16 karena ruang Hari ini berasal dari sana.
- Change 002 tidak memblokir change ini. Tanpa kebijakan yang disetujui, dasbor menampilkan konsumsi tanpa target — dan itu keadaan yang sudah dispesifikasikan.
- Paket 1 mendahului paket 2 — tidak boleh menyusun katalog dari sumber yang hak pakainya belum jelas.
- Paket 2 mendahului paket 5.
- Paket 4 mendahului paket 5 sampai 10.
- Paket 7 mendahului paket 11; paket 8 mendahului paket 12, 13, dan 14; paket 9 mendahului paket 15 dan 16.
- Paket 17 mengakhiri pekerjaan.
- Change ini memblokir tiga change input berikutnya: barcode, label gizi, dan foto makanan.

## Urutan Rilis

### Tahap 1 — Sumber data dan skema

**Isi:** paket 1, 2, 3, 4, 5, 6.
**Prasyarat:** change 004 selesai.
**Gate verifikasi:** dokumen sumber data menyatakan secara eksplisit sumber mana yang boleh didistribusikan dan mana yang tidak; setiap makanan pada himpunan awal memiliki provenans lengkap; seed dijalankan tiga kali menghasilkan jumlah baris yang sama dengan pengenal yang sama; seluruh fixture migrasi lolos; pemeriksaan foreign key bersih; `flutter analyze`, `dart format`, dan `flutter test` bersih.

### Tahap 2 — Repositori dan agregasi

**Isi:** paket 7, 8, 9, 10.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** pencarian mengabaikan huruf besar-kecil dan mencocokkan bagian mana pun dari nama; potret nilai gizi tidak berubah setelah katalog diperbarui, makanan buatan pengguna disunting, atau makanan dihapus; penyimpanan catatan yang gagal tidak meninggalkan sisa; nilai belum diketahui tidak pernah menjadi nol di seluruh rantai; perubahan catatan memicu pembangunan ulang potret kemajuan dan hasilnya tidak tergandakan.

### Tahap 3 — Layar katalog dan buku harian

**Isi:** paket 11, 12, 13, 14.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** uji widget seluruh layar pada ukuran teks normal dan besar; hasil pencarian kosong menawarkan pembuatan makanan sendiri; bagian terakhir dicatat kosong bagi pengguna baru dan tidak diisi contoh; nilai gizi dikosongkan tersimpan sebagai belum diketahui; nilai mustahil ditolak dengan penjelasan; pemindahan antar waktu makan tidak mengubah total harian; pemeriksaan manual di Chrome pada viewport 390×844 dibandingkan dengan `13`–`17`.

### Tahap 4 — Dasbor dan pengerasan

**Isi:** paket 15, 16, 17.
**Prasyarat:** tahap 3 selesai dan gate-nya lolos.
**Gate verifikasi:** total pada ruang Hari ini menyesuaikan seketika setelah setiap perubahan catatan; hari tanpa catatan tampil sebagai belum diketahui; keadaan tanpa target tampil tanpa sisa maupun persentase; kelebihan konsumsi dinyatakan netral, diperiksa kalimat per kalimat; jalur foto dan barcode ditandai belum tersedia dan tidak dapat dibuka; uji integrasi alur penuh dalam mode pesawat dari pencarian sampai ringkasan; data bertahan setelah perangkat dimatikan dan dinyalakan; pemeriksaan skala teks besar dan pembaca layar; verifikasi di perangkat Android.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Hak pakai sumber data tidak kunjung jelas dalam timebox | Katalog awal lebih kecil dari harapan | Katalog tetap berjalan dengan himpunan kecil; jalur makanan buatan sendiri diperlakukan sebagai jalur utama; penambahan sumber menjadi change tersendiri tanpa mengubah requirement |
| Penyusunan katalog manual memakan waktu lebih lama | Tahap 1 melar dan menahan seluruh tahap berikutnya | Batasi himpunan awal pada makanan yang paling sering dicatat; tahap 2 dapat dimulai dengan data uji sementara selama seed belum final |
| Potret nilai gizi membesarkan basis data melebihi perkiraan | Kinerja dan ukuran pemasangan terganggu | Ukur ukuran basis data pada data uji realistis sebelum change ditutup; potret dibatasi pada nilai yang memang ditampilkan |
| Pencarian terasa lambat setelah katalog tumbuh | Pengalaman pencatatan memburuk | Ukur pada katalog uji berukuran beberapa kali himpunan awal; peningkatan pencarian menjadi change tersendiri dengan tolok ukur |
| Nilai belum diketahui merembet dan membuat ringkasan sulit dibaca | Pengguna bingung membaca total | Pernyataan ketidaklengkapan per zat gizi, diuji dengan makanan yang sengaja tidak lengkap |
| Change ini terlalu besar untuk satu kali review | Kualitas review menurun | Empat tahap dengan gate masing-masing; setiap tahap dapat di-review tersendiri |
| Bahasa dasbor bergeser menjadi menghukum saat implementasi | Melanggar arah produk | Pemeriksaan kalimat per kalimat sebagai bagian gate tahap 4, mengacu pada rancangan `18` dan `40` |
