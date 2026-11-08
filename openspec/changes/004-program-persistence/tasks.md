## 1. mealora-mobile — Tabel dan skema

- [x] 1.1 Baca ulang assessment §42–§44, spec change 003, dan layar `05`, `16`, `18`, `29`, `30`, `36`, `40` di `docs/mealora.pen` sebelum menulis tabel, agar kolom yang dibuat memang yang ditampilkan
- [x] 1.2 Buat tabel katalog program: kode unik, nama, deskripsi, penanda perlu target berat, penanda ketersediaan, urutan tampil, versi definisi, dan jejak waktu
- [x] 1.3 Buat tabel program pengguna sesuai §42: profil (TEXT tanpa FK sungguhan — Design D12, tabel `profiles` belum ada), program, status, waktu mulai/jeda/berakhir, berat awal, berat tujuan, tanggal tujuan, target energi dan makro, salinan masukan, `calculator_version`, `policy_version`, alasan jeda, alasan selesai, tautan program pendahulu dan pengganti, serta konvensi record pengguna dari change 001
- [x] 1.4 Buat tabel potret kemajuan: program pengguna, tanggal lokal, waktu pencatatan, berat, perubahan berat, rasio kemajuan, energi tercatat, rasio kesesuaian, makro, jumlah waktu makan, penanda kelengkapan buku harian, nomor hari aktif, kolom ukuran tambahan, dan versi perhitungan
- [x] 1.5 Pastikan seluruh kolom nilai pada potret kemajuan dapat bernilai kosong, sehingga "belum diketahui" berbeda dari nol; kolom pencacah tetap wajib terisi
- [x] 1.6 Buat tabel peristiwa siklus hidup: program pengguna, jenis peristiwa, waktu kejadian, status asal, status tujuan, kode alasan, dan data tambahan
- [x] 1.7 Pastikan setiap tabel milik pengguna memakai mixin metadata siap-sinkron dari change 001, dan tambahkan uji yang menegaskannya

## 2. mealora-mobile — Seed, indeks, dan trigger

- [x] 2.1 Tulis seed katalog untuk empat kode program dengan pengenal tetap yang ditulis di kode, bukan dibangkitkan saat pemasangan
- [x] 2.2 Buat seed bersifat penyisipan-atau-perbarui berdasarkan kode program; uji bahwa menjalankannya tiga kali menghasilkan tepat empat baris dengan pengenal yang sama
- [x] 2.3 Buat indeks unik parsial untuk baris hidup berstatus `active` per profil dan baris hidup berstatus `paused` per profil
- [x] 2.4 Buat indeks unik hidup pada pasangan program pengguna dan tanggal lokal di tabel potret kemajuan
- [x] 2.5 Buat indeks pendukung kueri riwayat program menurut waktu
- [x] 2.6 Buat trigger SQLite yang menolak keadaan dengan lebih dari satu program berjalan per profil, termasuk kombinasi satu `active` dan satu `paused` yang tidak tertangkap kedua indeks parsial
- [x] 2.7 Uji trigger dengan penulisan langsung ke tabel yang sengaja melanggar invarian; trigger dianggap belum ada sampai uji ini membuktikannya menolak
- [x] 2.8 Bila trigger tidak dapat diselesaikan dalam timebox satu hari, catat keterbatasannya sebagai utang teknis eksplisit yang wajib ditutup sebelum sinkronisasi MVP 2, dan pastikan transaksi tetap menegakkan invarian — tidak berlaku: trigger selesai dan teruji (task 2.6/2.7)

## 3. mealora-mobile — Repositori program

- [x] 3.0 Ubah `ProgramRepository` (change 003) dan seluruh pemanggilnya — `ActivateProgramCommand`, `ChangeProgramCommand`, perintah siklus hidup sederhana, `InMemoryProgramRepository`, dan test yang memanggil command-command tersebut — menjadi `Future`-based (Design D11), sebelum menulis DAO Drift; pastikan `flutter test` tetap hijau pada langkah ini sebelum lanjut — ditambah `applyActivation` baru pada kontrak (Design D4) supaya aktivasi juga satu transaksi, bukan hanya pergantian
- [x] 3.1 Implementasikan kontrak repositori program (async, Design D11) dari change 003 memakai DAO Drift, tanpa membocorkan tipe Drift ke lapisan atas
- [x] 3.2 Pakai lapisan akses data bersama change 001 untuk menyaring record terhapus lunak secara bawaan; sediakan jalur eksplisit bila record terhapus perlu dibaca
- [x] 3.3 Implementasikan pemetaan antara entitas domain dan baris basis data, termasuk salinan masukan dan kedua versi
- [x] 3.4 Uji: seluruh uji perintah siklus hidup change 003 dijalankan ulang terhadap penyimpanan sungguhan, bukan penyimpanan tiruan

