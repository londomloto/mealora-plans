# Work Order

## Ringkasan

Change ini membangun perjalanan pertama pengguna di dua repositori. Di `mealora-plans`, satu layar baru ditambahkan ke dokumen desain — keadaan "masukan berubah sejak pratinjau" yang diwajibkan domain tetapi belum dirancang. Di `mealora-apps/mealora-mobile`, dibangun tabel profil beserta migrasi skema versi 2 ke 3, alur onboarding sembilan layar, penyambungan ke perintah aktivasi, dan penyambungan ruang Hari ini ke program aktif. Estimasi 9,5–12,5 hari-orang dalam tiga tahap: desain dan profil, alur onboarding, lalu aktivasi dan keadaan khusus.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Rancang layar "masukan berubah sejak pratinjau" di `docs/mealora.pen`, mengikuti bahasa visual `12 · Tinjau target` | 0,5 | pasti | Daftar nilai yang berubah, nilai lama dan baru, pratinjau diperbarui, nada netral |
| 2 | Pemetaan kode alasan penolakan ke kalimat Indonesia pada kerangka layar `26`, ditinjau terhadap tiga larangan bahasa | 0,5 | pasti | Melanjutkan task 3.2 change 002; hasil akhirnya dipakai implementasi |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 3 | Tabel profil, repositori profil, dan migrasi skema 2 → 3 termasuk pelengkapan foreign key dari tabel program | 1,0 | pasti | Tidak membuat profil otomatis |
| 4 | Fixture migrasi: kosong, langsung v3, v2 berisi data program, v2 berisi program tanpa profil, migrasi terputus | 0,75 | pasti | Perlakuan baris yatim diputuskan saat fixture dibuat dan dicatat |
| 5 | Wadah state alur onboarding: masukan terkumpul, langkah saat ini, penyimpanan bertahap, penanda kelengkapan | 1,0 | pasti | Satu wadah per alur, bukan per layar |
| 6 | Layar sambutan dan profil awal (`07`, `08`) beserta validasi masukan dan keterangan masukan biologis | 1,25 | pasti | Nama panggilan opsional |
| 7 | Layar tingkat aktivitas (`09`) beserta tiga pilihan dan keterangan pengaruhnya | 0,5 | pasti | |
| 8 | Layar pemilihan program dan detail program (`10`, `11`) beserta fokus kebiasaan dan pengakuan perkiraan | 1,25 | pasti | Pengakuan wajib sebelum pratinjau |
| 9 | Layar target berat (`25`) untuk Turun Berat dan Naik Berat, dengan tanggal tujuan opsional | 0,75 | pasti | |
| 10 | Layar tinjau target (`12`): nilai, dasar perkiraan, asumsi, peringatan, kedua versi, pernyataan belum aktif | 1,25 | pasti | Angka hanya muncul pada hasil yang disetujui |
| 11 | Penyambungan ke perintah aktivasi change 003 dan 004, termasuk penanganan hasil verifikasi ulang | 0,75 | pasti | Perbandingan dilakukan perintah, bukan lapisan tampilan |
| 12 | Layar "masukan berubah sejak pratinjau" sesuai rancangan paket 1 | 0,75 | pasti | Peninjauan ulang, bukan dialog kesalahan |
| 13 | Kerangka layar keadaan tidak-disetujui (`26`) dengan isi per kode alasan, dan keadaan belum ada program (`36`) | 1,0 | pasti | Satu kerangka, bukan lima layar terpisah |
| 14 | Ruang Hari ini membaca program aktif dan target harian; konsumsi tetap "belum diketahui" | 0,75 | pasti | Menggantikan keadaan kosong dari change 001 |
| 15 | Aksesibilitas dan pemeriksaan bahasa seluruh layar onboarding | 0,75 | pasti | Skala teks besar, pembaca layar, kesalahan tidak hanya lewat warna |
| 16 | Gate verifikasi repo dan uji integrasi alur penuh | 0,75 | pasti | `flutter analyze`, `dart format`, `flutter test` |

**Subtotal:** 9,5–12,5 hari-orang.

## Dependensi Antar-Paket

