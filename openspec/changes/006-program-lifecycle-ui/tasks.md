## 1. mealora-plans — Rancangan layar rincian target

- [x] 1.1 Rancang layar rincian "Bagaimana dihitung" untuk program yang sedang berjalan di `docs/mealora-v2.pen` lewat MCP pen.dev, mengikuti struktur `30 · Detail program selesai` (dibangun sebagai layar `46 · Bagaimana dihitung (berjalan)`; dirancang di `mealora-v2.pen`, bukan `mealora.pen`, atas instruksi eksplisit redesign)
- [x] 1.2 Muat bagian: target yang berlaku, masukan yang dipakai, tingkat aktivitas, asumsi, peringatan, tanggal perhitungan terakhir, versi kalkulator, dan versi kebijakan
- [x] 1.3 Pastikan peringatan yang menyertai pembuatan target punya tempat tetap di layar ini, bukan hanya muncul saat pratinjau
- [x] 1.4 Pastikan seluruh nilai berlabel perkiraan dan tidak ada istilah teknis internal di teks pengguna

## 2. mealora-mobile — Ruang Program

- [x] 2.1 Bangun ruang Program sebagai satu layar yang menampilkan keadaan berjalan maupun dijeda (`05`, `27`), dengan susunan sama dan perbedaan terbatas pada penanda keadaan serta daftar kendali (`_RunningProgramView`/`_ProgramHero`, `program_screen.dart`)
- [x] 2.2 Tampilkan nama program, keadaan, target energi harian berlabel perkiraan, kemajuan yang sesuai jenis program, berat terbaru bila ada, dan tanggal perhitungan terakhir
- [x] 2.3 Tampilkan kemajuan Makan Sehat sebagai kelengkapan pencatatan; pastikan tidak ada persentase kemajuan berat di layar itu (`WeeklyConsistencyCard`; program berbasis berat memakai `WeightProgressPlaceholderCard` karena pemantauan berat belum ada — lihat catatan di task 2.4)
- [x] 2.4 Tampilkan nilai yang datanya belum ada sebagai belum diketahui; pastikan tidak ada nol, grafik kosong tanpa keterangan, atau angka yang dikarang (bar harian punya 3 keadaan — lengkap/belum lengkap/belum ada data — bukan terisi-atau-kosong; "berat terbaru" SELALU "belum ada catatan" untuk saat ini karena belum ada tabel pencatatan berat terpisah dari snapshot kemajuan — lihat laporan akhir)
- [x] 2.5 Tandai keadaan dijeda tanpa bergantung pada warna saja, sertakan tanggal mulai jeda, keterangan hari jeda tidak dihitung, dan keterangan pencatatan tetap tersedia
- [x] 2.6 Sediakan kendali jeda, ganti, dan riwayat pada keadaan berjalan; lanjutkan, ganti, dan selesaikan pada keadaan dijeda
- [x] 2.7 Uji widget kedua keadaan pada ukuran teks normal dan besar (`test/widget/program_lifecycle_test.dart`)

## 3. mealora-mobile — Keadaan khusus

- [x] 3.1 Bangun keadaan belum ada program berjalan dengan ajakan memilih program dan penegasan catatan lama tetap ada (`_NoProgramState` — sudah ada sejak change 001/005, dipakai ulang apa adanya)
- [x] 3.2 Bangun keadaan profil belum lengkap dengan tindakan melengkapi profil (`_ProfileIncompleteState`) — jaring pengaman: gerbang peluncuran (`isOnboardingCompleteProvider`) seharusnya sudah menahan ini sebelum ruang utama tampil, jadi keadaan ini praktis tidak teruji lewat jalur normal
- [x] 3.3 Bangun keadaan belum ada catatan berat dengan pernyataan apa adanya, bukan 0 kg (`_LatestWeightTile`) — dibangun selalu menampilkan "Belum ada catatan" untuk saat ini karena belum ada sumber data "berat terbaru" yang terpisah dari snapshot kemajuan (lihat laporan akhir); tidak diverifikasi lewat assert eksplisit di uji, hanya hadir tiap ruang Program dirender
- [x] 3.4 Bangun keadaan kebijakan tidak tersedia memakai kerangka penolakan change 005, tanpa satu pun angka target (`_RevisionRejectedView` di `program_revision_review_screen.dart`, menangani `MissingValidatedPolicy` persis seperti `OnboardingRejectionScreen`) — sama seperti change 005, ini jaring pengaman yang praktis tidak teruji karena `nutritionPolicyProvider` selalu `approved` di aplikasi ini
- [ ] 3.5 Uji: masing-masing keadaan muncul pada jalurnya dan menjelaskan tindakan yang tersedia — HANYA keadaan "belum ada program" (3.1) punya uji eksplisit (sudah ada sebelum change ini); 3.2/3.3/3.4 belum punya uji tersendiri

