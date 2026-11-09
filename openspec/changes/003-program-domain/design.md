# Design — 003 · Domain program

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 001 menyediakan kerangka proyek, sumber waktu dan pengenal yang di-inject, serta tipe hasil/kegagalan bersama; change 002 menyediakan kebijakan `np-1.0.0` beserta vektor uji emas. Belum ada kode domain program sama sekali.

Batasan yang mengikat dari assessment v1.1:

- `NutritionCalculator` tidak boleh mengetahui Flutter, Drift, repositori, status program, atau kebijakan defisit/surplus (§39).
- `ProgramEngine` deterministik dan murni; nilai yang hilang gagal tertutup dengan `missing_validated_policy` (§39).
- Keduanya harus dapat diuji tanpa Flutter, Drift, atau jaringan (§46.3).
- Lifecycle, invarian satu program berjalan, dan atomisitas pergantian bersifat normatif (§41).
- Tipe enum, value object, dan kegagalan bertipe dipakai alih-alih string ajaib dan pengecualian umum (§48.9).

## Goals / Non-Goals

**Goals**

- Seluruh aturan paling berisiko di produk ini — target energi, penolakan, dan siklus hidup — dapat diuji tanpa basis data dan tanpa widget.
- Vektor uji emas dari change 002 berjalan apa adanya sebagai uji regresi terhadap `ProgramEngine`.
- Satuan tidak dapat tertukar diam-diam.
- Invarian satu program berjalan dirumuskan di domain, sehingga lapisan persistensi hanya perlu menegakkannya, bukan menemukannya.

**Non-Goals**

- Tidak ada tabel, DAO, transaksi basis data, atau repositori konkret — itu change 004.
- Tidak ada layar, provider, atau view model — itu change 005.
- Tidak ada perhitungan progres harian dari buku harian; domain hanya menetapkan bahwa hari jeda tidak dihitung.
- Tidak ada penyesuaian target adaptif.

## Decisions

### D1 — Dua komponen terpisah dengan arah ketergantungan satu arah

`NutritionCalculator` menerima fakta fisiologis (usia, masukan biologis, tinggi, berat, tingkat aktivitas) dan mengembalikan perkiraan energi istirahat, perkiraan energi harian, asumsi, peringatan, serta `calculator_version`. Ia tidak tahu program apa pun.

`ProgramEngine` menerima fakta profil, kode program, masukan khusus program, dan hasil kalkulator, lalu mengembalikan proposal target atau keadaan tidak-disetujui bertipe berikut `policy_version`.

Arahnya satu arah: mesin program memakai kalkulator, tidak sebaliknya. Ini membuat penggantian persamaan energi (`msj-1.0.0` → persamaan lain) tidak menyentuh kebijakan, dan penggantian kebijakan tidak menyentuh persamaan.

*Alternatif:* satu komponen yang mengerjakan keduanya. Ditolak — tepat pencampuran yang dilarang §39, dan membuat uji guardrail harus selalu melewati aritmetika energi.

### D2 — Hasil bertipe tertutup, bukan pengecualian

Hasil kalkulator dan mesin program berupa tipe hasil tertutup dengan lima keadaan yang disebut spec. Pemanggil wajib menangani setiap keadaan; menambah keadaan baru di kemudian hari akan menggagalkan kompilasi di setiap tempat yang belum menanganinya — jaring yang jauh lebih baik daripada pengecualian yang tertangkap entah di mana.

Setiap keadaan tidak-disetujui membawa kode alasan dari daftar tertutup di `nutrition-policy`, bukan kalimat bebas. Pemetaan kode alasan ke kalimat pengguna berada di lapisan presentasi, sehingga domain tetap bebas dari teks UI dan dapat diterjemahkan belakangan.

### D3 — Nilai terbungkus tipe untuk satuan

Energi, massa, panjang, dan tanggal lokal dibungkus tipe tersendiri, bukan `double` telanjang. Dengan begitu kilogram tidak dapat diberikan ke parameter yang mengharapkan kilokalori, dan pembulatan kanonis terjadi di satu tempat.

*Trade-off:* sedikit lebih banyak kode dan konversi di batas. Diterima — satuan tertukar adalah kelas kesalahan yang paling mungkin merusak angka kesehatan dan paling sulit terlihat saat review.

### D4 — Mesin keadaan eksplisit, bukan rangkaian `if`

Perpindahan keadaan dirumuskan sebagai tabel perpindahan yang dapat diuji secara menyeluruh: untuk setiap pasangan (keadaan, perintah) ada tepat satu hasil, sah atau kesalahan bertipe. Uji matriks menjalankan seluruh pasangan, sehingga perpindahan yang terlupakan ketahuan sebagai lubang di tabel, bukan sebagai bug yang muncul berbulan-bulan kemudian.

### D5 — Invarian satu program berjalan dirumuskan di domain, ditegakkan di dua lapis

Domain merumuskan dan menguji invarian; persistensi (change 004) menegakkannya lewat indeks unik parsial dan transaksi. Dua lapis sengaja: domain menangkap kesalahan logika, basis data menangkap keadaan yang mustahil dicapai lewat jalur yang benar — misalnya perintah bersamaan.

