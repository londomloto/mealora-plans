# Design — 008 · Pemantauan berat dan riwayat harian

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 007 menyediakan katalog, buku harian, agregasi harian, dan ruang Hari ini; change 004 menyediakan potret kemajuan per tanggal; change 006 menyediakan ruang Program yang sudah menyiapkan tempat menampilkan berat terbaru. Ruang Riwayat masih berupa keadaan kosong dari change 001, dan belum ada tabel berat badan.

Bentuk tabel catatan berat ditetapkan assessment §11; kewajiban pemantauan berat ditetapkan §6.10; riwayat ditetapkan §6.11; ambang hitung ulang target ditetapkan kebijakan `np-1.0.0` pada change 002.

## Goals / Non-Goals

**Goals**

- Mencatat berat murah dan tidak menakutkan, termasuk memperbaiki salah ketik.
- Riwayat menampilkan apa yang benar-benar tercatat, tanpa menambal celah dengan tebakan.
- Angka berat dan hari kosong tidak pernah berubah menjadi penilaian atas pengguna.
- Ruang Program dan kemajuan program akhirnya mendapat sumber berat yang sungguhan.

**Non-Goals**

- Tidak ada ringkasan mingguan, rangkaian hari berturut-turut, skor nutrisi, atau lencana — seluruhnya SHOULD HAVE pada §7 atau di luar MVP.
- Tidak ada proyeksi kapan berat tujuan akan tercapai.
- Tidak ada pengukuran tubuh lain seperti lingkar pinggang atau persentase lemak tubuh.
- Tidak ada impor berat dari timbangan pintar, Health Connect, atau Apple Health.
- Tidak ada perubahan pada aturan kebijakan maupun siklus hidup program.

## Decisions

### D1 — Catatan berat sebagai peristiwa bertanggal, bukan nilai pada profil

Berat badan disimpan sebagai catatan bertanggal tersendiri, sesuai §11, bukan sebagai kolom yang ditimpa pada profil. Berat "saat ini" adalah catatan terbaru, bukan nilai yang disimpan terpisah.

Alasannya: profil yang menyimpan satu nilai berat akan kehilangan riwayat setiap kali diperbarui, dan membuat dua sumber kebenaran — kolom profil dan daftar catatan — yang pasti berbeda cepat atau lambat.

Konsekuensi yang ditangani: berat pada salinan masukan target (change 003) tetap berupa potret nilai saat itu, bukan rujukan ke catatan terbaru.

### D2 — Celah pada tren ditampilkan sebagai celah

Rentang tanpa catatan tidak disambung dengan garis dari nilai terakhir dan tidak diisi nol. Pengguna yang tidak menimbang selama dua minggu melihat ketiadaan data, bukan garis datar yang menyiratkan beratnya tidak berubah.

Ini bukan kemurnian data demi dirinya sendiri: garis yang disambung akan terbaca sebagai fakta, dan pada angka kesehatan, fakta palsu lebih berbahaya daripada ketiadaan informasi.

Rancangan `31 · Pantau berat` menampilkan tren empat minggu terakhir; bentuk itu dipertahankan, dengan celah yang terlihat.

### D3 — Satu catatan tidak digambar sebagai tren

Dengan satu catatan, sistem menampilkan catatan itu dan menyatakan tren belum dapat ditampilkan. Menggambar tren dari satu titik adalah grafik yang tidak berarti apa-apa tetapi terlihat berarti.

### D4 — Menyunting dan menghapus catatan berat adalah kebutuhan, bukan kemewahan

Salah ketik pada angka berat lumrah terjadi — satu digit salah menghasilkan lompatan puluhan kilogram yang merusak tren, kemajuan program, dan berpotensi memicu usulan hitung ulang target yang keliru.

Karena itu penyuntingan dan penghapusan ada sejak change ini, bukan ditunda, dan keduanya wajib memperbarui berat terbaru, tren, serta potret kemajuan yang terpengaruh.

### D5 — Catatan berat memicu pembangunan ulang potret kemajuan dan pemeriksaan ambang

Setiap penambahan, penyuntingan, dan penghapusan catatan berat memicu pembangunan ulang potret kemajuan untuk tanggal terkait (change 004 D5, idempoten), lalu pemeriksaan terhadap ambang hitung ulang kebijakan.

Pemeriksaan ambang hanya **mengusulkan** peninjauan target. Target baru tidak pernah berlaku tanpa persetujuan pengguna (change 002, change 006 D5). Usulan ditampilkan di ruang Program, bukan sebagai gangguan di tengah pencatatan berat — pengguna yang baru menimbang sedang melakukan hal lain.