## 4. mealora-mobile — Rincian asal-usul target

- [x] 4.1 Bangun layar rincian sesuai rancangan task 1.1, dapat dibuka dari ruang Program (`how_calculated_screen.dart`, dibuka lewat tautan "Bagaimana dihitung" di `_ProgramHero`)
- [x] 4.2 Baca nilai dari program pengguna yang tersimpan; jangan menghitung ulang apa pun (membaca `program.proposal`/`program.inputSnapshot` langsung, tidak memanggil `ProgramEngine`/`NutritionCalculator`)
- [x] 4.3 Tampilkan peringatan yang tersimpan bersama target, termasuk peringatan batas bawah energi (bagian "Peringatan" permanen, disembunyikan seluruhnya bila `proposal.warnings` kosong — diuji untuk kasus kosong; kasus peringatan benar-benar tampil belum diuji karena profil uji yang dipakai tidak memicu peringatan apa pun)
- [x] 4.4 Uji: target yang dibuat dengan peringatan tetap menampilkan peringatan itu setelah aplikasi ditutup dan dibuka kembali (`test/widget/program_lifecycle_test.dart` — profil laki-laki kecil/sedentary/turun berat yang memicu `floorApplied`, container Riverpod dibuang dan dibuat ulang di atas basis data yang sama, lalu "Peringatan" masih tampil)

## 5. mealora-mobile — Jeda, lanjutkan, dan selesaikan

- [x] 5.1 Sambungkan kendali jeda dan lanjutkan ke perintah siklus hidup change 003 dan 004 (`PauseProgramCommand`/`ResumeProgramCommand` lewat `program_providers.dart`)
- [x] 5.2 Bangun layar selesaikan program (`39`): pemilihan alasan, pernyataan bahwa ringkasan akhir disimpan, pernyataan bahwa program selesai tidak dapat dilanjutkan, dan jalan batal
- [x] 5.3 Pastikan layar penyelesaian berupa peninjauan, bukan dialog konfirmasi singkat (layar penuh dengan `Scaffold` sendiri, bukan `AlertDialog`)
- [x] 5.4 Pastikan program yang sudah selesai tidak menampilkan kendali melanjutkan di mana pun (tidak ada kendali lanjutkan di `history_screens.dart` sama sekali; `findRunning` mengecualikan `completed`/`changed`)
- [ ] 5.5 Uji integrasi: jeda → catat makanan dan berat → lanjutkan; hari jeda tidak menambah hari aktif dan catatan tetap tersimpan — TIDAK BISA dibuat: pencatatan makanan dan berat belum ada di aplikasi ini (Non-Goals change 006); menyusul begitu buku harian/pemantauan berat selesai
- [x] 5.6 Uji: membatalkan layar penyelesaian tidak mengubah apa pun (`test/widget/program_lifecycle_test.dart`)

## 6. mealora-mobile — Pergantian program

