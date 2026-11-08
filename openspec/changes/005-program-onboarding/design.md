# Design — 005 · Onboarding dan aktivasi program

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 001 menyediakan tema, komponen dasar, lokalisasi, splash, dan navigasi empat ruang berkeadaan kosong; change 002 menyediakan kebijakan `np-1.0.0`; change 003 menyediakan domain program dengan perintah aktivasi; change 004 menyediakan penyimpanan program beserta transaksinya. Belum ada tabel profil dan belum ada satu pun layar fitur.

Rancangan layar sudah tersedia di `docs/mealora.pen`: `07 · Selamat datang`, `08 · Profil awal`, `09 · Aktivitas harian`, `10 · Pilih program`, `11 · Detail program`, `12 · Tinjau target`, `25 · Target berat program`, `26 · Kebijakan belum tersedia`, dan `36 · Belum ada program`.

## Goals / Non-Goals

**Goals**

- Perjalanan pertama yang utuh dan jujur, dari pemasangan sampai program berjalan.
- Penolakan terasa membantu, bukan menghukum — dan tidak pernah membocorkan angka target.
- Tidak ada angka yang muncul di layar tanpa dasar yang bisa dibuka pengguna.
- Masukan pengguna tidak hilang ketika aplikasi ditutup di tengah onboarding.

**Non-Goals**

- Tidak ada layar siklus hidup program — Program saya, jeda, ganti, riwayat, selesaikan — itu change berikutnya.
- Tidak ada pencatatan makanan, berat badan, atau riwayat harian.
- Tidak ada pengaturan satuan, bahasa, atau privasi; ruang Profil tetap pada keadaan kosong.
- Tidak ada animasi atau transisi khusus di luar yang sudah ada pada komponen dasar.

## Decisions

### D1 — Urutan langkah mengikuti rancangan, bukan urutan teknis

Urutan: sambutan → profil → aktivitas → pilih program → detail program → (target berat, bila berlaku) → tinjau target. Ini urutan yang sudah dirancang, dan alasannya kuat: pengguna diminta data yang paling netral lebih dulu, dan baru menyatakan niatnya setelah merasa aplikasi ini tidak menghakimi.

Alternatif yang lebih "efisien" — menanyakan program lebih dulu agar masukan bisa disesuaikan — ditolak. Menanyakan "mau turun berapa kilo?" sebagai pertanyaan kedua setelah nama adalah pembingkaian yang persis ingin dihindari produk ini.

### D2 — Masukan disimpan bertahap sebagai draf, bukan ditahan sampai akhir

Setiap langkah menyimpan masukannya begitu sah. Aplikasi yang ditutup di tengah onboarding tidak membuat pengguna mengulang dari awal.

Konsekuensi yang harus ditangani: profil bisa ada dalam keadaan belum lengkap. Karena itu profil tersimpan menyimpan penanda kelengkapan onboarding, dan perhitungan target tidak pernah dijalankan atas profil yang belum lengkap — ia mengembalikan `needs_user_correction` dengan `missing_required_input`, persis seperti jalur lain.

*Alternatif:* menahan seluruh masukan di memori sampai aktivasi. Ditolak — kehilangan masukan karena telepon berdering adalah kegagalan produk yang tidak perlu.

### D3 — Pratinjau tidak pernah menulis program

Pratinjau murni perhitungan: tidak ada baris program yang dibuat, bahkan sebagai draf. Program baru lahir saat pengguna menyetujui.

Ini menjaga janji di layar `12` ("Tidak ada program aktif sebelum kamu menyetujui") menjadi benar secara harfiah, bukan sekadar benar di tampilan. Baris draf yang tidak pernah dikonfirmasi juga akan menumpuk tanpa guna.

### D4 — Verifikasi ulang dilakukan server-side logika, bukan dengan membandingkan di layar

Saat pengguna menekan setujui, perintah aktivasi (change 003 D6, change 004 D4) membaca ulang fakta profil di dalam transaksi dan membandingkannya dengan salinan yang dipakai pratinjau. Lapisan tampilan tidak melakukan perbandingan sendiri — ia hanya menampilkan hasil yang dikembalikan.

Alasannya: perbandingan di lapisan tampilan akan terlewat begitu ada jalur lain yang mengaktifkan program, dan membuat dua sumber kebenaran tentang "apakah masih sama".

### D5 — Layar baru: masukan berubah sejak pratinjau

Rancangan belum memuat layar untuk keadaan ini, padahal domain mewajibkannya. Rancangan yang dipilih: layar peninjauan ulang, bukan dialog kesalahan.

Isinya: pernyataan singkat bahwa masukan berubah sejak pratinjau, daftar nilai yang berubah beserta nilai lama dan nilai baru, pratinjau target yang sudah diperbarui, dan tombol untuk meninjau serta menyetujui ulang. Nadanya netral — perubahan data bukan kesalahan pengguna.

Bahasa visualnya mengikuti `12 · Tinjau target` agar terasa sebagai kelanjutan, bukan sebagai gangguan. Layar ini ditambahkan ke `docs/mealora.pen` sebagai bagian change ini, sehingga rancangan dan implementasi tidak berbeda.

### D6 — Keadaan tidak-disetujui memakai satu layar dengan isi yang berbeda

Lima keadaan hasil dari domain dipetakan ke satu kerangka layar (`26 · Kebijakan belum tersedia`) dengan judul, penjelasan, dan tawaran langkah berikutnya yang berbeda menurut kode alasan — bukan lima layar terpisah.

Alasannya bukan penghematan: lima layar terpisah akan menggoda orang menambahkan "sedikit detail" di salah satunya, dan detail itulah yang berubah menjadi diagnosis. Satu kerangka memaksa setiap kasus memakai struktur yang sama: apa yang terjadi, apa yang tidak dibuat, apa yang bisa dilakukan sekarang.

