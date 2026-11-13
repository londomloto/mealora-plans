# Work Order

## Ringkasan

Change ini mengisi dua ruang terakhir yang masih kosong di `mealora-apps/mealora-mobile`: pemantauan berat badan dan riwayat harian. Dibangun tabel catatan berat beserta migrasi skema versi 4 ke 5, repositori berat, layar pantau berat dan tambah berat, ruang Riwayat dengan kalender dan ringkasan tanggal, serta penyambungan ke potret kemajuan program dan usulan peninjauan target. Tidak ada pekerjaan di `mealora-plans`. Estimasi 6,5–8,5 hari-orang dalam tiga tahap. Setelah change ini, seluruh kriteria penerimaan MVP pada assessment §28 terpenuhi kecuali yang memerlukan jalur foto, barcode, dan label gizi.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Tabel catatan berat beserta indeks dan migrasi skema 4 → 5 | 0,75 | pasti | Mengikuti §11 dan konvensi record pengguna change 001 |
| 2 | Fixture migrasi dan ujinya: kosong, langsung v5, v4 berisi data makanan dan program, migrasi terputus | 0,5 | pasti | Pola sama dengan change sebelumnya |
| 3 | Repositori berat: tambah, sunting, hapus, baca terbaru, baca rentang | 1,0 | pasti | Berat terbaru adalah catatan terbaru, bukan kolom profil |
| 4 | Penyambungan catatan berat ke pembangunan ulang potret kemajuan program | 0,5 | pasti | Idempoten, aman dipicu berlebih |
| 5 | Pemeriksaan ambang hitung ulang dan pemunculan usulan peninjauan target di ruang Program | 0,75 | pasti | Usulan saja; target baru tetap butuh persetujuan |
| 6 | Layar tambah berat (`32`): nilai, tanggal, catatan bebas, validasi, penegasan tersimpan lokal | 0,75 | pasti | Tanggal masa depan ditolak |
| 7 | Layar pantau berat (`31`): berat terbaru, perbandingan terhadap berat awal program, tren tujuh catatan terakhir, daftar catatan terakhir | 1,25 | pasti | Setiap titik tren adalah catatan asli |
| 8 | Penyuntingan dan penghapusan catatan berat dari daftar | 0,5 | pasti | Salah ketik harus murah diperbaiki |
| 9 | Keadaan khusus berat: belum ada catatan, satu catatan saja, program tanpa berat awal | 0,5 | pasti | Tidak ada 0 kg dan tidak ada tren dari satu titik |
| 10 | Ruang Riwayat (`18`): kalender bulanan, penandaan hari bercatatan, pemilihan tanggal | 1,25 | pasti | Tanggal masa depan tidak dapat dipilih |
| 11 | Ringkasan tanggal terpilih memakai ulang komponen ringkasan change 007, beserta daftar catatan makan dan berat hari itu | 0,75 | pasti | Bukan komponen ringkasan kedua |
| 12 | Penyuntingan catatan makan dari riwayat beserta pembangunan ulang kemajuan tanggal itu | 0,5 | pasti | Aturan sama dengan hari berjalan |
| 13 | Keadaan hari tanpa catatan di riwayat (`40`) dan hari yang baru sebagian tercatat | 0,5 | pasti | Belum diketahui, bukan nol dan bukan gagal |
| 14 | Aksesibilitas dan gate verifikasi repo | 0,75 | pasti | Kalender pada skala teks besar adalah titik rawan |

**Subtotal:** 6,5–8,5 hari-orang.

## Dependensi Antar-Paket

- Change 004 memblokir paket 4 dan 12 (potret kemajuan), change 006 memblokir paket 5 (ruang Program tempat usulan muncul), change 007 memblokir paket 11 dan 12 (komponen ringkasan dan penyuntingan catatan makan).
- Change 002 tidak memblokir change ini. Tanpa kebijakan yang disetujui, tidak ada ambang hitung ulang yang berlaku dan tidak ada usulan yang muncul — keadaan yang sudah sesuai aturan.
- Paket 1 mendahului paket 3; paket 3 mendahului paket 4 sampai 9.
- Paket 10 mendahului paket 11, 12, dan 13.
- Paket 14 mengakhiri pekerjaan.
- Change ini tidak memblokir tiga change input berikutnya; barcode, label gizi, dan foto makanan bergantung pada change 007, bukan pada change ini.