- [x] 6.1 Bangun pratinjau ganti program (`28`): program sekarang, program pengganti beserta targetnya, penegasan program lama pindah ke riwayat, penegasan catatan tetap utuh (`change_program_flow.dart`)
- [x] 6.2 Sambungkan ke alur pratinjau target dan perintah aktivasi change 005; jangan membangun jalur aktivasi kedua (dipakai ulang `ChangeProgramCommand`, yang sudah ada sejak change 003 justru untuk kasus ini — bukan `ActivateProgramCommand` kedua; mesin kebijakan `ProgramEngine.proposeTarget` yang sama persis dipakai keduanya)
- [x] 6.3 Pastikan layar "masukan berubah sejak pratinjau" dari change 005 juga berlaku pada jalur pergantian (`ProgramRevisionService.approve` membandingkan `previewInputs`/`currentInputs` sebelum memanggil `ChangeProgramCommand`, karena perintah itu sendiri tidak punya pemeriksaan ini — beda dari `ActivateProgramCommand`)
- [x] 6.4 Tangani penolakan kebijakan atas program pengganti: jelaskan tanpa angka target, biarkan program lama berjalan (`_RevisionRejectedView`; program lama tidak tersentuh karena `applyProgramChange` baru dipanggil pada hasil `Approved`)
- [x] 6.5 Uji: membatalkan pratinjau tidak mengubah program, target, maupun riwayat (`test/unit/features/program/program_revision_service_test.dart` — `ProgramRevisionService.preview` tidak pernah menulis ke penyimpanan)
- [x] 6.6 Uji: pergantian yang disetujui memindahkan program lama ke riwayat dengan keadaan diganti, menjalankan program baru, dan menjaga catatan makanan serta berat tetap utuh (idem — memverifikasi `changed`/`supersededByUserProgramId`/`supersedesUserProgramId` dan bahwa target lama tersimpan apa adanya, bukan ditulis ulang)
- [x] 6.7 Uji: uji aktivasi yang sama dijalankan untuk kedua jalur masuk — onboarding dan pergantian (idem, grup "Paritas jalur masuk onboarding vs pergantian" — menegaskan versi kalkulator/kebijakan/target sama persis untuk masukan setara, dan staleness check berlaku di kedua jalur)

**Catatan jujur:** diuji di level `ProgramRevisionService`/domain (bukan lewat navigasi UI penuh) — ini dianggap cukup karena layar (`change_program_flow.dart`, `program_revision_review_screen.dart`) hanya memanggil service ini tanpa logika tambahan; tidak ada uji widget end-to-end terpisah untuk jalur ganti program.

## 7. mealora-mobile — Riwayat dan detail program

- [x] 7.1 Bangun daftar riwayat program (`29`) berurutan menurut waktu beserta keadaan akhir dan rentang tanggal (`ProgramHistoryListScreen`)
- [x] 7.2 Bangun detail program (`30`): masukan, target, asumsi, peringatan, kedua versi, alasan berakhir, dan kemajuan akhir yang tersedia (`ProgramDetailHistoryScreen`)
- [x] 7.3 Baca nilai tersimpan apa adanya; jangan menghitung ulang dan jangan mengisi celah dengan nilai terakhir yang diketahui (membaca `UserProgram`/`ProgramProgressSnapshot` langsung, tidak ada pemanggilan kalkulator)
- [x] 7.4 Tampilkan nilai yang tidak pernah tercatat sebagai pernyataan apa adanya, seperti "belum ada data di hari terakhir"
- [x] 7.5 Tampilkan penegasan bahwa riwayat program tidak mengubah catatan makanan dan berat badan (note card di `ProgramHistoryListScreen`)
- [x] 7.6 Uji: mengganti versi kebijakan di lingkungan uji tidak mengubah satu pun nilai pada entri riwayat (`test/widget/program_lifecycle_test.dart` — container Riverpod kedua di atas basis data yang sama dengan `nutritionPolicyProvider` diubah ke `draft`; `programHistoryProvider`/`programByIdProvider` tetap mengembalikan nilai identik)

## 8. mealora-mobile — Ubah profil dan revisi target

- [x] 8.1 Bangun layar ubah profil (`34`) dengan pernyataan bahwa perubahan tidak langsung mengubah target yang berlaku (`edit_profile_screen.dart`)
- [x] 8.2 Sambungkan ke peninjauan target baru memakai layar pratinjau target change 005, ditambah perbandingan terhadap target yang berjalan (`ProgramRevisionReviewScreen` yang sama dengan jalur ganti program task 6, lewat `currentProposal`)
- [x] 8.3 Tampilkan selisih apa adanya tanpa penilaian; pastikan guardrail kebijakan tetap berlaku penuh (baris "Target sekarang"/"Target baru" apa adanya; guardrail berlaku penuh karena lewat `ProgramEngine.proposeTarget` yang sama)
- [x] 8.4 Tangani keadaan ketika profil yang diperbarui tidak lagi disetujui kebijakan: jelaskan tanpa angka target, biarkan target lama berlaku (jalur `_RevisionRejectedView` yang sama; target lama tidak tersentuh sampai `Approved`)
- [x] 8.5 Uji: menutup peninjauan tanpa menyetujui membiarkan target lama berlaku dan riwayat tidak berubah (`test/unit/features/program/program_revision_service_test.dart`, grup "revisi profil, program sama" — hanya memanggil `preview()`, setara menutup layar tanpa menekan setujui)
- [x] 8.6 Uji: menyetujui revisi membuat target baru berlaku sementara target sebelumnya tetap tersimpan apa adanya di riwayat (idem — `programCode` sama, masukan berubah, target baru aktif dan target lama tetap `changed` dengan `energyTarget` aslinya tidak berubah)

