# Design — 009 · Produk kemasan lewat barcode

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 007 menyediakan katalog, buku harian dengan potret nilai gizi, agregasi harian, dan lembar pilihan pencatatan dengan jalur barcode yang ditandai belum tersedia. Belum ada tabel produk kemasan, belum ada pemindai, dan belum ada klien sumber data produk.

Batasan yang mengikat dari assessment §50: barcode adalah pengenal, bukan sumber nilai (§50.1); aritmetika basis takaran tidak boleh tertukar (§50.1); provenans wajib dilacak (§50.4); kemasan di tangan pengguna menang ketika berbeda (§50.4); rekaman komunitas memerlukan peninjauan (§50.4).

## Goals / Non-Goals

**Goals**

- Mencatat produk kemasan yang pernah dipindai menjadi pekerjaan beberapa detik, sepenuhnya luring.
- Aritmetika per sajian, per kemasan, dan per 100 g tidak pernah tertukar.
- Pengguna selalu melihat apa yang akan dicatat sebelum dicatat.
- Jalur luring selalu ada; koneksi mempercepat, bukan menjadi syarat.

**Non-Goals**

- Tidak ada pembacaan label gizi lewat foto — itu change berikutnya, dan jalur "produk tidak ditemukan" hanya menunjuk ke sana.
- Tidak ada pengenalan foto makanan.
- Tidak ada katalog produk bermerek yang dibundel dalam aplikasi; yang tersimpan hanyalah produk yang pernah dikonfirmasi pengguna dan yang dibawa dari sumber yang disetujui.
- Tidak ada pembaruan massal rekaman produk dari sumber daring.

## Decisions

### D1 — Urutan pencarian: perangkat lebih dulu, daring belakangan

Barcode dicocokkan ke produk di perangkat lebih dulu. Pencarian daring hanya terjadi bila tidak ketemu dan perangkat sedang daring.

Alasannya bukan sekadar kecepatan: produk yang pernah dikonfirmasi pengguna — termasuk koreksinya terhadap kemasan di tangannya — adalah rekaman yang paling dapat dipercaya untuk pengguna itu. Mendahulukan sumber daring akan membuat koreksinya tertimpa setiap kali ia memindai ulang.

### D2 — Klien sumber data produk di balik antarmuka yang dapat diganti

Sumber data produk diakses lewat antarmuka, bukan dipanggil langsung dari layar. Kandidat yang disebut assessment adalah Open Food Facts, dengan kewajiban ODbL dan lisensi gambar yang harus dipenuhi.

Antarmuka ini membuat tiga hal mungkin: mengganti sumber tanpa menyentuh layar, menguji seluruh jalur tanpa jaringan, dan menolak sumber yang ternyata tidak memenuhi syarat lisensi tanpa membatalkan change.

Rekaman dari sumber komunitas ditandai jenis sumbernya, sehingga pengguna tahu bahwa nilai itu bukan dari produsen dan patut diperiksa terhadap kemasan.

### D3 — Hanya nomor barcode yang dikirim ke jaringan

Pencarian daring mengirim nomor barcode dan tidak lebih. Tidak ada gambar, tidak ada pengenal perangkat, tidak ada data profil.

Ini batas yang ditulis eksplisit di spec karena jalur barcode secara teknis punya kamera di tangannya — dan jalur yang punya kamera mudah bergeser menjadi jalur yang mengirim gambar.

### D4 — Basis takaran disimpan apa adanya, konversi hanya saat menghitung

Rekaman produk menyimpan basis aslinya — per sajian, per 100 g — beserta ukuran sajian dan jumlah sajian per kemasan. Konversi dilakukan hanya saat menghitung jumlah yang dimakan, dan basis yang dipakai ditampilkan bersama angkanya.

Menormalkan semua rekaman ke satu basis saat penyimpanan akan membuang informasi yang dibutuhkan untuk menjelaskan angka kepada pengguna, dan setiap pembulatan pada penyimpanan menjadi kesalahan permanen.

Aritmetika ini adalah bagian paling mudah salah di change ini dan paling sulit terlihat saat review — karena itu seluruh kombinasi basis diuji dengan nilai yang berbeda per basis, bukan nilai yang kebetulan sama.

### D5 — Koreksi pengguna menang dan bertahan

Ketika pengguna mengoreksi nilai, koreksi itu disimpan pada rekaman produk di perangkat beserta penanda bahwa nilai ini dikoreksi pengguna. Pemindaian berikutnya memakai nilai koreksi. Sumber daring tidak pernah menimpanya tanpa persetujuan.

Dasarnya ada di §50.4: produk mengalami reformulasi, dan kemasan yang dipegang pengguna hari ini lebih benar daripada rekaman basis data yang mungkin berumur dua tahun.

### D6 — Layar baru: masukan barcode manual

