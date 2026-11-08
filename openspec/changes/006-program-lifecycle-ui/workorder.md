# Work Order

## Ringkasan

Change ini mengisi ruang Program di `mealora-apps/mealora-mobile` dengan seluruh layar pengelolaan program: keadaan berjalan dan dijeda, rincian asal-usul target, pratinjau pergantian, penyelesaian, riwayat beserta detailnya, dan alur ubah profil dengan peninjauan revisi target. Di `mealora-plans` ditambahkan satu layar yang diwajibkan assessment §45 tetapi belum dirancang: rincian "Bagaimana dihitung" untuk program yang sedang berjalan. Tidak ada perubahan skema basis data. Estimasi 8–10,5 hari-orang dalam tiga tahap.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Rancang layar rincian "Bagaimana dihitung" untuk program berjalan di `docs/mealora.pen`, mengikuti struktur `30 · Detail program selesai` | 0,5 | pasti | Termasuk peringatan yang menyertai pembuatan target |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 2 | Ruang Program sebagai satu layar untuk keadaan berjalan dan dijeda (`05`, `27`) | 1,5 | pasti | Perbedaan dibatasi pada penanda keadaan dan daftar kendali |
| 3 | Empat keadaan khusus: belum ada program, profil belum lengkap, belum ada catatan berat, kebijakan tidak tersedia | 0,75 | pasti | Memakai komponen keadaan kosong change 001 dan kerangka penolakan change 005 |
| 4 | Layar rincian asal-usul target sesuai rancangan paket 1 | 1,0 | pasti | Dibuka dari ruang Program |
| 5 | Kendali jeda, lanjutkan, dan selesaikan beserta penyambungannya ke perintah change 003 dan 004 | 0,75 | pasti | |
| 6 | Layar selesaikan program (`39`): pemilihan alasan, pernyataan akibat, jalan batal | 0,75 | pasti | Bukan dialog konfirmasi singkat |
| 7 | Pratinjau ganti program (`28`) dan penyambungannya ke alur pratinjau serta aktivasi change 005 | 1,25 | pasti | Memakai ulang jalur aktivasi, bukan membangun jalur kedua |
| 8 | Riwayat program (`29`) dan detail program selesai (`30`) | 1,25 | pasti | Membaca nilai tersimpan, tidak menghitung ulang |
| 9 | Ubah profil (`34`) dan peninjauan revisi target beserta perbandingan terhadap target berjalan | 1,25 | pasti | Memakai ulang layar pratinjau target change 005 |
| 10 | Penyambungan butir Program saya dan Riwayat program pada ruang Profil (`33`) | 0,25 | pasti | Butir lain tetap belum aktif |
| 11 | Aksesibilitas seluruh layar: pembaca layar, skala teks besar, keadaan tidak hanya lewat warna | 0,75 | pasti | |
| 12 | Gate verifikasi repo dan uji integrasi alur siklus hidup penuh | 0,75 | pasti | `flutter analyze`, `dart format`, `flutter test` |

**Subtotal:** 8,0–10,5 hari-orang.

## Dependensi Antar-Paket

- Change 003, 004, dan 005 memblokir seluruh paket di `mealora-mobile`: perintah siklus hidup, penyimpanan riwayat, dan alur pratinjau berasal dari sana.
- Change 002 tidak memblokir change ini. Selama kebijakan berstatus draf, pergantian dan revisi target bermuara pada keadaan penolakan, dan itu perilaku yang benar.
- Paket 1 mendahului paket 4 — layar dirancang sebelum dibangun.
- Paket 2 mendahului paket 3, 4, dan 5: seluruhnya dibuka dari ruang Program.
- Paket 7 bergantung pada alur pratinjau change 005 dan pada paket 2.
- Paket 9 bergantung pada layar pratinjau target change 005.
- Paket 11 dan 12 mengakhiri pekerjaan.
- Change ini tidak memblokir katalog makanan dan buku harian; keduanya dapat dikerjakan paralel setelah change 005.

## Urutan Rilis

### Tahap 1 — Melihat program

**Isi:** paket 1, 2, 3, 4.
**Prasyarat:** change 005 selesai.
**Gate verifikasi:** layar rincian ada di `docs/mealora.pen` dan konsisten dengan `30`; `flutter analyze`, `dart format`, dan `flutter test` bersih; uji widget membuktikan keadaan berjalan dan dijeda memakai susunan yang sama dengan perbedaan yang disengaja; nilai tanpa data tampil sebagai belum diketahui di setiap bagian; keempat keadaan khusus tampil sesuai jalurnya; rincian asal-usul target menampilkan peringatan yang menyertai pembuatan target.

### Tahap 2 — Mengubah program

**Isi:** paket 5, 6, 7.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** uji integrasi jeda → catat → lanjutkan; membatalkan pratinjau pergantian maupun layar penyelesaian tidak mengubah apa pun; pergantian yang disetujui memindahkan program lama ke riwayat dan menjaga catatan tetap utuh; pergantian yang ditolak kebijakan tidak menampilkan satu pun angka target dan membiarkan program lama berjalan; program selesai tidak menampilkan kendali melanjutkan.

### Tahap 3 — Riwayat, revisi target, dan pengerasan

**Isi:** paket 8, 9, 10, 11, 12.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** riwayat tampil berurutan dengan keadaan akhir dan rentang tanggal; entri lama tetap menampilkan nilai aslinya setelah versi kebijakan diganti di lingkungan uji; nilai yang tidak pernah tercatat dinyatakan apa adanya; revisi target yang tidak disetujui membiarkan target lama berlaku dan riwayat tidak berubah; pemeriksaan skala teks besar dan pembaca layar pada seluruh layar; verifikasi di Chrome pada viewport 390×844 dibandingkan dengan `docs/mealora.pen`; verifikasi alur penuh di perangkat Android.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Kemajuan masih kosong karena buku harian belum ada | Ruang Program terasa setengah jadi saat diperlihatkan | Keadaan "belum diketahui" memang perilaku yang benar; aturan hari jeda diuji dengan catatan tiruan dan diuji ulang pada change buku harian |
| Satu layar untuk dua keadaan membengkak | Layar sulit dirawat dan mudah berbeda diam-diam | Batasi perbedaan pada penanda keadaan dan daftar kendali; bila melar, pisahkan dan catat alasannya |
| Alur pergantian menggoda dibangun sebagai jalur aktivasi kedua | Dua tempat yang harus sama-sama benar tentang hal paling berisiko | Pakai ulang perintah aktivasi change 003 dan 004; uji yang sama dijalankan untuk kedua jalur masuk |
| Perbandingan target lama dan baru mendorong pengguna mengejar angka agresif | Bertentangan dengan nada produk | Tampilkan selisih apa adanya tanpa penilaian; guardrail kebijakan tetap berlaku penuh |
| Layar rincian hasil rancangan sendiri terasa salah tempat | Perlu perbaikan setelah uji coba | Strukturnya meniru `30`; risiko terbatas pada penempatan, bukan isi |
| Kebijakan belum disetujui saat change ini selesai | Jalur pergantian dan revisi tidak dapat diperlihatkan utuh | Uji dengan kebijakan draf di lingkungan uji; keadaan penolakan adalah perilaku rilis yang benar |