## 4. mealora-mobile — Transaksi aktivasi dan pergantian

- [x] 4.1 Implementasikan transaksi aktivasi: baca ulang fakta profil terkini di dalam transaksi yang sama, verifikasi proposal masih sesuai, lalu tulis program, peristiwa, dan potret kemajuan awal — `ActivateProgramCommand` memverifikasi `previewInputs.matches(currentInputs)` sebelum menyentuh repositori sama sekali (tidak ada fakta profil sungguhan untuk dibaca ulang: tabel `profiles` belum ada, Design D12); `DriftProgramRepository.applyActivation` menulis program, peristiwa, dan potret awal dalam satu transaksi
- [x] 4.2 Implementasikan pembatalan aktivasi ketika fakta berubah sejak pratinjau, tanpa meninggalkan perubahan sebagian — dicek di domain (change 003) sebelum pemanggilan repositori apa pun, sehingga tidak ada penulisan sebagian yang mungkin terjadi
- [x] 4.3 Implementasikan transaksi pergantian: tandai program lama `changed` beserta waktu berakhir, tulis tautan dua arah, sisipkan peristiwa, aktifkan program baru
- [x] 4.4 Uji pergantian dengan kegagalan yang disuntikkan pada setiap langkah; setiap kasus harus mengembalikan keadaan persis seperti sebelum perintah — diuji dua lapis: tiruan dalam memori menguji ketiga titik injeksi (`after_supersede`/`after_new_program`/`after_events`, program_commands_test.dart), penyimpanan sungguhan menguji kegagalan nyata di tengah transaksi aktivasi dan pergantian (drift_program_repository_test.dart)
- [x] 4.5 Uji bahwa catatan makanan dan berat badan tidak berubah nilainya maupun kepemilikannya setelah aktivasi dan pergantian — tidak berlaku untuk change ini: tabel makanan dan berat belum ada (Design D12, dibuat change 007/008 yang bergantung pada change ini); diuji ulang di change tersebut
- [x] 4.6 Uji bahwa perintah aktivasi yang diulang tidak menghasilkan baris program ganda

## 5. mealora-mobile — Perintah siklus hidup lain

- [x] 5.1 Implementasikan jeda dan lanjutkan sebagai penulisan beserta peristiwanya, sehingga seluruh rentang jeda tetap dapat ditelusuri setelah program dilanjutkan
- [x] 5.2 Implementasikan selesaikan dengan alasan dan ringkasan akhir, serta batalkan untuk program yang masih draf
- [x] 5.3 Implementasikan idempotensi perintah berulang: tidak ada peristiwa ganda dan waktu mulai jeda tidak berubah
- [x] 5.4 Uji bahwa perpindahan dari keadaan akhir ditolak di tingkat penyimpanan, bukan hanya di domain — trigger baru `user_programs_terminal_state_is_final` (`program_invariant_trigger.dart`), diuji dengan penulisan langsung yang melewati domain

## 6. mealora-mobile — Potret kemajuan dan riwayat

- [x] 6.1 Implementasikan pembangunan ulang potret kemajuan untuk satu tanggal sebagai penyisipan-atau-perbarui berdasarkan pasangan program pengguna dan tanggal lokal — `DriftProgramRepository.rebuildProgressForDate`; menerima nilai turunan (perubahan berat, rasio kesesuaian) sebagai masukan, bukan menghitungnya sendiri (Non-Goals: perhitungan kemajuan dari buku harian baru datang change 007/008)
- [x] 6.2 Implementasikan penanganan hari jeda: tidak menambah nomor hari aktif dan tidak ikut dalam kesesuaian target, sementara catatan pada hari itu tetap tersimpan — mekanismenya netral terhadap keputusan ini (nomor hari aktif dan rasio kesesuaian adalah parameter pemanggil); diuji dengan mensimulasikan keputusan itu
- [x] 6.3 Implementasikan penanganan nilai belum diketahui: kolom dibiarkan kosong, tidak pernah diisi nol
- [x] 6.4 Pakai tanggal lokal yang tersimpan saat pencatatan; jangan menghitung ulang tanggal dari instan UTC saat membaca
- [x] 6.5 Uji: pembangunan ulang tiga kali menghasilkan satu baris per tanggal dengan nilai yang sama
- [x] 6.6 Uji: menyunting catatan sumber lalu membangun ulang menghasilkan nilai terbaru tanpa menggandakan nilai lama
- [x] 6.7 Uji perbandingan: pembangunan ulang penuh seluruh rentang menghasilkan nilai yang sama dengan potret tersimpan
- [x] 6.8 Implementasikan kueri riwayat program berurutan menurut waktu yang membaca nilai tersimpan apa adanya, tanpa menghitung ulang — `ProgramRepository.history` (kontrak diperluas dari change 003, konsisten dengan `applyActivation`)
- [x] 6.9 Uji: pembaruan katalog, pembaruan kebijakan, dan penyuntingan profil tidak mengubah satu pun nilai pada entri riwayat

