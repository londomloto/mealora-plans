# Design — 004 · Persistensi program

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 001 menyediakan Drift dengan skema versi 1, harness migrasi, fixture, konvensi record pengguna, dan sumber waktu/pengenal yang di-inject; change 003 menyediakan domain program lengkap dengan kontrak repositori dan perintah siklus hidup yang sudah diuji terhadap penyimpanan tiruan dalam memori.

Bentuk tabel, kolom, dan indeks ditetapkan assessment §42; kewajiban migrasi dan fixture ditetapkan §43; bentuk use case ditetapkan §44. Bagian ini menjelaskan pilihan di antara yang masih terbuka, bukan mengulang isi assessment.

## Goals / Non-Goals

**Goals**

- Apa yang sudah terbukti benar di domain tetap benar setelah melewati penyimpanan dan restart.
- Invarian satu program berjalan ditegakkan basis data, bukan hanya disepakati kode.
- Potret kemajuan dapat dibangun ulang kapan saja tanpa risiko penggandaan.
- Migrasi dari skema versi 1 terbukti aman terhadap seluruh fixture yang diwajibkan.

**Non-Goals**

- Tidak ada antarmuka pengguna, provider, atau view model.
- Tidak ada perhitungan kemajuan dari catatan makanan — tabel buku harian belum ada. Change ini menyiapkan bentuk potretnya dan menetapkan perlakuan "belum diketahui".
- Tidak ada mesin sinkronisasi. Kolom siap-sinkron diisi nilai lokal dan tidak dipakai lebih jauh.
- Tidak ada ekspor, impor, atau pencadangan.

## Decisions

### D1 — Empat tabel sesuai §42, termasuk tabel peristiwa

`programs` (katalog), `user_programs` (pendaftaran), `program_progress` (potret per tanggal), dan `program_events` (jejak siklus hidup). Tabel peristiwa disebut §42 sebagai "disarankan", dan change ini memakainya.

Alasannya bukan kelengkapan, melainkan kebutuhan nyata: `29 · Riwayat program` dan `05 · Program saya` menjanjikan rentang jeda yang dapat dijelaskan, dan domain (change 003, D8) sudah merumuskan jeda sebagai rentang peristiwa. Tanpa tabel ini, riwayat jeda hilang begitu program dilanjutkan, dan §42 menuntut kesetaraan fidelitas itu dibuktikan di tempat lain — yang justru lebih mahal.

### D2 — Katalog sebagai tabel dengan seed idempoten dan pengenal tetap

Pengenal baris katalog ditetapkan sebagai nilai tetap yang ditulis di kode seed, bukan dibangkitkan saat pemasangan. Dengan begitu, baris katalog di dua perangkat punya pengenal yang sama — syarat agar riwayat program dapat bermakna ketika sinkronisasi datang di MVP 2.

Seed dijalankan sebagai penyisipan-atau-perbarui berdasarkan kode program, sehingga menjalankannya berulang kali tidak menggandakan baris. Penarikan program memakai penanda ketersediaan; baris tidak pernah dihapus karena riwayat pengguna menunjuk ke sana (§41.10).

*Alternatif:* katalog tetap sebagai data dalam kode saja tanpa tabel. Ditolak — riwayat perlu menunjuk ke baris yang stabil, dan §42 menetapkan tabelnya.

### D3 — Invarian ditegakkan dua lapis: indeks parsial dan transaksi

Dua indeks unik parsial dipasang: satu untuk baris hidup berstatus `active` per profil, satu untuk baris hidup berstatus `paused` per profil.

Keterbatasan yang perlu dinyatakan terus terang: dua indeks itu **tidak** mencegah satu profil punya satu baris `active` *dan* satu baris `paused` sekaligus — padahal invarian produknya adalah satu program berjalan, apa pun statusnya. §42 menyebut hal ini dan meminta invariannya ditegakkan di transaksi aktivasi, dan sebaiknya lewat trigger SQLite yang diuji.

Keputusan: tegakkan di transaksi **dan** pasang trigger. Trigger adalah satu-satunya lapis yang tetap berlaku ketika penulisan datang dari jalur yang belum terbayang — termasuk, nantinya, dari penerapan perubahan hasil sinkronisasi. Trigger diuji eksplisit dengan penulisan langsung yang melanggar invarian, bukan dianggap benar karena sudah terpasang.