### D6 — Riwayat memakai ulang komponen ringkasan dari change 007

Ringkasan tanggal terpilih memakai komponen yang sama dengan ruang Hari ini, dengan sumber data tanggal yang dipilih. Membangun komponen ringkasan kedua akan menghasilkan dua tempat yang harus sama-sama benar tentang nilai belum diketahui dan ketidaklengkapan per zat gizi.

### D7 — Penandaan hari pada kalender bersifat informatif, bukan penilaian

Kalender menandai tanggal yang memiliki catatan agar pengguna dapat menemukan hari yang ingin dibuka. Penandaan itu tidak diberi warna "baik" dan "buruk", tidak dihitung sebagai rangkaian, dan tidak diberi ikon keberhasilan.

Rancangan `18` sudah menetapkan arah ini ("Catatan harian, tanpa hari yang 'gagal'"), dan `40` menetapkan kalimatnya ("Kosong bukan berarti kamu makan nol").

### D8 — Menyunting catatan lama memakai aturan yang sama dengan hari berjalan

Tidak ada pembatasan waktu untuk menyunting catatan makan dari riwayat. Orang mengingat dan memperbaiki catatan beberapa hari kemudian, dan mengunci riwayat hanya akan membuat data lebih buruk, bukan lebih benar.

Perubahan pada tanggal lama memicu pembangunan ulang potret kemajuan untuk tanggal itu, sama seperti perubahan pada hari berjalan.

### D9 — Tanggal catatan di masa depan ditolak

Baik catatan berat maupun pemilihan tanggal pada kalender tidak mengizinkan masa depan. Mencatat ke masa depan tidak punya makna pada produk ini dan merusak nomor hari aktif program serta kelengkapan buku harian.

### D10 — Migrasi versi 4 ke 5

`schemaVersion` naik dari 4 ke 5 satu kali: tabel catatan berat beserta indeks menurut profil dan tanggal. Data versi 4 tidak disentuh. Fixture mengikuti pola change sebelumnya: kosong, langsung versi 5, versi 4 berisi data makanan dan program, dan migrasi terputus.

## Risks / Trade-offs

- **Angka berat memicu perasaan tidak nyaman** bagi sebagian pengguna → mitigasi: bahasa netral tanpa pujian maupun teguran, tidak ada penilaian atas arah perubahan, dan pencatatan berat tidak pernah diwajibkan. Program Makan Sehat tetap berjalan penuh tanpa satu pun catatan berat.
- **Usulan hitung ulang target muncul pada saat yang salah** dan terasa seperti tekanan → mitigasi: usulan ditampilkan di ruang Program, bukan sebagai sela setelah menimbang.
- **Celah pada tren terlihat seperti bug** bagi sebagian pengguna → mitigasi: celah diberi keterangan, bukan dibiarkan sebagai ruang kosong tanpa penjelasan.
- **Menyunting catatan lama memicu pembangunan ulang yang banyak** bila pengguna menyunting banyak tanggal → mitigasi: pembangunan ulang per tanggal dan idempoten; bila terasa lambat, penundaan terjadwal menjadi perbaikan berikutnya dengan pengukuran.
- **Kalender pada skala teks besar mudah pecah layoutnya** → mitigasi: diuji pada skala teks besar sebagai bagian gate, bukan diperiksa sepintas.
- **Berat terbaru dipakai dua tempat** (ruang Program dan pemantauan berat) dan bisa berbeda → mitigasi: keduanya membaca sumber yang sama, diuji dengan penyuntingan dan penghapusan catatan terakhir.

## Migration Plan

1. Naikkan `schemaVersion` dari 4 ke 5 satu kali untuk change ini.
2. Buat tabel catatan berat beserta indeks menurut profil dan tanggal lokal.
3. Pertahankan seluruh data versi 4 tanpa perubahan.
4. Jalankan verifikasi pasca-migrasi: versi skema dan pemeriksaan foreign key.
5. Jalankan fixture: kosong, langsung versi 5, versi 4 berisi data makanan dan program, dan migrasi terputus.

Rollback: penurunan versi tidak didukung, konsisten dengan change sebelumnya.

## Open Questions

Tidak ada pertanyaan yang ditunda. Satu hal yang ditetapkan sekarang agar tidak menggantung: rentang tren yang ditampilkan adalah empat minggu terakhir, mengikuti rancangan `31`. Bila kemudian terbukti terlalu pendek untuk program jangka panjang, penambahan pilihan rentang menjadi perbaikan tersendiri dan tidak mengubah bentuk data.
