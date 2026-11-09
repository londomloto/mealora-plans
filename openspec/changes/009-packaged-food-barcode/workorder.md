# Work Order

## Ringkasan

Change ini membangun jalur pencatatan produk kemasan lewat barcode di dua repositori. Di `mealora-plans`, dirancang layar masukan barcode manual dan ditelusuri sumber data produk beserta kewajiban lisensinya. Di `mealora-apps/mealora-mobile`, dibangun tabel sifat produk kemasan beserta migrasi skema versi 5 ke 6, pemindai barcode dengan izin kamera, klien sumber data produk yang dapat diganti, aritmetika basis takaran, serta empat layar: pindai, masukan manual, produk tidak ditemukan, dan tinjau produk. Estimasi 8–10,5 hari-orang dalam tiga tahap.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Telusuri sumber data produk kemasan dan kewajiban lisensinya; dokumentasikan syarat atribusi dan pemakaian gambar | 1,0 | spike (timebox 1 hari) | Open Food Facts kandidat; ODbL dan lisensi gambar wajib dipenuhi |
| 2 | Rancang layar masukan barcode manual di `docs/mealora-v2.pen`, mengikuti bahasa visual `21` | 0,5 | pasti | Satu-satunya jalur barcode saat izin kamera ditolak |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 3 | Tabel sifat produk kemasan beserta provenans, indeks barcode, dan migrasi skema 5 → 6 | 1,0 | pasti | Produk kemasan adalah makanan dengan sifat tambahan |
| 4 | Fixture migrasi dan ujinya | 0,5 | pasti | Pola sama dengan change sebelumnya |
| 5 | Aritmetika basis takaran: per sajian, per kemasan, per 100 g, beserta ujinya | 1,0 | pasti | Bagian paling mudah salah dan paling sulit terlihat saat review |
| 6 | Klien sumber data produk di balik antarmuka yang dapat diganti, beserta implementasi tiruan untuk uji | 1,0 | pasti | Hanya nomor barcode yang dikirim |
| 7 | Repositori produk kemasan: cari di perangkat, simpan hasil konfirmasi, simpan koreksi pengguna | 1,0 | pasti | Koreksi pengguna tidak boleh tertimpa |
| 8 | Pemindai barcode beserta izin kamera dan keadaan izin ditolak, kamera tidak tersedia, dan kode tidak terbaca | 1,25 | spike (timebox 1 hari untuk integrasi pemindai) | Perilaku kamera berbeda antar perangkat Android |
| 9 | Layar pindai barcode (`21`) beserta keterangan bahwa barcode bukan sumber nilai gizi | 0,75 | pasti | |
| 10 | Layar masukan barcode manual sesuai rancangan paket 2, beserta validasi bentuk nomor | 0,5 | pasti | |
| 11 | Layar produk tidak ditemukan (`22`) beserta dua jalur lanjutan dan penandaan kebutuhan koneksi | 0,75 | pasti | Jalur foto label ditandai belum tersedia pada versi ini |
| 12 | Layar tinjau produk (`04`): rincian produk, basis nilai, pemilihan jumlah, koreksi nilai, konfirmasi | 1,5 | pasti | Tidak ada pencatatan otomatis |
| 13 | Penyambungan ke buku harian change 007 beserta potret nilai gizi | 0,5 | pasti | Masuk lewat jalur yang sama dengan makanan lain |
| 14 | Aksesibilitas dan gate verifikasi repo, termasuk verifikasi jalur pindai di perangkat Android | 1,0 | pasti | Jalur pindai tidak dapat diverifikasi di web |

**Subtotal:** 8,0–10,5 hari-orang.

## Dependensi Antar-Paket

- Change 007 memblokir seluruh paket di `mealora-mobile`: katalog, buku harian, potret nilai gizi, dan lembar pilihan pencatatan berasal dari sana.
- Change 008 tidak memblokir change ini; keduanya dapat berjalan paralel setelah change 007.
- Paket 1 mendahului pengaktifan pencarian daring, tetapi **tidak** memblokir paket lain — seluruh jalur luring berdiri sendiri.
- Paket 2 mendahului paket 10.
- Paket 3 mendahului paket 5, 6, dan 7.
- Paket 5 mendahului paket 12 — layar peninjauan menampilkan hasil aritmetika.
- Paket 8 mendahului paket 9.
- Paket 13 mendahului paket 14.
- Change ini memblokir change label gizi, karena jalur "produk tidak ditemukan" bermuara ke sana.