### D4 — Satu perintah domain dipetakan ke satu transaksi

Perintah pergantian dari change 003 adalah satu kesatuan. Di sini ia menjadi satu transaksi Drift yang mencakup seluruh langkah: tandai program lama, tulis tautan dua arah, sisipkan peristiwa, aktifkan program baru, buat potret progres awal. Tidak ada langkah yang dibiarkan di luar transaksi "karena kecil".

Verifikasi ulang fakta profil (change 003, D6) terjadi **di dalam** transaksi yang sama, sebelum penulisan pertama. Membacanya di luar transaksi akan membuka celah antara pembacaan dan penulisan.

### D5 — Potret kemajuan sebagai turunan, dengan kunci unik per tanggal

Sumber kebenaran tetap catatan makanan dan berat badan. Potret kemajuan adalah turunan yang mempercepat tampilan dan membekukan ringkasan historis.

Indeks unik hidup pada pasangan (program pengguna, tanggal lokal) membuat pembangunan ulang menjadi penyisipan-atau-perbarui, bukan penambahan. Ini yang membuat idempotensi bukan sekadar janji di kode: menjalankan pembangunan ulang dua kali secara fisik tidak dapat menghasilkan dua baris.

*Trade-off:* data turunan bisa menyimpang dari sumbernya bila ada jalur penulisan yang lupa memicu pembangunan ulang. Mitigasinya bukan disiplin, melainkan uji yang membandingkan hasil pembangunan ulang penuh dengan nilai tersimpan.

### D6 — "Belum diketahui" disimpan sebagai ketiadaan nilai, bukan nol

Kolom nilai pada potret kemajuan dibuat dapat bernilai kosong. Nol adalah fakta ("hari ini saya tidak makan apa pun"), sedangkan kosong adalah ketiadaan fakta ("saya belum mencatat") — dua hal yang berbeda dan tidak boleh ditampilkan sama. Layar `40 · Hari tanpa catatan` sudah dirancang persis untuk perbedaan ini.

Kolom pencacah, misalnya jumlah waktu makan yang tercatat, tetap bernilai nol karena nol di sana memang fakta yang diketahui.

### D7 — Migrasi versi 1 → 2, maju saja

`schemaVersion` naik satu kali untuk seluruh change ini. Migrasi membuat empat tabel, indeks, trigger, lalu menjalankan seed katalog. Seluruh data lama tidak disentuh.

Penurunan versi dinyatakan tidak didukung dan didokumentasikan, bukan diam-diam dibiarkan gagal. Alasannya sederhana: belum ada rilis publik, dan membangun migrasi mundur yang benar jauh lebih mahal daripada nilainya saat ini.

Fixture mengikuti §43: basis data kosong, pembuatan langsung pada versi 2, basis data versi 1 berisi data, migrasi terputus lalu diulang, data lama yang tidak valid, dan foreign key aktif. Verifikasi pasca-migrasi menjalankan pemeriksaan foreign key dan validasi katalog.

### D8 — Tidak ada pendaftaran otomatis saat migrasi

Migrasi tidak membuat program untuk siapa pun. Pengguna lama mendarat di keadaan "belum ada program" dengan seluruh catatan utuh.

Ini keputusan produk, bukan kemalasan teknis: mendaftarkan seseorang ke program dengan target yang tidak pernah ia tinjau melanggar §41.3 ("Activation requires an approved proposal and explicit confirmation"), dan bertentangan dengan janji di layar `12 · Tinjau target` bahwa tidak ada program aktif sebelum pengguna menyetujui.

### D9 — Repositori menyembunyikan Drift sepenuhnya

Domain hanya melihat kontrak repositori dari change 003. Tipe Drift, kueri, dan transaksi tidak pernah bocor ke atas. Penyaringan record terhapus lunak terjadi di lapisan akses data bersama dari change 001, bukan diulang di setiap kueri.

