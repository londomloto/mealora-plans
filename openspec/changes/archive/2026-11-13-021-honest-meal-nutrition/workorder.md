# Work Order

## Ringkasan

Change ini membuat total gizi jujur di tinjau foto, Hari ini, dan kedua kartu bagikan. Komponen foto yang belum ada di katalog bisa dilengkapi lewat Buat makanan (alat dari change 020), takaran mendapat satuan, dan makanan bisa dibagikan tanpa dicatat dengan kartu tanpa angka (FRS bagian 2). Repo yang disentuh hanya `mealora-mobile`, tanpa perubahan proxy, skema basis data, maupun data. Rilisnya satu tahap, setelah change 020.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | `PartialNutritionTotal` + formatter + unit test | 0.5 | pasti | Fungsi murni |
| 2 | Total jujur di tinjau foto & Hari ini | 0.5 | pasti | Hitung catatan berenergi null |
| 3 | Kartu makanan & ringkasan harian: total parsial, varian tanpa total, catatan belum dicatat | 0.75 | pasti | `MealShareCard`, `DailySummaryShareCard`, pratinjau |
| 4 | Tinjau foto: baris "belum ada di katalog", tombol "Lengkapi N bahan", tautan Bagikan saja tanpa mencatat | 0.5 | pasti | |
| 5 | Sheet koreksi: opsi Cari di katalog / Buat makanan ini, satuan takaran | 0.5 | pasti | |
| 6 | `CustomFoodScreen(returnCreatedFood)` + pengikatan ke komponen | 0.5 | pasti | Memakai `prefill` dari 020 |
| 7 | Layar Tersimpan: Lengkapi dulu / Bagikan tanpa total | 0.25 | pasti | |
| 8 | l10n + widget test + uji skenario FRS di HP fisik | 0.75 | pasti | |

**Total kasar:** ±4,25 hari-orang.

## Dependensi Antar-Paket

- Change 020 harus sudah ada di branch, karena Buat makanan dengan Tempel teks dan Foto info gizi berasal dari sana.
- Paket #1 mendahului #2, #3, dan #7.
- Paket #6 mendahului #5 untuk opsi "Buat makanan ini".
- Paket #3 mendahului #4 untuk tautan Bagikan saja, dan juga #7.

## Urutan Rilis

### Tahap 1 — Implementasi dan uji

**Isi:** semua paket.
**Prasyarat:** change 020 sudah selesai diimplementasikan.
**Gate verifikasi:**
- `flutter analyze`, `dart format --set-exit-if-changed lib test`, dan `flutter test`;
- skenario FRS 1–9 di HP fisik;
- regresi alur foto makanan (011) dan bagikan (014) untuk makanan yang lengkap.

Bila versi app di-bump, `latest_version` dan `release_notes` di `/app-config` proxy disinkronkan, dengan konfirmasi sebelum deploy.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Hitungan "belum diketahui" di Hari ini butuh data catatan per hari | Paket #2 molor | Pakai daftar catatan yang sudah dimuat layar Hari ini; bila belum tersedia, tambah query kecil di repository |
| Regresi kartu bagikan yang sudah dirilis (014) | Paket #3 molor | Widget test kartu untuk kasus lengkap dan tidak lengkap |
| 020 belum stabil | Tahap 1 tertunda | Mulai dari paket #1–#3 yang tidak bergantung pada 020 |