## Urutan Rilis

### Tahap 1 — Penyimpanan dan repositori berat

**Isi:** paket 1, 2, 3, 4, 5.
**Prasyarat:** change 007 selesai.
**Gate verifikasi:** `flutter analyze`, `dart format`, dan `flutter test` bersih; seluruh fixture migrasi lolos dan pemeriksaan foreign key bersih; berat terbaru selalu menunjuk catatan terbaru, diuji termasuk setelah penyuntingan dan penghapusan catatan terakhir; penambahan, penyuntingan, dan penghapusan catatan berat memperbarui potret kemajuan tanggal terkait tanpa penggandaan; usulan peninjauan target muncul hanya ketika ambang kebijakan terlewati, dan target lama tetap berlaku.

### Tahap 2 — Layar berat

**Isi:** paket 6, 7, 8, 9.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** uji widget pada ukuran teks normal dan besar; nilai berat mustahil dan tanggal masa depan ditolak dengan penjelasan; celah pada tren tampil sebagai ketiadaan data dan tidak disambung dari nilai terakhir; satu catatan tidak digambar sebagai tren; keadaan belum ada catatan tidak menampilkan 0 kg; pemeriksaan kalimat per kalimat memastikan tidak ada pujian atas penurunan maupun teguran atas kenaikan; pemeriksaan manual di Chrome pada viewport 390×844 dibandingkan dengan `31` dan `32`.

### Tahap 3 — Riwayat harian dan pengerasan

**Isi:** paket 10, 11, 12, 13, 14.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** kalender menandai hari bercatatan tanpa bergantung warna saja dan tanpa penilaian; tanggal masa depan tidak dapat dipilih; ringkasan tanggal memakai komponen yang sama dengan ruang Hari ini; hari kosong tampil sebagai belum diketahui; penyuntingan catatan pada tanggal lama memperbarui ringkasan dan kemajuan tanggal itu; ringkasan hari lampau tidak berubah setelah katalog diperbarui dan program diganti, diuji eksplisit; kalender tetap utuh pada skala teks besar; pembaca layar mengumumkan setiap tanggal beserta keadaan catatannya; verifikasi alur penuh di perangkat Android; uji kriteria penerimaan MVP §28 untuk jalur manual.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Kalender pecah layoutnya pada skala teks besar | Aksesibilitas gagal di gate tahap 3 | Uji skala teks besar sejak paket 10 dikerjakan, bukan di akhir |
| Berat terbaru berbeda antara ruang Program dan pemantauan berat | Pengguna melihat dua angka berbeda | Keduanya membaca sumber yang sama; diuji dengan penyuntingan dan penghapusan catatan terakhir |
| Usulan peninjauan target muncul di saat yang salah | Terasa seperti tekanan setelah menimbang | Usulan hanya muncul di ruang Program, ditegaskan sebagai syarat gate tahap 1 |
| Celah pada tren dianggap bug | Laporan keliru dan tekanan untuk menyambung garis | Celah diberi keterangan; keputusan dan alasannya dicatat di design agar tidak dibalik diam-diam |
| Penyuntingan banyak tanggal memicu pembangunan ulang bertubi-tubi | Terasa lambat | Pembangunan ulang per tanggal dan idempoten; ukur bila terasa, perbaiki dengan penundaan terjadwal pada change tersendiri |
| Bahasa bergeser menjadi menghakimi saat implementasi | Melanggar arah produk | Pemeriksaan kalimat per kalimat sebagai syarat gate tahap 2 dan 3, mengacu rancangan `18`, `31`, dan `40` |
