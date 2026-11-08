# Work Order

## Ringkasan

Change ini menutup MVP 1 dengan jalur pencatatan lewat foto makanan. Di `mealora-plans`, dikumpulkan himpunan uji foto makanan Indonesia berizin dan dijalankan evaluasi penyedia untuk pengenalan komponen — terpisah dari evaluasi label pada change 010. Di `mealora-apps/mealora-mobile`, dibangun klien pengenalan di atas antarmuka penyedia yang sudah ada, empat layar — foto makanan, tinjau komponen, koreksi komponen, dan draf foto gagal — serta pencatatan banyak komponen dalam satu transaksi. Tidak ada perubahan skema. Estimasi 9–12 hari-orang dalam tiga tahap, di luar waktu pengumpulan himpunan uji.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Kumpulkan 30–50 foto makanan Indonesia yang berizin, dengan ragam jenis hidangan, pencahayaan, dan sudut ambil | 1,5 | spike (timebox 2 hari) | Hasil evaluasi label change 010 tidak berlaku untuk tugas ini |
| 2 | Susun protokol evaluasi pengenalan komponen beserta ambang kelulusan, ditetapkan sebelum evaluasi dijalankan | 0,5 | pasti | Metrik: ketepatan identifikasi komponen, kewajaran porsi, beban koreksi, latensi, biaya per catatan diterima |
| 3 | Jalankan evaluasi pada kandidat penyedia dan dokumentasikan hasilnya beserta versi model, versi perintah, tanggal, wilayah, dan kasus kegagalan | 1,5 | spike | Yang diukur bukan akurasi gizi — angka berasal dari katalog |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 4 | Klien pengenalan komponen di atas antarmuka penyedia change 010, beserta implementasi tiruan untuk uji | 1,0 | pasti | Memakai ulang proksi dan aturan gambar apa adanya |
| 5 | Pemadanan komponen ke katalog, makanan buatan pengguna, dan produk yang pernah dikonfirmasi | 1,25 | pasti | Komponen tanpa padanan tidak menampilkan nilai gizi apa pun |
| 6 | Penyimpanan draf foto beserta komponen yang sudah diisi, bertahan melewati kegagalan dan penutupan aplikasi | 0,75 | pasti | Memakai mekanisme retensi gambar change 010 |
| 7 | Layar foto makanan (`19`) beserta panel persetujuan unggah dan tautan jalur manual | 1,0 | pasti | Mengikuti aturan persetujuan change 010 |
| 8 | Layar tinjau foto makanan (`03`): daftar komponen, padanan, porsi, perkiraan total, penegasan porsi perlu dicek | 1,5 | pasti | Total menyesuaikan seketika |
| 9 | Layar koreksi komponen (`38`): ubah padanan, porsi, metode masak; tambah bahan tak terlihat; tambah dan hapus komponen | 2,0 | pasti | Paket terberat; penanda ketidakpastian per komponen |
| 10 | Layar draf foto dan kegagalan layanan (`20`) beserta pengarahan ke pemilihan manual | 0,75 | pasti | Pesan tanpa istilah teknis |
| 11 | Pencatatan satu catatan per komponen dalam satu transaksi, dengan potret nilai gizi | 0,75 | pasti | Berhasil semua atau tidak sama sekali |
| 12 | Aksesibilitas, pemeriksaan bahasa, dan gate verifikasi repo termasuk verifikasi perangkat Android | 1,0 | pasti | Penanda ketidakpastian tidak boleh bergantung warna saja |

**Subtotal:** 9,0–12,0 hari-orang, di luar waktu pengumpulan himpunan uji.

## Dependensi Antar-Paket

- Change 007 memblokir paket 5 dan 11; change 010 memblokir paket 4, 6, dan 7 — seluruh aturan gambar, antarmuka penyedia, dan proksi berasal dari sana.
- Change 009 tidak memblokir change ini, kecuali untuk pemadanan ke produk yang pernah dikonfirmasi pada paket 5.
- Paket 1 mendahului paket 2 dan 3; paket 3 mendahului pemilihan penyedia untuk rilis, tetapi **tidak** memblokir paket 4 sampai 12 — seluruh layar dapat dibangun dan diuji dengan penyedia tiruan.
- Paket 4 dan 5 mendahului paket 8 dan 9.
- Paket 6 mendahului paket 10.
- Paket 11 mendahului paket 12.
- Change ini tidak memblokir apa pun; setelahnya MVP 1 lengkap.

