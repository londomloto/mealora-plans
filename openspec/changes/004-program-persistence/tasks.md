## 1. mealora-mobile — Tabel dan skema

- [ ] 1.1 Baca ulang assessment §42–§44, spec change 003, dan layar `05`, `16`, `18`, `29`, `30`, `36`, `40` di `docs/mealora.pen` sebelum menulis tabel, agar kolom yang dibuat memang yang ditampilkan
- [ ] 1.2 Buat tabel katalog program: kode unik, nama, deskripsi, penanda perlu target berat, penanda ketersediaan, urutan tampil, versi definisi, dan jejak waktu
- [ ] 1.3 Buat tabel program pengguna sesuai §42: profil, program, status, waktu mulai/jeda/berakhir, berat awal, berat tujuan, tanggal tujuan, target energi dan makro, salinan masukan, `calculator_version`, `policy_version`, alasan jeda, alasan selesai, tautan program pendahulu dan pengganti, serta konvensi record pengguna dari change 001
- [ ] 1.4 Buat tabel potret kemajuan: program pengguna, tanggal lokal, waktu pencatatan, berat, perubahan berat, rasio kemajuan, energi tercatat, rasio kesesuaian, makro, jumlah waktu makan, penanda kelengkapan buku harian, nomor hari aktif, kolom ukuran tambahan, dan versi perhitungan
- [ ] 1.5 Pastikan seluruh kolom nilai pada potret kemajuan dapat bernilai kosong, sehingga "belum diketahui" berbeda dari nol; kolom pencacah tetap wajib terisi
- [ ] 1.6 Buat tabel peristiwa siklus hidup: program pengguna, jenis peristiwa, waktu kejadian, status asal, status tujuan, kode alasan, dan data tambahan
- [ ] 1.7 Pastikan setiap tabel milik pengguna memakai mixin metadata siap-sinkron dari change 001, dan tambahkan uji yang menegaskannya

## 2. mealora-mobile — Seed, indeks, dan trigger

- [ ] 2.1 Tulis seed katalog untuk empat kode program dengan pengenal tetap yang ditulis di kode, bukan dibangkitkan saat pemasangan
- [ ] 2.2 Buat seed bersifat penyisipan-atau-perbarui berdasarkan kode program; uji bahwa menjalankannya tiga kali menghasilkan tepat empat baris dengan pengenal yang sama
- [ ] 2.3 Buat indeks unik parsial untuk baris hidup berstatus `active` per profil dan baris hidup berstatus `paused` per profil
- [ ] 2.4 Buat indeks unik hidup pada pasangan program pengguna dan tanggal lokal di tabel potret kemajuan
- [ ] 2.5 Buat indeks pendukung kueri riwayat program menurut waktu
- [ ] 2.6 Buat trigger SQLite yang menolak keadaan dengan lebih dari satu program berjalan per profil, termasuk kombinasi satu `active` dan satu `paused` yang tidak tertangkap kedua indeks parsial
- [ ] 2.7 Uji trigger dengan penulisan langsung ke tabel yang sengaja melanggar invarian; trigger dianggap belum ada sampai uji ini membuktikannya menolak
- [ ] 2.8 Bila trigger tidak dapat diselesaikan dalam timebox satu hari, catat keterbatasannya sebagai utang teknis eksplisit yang wajib ditutup sebelum sinkronisasi MVP 2, dan pastikan transaksi tetap menegakkan invarian

## 3. mealora-mobile — Repositori program

- [ ] 3.1 Implementasikan kontrak repositori program dari change 003 memakai DAO Drift, tanpa membocorkan tipe Drift ke lapisan atas
- [ ] 3.2 Pakai lapisan akses data bersama change 001 untuk menyaring record terhapus lunak secara bawaan; sediakan jalur eksplisit bila record terhapus perlu dibaca
- [ ] 3.3 Implementasikan pemetaan antara entitas domain dan baris basis data, termasuk salinan masukan dan kedua versi
- [ ] 3.4 Uji: seluruh uji perintah siklus hidup change 003 dijalankan ulang terhadap penyimpanan sungguhan, bukan penyimpanan tiruan

## 4. mealora-mobile — Transaksi aktivasi dan pergantian

- [ ] 4.1 Implementasikan transaksi aktivasi: baca ulang fakta profil terkini di dalam transaksi yang sama, verifikasi proposal masih sesuai, lalu tulis program, peristiwa, dan potret kemajuan awal
- [ ] 4.2 Implementasikan pembatalan aktivasi ketika fakta berubah sejak pratinjau, tanpa meninggalkan perubahan sebagian
- [ ] 4.3 Implementasikan transaksi pergantian: tandai program lama `changed` beserta waktu berakhir, tulis tautan dua arah, sisipkan peristiwa, aktifkan program baru
- [ ] 4.4 Uji pergantian dengan kegagalan yang disuntikkan pada setiap langkah; setiap kasus harus mengembalikan keadaan persis seperti sebelum perintah
- [ ] 4.5 Uji bahwa catatan makanan dan berat badan tidak berubah nilainya maupun kepemilikannya setelah aktivasi dan pergantian
- [ ] 4.6 Uji bahwa perintah aktivasi yang diulang tidak menghasilkan baris program ganda