Catatan implementasi: kolom `input_snapshot_json` menyimpan JSON dengan dua kunci — `inputs` (salinan `ProgramProposalInputs`) dan `proposal` (bagian `ProgramTargetProposal` yang tidak punya kolom diskret sendiri: peringatan, pita toleransi, berat acuan, penanda tampilan, dan persentase makro). Kolom diskret (`daily_energy_target_kcal`, `protein_target_g`, dst.) tetap ada untuk kueri cepat tanpa membongkar JSON (sesuai niat §42); JSON-nya yang membuat `ProgramTargetProposal` dapat dipulihkan utuh untuk riwayat (D10), tanpa menambah kolom di luar yang sudah ditetapkan assessment. `pause_intervals` tidak disimpan sebagai kolom — dipulihkan dari pasangan peristiwa `paused`/`resumed` di `program_events` saat baris dibaca (konsisten dengan D1: tabel peristiwa adalah sumber kebenaran jejak jeda).

### D10 — Kueri riwayat membaca nilai tersimpan, bukan menghitung ulang

Entri riwayat menampilkan masukan, target, asumsi, dan versi dari baris program pengguna apa adanya. Tidak ada perhitungan ulang saat membaca — itulah yang membuat target lama tetap dapat dijelaskan setelah kebijakan berganti versi.

### D11 — `ProgramRepository` menjadi async (Future-based), bukan sinkron

Kontrak `ProgramRepository` dari change 003 sinkron (`UserProgram? findRunning(...)`, dst.), dan seluruh command siklus hidup (`ActivateProgramCommand`, `ChangeProgramCommand`, perintah sederhana) memanggilnya sinkron. Ini dirumuskan sebelum ada implementasi penyimpanan sungguhan.

Koneksi Drift aplikasi ini (`openMealoraConnection`, lewat `drift_flutter`) berjalan di isolate latar belakang pada native dan di web worker pada web (design D3, change 001) — bukan koneksi sinkron dalam proses. Drift DAO di atas koneksi ini SHALL TIDAK dapat diakses sinkron; membangun jalur sinkron terpisah berarti dua akses ke berkas basis data yang sama (berisiko lock/korupsi) dan tidak berjalan di web sama sekali.

Keputusan: ubah `ProgramRepository` dan seluruh pemanggilnya (command change 003, tiruan dalam memori, dan uji yang memanggilnya) menjadi `Future`-based sebelum DAO Drift sungguhan ditulis. Ini bukan perubahan requirement domain — tidak ada SHALL di spec manapun yang menyatakan repositori sinkron — murni detail tipe Dart pada kontrak internal yang belum dipakai UI mana pun.

*Trade-off:* seluruh test change 003 yang memanggil command (program_commands_test.dart, dll.) perlu disesuaikan memakai `async`/`await`, dan tiruan dalam memori (`InMemoryProgramRepository`) perlu membungkus method dengan `Future.value`/`async` meski tidak benar-benar melakukan I/O. Biaya ini dibayar sekali, sebelum DAO Drift ditulis, alih-alih memaksakan penyimpanan sungguhan jadi sinkron atau menambal celah async-dalam-sinkron yang getas.

### D12 — `user_programs.profile_id` tanpa foreign key basis data untuk sekarang

Assessment §42 menetapkan `profile_id TEXT FK NOT NULL`. Tabel `profiles` itu sendiri baru dibuat change 005 (onboarding profil) — dan change 005 menyatakan dirinya **bergantung pada** change ini (butuh `user_programs` untuk aktivasi program). Menulis FK sungguhan di sini berarti change ini balik bergantung pada tabel yang belum ada sampai change 005 selesai — dua arah ketergantungan yang tidak dapat dipenuhi sekaligus dengan urutan change 001→012 yang sudah ditetapkan di proposal 005/007/008.

Keputusan: `profile_id` disimpan sebagai `TEXT` biasa, tanpa `.references()`. Domain (change 003) sudah memperlakukan `profileId` sebagai string buram, bukan entitas yang di-join — tidak ada perilaku domain yang hilang. Keutuhan rujukan ke `profiles` ditegakkan kode (change 005 memverifikasi profil ada sebelum memanggil aktivasi), bukan basis data, sampai migrasi lanjutan di change 005 menambahkan FK constraint sungguhan setelah tabel `profiles` ada. Dicatat sebagai utang teknis eksplisit, sama seperti keterbatasan trigger di D3.