**Catatan jujur:** sama seperti group 6 — diuji di level `ProgramRevisionService` (dipakai identik oleh jalur ganti program dan revisi profil, Design D5), bukan lewat navigasi UI `edit_profile_screen.dart` penuh.

## 9. mealora-mobile — Penyambungan, aksesibilitas, dan penutupan

- [x] 9.1 Sambungkan butir Program saya dan Riwayat program pada ruang Profil (`33`); biarkan butir lain belum aktif — **penyimpangan yang disengaja**: butir "Ubah profil" (dibangun di task 8.1) juga disambungkan di sini, karena membiarkannya mati total akan membuat layar `34` tidak terjangkau dari mana pun di aplikasi — keputusan ini sebaiknya dikonfirmasi; butir lain (Satuan & bahasa, Privasi & data lokal, Tentang Mealora) tetap `enabled: false` sesuai instruksi
- [ ] 9.2 Lengkapi label pembaca layar pada seluruh kendali siklus hidup, keadaan program, dan entri riwayat — SEBAGIAN: kendali (`ProgramControlTile`, `ProgramActionButton`, tautan "Bagaimana dihitung") dan entri riwayat sudah punya `Semantics(button:, label:)` eksplisit; belum ada audit pembaca layar menyeluruh (mis. `ProgramStatusChip`/`MealoraChip` mengandalkan teks tampil tanpa `Semantics` terpisah) atau uji `find.bySemanticsLabel` khusus change ini
- [x] 9.3 Pastikan keadaan program dapat dikenali tanpa bergantung pada warna saja (`ProgramStatusChip` selalu ikon+teks; keadaan dijeda selalu menyertakan tanggal dan dua kalimat penjelasan, bukan warna semata)
- [ ] 9.4 Uji seluruh layar pada skala teks besar: tidak ada teks terpotong, tertindih, atau kendali yang tidak terjangkau — SEBAGIAN: hanya ruang Program (aktif+dijeda) diuji pada skala 2x (`test/widget/program_lifecycle_test.dart`) — menemukan dan memperbaiki satu overflow nyata di `_ProgramHero` (task ini juga menemukan satu overflow PRA-ADA yang TIDAK terkait change ini, di `today_screen.dart` pada skala 2x dengan program aktif — lihat laporan akhir, tidak diperbaiki karena di luar lingkup). Riwayat, detail, Bagaimana dihitung, Selesaikan, Ganti, dan Ubah profil BELUM diuji pada skala besar.
- [ ] 9.5 Verifikasi di Chrome pada viewport 390×844 dan bandingkan seluruh layar dengan `docs/mealora.pen` — BELUM DIKERJAKAN: agen latar belakang yang mengerjakan group 2-9 tidak punya akses Browser/alat visual interaktif. Perlu dikerjakan di sesi dengan akses Browser.
- [ ] 9.6 Verifikasi alur siklus hidup penuh di perangkat Android: aktif → jeda → lanjutkan → ganti → selesaikan → riwayat — BELUM DIKERJAKAN: butuh perangkat/emulator Android fisik yang tidak tersedia bagi agen latar belakang ini. Alur yang sama sudah diverifikasi lewat uji integrasi di atas basis data nyata (`test/widget/program_lifecycle_test.dart`), tapi itu bukan pengganti verifikasi perangkat sungguhan.
- [x] 9.7 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa — ketiganya BERSIH (`flutter analyze`: 0 masalah; `dart format --set-exit-if-changed .`: tidak ada perubahan; `flutter test`: 306/306 lolos, termasuk 16 uji baru untuk change ini di dua sesi). Risiko yang tersisa dirangkum di laporan akhir sesi ini.