*Catatan jujur:* pada MVP 1 yang satu pengguna dan satu perangkat, perintah bersamaan praktis jarang. Lapis kedua tetap dipasang karena ongkosnya kecil dan karena sinkronisasi di MVP 2 akan membuat kasus itu nyata.

### D6 — Aktivasi memverifikasi ulang, tidak memercayai proposal

Proposal yang ditampilkan ke pengguna bisa basi: berat badan berubah, profil disunting, atau tengah malam lewat. Karena itu aktivasi membaca ulang fakta terkini dan memverifikasi bahwa proposal masih sesuai sebelum apa pun ditulis. Bila berbeda, aktivasi dibatalkan dan pengguna diminta meninjau ulang — bukan diam-diam mengaktifkan target yang dihitung dari data lama.

Desain sudah menyiapkan kebutuhan ini: layar `12 · Tinjau target` menyatakan tidak ada program aktif sebelum pengguna menyetujui.

### D7 — Atomisitas pergantian dirumuskan sebagai satu perintah domain

Pergantian program bukan rangkaian "selesaikan lalu buat", melainkan satu perintah dengan satu hasil. Domain menetapkan langkah-langkah dan syarat keutuhannya; change 004 memetakannya ke satu transaksi basis data. Merumuskannya sebagai dua perintah terpisah akan membuat keadaan setengah jadi dapat diwakili — justru yang dilarang §41.4.

### D8 — Jeda dicatat sebagai rentang, bukan penanda tunggal

Jeda disimpan sebagai peristiwa mulai dan peristiwa lanjut, sehingga total hari aktif dapat dihitung ulang kapan saja dari jejak peristiwa. Penanda `paused_at` tunggal akan kehilangan riwayat jeda sebelumnya begitu program dilanjutkan, padahal `05 · Program saya` dan `29 · Riwayat program` menjanjikan perjalanan yang dapat dijelaskan.

### D9 — Program pengguna menyimpan salinan masukan, bukan rujukan ke profil

Target yang disetujui menyimpan salinan nilai yang dipakai saat perhitungan. Merujuk ke profil hidup akan membuat target lama berubah makna setiap kali pengguna menyunting profilnya — bertentangan dengan keputusan change 002 bahwa kebijakan dan pembaruannya tidak pernah mengubah riwayat yang sudah disetujui (design.md change 002, Risks). Ini konsekuensi yang sama dengan alasan meal item menyimpan snapshot gizi (§11).

### D10 — Katalog sebagai data acuan dalam kode domain

Pada change ini katalog adalah data acuan dalam Dart murni, agar domain dapat diuji tanpa basis data. Change 004 memindahkan sumber kebenarannya ke tabel katalog dengan seed idempoten; definisi domain menjadi bentuk yang dibaca setelah dimuat. Kode program tetap sama di kedua tempat.

## Risks / Trade-offs

- **Domain menjadi abstraksi yang tidak pernah dipakai apa adanya** bila change 004 dan 005 ternyata butuh bentuk lain → mitigasi: bentuk masukan dan keluaran diturunkan dari use case di assessment §44 dan dari layar yang sudah ada di `docs/mealora.pen`, bukan dari imajinasi.
- **Kebijakan belum disetujui saat change ini dikerjakan** → mesin tidak dapat diuji pada jalur "disetujui" dengan nilai final. Mitigasi: vektor uji emas change 002 dipakai sebagai sumber; bila nilainya berubah setelah peninjauan, yang berubah hanya berkas data dan kolom hasil vektor, bukan struktur mesin.
- **Uji matriks perpindahan bisa membengkak** menjadi ratusan kasus → mitigasi: dihasilkan dari tabel, bukan ditulis tangan satu per satu.
- **Pemisahan kalkulator dan mesin program terasa berlebihan** bagi implementer berikutnya dan tergoda digabung → mitigasi: uji arsitektur dari change 001 melarang domain mengimpor Flutter/Drift, dan uji khusus memastikan kalkulator tidak mengetahui kode program maupun status.
- **Idempotensi yang terlalu longgar** dapat menyembunyikan kesalahan nyata (perintah kedua yang sebenarnya salah dianggap pengulangan) → mitigasi: idempotensi hanya berlaku ketika maksud perintah identik; perintah berbeda pada keadaan yang sama tetap mengembalikan kesalahan bertipe.

## Migration Plan

Tidak ada data pengguna yang terdampak — belum ada penyimpanan program. Urutan:

1. Value object dan tipe hasil.
2. `NutritionCalculator` beserta uji golden energi.
3. Katalog program sebagai data acuan domain.
4. `ProgramEngine`: kelayakan, kebijakan per program, guardrail, kode alasan.
5. Mesin keadaan siklus hidup beserta uji matriks.
6. Perintah aktivasi dan pergantian sebagai satu kesatuan, diuji terhadap penyimpanan tiruan dalam memori.

Rollback: murni penambahan kode baru; membuang commit tidak berdampak pada pengguna karena belum ada yang memanggilnya.

## Open Questions

Tidak ada pertanyaan yang ditunda. Satu hal yang perlu ditegaskan, bukan ditanyakan: angka kebijakan datang dari change 002 dan bukan keputusan change ini. Bila nilai kebijakan berubah di kemudian hari, perubahan itu masuk ke change 002 sebagai versi baru, dan change ini hanya memperbarui vektor hasil yang diharapkan.
