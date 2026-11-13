# Functional Requirements Specification

## Mealora - Pemberitahuan dan Wajib Update Aplikasi

| | |
|---|---|
| Change | 017-app-update-check |
| Versi | v0.1-draft |
| Tanggal | 2026-11-12 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Aplikasi memberi tahu pengguna ketika versi baru tersedia, dan pengguna boleh menundanya.
- Aplikasi mewajibkan update ketika versi yang terpasang sudah tidak didukung.
- Tim dapat mengatur versi terbaru, versi minimum, catatan rilis, dan tautan toko tanpa merilis ulang aplikasi.
- Aplikasi tetap dapat dipakai normal ketika pengecekan versi gagal.

### 1.2 Deferred Items (Not in This FRS Version)

- Update langsung di dalam aplikasi tanpa membuka toko. Ditunda untuk menjaga ruang lingkup MVP.
- Layar "Apa yang baru" setelah update terpasang.
- Pengaturan versi yang berbeda untuk Android dan iOS.
- Sinkronisasi versi otomatis lewat pipeline rilis.

## 2. Pemberitahuan dan Wajib Update

### 2.1 User Story

As a pengguna Mealora,
I want diberi tahu ketika ada versi baru aplikasi,
So that saya mendapat perbaikan dan fitur terbaru, dan tidak terjebak di versi yang sudah tidak berfungsi.

As a tim produk Mealora,
I want dapat mewajibkan update ketika versi lama sudah tidak didukung,
So that semua pengguna memakai versi yang aman dan kompatibel.

### 2.2 Functional Scope

- Aplikasi memeriksa informasi versi setiap kali dibuka, dan saat dibuka kembali dari latar belakang paling sering sekali per jam. Pemeriksaan tidak memperlambat tampilnya layar awal.
- Bila ada versi baru, tampil pemberitahuan "Update tersedia" berisi catatan rilis (bila ada) dengan dua pilihan: "Update" untuk membuka halaman aplikasi di Play Store / App Store, dan "Nanti" untuk menutup pemberitahuan. Setelah memilih "Nanti", pemberitahuan untuk versi yang sama tidak muncul lagi. Pemberitahuan baru muncul lagi saat ada versi yang lebih baru.
- Bila versi yang terpasang sudah tidak didukung, tampil layar "Wajib update" yang menutupi seluruh aplikasi. Layar ini tidak dapat ditutup, termasuk dengan tombol kembali, dan hanya menyediakan tombol menuju toko.
- Status wajib update tetap berlaku meskipun perangkat sedang offline. Bila tim kemudian menurunkan batas versi minimum, layar ini hilang begitu aplikasi berhasil memeriksa ulang.
- Bila informasi versi tidak dapat diambil (tidak ada internet, server tidak merespons, atau data tidak valid), aplikasi berjalan normal tanpa pesan kesalahan.
- Informasi versi bersifat publik dan tidak memuat data pengguna maupun rahasia sistem. Aplikasi tidak mengirim data pengguna saat memeriksa versi.
- Perbandingan versi dilakukan per angka, sehingga 1.10.0 dianggap lebih baru dari 1.9.0. Nomor build diabaikan.

### 2.3 Acceptance Criteria

2.3.1. The system shall menyediakan informasi versi terbaru, versi minimum, catatan rilis, dan tautan toko yang dapat dibaca tanpa login.

2.3.2. The system shall tidak memuat rahasia atau pengaturan internal server di dalam informasi versi.

2.3.3. The system shall menolak berjalan bila versi minimum lebih tinggi dari versi terbaru atau bila format versinya tidak valid.

2.3.4. The system shall memeriksa versi saat aplikasi dibuka tanpa menunda tampilnya layar awal.

2.3.5. The system shall memeriksa ulang versi saat aplikasi kembali ke depan hanya jika sudah lewat minimal satu jam sejak pemeriksaan berhasil terakhir.

2.3.6. The system shall membandingkan versi per angka dan mengabaikan nomor build.

2.3.7. The system shall menampilkan layar wajib update yang tidak dapat ditutup bila versi terpasang di bawah versi minimum.

2.3.8. The system shall membuka halaman aplikasi di toko sesuai platform perangkat saat tombol update ditekan.

2.3.9. The system shall menampilkan pemberitahuan update tersedia dengan pilihan "Update" dan "Nanti" bila versi terpasang di bawah versi terbaru tetapi masih didukung.

2.3.10. The system shall tidak menampilkan ulang pemberitahuan untuk versi yang sudah ditunda pengguna, dan shall menampilkannya lagi untuk versi yang lebih baru.

2.3.11. The system shall berjalan normal tanpa pesan kesalahan bila informasi versi tidak dapat diambil atau tidak valid.

2.3.12. The system shall tetap memberlakukan wajib update dari informasi versi terakhir yang tersimpan ketika pemeriksaan gagal.

2.3.13. The system shall menghilangkan layar wajib update bila pemeriksaan berhasil berikutnya menunjukkan versi terpasang sudah didukung kembali.

2.3.14. The system shall tidak menampilkan pemberitahuan maupun layar update di platform yang belum memiliki tautan toko.

## 3. High Level Test Scenarios

1. Versi terpasang 1.1.0, terbaru 1.2.0, minimum 1.0.0 → buka aplikasi → muncul pemberitahuan "Update tersedia" dengan catatan rilis.
2. Dari skenario 1, pilih "Nanti" → tutup lalu buka lagi aplikasi → pemberitahuan tidak muncul.
3. Dari skenario 2, tim mengubah versi terbaru menjadi 1.3.0 → buka aplikasi → pemberitahuan muncul untuk 1.3.0.
4. Versi terpasang 1.0.0, minimum 1.1.0 → buka aplikasi → layar "Wajib update" menutupi aplikasi, dan tombol kembali tidak menutupnya.
5. Dari skenario 4, tekan tombol update → Play Store / App Store terbuka di halaman Mealora.
6. Dari skenario 4, matikan internet lalu buka ulang aplikasi → layar "Wajib update" tetap tampil.
7. Dari skenario 4, tim menurunkan minimum menjadi 1.0.0 → buka ulang aplikasi dengan internet → aplikasi dapat dipakai normal.
8. Perangkat tanpa internet dan belum pernah memeriksa versi → buka aplikasi → aplikasi berjalan normal tanpa pesan kesalahan.
9. Versi terpasang sama dengan versi terbaru → buka aplikasi → tidak muncul pemberitahuan apa pun.
