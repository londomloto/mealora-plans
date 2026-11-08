# Work Order

## Ringkasan

Change ini memindahkan domain program dari memori ke perangkat di satu repositori, `mealora-apps/mealora-mobile`: empat tabel baru, seed katalog idempoten, penegakan satu program berjalan lewat indeks dan trigger, repositori yang mengimplementasikan kontrak domain, transaksi aktivasi dan pergantian, potret kemajuan per tanggal, kueri riwayat, serta migrasi skema versi 1 ke 2 beserta seluruh fixture yang diwajibkan assessment §43. Tidak ada layar. Estimasi 7–9,5 hari-orang dalam tiga tahap: skema, perintah tertulis, lalu migrasi dan pengerasan.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Tabel katalog program dan tabel program pengguna sesuai §42, memakai konvensi record pengguna dari change 001 | 1,0 | pasti | Termasuk kolom salinan masukan, target, asumsi, dan kedua versi |
| 2 | Tabel potret kemajuan dan tabel peristiwa siklus hidup | 0,75 | pasti | Kolom nilai dibuat dapat kosong agar "belum diketahui" berbeda dari nol |
| 3 | Seed katalog idempoten dengan pengenal tetap untuk empat kode program, beserta penanda ketersediaan | 0,5 | pasti | Menjalankan seed berulang tidak boleh menggandakan baris |
| 4 | Indeks unik parsial untuk baris `active` dan `paused`, indeks riwayat, indeks unik potret per tanggal | 0,5 | pasti | Indeks saja belum cukup menegakkan invarian produk — lihat paket 5 |
| 5 | Trigger SQLite penegak invarian satu program berjalan, beserta uji penulisan langsung yang melanggarnya | 0,75 | spike (timebox 1 hari) | Trigger dianggap belum ada sampai uji membuktikannya menolak |
| 6 | Repositori program yang mengimplementasikan kontrak domain change 003 dan menyembunyikan Drift dari lapisan atas | 1,0 | pasti | Penyaringan record terhapus lunak memakai lapisan bersama change 001 |
| 7 | Transaksi aktivasi: verifikasi ulang fakta di dalam transaksi, tulis program, sisipkan peristiwa, buat potret awal | 0,75 | pasti | Gagal di langkah mana pun membatalkan seluruhnya |
| 8 | Transaksi pergantian: tandai program lama, tautkan dua arah, sisipkan peristiwa, aktifkan program baru | 0,75 | pasti | Diuji dengan kegagalan yang disuntikkan di setiap langkah |
| 9 | Jeda, lanjutkan, selesaikan, batalkan sebagai penulisan beserta peristiwanya; idempotensi perintah berulang | 0,5 | pasti | Rentang jeda harus tetap dapat ditelusuri setelah dilanjutkan |
| 10 | Pembangunan ulang potret kemajuan per tanggal sebagai penyisipan-atau-perbarui, termasuk penanganan hari jeda dan nilai belum diketahui | 1,0 | pasti | Sumber angka buku harian belum ada; isi yang tersedia dulu, sisanya kosong |
| 11 | Kueri riwayat program berurutan beserta seluruh nilai aslinya | 0,5 | pasti | Membaca nilai tersimpan, tidak menghitung ulang |
| 12 | Migrasi skema 1 → 2, verifikasi pasca-migrasi, dan dokumentasi bahwa penurunan versi tidak didukung | 0,75 | pasti | Termasuk pemeriksaan foreign key dan validasi katalog |
| 13 | Fixture migrasi §43 dan ujinya: kosong, langsung v2, v1 berisi data, migrasi terputus, data lama tidak valid, foreign key aktif | 1,0 | pasti | Fixture dibuat lewat alur aplikasi, bukan penulisan SQL manual |
| 14 | Gate verifikasi repo dan uji arsitektur bahwa domain tetap bebas Drift | 0,5 | pasti | `flutter analyze`, `dart format`, `flutter test` |

**Subtotal:** 7,0–9,5 hari-orang.

## Dependensi Antar-Paket

