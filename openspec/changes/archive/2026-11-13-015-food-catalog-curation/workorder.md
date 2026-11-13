# Work Order

## Ringkasan

Change ini mengirim katalog makanan yang terkurasi: nilai gizi dikoreksi terhadap TKPI 2017, takaran sehari-hari dengan asal-usul bertingkat, masukan gram/ml, pemisahan bentuk siap konsumsi, sinonim pencarian, dan pemeriksaan mutu otomatis (lihat `frs.md`). Repo yang tersentuh adalah `mealora-mobile` (skema, generator, dataset, UI, test) dan `mealora-plans` (dokumentasi sumber). Rilisnya dibagi tiga tahap.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Migrasi skema v10 (provenans takaran, bentuk, status aktif) + test migrasi | 1 | pasti | Hanya `addColumn` |
| 2 | Ekspor seed sekarang ke dataset CSV + generator seed + test sinkron | 1,5 | pasti | |
| 3 | Pemeriksa mutu katalog (test) + laporan awal pelanggaran | 1 | pasti | |
| 4 | Pencocokan 1.346 item ke TKPI 2017 + koreksi gizi + karbo 0 + duplikat | 3–5 | spike 1 hari dulu | Bergantung struktur PDF TKPI 2017 (ekstraksi tabel) |
| 5 | Takaran sehari-hari ~250 makanan teratas + tinjauan pemilik produk per batch | 4 | pasti (eksekusi), tinjauan bergantung jadwal pemilik produk | Batch 50 item |
| 6 | Takaran sisa katalog + bentuk siap konsumsi (mis. teh seduh) | 3 | pasti | |
| 7 | UI: penanda "perkiraan", takaran bawaan baru, masukan gram/ml | 2 | pasti | Mengikuti `docs/mealora-v2.pen` |
| 8 | Pencarian: sinonim, urutan bentuk, filter aktif; alias satuan suara | 1 | pasti | |
| 9 | Verifikasi emulator Android + gate repo | 1 | pasti | |

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Perbarui `docs/food-data-sources.md` (tingkat sumber, rujukan dataset, keterbatasan baru) | 0,5 | pasti | |

Total kasar: **18–21 hari-orang**, belum termasuk waktu tunggu tinjauan pemilik produk.

## Dependensi Antar-Paket

- Change 007 diarsipkan lebih dulu, karena spec `food-catalog` yang dimodifikasi berasal dari sana.
- mobile#1 → mobile#2 → mobile#3, karena generator butuh kolom baru dan pemeriksa butuh dataset.
- mobile#3 → mobile#4/#5/#6, karena kurasi memakai pemeriksa sebagai umpan balik.
- mobile#1 → mobile#7, #8.
- mobile#5 butuh tinjauan pemilik produk per batch sebelum batch berikutnya digabung.

## Urutan Rilis

### Tahap 1 — Fondasi & akurasi gizi

**Isi:** mobile#1–#4, plans#1.
**Prasyarat:** 007 diarsipkan. PDF TKPI 2017 sudah diunduh.
**Gate verifikasi:** `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` (termasuk test mutu dan test migrasi v9→v10). Lalu uji pembaruan di emulator dari build v9 berisi catatan: catatan lama tidak berubah dan pencarian berjalan.

### Tahap 2 — Takaran sehari-hari & UI

**Isi:** mobile#5, #7, #8.
**Prasyarat:** Tahap 1 sudah digabung.
**Gate verifikasi:** test mutu lolos, tinjauan pemilik produk untuk semua batch ~250 item, dan skenario uji FRS 1–7 dijalankan di emulator.

### Tahap 3 — Sisa katalog

**Isi:** mobile#6, #9.
**Prasyarat:** Tahap 2 sudah digabung.
**Gate verifikasi:** test mutu lolos untuk seluruh katalog, spot-check acak 30 item oleh pemilik produk, dan gate repo lengkap.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Tabel PDF TKPI 2017 sulit diekstrak otomatis | mobile#4 molor | Spike 1 hari. Fallback: entri manual berbantuan untuk item yang gagal diekstrak |
| Banyak nama Kaggle tidak cocok dengan TKPI 2017 | mobile#4 molor | Pencocokan kode/nama bertahap. Item yang tidak cocok ditandai belum terverifikasi, bukan memblokir |
| Tinjauan pemilik produk lambat | Tahap 2 tertunda | Batch kecil (50 item), tinjauan berjalan paralel dengan mobile#7/#8 |
| DBMP/SKMI resmi tidak kunjung didapat | Lebih banyak takaran berlabel "perkiraan" | Desain sudah menampung, dan dataset bisa diganti kapan saja tanpa perubahan kode |
