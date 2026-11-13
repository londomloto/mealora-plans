# Work Order

## Ringkasan

Change ini menghasilkan kebijakan gizi berversi `np-1.0.0` beserta dasar rujukan, vektor uji emas, dan tinjauan teknisnya. Dua repositori tersentuh: `mealora-plans` memuat dokumen kebijakan, tabel vektor uji, dan hasil tinjauan; `mealora-apps/mealora-mobile` memuat berkas data kebijakan berversi dan fixture uji. Tidak ada mesin perhitungan yang ditulis di sini — `ProgramEngine` adalah change berikutnya. Estimasi 3,5–5 hari-orang. Dua tahap: penyusunan dan tinjauan teknis, lalu penerapan koreksi dan penurunan ke repo aplikasi.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Dokumen peninjauan `docs/nutrition-policy-v1.md`: seluruh nilai, dasar rujukan, pranala sumber, dan kolom keputusan peninjau per baris | 1,0 | pasti | Disusun agar peninjau bisa menyetujui atau mengoreksi nilai satu per satu |
| 2 | Tabel vektor uji emas: kasus normal, kasus batas tepat di bawah/pada/di atas setiap ambang, dan seluruh kasus penolakan | 1,0 | pasti | Setiap baris memuat masukan, hasil yang diharapkan, dan aturan yang diuji |
| 3 | Pemeriksaan silang terhadap AKG Indonesia (PMK 28/2019) untuk protein, lemak, karbohidrat, dan serat | 0,5 | pasti | Sebagai pembanding kewajaran, bukan sebagai sumber target |
| 4 | Pemetaan kode alasan ke kalimat berbahasa Indonesia yang dilihat pengguna, selaras dengan layar `26 · Target tidak dibuat` | 0,5 | pasti | Diperiksa terhadap tiga larangan: tidak mendiagnosis, tidak menjanjikan hasil, tidak menyalahkan pengguna |
| 5 | Siklus peninjauan gizi: pengajuan, penerimaan koreksi, penerapan koreksi, pencatatan persetujuan | 0,5 | spike (waktu tunggu di luar kendali tim) | Durasi bergantung ketersediaan peninjau; usaha tim sendiri kecil |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 6 | Berkas data kebijakan berversi `np-1.0.0` beserta penanda status persetujuan | 0,5 | pasti | Data saja; belum ada kode yang membacanya |
| 7 | Fixture uji emas dalam bentuk yang bisa dibaca uji otomatis, terikat ke versi kebijakan | 0,5 | pasti | Dipakai change berikutnya sebagai uji regresi `ProgramEngine` |

**Subtotal:** 3,5–5,0 hari-orang.

## Dependensi Antar-Paket

- Paket 1 memblokir paket 2, 3, dan 4 — vektor uji dan pemetaan kalimat diturunkan dari nilai yang sudah tertulis lengkap.
- Paket 2 dan 3 mendahului paket 5: tinjauan teknis menilai nilai beserta kasus batasnya sekaligus, bukan dua kali.
- Paket 5 memblokir paket 6 dan 7: berkas data boleh disiapkan lebih dulu, tetapi nilainya baru final setelah koreksi tinjauan diterapkan.
- Change 001 (fondasi aplikasi) tidak memblokir change ini — keduanya dapat berjalan paralel, karena change ini tidak menulis kode aplikasi.
- Change ini memblokir seluruh change program berikutnya: `ProgramEngine`, pratinjau dan aktivasi target, serta setiap layar yang menampilkan angka target.

## Urutan Rilis

### Tahap 1 — Penyusunan dan tinjauan teknis

**Isi:** paket 1, 2, 3, 4, 5.
**Prasyarat:** tidak ada.
**Gate verifikasi:** dokumen kebijakan memuat setiap nilai yang disebut di `specs/nutrition-policy/spec.md` tanpa kecuali; setiap nilai punya dasar yang dapat dibuka pranalanya atau ditandai eksplisit sebagai keputusan produk; vektor uji mencakup seluruh aturan dan seluruh kode alasan; tinjauan teknis memberikan putusan tertulis per baris; seluruh koreksi sudah diterapkan serempak ke `specs/`, `design.md`, `frs.md`, dan dokumen kebijakan.

### Tahap 2 — Penurunan ke repo aplikasi

**Isi:** paket 6 dan 7.
**Prasyarat:** tahap 1 selesai dan koreksi tinjauan sudah diterapkan.
**Gate verifikasi:** berkas data kebijakan di repo aplikasi identik nilainya dengan `specs/nutrition-policy/spec.md` (diperiksa baris per baris); fixture uji emas dapat dibaca perkakas uji; `flutter analyze`, `dart format`, dan `flutter test` lolos; change berikutnya dapat dimulai.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Angka dihitung dari rumus dan pedoman publik, bukan penilaian individual tenaga kesehatan | Risiko inheren aplikasi estimasi otomatis | Ditelusuri ke sumber publik per baris, diuji lewat vektor uji emas, gagal tertutup untuk profil di luar cakupan (`design.md` D13) |
| Tinjauan mengubah banyak nilai sekaligus | Vektor uji emas dan dokumen harus disusun ulang | Susun vektor uji dari aturan, bukan dari angka hasil, sehingga perubahan nilai hanya mengubah kolom hasil |
| Perubahan kebijakan datang setelah `ProgramEngine` ditulis | Rework di change berikutnya | Tutup change ini sebelum change 003 dimulai; perubahan nilai sesudahnya wajib menjadi versi kebijakan baru |
| Nilai di repo aplikasi menyimpang dari spec karena disalin manual | Perilaku aplikasi berbeda dari kebijakan tertulis | Pemeriksaan baris per baris sebagai gate tahap 2, dan uji yang membandingkan berkas data dengan vektor emas |
| Pengali aktivitas berubah lagi | Seluruh angka turunan berubah | Pengali kini terikat pita PAL FAO/WHO/UNU, bukan konvensi kalkulator; vektor uji dirancang agar penggantiannya langsung terlihat dampaknya |
| Dokumen dianggap sebagai nasihat medis | Risiko reputasi dan hukum | Bahasa produk konsisten menyebut perkiraan; penolakan tidak mendiagnosis; batas cakupan dinyatakan di dokumen dan di aplikasi |