Pemetaan kode alasan ke kalimat berada di lapisan tampilan (change 002, task 3.2), bukan di domain.

### D7 — Angka tidak pernah bocor pada keadaan tidak-disetujui

Lapisan tampilan tidak menerima nilai target pada hasil yang tidak disetujui — domain memang tidak mengembalikannya. Tambahan di sisi tampilan: tidak ada angka contoh, tidak ada placeholder bergaya angka, dan tidak ada sisa nilai dari pratinjau sebelumnya yang masih tersimpan di state.

Diuji eksplisit, karena kebocoran semacam ini biasanya datang dari state yang tidak dibersihkan, bukan dari kode yang sengaja menampilkannya.

### D8 — Tabel profil dan migrasi versi 2 ke 3

Profil disimpan pada tabelnya sendiri mengikuti §11, dengan konvensi record pengguna dari change 001 dan penanda kelengkapan onboarding dari D2. `schemaVersion` naik dari 2 ke 3 satu kali.

Migrasi tidak menyentuh data program yang sudah ada dan tidak membuat profil secara otomatis. Fixture mengikuti pola change 004: kosong, langsung versi 3, versi 2 berisi data, dan migrasi terputus.

*Catatan urutan:* tabel profil baru dibuat sekarang, padahal change 004 sudah merujuk profil dari tabel program. Pada change 004 rujukan itu berupa pengenal profil tanpa tabel tujuan. Di change ini rujukan tersebut dilengkapi menjadi foreign key sungguhan, dan pemeriksaan foreign key dijalankan sebagai bagian verifikasi migrasi.

### D9 — Satu wadah state per alur, bukan per layar

Alur onboarding memakai satu wadah state yang memuat masukan terkumpul, hasil perhitungan terakhir, dan langkah saat ini. Setiap layar membaca bagian yang relevan.

Alternatif berupa state per layar akan membuat perpindahan mundur kehilangan konteks, dan membuat pratinjau harus merakit ulang masukan dari beberapa sumber — tempat paling mudah untuk salah.

### D10 — Ruang Hari ini membaca program aktif, belum membaca buku harian

Setelah aktivasi, ruang Hari ini menampilkan chip program aktif dan target energi harian, sementara bagian konsumsi tetap pada keadaan belum diketahui karena buku harian belum ada.

Ini keadaan sementara yang jujur dan sudah sesuai aturan: hari tanpa catatan ditampilkan sebagai belum diketahui, bukan nol (change 004).

## Risks / Trade-offs

- **Kebijakan `np-1.0.0` belum disetujui saat change ini dikerjakan** → seluruh onboarding bermuara di layar `26`, dan jalur bahagia tidak dapat diperlihatkan kepada pemangku kepentingan. Mitigasi: jalur bahagia tetap diuji penuh dengan kebijakan draf di lingkungan uji; keadaan `26` justru menjadi perilaku rilis yang benar sampai persetujuan turun.
- **Masukan tersimpan bertahap membuat profil tidak lengkap bisa ada** → risiko perhitungan dijalankan atas data separuh. Mitigasi: penanda kelengkapan, dan jalur `missing_required_input` yang diuji.
- **Pemetaan kode alasan ke kalimat bisa berubah menjadi diagnosis** seiring waktu → mitigasi: satu kerangka layar, pemeriksaan bahasa sebagai bagian gate, dan daftar larangan yang eksplisit.
- **Layar baru yang saya rancang sendiri** (masukan berubah sejak pratinjau) belum pernah dilihat pengguna nyata → mitigasi: strukturnya meniru layar `12` yang sudah dirancang matang; bila terasa mengganggu saat dipakai, perbaikannya murah karena terisolasi.
- **Migrasi versi 2 ke 3 menambah foreign key ke tabel yang baru ada** → risiko kegagalan pemeriksaan pada basis data yang sudah berisi program. Mitigasi: fixture khusus berisi program tanpa profil, dan keputusan eksplisit tentang perlakuannya sebelum migrasi ditulis.
- **Onboarding terasa panjang** (lima langkah plus target berat) → mitigasi: indikator langkah, masukan tersimpan, dan nama panggilan yang opsional; tidak ada langkah yang ditambahkan di luar yang dibutuhkan perhitungan dan kelayakan.

## Migration Plan

1. Naikkan `schemaVersion` dari 2 ke 3 satu kali untuk change ini.
2. Buat tabel profil, lengkapi rujukan profil pada tabel program menjadi foreign key, dan jalankan pemeriksaan foreign key.
3. Jangan membuat profil otomatis dan jangan mengaktifkan program apa pun.
4. Jalankan fixture: kosong, langsung versi 3, versi 2 berisi data program, versi 2 berisi program tanpa profil, dan migrasi terputus.
5. Setelah migrasi, pengguna tanpa profil lengkap masuk ke onboarding; pengguna dengan profil lengkap tanpa program masuk ke keadaan belum ada program.

Rollback: penurunan versi tidak didukung, konsisten dengan change 004. Belum ada rilis publik, sehingga pemulihan dilakukan dengan membuang commit dan memasang ulang pada perangkat uji.

## Open Questions

Tidak ada pertanyaan yang ditunda. Satu hal yang memerlukan keputusan saat implementasi, bukan sebelum: perlakuan terhadap basis data versi 2 yang memuat baris program tanpa profil yang sesuai. Keadaan ini hanya mungkin terjadi pada perangkat uji internal, karena belum ada rilis publik, dan pilihannya — menolak migrasi atau membersihkan baris yatim — ditetapkan saat fixture dibuat dan dicatat di catatan migrasi.
