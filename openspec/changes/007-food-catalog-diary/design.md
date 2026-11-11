# Design — 007 · Katalog makanan, buku harian, dan dasbor harian

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 001–006 menyediakan kerangka, penyimpanan, kebijakan, domain dan layar program. Ruang Hari ini menampilkan program aktif dengan konsumsi "belum diketahui" karena belum ada sumber datanya.

Bentuk tabel makanan, takaran, nilai gizi, catatan makan, dan butir catatan ditetapkan assessment §11; alasan potret nilai gizi ditetapkan di bagian yang sama; agregasi harian ditetapkan §14; kewajiban provenans ditetapkan §50.4.

## Goals / Non-Goals

**Goals**

- Mencatat makanan terasa cepat dan tidak merepotkan, sepenuhnya luring.
- Angka pada riwayat tidak pernah berubah di belakang pengguna.
- Nilai gizi yang ditampilkan punya asal-usul yang dapat ditelusuri.
- Hari yang belum dicatat tidak pernah tampak seperti hari yang gagal.

**Non-Goals**

- Tidak ada pemantauan berat badan dan riwayat lintas tanggal — itu change tersendiri.
- Tidak ada barcode, label gizi, maupun foto makanan; pintunya ditampilkan sebagai belum tersedia.
- Tidak ada favorit, template makan, duplikasi makanan kemarin, air minum, atau ringkasan mingguan — seluruhnya SHOULD HAVE pada assessment §7 dan menunggu setelah alur inti stabil.
- Tidak ada mikronutrien di luar yang sudah disebut; serat, gula, dan natrium disimpan bila sumbernya menyediakan, tetapi belum ditampilkan sebagai target.

## Decisions

### D1 — Potret nilai gizi disimpan pada butir catatan

Setiap butir catatan menyimpan nama makanan, label takaran, dan nilai gizi per takaran yang dipakai saat pencatatan. Perhitungan menjadi potret dikalikan jumlah takaran.

Ini mengikuti §11 dan alasannya kuat: pembaruan katalog, penyuntingan makanan buatan pengguna, atau penghapusan makanan tidak boleh mengubah total kalori enam bulan lalu. Rujukan ke makanan dan takaran tetap disimpan untuk penelusuran, tetapi bukan sumber nilai saat menampilkan riwayat.

*Trade-off:* data berulang dan ukuran basis data lebih besar. Diterima tanpa ragu — riwayat yang berubah sendiri adalah kegagalan kepercayaan yang tidak bisa diperbaiki dengan permintaan maaf.

### D2 — Sumber data gizi: kurasi kecil dengan provenans, bukan impor besar tanpa hak

Assessment §33 menandai sumber data makanan Indonesia sebagai keputusan terbuka, dan §50.4 melarang redistribusi data TKPI sebelum hak pakainya dipastikan.

Keputusan untuk change ini: katalog bawaan berisi **himpunan kecil yang dikurasi**, setiap makanan dengan provenans lengkap, dan tidak satu pun nilai disalin dari sumber yang hak pakainya belum dipastikan. Lebih baik katalog berisi seratus makanan yang sah daripada dua ribu makanan yang tidak boleh didistribusikan.

Konsekuensi yang diterima: pengguna akan lebih sering memakai makanan buatan sendiri di awal. Karena itu jalur pembuatan makanan sendiri diperlakukan sebagai jalur utama, bukan jalan terakhir — ia muncul pada hasil pencarian kosong dan pada daftar hasil.

Penelusuran hak pakai sumber adalah paket kerja tersendiri di `mealora-plans`, dan hasilnya menentukan seberapa besar katalog bisa tumbuh pada change berikutnya.

**Revisi 2026-11-11:** keputusan "kurasi kecil, bukan impor besar tanpa hak" di atas
**dibatalkan** oleh pemilik produk untuk katalog bawaan — lihat
`mealora-plans/docs/food-data-sources.md` §5. Katalog sekarang memakai data TKPI
(1.346 item, via dataset Kaggle turunan panganku.org) yang hak pakainya **masih belum
dipastikan**, bukan karena analisis di atas berubah kesimpulan. Ini dicatat di sini
supaya pembaca dokumen ini tidak mengira D2 masih berlaku seperti semula.