## Urutan Rilis

### Tahap 1 — Data, aritmetika, dan sumber produk

**Isi:** paket 1, 2, 3, 4, 5, 6, 7.
**Prasyarat:** change 007 selesai.
**Gate verifikasi:** dokumen sumber data produk menyatakan kewajiban lisensinya dan apakah pencarian daring dapat diaktifkan pada rilis pertama; layar masukan manual ada di `docs/mealora-v2.pen`; seluruh fixture migrasi lolos dan pemeriksaan foreign key bersih; aritmetika basis takaran lolos seluruh kombinasi dengan nilai yang berbeda per basis — per sajian, beberapa sajian, satu kemasan, dan per 100 g; klien sumber data hanya mengirim nomor barcode, diuji dengan pengamatan permintaan; koreksi pengguna tidak tertimpa oleh hasil dari sumber daring.

### Tahap 2 — Pemindai dan layar

**Isi:** paket 8, 9, 10, 11, 12.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** uji widget seluruh layar pada ukuran teks normal dan besar; izin kamera hanya diminta saat jalur pemindaian dipilih; penolakan izin, kamera tidak tersedia, dan kode tidak terbaca mengarah ke masukan manual dan pencarian katalog, bukan layar gagal; nomor barcode tidak sah ditolak tanpa pencarian; layar peninjauan menampilkan basis nilai sebelum pemilihan jumlah; menutup peninjauan tidak membuat catatan; jalur foto label ditandai belum tersedia dan tidak dapat dibuka.

### Tahap 3 — Penyambungan dan verifikasi perangkat

**Isi:** paket 13, 14.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** produk yang dikonfirmasi masuk ke buku harian lewat jalur yang sama dengan makanan lain, dengan potret nilai gizi yang dibekukan; produk tersimpan dapat ditemukan lewat pencarian nama dan muncul pada daftar terakhir dicatat; koreksi pengguna bertahan pada pemindaian berikutnya; catatan lama tidak berubah setelah rekaman produk dikoreksi; verifikasi jalur pemindaian di perangkat Android, termasuk mode pesawat untuk produk tersimpan; pengamatan lalu lintas jaringan menunjukkan tidak ada gambar yang terkirim; pemeriksaan skala teks besar dan pembaca layar; `flutter analyze`, `dart format`, dan `flutter test` bersih.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Sumber data produk tidak memenuhi syarat lisensi | Pencarian daring tidak dapat diaktifkan pada rilis pertama | Seluruh jalur luring berdiri sendiri; klien di balik antarmuka sehingga sumber dapat diganti tanpa menyentuh layar |
| Integrasi pemindai barcode lebih rumit dari perkiraan | Tahap 2 melar | Timebox satu hari untuk integrasi; masukan manual memastikan jalur barcode tetap berfungsi meski pemindai tertunda |
| Perilaku kamera dan izin berbeda antar perangkat Android | Keadaan tak terduga ditemukan terlambat | Keadaan izin ditolak, kamera tidak ada, dan kode tidak terbaca dirancang sejak awal, bukan ditambal |
| Aritmetika basis takaran salah tanpa ketahuan | Angka tampak masuk akal tetapi keliru | Uji seluruh kombinasi dengan nilai yang berbeda per basis, memakai angka nyata dari rancangan `04` dan `37` |
| Jalur pindai tidak dapat diuji di lingkungan pratinjau web | Umpan balik visual lebih lambat | Dinyatakan sejak design; masukan manual menanggung uji otomatis; verifikasi perangkat menjadi syarat gate tahap 3 |
| Rekaman dari sumber komunitas memuat nilai keliru | Pengguna mencatat angka yang salah | Jenis sumber ditampilkan, peninjauan wajib sebelum mencatat, koreksi pengguna menang dan bertahan |