## Urutan Rilis

### Tahap 1 — Evaluasi dan fondasi pengenalan

**Isi:** paket 1, 2, 3, 4, 5, 6.
**Prasyarat:** change 010 selesai.
**Gate verifikasi:** himpunan uji memenuhi jumlah dan ragam yang disyaratkan serta berizin; protokol dan ambang kelulusan ditetapkan sebelum evaluasi; hasil evaluasi tercatat lengkap; klien pengenalan memakai ulang antarmuka dan proksi change 010 tanpa aturan gambar baru; komponen tanpa padanan tidak menampilkan satu pun nilai gizi, diuji eksplisit; draf foto bertahan melewati penutupan aplikasi; `flutter analyze`, `dart format`, dan `flutter test` bersih.

### Tahap 2 — Layar foto dan koreksi

**Isi:** paket 7, 8, 9, 10.
**Prasyarat:** tahap 1 selesai dan gate-nya lolos.
**Gate verifikasi:** uji widget seluruh layar pada ukuran teks normal dan besar; persetujuan unggah diminta sebelum pengiriman dan jalur manual tersedia tanpa mengambil gambar; daftar komponen menampilkan padanan, porsi, dan penanda ketidakpastian per komponen; penambahan, penghapusan, dan pengubahan komponen memperbarui perkiraan total seketika; bahan tak terlihat ditambahkan lewat jalur katalog yang sama, bukan mekanisme yang menebak nilai; kegagalan layanan menyimpan draf, menyatakan belum ada catatan, dan mengarahkan ke jalur manual dengan bahasa tanpa istilah teknis.

### Tahap 3 — Pencatatan, pengerasan, dan penutupan MVP 1

**Isi:** paket 11, 12.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** konfirmasi menghasilkan satu catatan per komponen dengan potret nilai gizi; kegagalan pada komponen terakhir tidak menyisakan satu pun catatan; setiap komponen dapat disunting, dipindahkan, dan dihapus sendiri setelah tercatat; menutup peninjauan tidak membuat catatan apa pun; pemeriksaan bahasa memastikan nilai disebut berasal dari padanan katalog, bukan pengukuran atas foto; penanda ketidakpastian dapat dikenali tanpa warna; verifikasi di perangkat Android untuk jalur kamera dan kegagalan layanan; alur inti dijalankan penuh dalam mode pesawat; pemeriksaan kriteria penerimaan MVP 1 pada assessment §28 dan §50.5 secara menyeluruh.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Himpunan uji foto makanan berizin sulit dikumpulkan | Tahap 1 melar dan pemilihan penyedia tertunda | Timebox dua hari; paket 4–12 tetap berjalan dengan penyedia tiruan; bila belum cukup saat rilis, jalur foto ditunda sementara tiga jalur lain sudah lengkap |
| Tidak ada penyedia yang memenuhi ambang | Jalur foto tidak layak rilis | Ambang ditetapkan sebelum evaluasi; MVP 1 tetap berguna dengan tiga jalur lain; penyedia lain dapat dicoba tanpa mengubah layar |
| Katalog kecil membuat banyak komponen tanpa padanan | Alur foto terasa setengah jalan | Jalur pencarian dan pembuatan makanan tersedia langsung dari peninjauan; pertumbuhan katalog pada change 007 memperbaikinya tanpa menyentuh change ini |
| Layar koreksi komponen membengkak | Paket 9 melar | Batasi sumbu ketidakpastian pada tiga: padanan, porsi, metode masak; bahan tak terlihat memakai jalur komponen biasa |
| Biaya inferensi foto lebih besar daripada label | Tagihan di luar perkiraan | Batas biaya proksi change 010 berlaku sama; biaya per catatan diterima diukur pada evaluasi |
| Pengguna menerima usulan tanpa memeriksa porsi | Angka keliru masuk buku harian | Penanda ketidakpastian dengan sebab spesifik, porsi selalu dapat disunting, bahasa yang menyatakan porsi perlu dicek; diterima bahwa risiko dikurangi, bukan dihapus |
