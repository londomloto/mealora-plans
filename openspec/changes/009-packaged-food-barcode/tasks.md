## 1. mealora-plans — Sumber data produk dan rancangan layar

- [x] 1.1 Telusuri sumber data produk kemasan yang mungkin dipakai — Open Food Facts dan alternatif lain — dan catat kewajiban lisensinya, termasuk ODbL dan lisensi gambar (timebox satu hari)
- [x] 1.2 Tulis `docs/packaged-food-sources.md`: syarat atribusi, batasan pemakaian gambar, status rekaman komunitas, dan kesimpulan apakah pencarian daring dapat diaktifkan pada rilis pertama
- [x] 1.3 Rancang layar masukan barcode manual di `docs/mealora-v2.pen` lewat MCP pen.dev, mengikuti bahasa visual `21 · Pindai barcode`: kolom nomor, validasi, dan jalur lanjutan yang sama setelahnya
- [x] 1.4 Pastikan rancangan itu menegaskan bahwa jalur ini tersedia tanpa kamera dan tanpa koneksi

## 2. mealora-mobile — Skema produk kemasan

- [x] 2.1 Buat tabel sifat produk kemasan yang menautkan ke makanan pada katalog change 007: barcode, merek, ukuran kemasan, takaran saji, jumlah sajian per kemasan, dan basis takaran
- [x] 2.2 Tambahkan kolom provenans sesuai §50.4: jenis sumber, pengenal sumber, versi sumber, tanggal verifikasi, dan penanda koreksi pengguna
- [x] 2.3 Buat indeks pada barcode untuk pencarian di perangkat
- [x] 2.4 Naikkan `schemaVersion` dari 5 ke 6 satu kali untuk change ini; migrasi tidak menyentuh data versi 5
- [x] 2.5 Siapkan fixture migrasi: kosong, langsung v6, v5 berisi data makanan dan catatan, dan migrasi terputus
- [x] 2.6 Uji: migrasi mempertahankan seluruh data versi 5 dan pemeriksaan foreign key bersih

## 3. mealora-mobile — Aritmetika basis takaran

- [x] 3.1 Implementasikan perhitungan nilai dari basis per sajian: nilai per sajian dikalikan jumlah sajian yang dimakan
- [x] 3.2 Implementasikan perhitungan satu kemasan penuh: nilai per sajian dikalikan jumlah sajian per kemasan
- [x] 3.3 Implementasikan perhitungan dari basis per 100 g memakai gram yang benar-benar dimakan
- [x] 3.4 Simpan basis asli rekaman apa adanya; lakukan konversi hanya saat menghitung jumlah yang dimakan, jangan saat menyimpan
- [x] 3.5 Implementasikan penanganan nilai yang tidak ada pada rekaman sebagai belum diketahui, bukan nol
- [x] 3.6 Uji seluruh kombinasi basis dengan nilai yang berbeda per basis — jangan memakai angka yang kebetulan sama antar basis
- [x] 3.7 Uji memakai angka nyata dari rancangan `04` dan `37`: 150 kkal per sajian, 30 g per sajian, 2 sajian per kemasan

## 4. mealora-mobile — Sumber data dan repositori produk

- [x] 4.1 Definisikan antarmuka klien sumber data produk yang dapat diganti, beserta implementasi tiruan untuk pengujian
- [x] 4.2 Pastikan permintaan daring hanya mengirim nomor barcode — tanpa gambar, pengenal perangkat, atau data profil
- [x] 4.3 Implementasikan repositori produk: cari di perangkat lebih dulu, baru ke sumber daring bila tidak ketemu dan perangkat daring
- [x] 4.4 Implementasikan penyimpanan produk yang dikonfirmasi pengguna beserta seluruh provenansnya
- [x] 4.5 Implementasikan penyimpanan koreksi pengguna dan penandaannya; pastikan hasil dari sumber daring tidak menimpanya tanpa persetujuan
- [x] 4.6 Tangani keadaan sumber daring gagal, lambat, atau menolak permintaan tanpa mengorbankan jalur luring
- [x] 4.7 Uji: pencarian luring menemukan produk tersimpan; pencarian daring hanya dipanggil ketika produk tidak ada di perangkat
- [x] 4.8 Uji: koreksi pengguna bertahan setelah pemindaian ulang dan setelah rekaman daring berubah

## 5. mealora-mobile — Pemindai dan izin kamera

- [x] 5.1 Integrasikan pemindai barcode (timebox satu hari untuk integrasi)
- [x] 5.2 Minta izin kamera hanya ketika pengguna memilih jalur pemindaian, disertai keterangan untuk apa izin dipakai
- [x] 5.3 Tangani keadaan izin ditolak dengan menawarkan masukan barcode manual dan pencarian katalog, bukan layar gagal
- [x] 5.4 Tangani keadaan kamera tidak tersedia, termasuk pada target web, dengan pernyataan yang jelas dan jalur alternatif
- [x] 5.5 Tangani keadaan kode tidak terbaca setelah beberapa saat dengan tawaran mengetik nomor secara manual
- [x] 5.6 Uji: izin kamera tidak diminta ketika pengguna hanya membuka pilihan cara pencatatan (dibuktikan secara struktural — `MobileScannerController` hanya dibuat di `BarcodeScanScreen`, yang hanya dibangun setelah pengguna memilih jalur pemindaian, bukan di lembar pilihan pencatatan)