- Change 001 memblokir seluruh paket di `mealora-mobile`: tema, komponen dasar, lokalisasi, dan navigasi berasal dari sana.
- Change 003 dan 004 memblokir paket 11 sampai 14: perintah aktivasi dan penyimpanan program berasal dari sana.
- Change 002 **tidak** memblokir change ini. Selama kebijakan berstatus draf, seluruh alur bermuara di paket 13, dan itu memang perilaku rilis yang benar.
- Paket 1 mendahului paket 12 — layar dirancang sebelum dibangun.
- Paket 2 mendahului paket 13 — kalimat ditinjau sebelum ditanam di kode.
- Paket 3 mendahului paket 5 sampai 10: tidak ada tempat menyimpan masukan sebelum tabel profil ada.
- Paket 5 mendahului seluruh paket layar.
- Paket 10 mendahului paket 11 dan 12.
- Change ini memblokir change siklus hidup program di layar, serta katalog makanan dan buku harian.

## Urutan Rilis

### Tahap 1 — Desain dan fondasi profil

**Isi:** paket 1, 2, 3, 4, 5.
**Prasyarat:** change 001 dan 004 selesai.
**Gate verifikasi:** layar baru ada di `docs/mealora.pen` dan konsisten dengan bahasa visual yang berlaku; seluruh kalimat penolakan lolos pemeriksaan tiga larangan bahasa; `flutter analyze`, `dart format`, dan `flutter test` bersih; seluruh fixture migrasi lolos termasuk basis data v2 berisi program; pemeriksaan foreign key bersih setelah migrasi; tidak ada profil yang dibuat otomatis.

### Tahap 2 — Alur pengumpulan masukan

**Isi:** paket 6, 7, 8, 9.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** uji widget untuk setiap layar; masukan tersimpan bertahap dan bertahan melewati penutupan aplikasi; perpindahan mundur tidak menghilangkan isian; nilai tidak masuk akal ditolak dengan penjelasan rentang; Makan Sehat tidak pernah meminta berat tujuan; pengakuan perkiraan wajib sebelum pratinjau; pemeriksaan manual di Chrome pada viewport 390×844 dibandingkan dengan layar `07`–`11` dan `25`.

### Tahap 3 — Pratinjau, aktivasi, dan keadaan khusus

**Isi:** paket 10, 11, 12, 13, 14, 15, 16.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** uji integrasi alur penuh dari pemasangan sampai program aktif berjalan dalam mode pesawat; menutup pratinjau tidak menyisakan data program; perubahan fakta sebelum persetujuan membatalkan aktivasi dan menampilkan pratinjau diperbarui; keadaan tidak-disetujui tidak menampilkan satu pun angka, diuji termasuk terhadap sisa state pratinjau sebelumnya; keadaan belum ada program muncul pada ketiga jalurnya; ruang Hari ini menampilkan program aktif dengan konsumsi "belum diketahui"; pemeriksaan skala teks besar dan pembaca layar; verifikasi di perangkat Android untuk alur penuh.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Kebijakan gizi belum disetujui saat change ini selesai | Jalur bahagia tidak dapat diperlihatkan ke pemangku kepentingan | Uji dengan kebijakan draf di lingkungan uji; keadaan "target belum tersedia" adalah perilaku rilis yang benar sampai persetujuan turun |
| Migrasi v2 → v3 menemukan baris program tanpa profil pada perangkat uji | Tahap 1 tertahan | Fixture khusus dan keputusan perlakuan ditetapkan saat fixture dibuat, bukan saat migrasi gagal |
| Jumlah layar membuat tahap 2 melar | Jadwal keseluruhan mundur | Layar memakai komponen dasar change 001; bila melar, paket 9 (target berat) dapat dipindah ke tahap 3 karena hanya dipakai dua program |
| Angka bocor di keadaan penolakan lewat sisa state | Melanggar aturan keselamatan produk | Uji khusus yang membuka pratinjau lalu memicu penolakan, memeriksa tidak ada angka tersisa |
| Layar baru hasil rancangan sendiri terasa mengganggu saat dipakai | Perlu perbaikan setelah uji coba | Strukturnya meniru layar `12`; perbaikan murah karena terisolasi di satu layar |
| Onboarding terasa panjang bagi pengguna | Tingkat penyelesaian rendah | Indikator langkah, masukan tersimpan, nama panggilan opsional; tidak menambah langkah di luar kebutuhan perhitungan dan kelayakan |
