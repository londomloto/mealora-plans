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

Ini keputusan produk, bukan kemalasan teknis: mendaftarkan seseorang ke program dengan target yang tidak pernah ia tinjau melanggar §40.3 dan §41.3, dan bertentangan dengan janji di layar `12 · Tinjau target` bahwa tidak ada program aktif sebelum pengguna menyetujui.

### D9 — Repositori menyembunyikan Drift sepenuhnya

Domain hanya melihat kontrak repositori dari change 003. Tipe Drift, kueri, dan transaksi tidak pernah bocor ke atas. Penyaringan record terhapus lunak terjadi di lapisan akses data bersama dari change 001, bukan diulang di setiap kueri.

### D10 — Kueri riwayat membaca nilai tersimpan, bukan menghitung ulang

Entri riwayat menampilkan masukan, target, asumsi, dan versi dari baris program pengguna apa adanya. Tidak ada perhitungan ulang saat membaca — itulah yang membuat target lama tetap dapat dijelaskan setelah kebijakan berganti versi.

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