- Change 001 memblokir seluruh paket: harness migrasi, konvensi record, dan lapisan akses data bersama harus ada lebih dulu.
- Change 003 memblokir paket 6 sampai 11: kontrak repositori dan perintah siklus hidup berasal dari sana.
- Change 002 tidak memblokir change ini. Nilai kebijakan hanya tersimpan sebagai salinan; penyimpanan tidak menghitung target.
- Paket 1 dan 2 mendahului seluruh paket penulisan.
- Paket 4 mendahului paket 5: trigger melengkapi apa yang tidak dapat ditegakkan indeks parsial.
- Paket 6 mendahului paket 7 sampai 11.
- Paket 12 mendahului paket 13; keduanya mengakhiri pekerjaan.
- Change ini memblokir change onboarding dan aktivasi program di layar, serta tampilan progres dan riwayat.

## Urutan Rilis

Tidak ada yang terlihat pengguna pada change ini. "Tahap" berarti titik henti yang dapat diverifikasi dan di-review tersendiri.

### Tahap 1 — Skema dan penegakan invarian

**Isi:** paket 1, 2, 3, 4, 5.
**Prasyarat:** change 001 selesai.
**Gate verifikasi:** `flutter analyze` dan `dart format` bersih; `flutter test` hijau; seed dijalankan tiga kali berturut-turut menghasilkan tepat empat baris katalog dengan pengenal yang sama; uji penulisan langsung yang mencoba membuat dua program berjalan ditolak basis data, termasuk kombinasi satu `active` dan satu `paused`; pemeriksaan foreign key bersih.

### Tahap 2 — Repositori dan perintah tertulis

**Isi:** paket 6, 7, 8, 9, 10, 11.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** seluruh uji perintah siklus hidup change 003 lolos terhadap penyimpanan sungguhan, bukan hanya penyimpanan tiruan; kegagalan yang disuntikkan di setiap langkah pergantian selalu mengembalikan keadaan semula; pembangunan ulang kemajuan tiga kali menghasilkan satu baris per tanggal dengan nilai sama; hari jeda tidak menambah hari aktif; nilai yang belum ada tersimpan kosong, bukan nol; uji arsitektur membuktikan domain tidak mengimpor Drift.

### Tahap 3 — Migrasi dan pengerasan

**Isi:** paket 12, 13, 14.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** seluruh fixture §43 lolos; basis data versi 1 berisi data melewati migrasi dengan seluruh catatan utuh dan tanpa satu pun profil terdaftar ke program; migrasi yang diputus di tengah jalan tidak merusak data dan selesai pada percobaan berikutnya; pemeriksaan foreign key dan validasi katalog bersih setelah migrasi; alur mode pesawat di perangkat Android membuktikan program bertahan melewati penutupan aplikasi dan restart perangkat.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Trigger SQLite lebih rumit dari perkiraan atau berperilaku tak terduga pada penulisan beruntun | Tahap 1 melar | Timebox satu hari; bila gagal, invarian ditegakkan di transaksi saja dan keterbatasannya dicatat eksplisit sebagai utang teknis yang harus ditutup sebelum sinkronisasi MVP 2 |
| Bentuk potret kemajuan ternyata tidak cocok setelah buku harian ada | Rework di change katalog dan buku harian | Kolom diambil dari §42 dan dari layar `05`, `16`, `18`, `40`; kolom ukuran tambahan disediakan sejak awal |
| Fixture migrasi dibuat lewat SQL manual sehingga tidak mewakili data nyata | Migrasi lolos uji tetapi gagal di lapangan | Fixture wajib dibuat lewat alur aplikasi versi 1, ditegaskan sebagai syarat gate tahap 3 |
| Data turunan menyimpang dari catatan sumber | Angka kemajuan salah tanpa ada yang menyadari | Uji perbandingan antara pembangunan ulang penuh dan nilai tersimpan |
| Sumber angka buku harian belum ada saat paket 10 dikerjakan | Sebagian potret hanya dapat diuji dengan data tiruan | Terima; uji memakai catatan tiruan dan diulang pada change buku harian dengan data sungguhan |
| Verifikasi Android tertunda karena perangkat belum siap | Gate tahap 3 tertahan | Sama dengan change 001: perangkat fisik sebagai cadangan; tahap 1 dan 2 tetap dapat diverifikasi lewat uji otomatis |