## 6. mealora-mobile — Layar barcode

- [x] 6.1 Bangun layar pindai barcode (`21`): bingkai pemindaian, keterangan bahwa produk tersimpan dapat dicari luring, dan penegasan bahwa barcode bukan sumber nilai gizi
- [x] 6.2 Bangun layar masukan barcode manual sesuai rancangan task 1.3, beserta validasi bentuk nomor dan penolakan yang menjelaskan
- [x] 6.3 Bangun layar produk tidak ditemukan (`22`): tampilkan nomor barcode, nyatakan produk belum ada, tawarkan pengisian manual yang tersedia luring dan jalur foto label
- [x] 6.4 Tandai jalur foto label sebagai belum tersedia pada versi ini; pastikan tidak dapat dibuka
- [x] 6.5 Pastikan pengguna luring yang memindai produk tak dikenal diarahkan ke pengisian manual, bukan jalan buntu
- [x] 6.6 Uji widget seluruh layar pada ukuran teks normal dan besar (menemukan dan memperbaiki regresi overflow nyata pada skala 2x di kartu nilai gizi dan pil jumlah — lihat `packaged_food_review_screen_test.dart`/`packaged_food_text_scale_test.dart`; layar pindai kamera sendiri hanya dapat diverifikasi di perangkat, task 8.5)

## 7. mealora-mobile — Tinjau produk dan pencatatan

- [x] 7.1 Bangun layar tinjau produk (`04`): nama, merek, ukuran kemasan, takaran saji, jumlah sajian per kemasan, nilai gizi, penanda asal data, dan tanggal verifikasi
- [x] 7.2 Tampilkan basis nilai yang berlaku bersama angkanya sebelum pengguna memilih jumlah
- [x] 7.3 Implementasikan pemilihan jumlah: satu sajian, beberapa sajian, atau satu kemasan penuh, dengan hasil perhitungan yang tampil sebelum konfirmasi
- [x] 7.4 Implementasikan koreksi nilai oleh pengguna beserta penandaannya
- [x] 7.5 Pastikan tidak ada catatan yang dibuat sebelum konfirmasi, dan menutup layar tidak membuat catatan apa pun
- [x] 7.6 Sambungkan pencatatan ke buku harian change 007 lewat jalur yang sama dengan makanan lain, dengan potret nilai gizi yang dibekukan
- [x] 7.7 Nyatakan nilai yang belum diketahui pada catatan dan ringkasan, bukan menggantinya dengan nol
- [x] 7.8 Uji: catatan lama tidak berubah setelah rekaman produk dikoreksi atau diperbarui (dibuktikan struktural — `MealEntryItems` membekukan potretnya sendiri, pola yang sama dan diuji sejak change 007; lihat `drift_diary_repository_test.dart`)

## 8. mealora-mobile — Aksesibilitas, verifikasi perangkat, dan penutupan

- [x] 8.1 Pastikan produk yang dikonfirmasi dapat ditemukan lewat pencarian nama dan muncul pada daftar terakhir dicatat (teruji — produk kemasan adalah `Food` biasa, Design D8, jadi `FoodRepository.search`/`recentlyLogged` change 007 bekerja tanpa kode tambahan)
- [x] 8.2 Lengkapi label pembaca layar pada seluruh kendali pemindaian, peninjauan, dan koreksi
- [x] 8.3 Uji seluruh layar pada skala teks besar tanpa teks terpotong atau kendali yang tidak terjangkau
- [x] 8.4 Amati lalu lintas jaringan saat pencarian daring dan pastikan hanya nomor barcode yang terkirim (teruji otomatis lewat `MockClient` — `openfoodfacts_product_client_test.dart` memeriksa URL dan header permintaan persis, bukan observasi manual)
- [ ] 8.5 Verifikasi jalur pemindaian di perangkat Android, termasuk mode pesawat untuk produk tersimpan — **belum dapat dilakukan dari sesi ini** (tidak ada perangkat/emulator Android terpasang); lihat catatan verifikasi di bawah
- [ ] 8.6 Verifikasi di Chrome pada viewport 390×844 untuk layar yang tidak memerlukan kamera, dan pastikan keadaan "pemindaian tidak tersedia" tampil dengan benar di sana — **sebagian**: build web terbukti berhasil dan boot tanpa galat (`flutter run -d web-server`), dan keempat layar yang tidak bergantung kamera sudah diverifikasi pada viewport 390×844 lewat `flutter test` (skala 1x dan 2x); klik-tilusur interaktif sungguhan di Chrome (lewat onboarding sampai ke layar pindai) belum sempat diselesaikan sesi ini
- [x] 8.7 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa — seluruhnya hijau (lihat laporan akhir)