### D3 — Pencarian memakai pencocokan sederhana lebih dulu

Pencarian memakai pencocokan substring tanpa memperhatikan huruf besar-kecil pada nama makanan, diurutkan dengan mendahulukan kecocokan di awal nama. Tidak ada pencarian fonetik, tidak ada toleransi salah ketik, tidak ada indeks teks penuh.

Alasannya: pada katalog ratusan sampai beberapa ribu makanan, pencocokan sederhana sudah terasa seketika, sementara indeks teks penuh menambah kerumitan migrasi dan perilaku yang sulit dijelaskan ketika hasilnya aneh. Bila katalog tumbuh besar setelah sumber datanya pasti, peningkatan pencarian menjadi change tersendiri dengan tolok ukur yang jelas.

### D4 — "Terakhir dicatat" diturunkan dari buku harian, bukan tabel terpisah

Daftar makanan yang terakhir dicatat dihitung dari catatan makan yang ada, bukan disimpan sebagai tabel riwayat pencarian tersendiri. Ini menghindari dua sumber kebenaran yang bisa berbeda, dan membuat penghapusan catatan otomatis tercermin.

Takaran yang terakhir dipakai untuk makanan itu ikut dibawa, karena itulah yang membuat pencatatan ulang menjadi satu ketukan.

### D5 — Favorit ditunda, meski sudah terlihat di rancangan

Rancangan `13 · Cari makanan` memuat pintasan Favorit. Change ini tidak membangunnya: assessment menempatkan favorit sebagai SHOULD HAVE (§7), dan "terakhir dicatat" sudah menutup sebagian besar kebutuhan yang sama dengan ongkos jauh lebih kecil.

Pintasan itu ditampilkan sebagai belum tersedia, mengikuti aturan yang sama dengan jalur barcode dan foto: pintu yang belum aktif harus terlihat belum aktif, bukan membuka layar yang gagal.

### D6 — Empat waktu makan tetap, bukan dapat diubah pengguna

Sarapan, Makan siang, Camilan, dan Makan malam sesuai §6.7 dan rancangan. Tidak ada waktu makan tambahan atau penamaan ulang pada MVP 1.

### D7 — Agregasi dihitung dari catatan, tidak disimpan ganda

Total harian dihitung dari potret dikalikan jumlah takaran, sesuai §14, dan tidak disimpan sebagai kolom tersendiri pada tabel hari. Satu-satunya nilai agregat yang tersimpan adalah potret kemajuan program dari change 004 — dan itu memang turunan yang dibangun ulang, bukan sumber kebenaran.

Bila pengukuran nanti menunjukkan agregasi terasa lambat pada riwayat panjang, penyimpanan agregat menjadi change tersendiri dengan angka sebagai dasarnya, bukan dugaan.

### D8 — Perubahan catatan memicu pembangunan ulang potret kemajuan

Setiap penambahan, penyuntingan, pemindahan, dan penghapusan catatan memicu pembangunan ulang potret kemajuan untuk tanggal yang terpengaruh. Pemindahan antar waktu makan pada tanggal yang sama tetap memicu pembangunan ulang, karena jumlah waktu makan yang tercatat ikut berubah.

Pembangunan ulang bersifat idempoten (change 004 D5), sehingga memicunya terlalu sering tidak merusak apa pun — jauh lebih aman daripada kurang memicu.

### D9 — Nilai gizi yang tidak diketahui tetap kosong di seluruh rantai

Makanan dengan nilai lemak yang tidak diketahui menghasilkan catatan dengan lemak tidak diketahui, dan total harian yang menyatakan lemak tidak lengkap. Nilai itu tidak pernah diperlakukan sebagai nol di mana pun — tidak di katalog, tidak di potret, tidak di agregasi.

Konsekuensi yang harus ditangani di tampilan: total harian bisa berupa "lengkap untuk energi, tidak lengkap untuk lemak". Dasbor menyatakan ketidaklengkapan itu alih-alih diam-diam menjumlahkan yang ada seolah-olah itu totalnya.