## 5. mealora-mobile — Perintah siklus hidup lain

- [ ] 5.1 Implementasikan jeda dan lanjutkan sebagai penulisan beserta peristiwanya, sehingga seluruh rentang jeda tetap dapat ditelusuri setelah program dilanjutkan
- [ ] 5.2 Implementasikan selesaikan dengan alasan dan ringkasan akhir, serta batalkan untuk program yang masih draf
- [ ] 5.3 Implementasikan idempotensi perintah berulang: tidak ada peristiwa ganda dan waktu mulai jeda tidak berubah
- [ ] 5.4 Uji bahwa perpindahan dari keadaan akhir ditolak di tingkat penyimpanan, bukan hanya di domain

## 6. mealora-mobile — Potret kemajuan dan riwayat

- [ ] 6.1 Implementasikan pembangunan ulang potret kemajuan untuk satu tanggal sebagai penyisipan-atau-perbarui berdasarkan pasangan program pengguna dan tanggal lokal
- [ ] 6.2 Implementasikan penanganan hari jeda: tidak menambah nomor hari aktif dan tidak ikut dalam kesesuaian target, sementara catatan pada hari itu tetap tersimpan
- [ ] 6.3 Implementasikan penanganan nilai belum diketahui: kolom dibiarkan kosong, tidak pernah diisi nol
- [ ] 6.4 Pakai tanggal lokal yang tersimpan saat pencatatan; jangan menghitung ulang tanggal dari instan UTC saat membaca
- [ ] 6.5 Uji: pembangunan ulang tiga kali menghasilkan satu baris per tanggal dengan nilai yang sama
- [ ] 6.6 Uji: menyunting catatan sumber lalu membangun ulang menghasilkan nilai terbaru tanpa menggandakan nilai lama
- [ ] 6.7 Uji perbandingan: pembangunan ulang penuh seluruh rentang menghasilkan nilai yang sama dengan potret tersimpan
- [ ] 6.8 Implementasikan kueri riwayat program berurutan menurut waktu yang membaca nilai tersimpan apa adanya, tanpa menghitung ulang
- [ ] 6.9 Uji: pembaruan katalog, pembaruan kebijakan, dan penyuntingan profil tidak mengubah satu pun nilai pada entri riwayat

## 7. mealora-mobile — Migrasi skema 1 → 2

- [ ] 7.1 Naikkan `schemaVersion` dari 1 ke 2 satu kali untuk seluruh change ini
- [ ] 7.2 Tulis migrasi yang membuat empat tabel, seluruh indeks, dan trigger, lalu menjalankan seed katalog
- [ ] 7.3 Pastikan migrasi tidak menyentuh data versi 1 dan tidak mendaftarkan profil mana pun ke program
- [ ] 7.4 Implementasikan verifikasi pasca-migrasi: versi skema benar, katalog valid, dan `PRAGMA foreign_key_check` bersih
- [ ] 7.5 Implementasikan alur konversi target lama yang memerlukan konfirmasi pengguna, mencatat asal-usul sebagai hasil konversi yang dikonfirmasi, dan menyimpan salinan nilai asli
- [ ] 7.6 Dokumentasikan bahwa penurunan versi tidak didukung, di README repo dan di catatan migrasi

## 8. mealora-mobile — Fixture migrasi dan gate verifikasi

- [ ] 8.1 Siapkan fixture basis data kosong dan fixture pembuatan langsung pada versi 2
- [ ] 8.2 Siapkan fixture basis data versi 1 berisi data — profil, catatan makanan, makanan buatan sendiri, favorit, dan riwayat berat — dibuat lewat alur aplikasi versi 1, bukan penulisan SQL manual
- [ ] 8.3 Siapkan fixture migrasi terputus dan fixture data lama yang tidak valid
- [ ] 8.4 Uji: migrasi atas fixture berisi data mempertahankan seluruh catatan dan tidak mengaktifkan program apa pun
- [ ] 8.5 Uji: migrasi terputus tidak merusak data dan selesai pada percobaan berikutnya
- [ ] 8.6 Uji: foreign key aktif sepanjang migrasi dan pemeriksaannya bersih sesudahnya
- [ ] 8.7 Verifikasi di perangkat Android: aktifkan program, tutup aplikasi, matikan dan nyalakan perangkat, buka kembali dalam mode pesawat — program, status, dan riwayat bertahan
- [ ] 8.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; jalankan uji arsitektur bahwa domain tidak mengimpor Drift; laporkan hasil beserta risiko yang tersisa
