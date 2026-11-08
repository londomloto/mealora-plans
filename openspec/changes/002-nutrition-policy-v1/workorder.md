# Work Order

## Ringkasan

Change ini menghasilkan kebijakan gizi berversi `np-1.0.0` beserta dasar rujukan, vektor uji emas, dan persetujuan peninjau gizi. Dua repositori tersentuh: `mealora-plans` memuat dokumen peninjauan dan tabel vektor uji, `mealora-apps/mealora-mobile` memuat berkas data kebijakan berversi dan fixture uji. Tidak ada mesin perhitungan yang ditulis di sini — `ProgramEngine` adalah change berikutnya. Estimasi 3,5–5 hari-orang di pihak kami, ditambah waktu tunggu peninjauan gizi yang berada di luar kendali tim. Dua tahap: penyusunan dan peninjauan, lalu pengesahan dan penurunan ke repo aplikasi.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Dokumen peninjauan `docs/nutrition-policy-v1.md`: seluruh nilai, dasar rujukan, pranala sumber, dan kolom keputusan peninjau per baris | 1,0 | pasti | Disusun agar peninjau bisa menyetujui atau mengoreksi nilai satu per satu |
| 2 | Tabel vektor uji emas: kasus normal, kasus batas tepat di bawah/pada/di atas setiap ambang, dan seluruh kasus penolakan | 1,0 | pasti | Setiap baris memuat masukan, hasil yang diharapkan, dan aturan yang diuji |
| 3 | Pemeriksaan silang terhadap AKG Indonesia (PMK 28/2019) untuk protein, lemak, karbohidrat, dan serat | 0,5 | pasti | Sebagai pembanding kewajaran, bukan sebagai sumber target |
| 4 | Pemetaan kode alasan ke kalimat berbahasa Indonesia yang dilihat pengguna, selaras dengan layar `26 · Kebijakan belum tersedia` | 0,5 | pasti | Ditinjau bersama peninjau gizi agar tidak terdengar menghakimi atau mendiagnosis |
| 5 | Siklus peninjauan gizi: pengajuan, penerimaan koreksi, penerapan koreksi, pencatatan persetujuan | 0,5 | spike (waktu tunggu di luar kendali tim) | Durasi bergantung ketersediaan peninjau; usaha tim sendiri kecil |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 6 | Berkas data kebijakan berversi `np-1.0.0` beserta penanda status persetujuan | 0,5 | pasti | Data saja; belum ada kode yang membacanya |
| 7 | Fixture uji emas dalam bentuk yang bisa dibaca uji otomatis, terikat ke versi kebijakan | 0,5 | pasti | Dipakai change berikutnya sebagai uji regresi `ProgramEngine` |

**Subtotal:** 3,5–5,0 hari-orang, di luar waktu tunggu peninjauan.

## Dependensi Antar-Paket

- Paket 1 memblokir paket 2, 3, dan 4 — vektor uji dan pemetaan kalimat diturunkan dari nilai yang sudah tertulis lengkap.
- Paket 2 dan 3 mendahului paket 5: peninjau gizi meninjau nilai beserta kasus batasnya sekaligus, bukan dua kali.
- Paket 5 memblokir paket 6 dan 7 dalam arti **status**: berkas data boleh disiapkan lebih dulu, tetapi penandanya tidak boleh berubah menjadi disetujui sebelum peninjauan selesai.
- Change 001 (fondasi aplikasi) tidak memblokir change ini — keduanya dapat berjalan paralel, karena change ini tidak menulis kode aplikasi.
- Change ini memblokir seluruh change program berikutnya: `ProgramEngine`, pratinjau dan aktivasi target, serta setiap layar yang menampilkan angka target.

## Urutan Rilis

### Tahap 1 — Penyusunan dan peninjauan

**Isi:** paket 1, 2, 3, 4, 5.
**Prasyarat:** artefak change ini disetujui pemilik produk sebagai bahan yang layak diajukan ke peninjau gizi.
**Gate verifikasi:** dokumen peninjauan memuat setiap nilai yang disebut di `specs/nutrition-policy/spec.md` tanpa kecuali; setiap nilai punya dasar yang dapat dibuka pranalanya atau ditandai eksplisit sebagai keputusan produk; vektor uji mencakup seluruh aturan dan seluruh kode alasan; peninjau gizi memberikan keputusan tertulis per baris; seluruh koreksi peninjau sudah diterapkan ke `specs/` dan dokumen peninjauan.

### Tahap 2 — Pengesahan dan penurunan ke repo aplikasi

**Isi:** paket 6, 7, serta perubahan status `np-1.0.0` menjadi disetujui.
**Prasyarat:** tahap 1 selesai dan peninjau gizi menyetujui.
**Gate verifikasi:** berkas data kebijakan di repo aplikasi identik nilainya dengan `specs/nutrition-policy/spec.md` (diperiksa baris per baris); fixture uji emas dapat dibaca perkakas uji; penanda status, tanggal persetujuan, dan identitas peninjau tercatat; change berikutnya dapat dimulai.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Peninjau gizi belum ditunjuk atau tidak tersedia | Seluruh change program tertahan tanpa batas waktu | Tunjuk peninjau sebelum tahap 1 dimulai; sementara itu change 001 dan pekerjaan katalog makanan tetap bisa berjalan karena tidak bergantung pada kebijakan |
| Peninjau mengubah banyak nilai sekaligus | Vektor uji emas dan dokumen harus disusun ulang | Susun vektor uji dari aturan, bukan dari angka hasil, sehingga perubahan nilai hanya mengubah kolom hasil |
| Perubahan kebijakan datang setelah `ProgramEngine` ditulis | Rework di change berikutnya | Tahan change program sampai status `np-1.0.0` disetujui; jangan mulai dengan nilai sementara |
| Nilai di repo aplikasi menyimpang dari spec karena disalin manual | Perilaku aplikasi berbeda dari kebijakan yang disetujui | Pemeriksaan baris per baris sebagai gate tahap 2, dan uji yang membandingkan berkas data dengan vektor emas |
| Pengali aktivitas ditolak peninjau | Seluruh angka turunan berubah | Pengali sudah ditandai sebagai keputusan produk; vektor uji dirancang agar penggantiannya langsung terlihat dampaknya |
| Dokumen dianggap sebagai nasihat medis | Risiko reputasi dan hukum | Bahasa produk konsisten menyebut perkiraan; penolakan tidak mendiagnosis; batas cakupan dinyatakan di dokumen dan di aplikasi |