Rancangan `21` memuat tautan "Masukkan nomor barcode secara manual", tetapi layarnya belum ada. Change ini merancangnya: kolom nomor, validasi bentuk barcode, dan jalur yang sama setelahnya.

Jalur ini bukan pelengkap: ia adalah satu-satunya jalur barcode yang bekerja ketika izin kamera ditolak, kamera rusak, atau kode pada kemasan sudah lecek. Tanpa itu, penolakan izin kamera berarti jalan buntu.

### D7 — Izin kamera diminta saat dipakai, dengan penjelasan

Izin kamera diminta ketika pengguna memilih jalur pemindaian, bukan saat aplikasi dibuka atau saat lembar pilihan pencatatan dibuka. Penolakan izin tidak pernah menghasilkan layar gagal — ia mengarahkan ke masukan manual dan pencarian katalog.

### D8 — Produk kemasan sebagai makanan dengan sifat tambahan

Produk kemasan disimpan sebagai makanan pada katalog change 007, ditambah rekaman sifat kemasan: barcode, merek, ukuran kemasan, jumlah sajian per kemasan, basis takaran, dan provenans.

Alasannya: produk kemasan harus bisa dicari lewat nama, muncul di "terakhir dicatat", dan dicatat lewat jalur yang sama dengan makanan lain. Membuat jenis entitas kedua akan memaksa setiap layar buku harian menangani dua bentuk makanan.

### D9 — Potret nilai gizi tetap menjadi aturan

Catatan yang dibuat dari produk kemasan membekukan nilainya seperti catatan lain (change 007 D1). Koreksi pengguna atas rekaman produk di kemudian hari tidak mengubah catatan yang sudah ada.

### D10 — Migrasi versi 5 ke 6

`schemaVersion` naik dari 5 ke 6 satu kali: tabel sifat produk kemasan beserta indeks pada barcode, dan kolom provenans. Data versi 5 tidak disentuh. Fixture mengikuti pola change sebelumnya.

### D11 — Verifikasi jalur pindai hanya sah di Android

Kamera tidak tersedia pada target web yang dipakai untuk pratinjau pengembangan (change 001 D3). Karena itu jalur pemindaian diverifikasi di perangkat Android, sementara di web jalur itu menampilkan keadaan "pemindaian tidak tersedia di lingkungan ini" dan masukan manual tetap dapat diuji.

Ini dinyatakan sekarang agar tidak ditemukan sebagai kejutan saat gate verifikasi.

## Risks / Trade-offs

- **Sumber data produk ternyata tidak memenuhi syarat lisensi** → mitigasi: klien di balik antarmuka; jalur luring dan masukan manual tidak bergantung pada sumber mana pun, sehingga change tetap berguna meski pencarian daring dimatikan.
- **Rekaman komunitas memuat nilai yang salah** → mitigasi: jenis sumber ditampilkan, peninjauan wajib sebelum mencatat, dan koreksi pengguna menang serta bertahan.
- **Aritmetika basis takaran salah tanpa ketahuan** → ini risiko paling serius di change ini, karena hasilnya berupa angka yang tampak masuk akal. Mitigasi: uji seluruh kombinasi basis dengan nilai yang berbeda per basis; uji dengan kasus dari rancangan `04` dan `37` yang memakai angka nyata.
- **Pengguna mengira pindaian langsung mencatat** → mitigasi: peninjauan wajib, dan tidak ada pencatatan otomatis setelah pemindaian.
- **Kamera dan izinnya berperilaku berbeda antar perangkat Android** → mitigasi: keadaan izin ditolak, kamera tidak tersedia, dan kode tidak terbaca ditangani sebagai keadaan yang dirancang, bukan kasus tepi.
- **Jalur pindai tidak dapat diuji di lingkungan pratinjau** → mitigasi: dinyatakan sejak design; masukan manual menanggung sebagian besar uji otomatis; verifikasi perangkat menjadi syarat gate.

## Migration Plan

1. Naikkan `schemaVersion` dari 5 ke 6 satu kali untuk change ini.
2. Buat tabel sifat produk kemasan beserta kolom provenans dan indeks pada barcode.
3. Pertahankan seluruh data versi 5 tanpa perubahan.
4. Jalankan verifikasi pasca-migrasi: versi skema dan pemeriksaan foreign key.
5. Jalankan fixture: kosong, langsung versi 6, versi 5 berisi data makanan dan catatan, dan migrasi terputus.

Rollback: penurunan versi tidak didukung, konsisten dengan change sebelumnya.

## Open Questions

Satu pertanyaan yang dapat ditunda tanpa mengubah spec maupun pemecahan task: **sumber data produk mana yang dipakai dan bagaimana kewajiban lisensinya dipenuhi**. Penelusurannya adalah paket kerja di `mealora-plans` pada change ini. Hasilnya menentukan apakah pencarian daring diaktifkan pada rilis pertama atau tidak — bukan bagaimana jalur barcode bekerja, karena seluruh jalur luring berdiri sendiri.
