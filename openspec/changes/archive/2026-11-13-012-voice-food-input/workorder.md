# Work Order

## Ringkasan

Change ini menambahkan jalur pencatatan kelima: berbicara. Di `mealora-plans`, dirancang tiga layar yang belum ada — rekam suara, tinjau transkrip, dan penambahan jalur suara pada lembar pilihan pencatatan — serta disusun himpunan uji kalimat pencatatan berbahasa Indonesia beserta evaluasi penguraiannya. Di `mealora-apps/mealora-mobile`, dibangun perekam suara dengan izin mikrofon, pengenalan ucapan di perangkat, klien penguraian teks di atas antarmuka penyedia change 010, dan penyambungan ke peninjauan komponen change 011. Tidak ada perubahan skema. Estimasi 7–9,5 hari-orang dalam tiga tahap.

## Breakdown per Repository

### mealora-plans

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Rancang tiga layar di `docs/mealora-v2.pen`: rekam suara (siap, merekam, selesai), tinjau transkrip, dan jalur suara pada lembar `02` | 1,0 | pasti | Penanda sedang merekam tidak boleh bergantung warna saja |
| 2 | Susun himpunan uji kalimat pencatatan berbahasa Indonesia: 50–80 kalimat nyata mencakup hidangan majemuk, jumlah yang tidak disebut, dan satuan tidak baku | 0,75 | pasti | Termasuk kalimat di luar cakupan untuk menguji penolakan |
| 3 | Jalankan evaluasi penguraian pada penyedia yang sudah dipakai change 010 dan 011, dan verifikasi kuota pada akun proyek yang sebenarnya | 1,0 | spike (timebox 1 hari) | Masukan berupa teks; catat biaya nyata per kalimat |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 4 | Perekam suara, izin mikrofon, dan keadaan izin ditolak serta perangkat tidak mendukung | 1,0 | pasti | Pola izin sama dengan kamera change 009 |
| 5 | Pengenalan ucapan di perangkat beserta penanganan hasil kosong | 1,0 | spike (timebox 1 hari) | Dukungan bahasa Indonesia berbeda antar perangkat |
| 6 | Layar rekam suara sesuai rancangan paket 1 | 0,75 | pasti | Keadaan merekam harus jelas dan mudah dihentikan |
| 7 | Layar tinjau transkrip beserta penyuntingan teks, rekam ulang, dan ketik kalimat | 1,0 | pasti | Jalur ketik setara, bukan cadangan |
| 8 | Klien penguraian teks di atas antarmuka penyedia change 010, beserta implementasi tiruan | 1,0 | pasti | Yang dikirim teks, bukan audio |
| 9 | Penolakan permintaan di luar cakupan dan penguraian bagian makanan saja pada ucapan bercampur | 0,5 | pasti | Dikunci di perintah penguraian dan di ketersediaan mikrofon |
| 10 | Penanganan jumlah tidak disebut dan satuan tidak baku sebagai keadaan yang menahan konfirmasi | 0,75 | pasti | Tidak menebak, tidak memakai takaran bawaan diam-diam |
| 11 | Penyambungan ke peninjauan komponen dan pencatatan change 011 | 0,5 | pasti | Jangan membangun layar peninjauan kedua |
| 12 | Retensi rekaman suara dan penghapusan setelah transkrip, mengikuti pola retensi change 010 | 0,5 | pasti | Bawaan menghapus |
| 13 | Aksesibilitas, pemeriksaan bahasa, dan gate verifikasi repo termasuk verifikasi perangkat Android | 0,75 | pasti | Keadaan merekam diumumkan pembaca layar |

**Subtotal:** 7,0–9,5 hari-orang.

## Dependensi Antar-Paket

- Change 007 memblokir paket 10 dan 11; change 010 memblokir paket 8 dan 12; change 011 memblokir paket 11.
- Change 009 tidak memblokir change ini.
- Paket 1 mendahului paket 6 dan 7.
- Paket 2 mendahului paket 3; paket 3 mendahului pengaktifan penguraian pada rilis, tetapi **tidak** memblokir paket 4 sampai 13 — seluruh layar dapat dibangun dan diuji dengan penyedia tiruan.
- Paket 4 dan 5 mendahului paket 6.
- Paket 8 mendahului paket 9 dan 10.
- Paket 13 mengakhiri pekerjaan.
- Change ini tidak memblokir apa pun.