### D10 — Migrasi versi 3 ke 4

`schemaVersion` naik dari 3 ke 4 satu kali: tabel makanan, takaran saji, nilai gizi, catatan makan, dan butir catatan, beserta indeks pencarian dan indeks catatan per tanggal. Data awal katalog ditanam lewat seed idempoten dengan pengenal tetap, mengikuti pola change 004.

Fixture mengikuti pola yang sama: kosong, langsung versi 4, versi 3 berisi data program, dan migrasi terputus.

### D11 — Bahasa dasbor netral terhadap kelebihan konsumsi

Melampaui target disajikan sebagai kelebihan terhadap perkiraan, bukan pelanggaran. Tidak ada warna merah yang berdiri sendiri sebagai penilaian, tidak ada ikon peringatan, tidak ada kalimat yang menyalahkan.

Ini bukan sekadar pilihan nada. Aplikasi pencatat makanan dipakai juga oleh orang dengan hubungan sulit terhadap makanan, dan bahasa yang menghukum adalah risiko nyata — rancangan `18` dan `40` sudah menetapkan arah ini ("tanpa hari yang gagal", "kosong bukan berarti kamu makan nol").

## Risks / Trade-offs

- **Katalog kecil membuat produk terasa kosong di awal** → mitigasi: jalur makanan buatan sendiri diperlakukan sebagai jalur utama; "terakhir dicatat" membuat pengulangan murah; penelusuran hak pakai sumber dijadwalkan sebagai paket kerja agar katalog bisa tumbuh.
- **Hak pakai sumber data tidak kunjung pasti** → katalog tetap kecil lebih lama. Mitigasi: spec tidak mengikat ke sumber tertentu — yang diwajibkan adalah adanya provenans, sehingga penambahan sumber baru tidak mengubah requirement.
- **Potret nilai gizi membesarkan basis data** → mitigasi: hanya nilai yang ditampilkan yang dipotret; pengukuran ukuran basis data dilakukan pada data uji realistis sebelum change ditutup.
- **Pencarian sederhana terasa kurang pintar** (salah ketik tidak dimaafkan) → mitigasi: diterima untuk MVP; peningkatan menjadi change tersendiri dengan tolok ukur, bukan ditambal diam-diam.
- **Nilai tidak diketahui merembet ke total** dan membuat dasbor sulit dibaca → mitigasi: pernyataan ketidaklengkapan per zat gizi, diuji dengan makanan yang sengaja tidak lengkap.
- **Pembangunan ulang potret kemajuan dipicu terlalu sering** → mitigasi: idempoten dan murah; bila terasa lambat, penundaan terjadwal menjadi perbaikan berikutnya dengan pengukuran.

## Migration Plan

1. Naikkan `schemaVersion` dari 3 ke 4 satu kali untuk change ini.
2. Buat tabel makanan, takaran saji, nilai gizi, catatan makan, dan butir catatan beserta indeksnya.
3. Jalankan seed katalog bawaan dengan pengenal tetap dan provenans lengkap, idempoten.
4. Pertahankan seluruh data versi 3 tanpa perubahan.
5. Jalankan verifikasi pasca-migrasi: versi skema, validasi katalog, dan pemeriksaan foreign key.
6. Jalankan fixture: kosong, langsung versi 4, versi 3 berisi program, dan migrasi terputus.

Rollback: penurunan versi tidak didukung, konsisten dengan change sebelumnya.

## Open Questions

Satu pertanyaan yang memang dapat ditunda tanpa mengubah spec, rancangan, atau pemecahan task: **sumber data gizi mana saja yang hak pakainya memungkinkan redistribusi dalam aplikasi**. Penelusurannya adalah paket kerja di `mealora-plans` pada change ini, dan hasilnya menentukan seberapa besar katalog tumbuh — bukan bagaimana katalog bekerja. Requirement sudah ditulis agar tidak terikat pada sumber tertentu: yang diwajibkan adalah provenans, bukan nama sumbernya.