## 7. mealora-mobile — Migrasi skema 1 → 2

- [x] 7.1 Naikkan `schemaVersion` dari 1 ke 2 satu kali untuk seluruh change ini
- [x] 7.2 Tulis migrasi yang membuat empat tabel, seluruh indeks, dan trigger, lalu menjalankan seed katalog
- [x] 7.3 Pastikan migrasi tidak menyentuh data versi 1 dan tidak mendaftarkan profil mana pun ke program
- [x] 7.4 Implementasikan verifikasi pasca-migrasi: versi skema benar, katalog valid, dan `PRAGMA foreign_key_check` bersih — `verifyProgramCatalog` ditambahkan dan dipanggil di `openLocalStorage` bersama `verifyMigration`
- [x] 7.5 Implementasikan alur konversi target lama yang memerlukan konfirmasi pengguna, mencatat asal-usul sebagai hasil konversi yang dikonfirmasi, dan menyimpan salinan nilai asli — tidak berlaku untuk change ini: tabel target gizi lama (`nutrition_goals`) belum ada di repo ini (konsisten dengan Design D12 — bukan bagian dari change 001), jadi tidak ada yang dikonversi; alur ini masuk saat change yang menambah tabel tersebut dan memerlukan onboarding profil (change 005)
- [x] 7.6 Dokumentasikan bahwa penurunan versi tidak didukung, di README repo dan di catatan migrasi — README sudah menyatakan aturan umum (change 001); ditambahkan bagian khusus skema versi 2

## 8. mealora-mobile — Fixture migrasi dan gate verifikasi

- [x] 8.1 Siapkan fixture basis data kosong dan fixture pembuatan langsung pada versi 2
- [x] 8.2 Siapkan fixture basis data versi 1 berisi data memakai tabel yang benar-benar ada di v1 repo ini — `harness_records`/`harness_record_notes` dan `ui_preferences` — dibuat lewat alur harness yang sudah ada, bukan penulisan SQL manual (Design D12) — `LegacyV1Database` (test-only, skema dibekukan) dipakai supaya jalur `onUpgrade` v1→v2 sungguhan teruji, bukan sekadar `onCreate` langsung pada v2
- [x] 8.3 Siapkan fixture migrasi terputus dan fixture data lama yang tidak valid — migrasi terputus disiapkan untuk v1→v2 sungguhan; fixture "data lama tidak valid" tidak berlaku (tabel target gizi lama belum ada — sama seperti 7.5, Design D12)
- [x] 8.4 Uji: migrasi atas fixture berisi data mempertahankan seluruh catatan dan tidak mengaktifkan program apa pun
- [x] 8.5 Uji: migrasi terputus tidak merusak data dan selesai pada percobaan berikutnya
- [x] 8.6 Uji: foreign key aktif sepanjang migrasi dan pemeriksaannya bersih sesudahnya
- [ ] 8.7 Verifikasi di perangkat Android: aktifkan program, tutup aplikasi, matikan dan nyalakan perangkat, buka kembali dalam mode pesawat — program, status, dan riwayat bertahan — BELUM DIKERJAKAN: butuh perangkat Android sungguhan (atau emulator sebagai pendekatan lebih lemah, ditawarkan tapi ditolak pengguna untuk sekarang). Juga belum ada UI aktivasi program (baru change 005/006), jadi verifikasi sungguhan baru bisa penuh setelah UI itu ada. Dicatat sebagai follow-up sebelum rilis, bukan diselesaikan di sesi ini.
- [x] 8.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; jalankan uji arsitektur bahwa domain tidak mengimpor Drift; laporkan hasil beserta risiko yang tersisa — `flutter analyze`: bersih; `dart format --set-exit-if-changed .`: bersih; `flutter test`: 218/218 lulus (termasuk `test/unit/architecture/layer_rules_test.dart`, yang menegaskan domain tidak mengimpor Drift). Risiko yang tersisa: (1) task 8.7 belum diverifikasi — perlu perangkat Android sungguhan, tidak dapat dilakukan dari sesi ini; (2) `profile_id` tanpa FK sungguhan sampai change 005 (Design D12); (3) alur konversi target lama (7.5) dan non-interferensi makanan/berat (4.5) tertunda ke change 005/007/008 karena tabelnya belum ada