## Urutan Rilis

### Tahap 1 — Rancangan, himpunan uji, dan evaluasi

**Isi:** paket 1, 2, 3.
**Prasyarat:** change 011 selesai.
**Gate verifikasi:** ketiga layar ada di `docs/mealora-v2.pen` dan konsisten dengan bahasa visual yang berlaku; penanda sedang merekam dapat dikenali tanpa warna; himpunan uji memuat hidangan majemuk, jumlah yang tidak disebut, satuan tidak baku, dan kalimat di luar cakupan; hasil evaluasi penguraian tercatat beserta versi model, versi perintah, tanggal, dan kasus kegagalan; kuota dan biaya nyata per kalimat diverifikasi pada akun proyek, bukan dikutip dari dokumentasi.

### Tahap 2 — Rekaman, transkrip, dan penguraian

**Isi:** paket 4, 5, 6, 7, 8, 9, 12.
**Prasyarat:** tahap 1 selesai untuk paket 1; paket 3 boleh berjalan paralel.
**Gate verifikasi:** `flutter analyze`, `dart format`, dan `flutter test` bersih; izin mikrofon hanya diminta saat jalur suara dipilih; penolakan izin dan perangkat tanpa pengenalan ucapan mengarah ke pengetikan kalimat, bukan layar gagal; pengamatan lalu lintas jaringan membuktikan tidak ada rekaman suara yang keluar dari perangkat, dan penguraian hanya mengirim teks; transkrip dapat disunting sebelum diurai; permintaan di luar cakupan tidak dijalankan dan dinyatakan batasnya; ucapan bercampur hanya diuraikan bagian makanannya; rekaman dihapus setelah transkrip sesuai pengaturan bawaan.

### Tahap 3 — Peninjauan, pencatatan, dan pengerasan

**Isi:** paket 10, 11, 13.
**Prasyarat:** tahap 2 selesai dan gate-nya lolos.
**Gate verifikasi:** jumlah yang tidak disebut dan satuan tidak baku menahan konfirmasi dengan penyebutan yang jelas; tidak ada takaran bawaan yang dipakai sebagai jumlah tanpa pengguna menetapkannya; nilai gizi berasal dari padanan katalog dan angka gizi dari keluaran model diabaikan, diuji eksplisit; konfirmasi menghasilkan satu catatan per makanan dalam satu transaksi; menutup peninjauan tidak membuat catatan; tidak ada kendali masukan suara di layar berat, program, profil, dan pengaturan; keadaan merekam diumumkan pembaca layar; verifikasi di perangkat Android untuk mikrofon, pengenalan ucapan, dan kegagalan penguraian.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Pengenalan ucapan di perangkat tidak mendukung bahasa Indonesia pada sebagian perangkat uji | Jalur utama tidak dapat diverifikasi merata | Timebox satu hari pada paket 5; keadaan "tidak tersedia di perangkat ini" dirancang sejak awal; pengetikan kalimat menanggung pengujian alur berikutnya |
| Kuota gratis penyedia berubah atau tidak mencakup pemakaian nyata | Biaya muncul di luar perkiraan | Verifikasi kuota pada akun proyek sebagai bagian gate tahap 1; penguraian memakai teks, masukan termurah; batas biaya proksi change 010 berlaku |
| Penguraian memecah hidangan majemuk secara keliru | Hasil terasa bodoh dan beban koreksi tinggi | Himpunan uji memuat hidangan majemuk secara khusus; ambang kelulusan ditetapkan sebelum evaluasi |
| Cakupan melebar menjadi perintah suara | Menuntut pemahaman maksud yang tidak ada di MVP 1 | Dikunci di dua tempat: perintah penguraian hanya meminta daftar makanan, dan mikrofon tidak tersedia di layar lain; diuji sebagai syarat gate tahap 3 |
| Pengguna menyetujui hasil tanpa memeriksa jumlah | Angka keliru masuk buku harian | Jumlah yang tidak disebut menahan konfirmasi; risiko berkurang, tidak hilang |
| Mikrofon aktif tanpa disadari | Masalah kepercayaan yang serius | Penanda merekam jelas dan tidak bergantung warna, penghentian selalu terjangkau, rekaman dihapus setelah transkrip |