*Trade-off:* basis data tidak menolak baris `user_programs` yang menunjuk `profile_id` tidak valid sampai FK ditambahkan di change 005. Diterima karena satu-satunya pemanggil di MVP 1 adalah kode aplikasi sendiri (tidak ada input eksternal atau sinkronisasi), dan uji domain change 003 sudah menegakkan profil harus ada sebelum aktivasi dipanggil.

Konsekuensi lanjutan untuk fixture migrasi (task 8.2): tabel `profiles`, catatan makanan, makanan buatan sendiri, favorit, dan riwayat berat yang disebut assessment §43 **belum ada di skema versi 1 repo ini** — baru dibuat change 005/007/008, yang semuanya menyatakan bergantung pada change ini. Fixture "basis data versi 1 berisi data" di task 8.2 memakai tabel yang benar-benar ada di v1 (`harness_records`/`harness_record_notes`, `ui_preferences`), bukan profil/makanan/berat; fixture migrasi dengan tabel-tabel itu ditambahkan di migrasi lanjutan change 005/007/008 saat tabelnya sudah ada.

## Risks / Trade-offs

- **Trigger SQLite sulit di-review dan mudah salah** → mitigasi: uji yang menulis langsung ke tabel untuk melanggar invarian, dijalankan sebagai bagian gate; trigger dianggap belum ada sampai uji itu membuktikannya bekerja.
- **Data turunan menyimpang dari sumbernya** → mitigasi: uji perbandingan antara pembangunan ulang penuh dan nilai tersimpan; pembangunan ulang selalu berupa penyisipan-atau-perbarui.
- **Migrasi diuji pada fixture buatan, bukan data pengguna nyata** → mitigasi: fixture dibuat dari alur aplikasi yang sesungguhnya, bukan dari penulisan SQL manual, sehingga bentuknya sama dengan yang akan ditemui di lapangan.
- **Kolom siap-sinkron terisi tetapi tidak terpakai** bisa membuat implementer berikutnya menganggapnya beban mati → mitigasi: uji yang menegaskan keberadaannya di setiap tabel pengguna, seperti pada change 001.
- **Potret progres dibuat sebelum ada sumber datanya** (buku harian belum ada) → risiko bentuknya tidak cocok nanti. Mitigasi: bentuk kolom diambil langsung dari §42 dan dari apa yang ditampilkan layar `05`, `16`, `18`, dan `40`; kolom bebas tambahan disediakan untuk ukuran yang baru muncul kemudian.
- **Zona waktu dan tanggal lokal** mudah salah ditangani saat agregasi → mitigasi: tanggal lokal disimpan sebagai nilai tersendiri saat pencatatan, tidak pernah dihitung ulang dari instan UTC pada waktu baca.

## Migration Plan

1. Naikkan `schemaVersion` dari 1 ke 2 satu kali untuk seluruh change ini.
2. Buat empat tabel, indeks unik parsial, indeks riwayat, dan trigger invarian dalam migrasi yang teruji.
3. Jalankan seed katalog idempoten dengan pengenal tetap untuk empat kode program.
4. Pertahankan seluruh data versi 1 tanpa perubahan; jangan daftarkan profil mana pun ke program.
5. Jalankan verifikasi pasca-migrasi: versi skema, validasi katalog, dan pemeriksaan foreign key.
6. Jalankan seluruh fixture §43 sebagai bagian gate.

Rollback: penurunan versi tidak didukung dan dicatat demikian. Selama belum ada rilis publik, pemulihan dilakukan dengan membuang commit dan memasang ulang aplikasi pada perangkat uji.

## Open Questions

Tidak ada pertanyaan yang ditunda. Satu hal yang sengaja dibiarkan terbuka sampai change buku harian: ukuran kualitas gizi mana saja yang mengisi kolom ukuran tambahan pada potret kemajuan untuk program Makan Sehat. Itu tidak mengubah bentuk tabel, tidak mengubah spec change ini, dan tidak mengubah pemecahan task — kolom tambahannya sudah disediakan.
