# Sumber Data Produk Kemasan Mealora — Penelusuran (`009-packaged-food-barcode`)

| | |
|---|---|
| Versi | v0.1 |
| Status | **Diterima untuk MVP 1** — pencarian daring diaktifkan, dengan kewajiban atribusi dipenuhi |
| Tanggal | 2026-11-11 |
| Change asal | `009-packaged-food-barcode` |
| Keputusan desain | `openspec/changes/009-packaged-food-barcode/design.md`, D2/D3 |

## 0. Keputusan

Pencarian daring produk kemasan **diaktifkan pada rilis pertama**, memakai
**Open Food Facts** sebagai sumber, dengan kewajiban atribusi ODbL dipenuhi di
layar tinjau produk dan halaman legal aplikasi. Keputusan ini dapat dibatalkan
tanpa mengubah satu baris pun jalur luring — Design D2 meletakkan sumber ini
di balik antarmuka klien yang dapat diganti, persis supaya keputusan lisensi
tidak mengikat arsitektur.

Dokumen ini adalah hasil paket kerja 1 di `tasks.md` (task 1.1–1.2): timebox
satu hari untuk menelusuri sumber yang mungkin dipakai dan kewajiban
lisensinya.

## 1. Sumber yang ditelusuri dan status hak pakainya

| Sumber | Barcode? | Status | Alasan |
|---|---|---|---|
| **Open Food Facts** | ✅ Ya — pengenal utama pencarian | ✅ **Dipakai, dengan kewajiban dipenuhi** | Basis data di bawah **ODbL 1.0** (Open Database License): boleh dipakai termasuk komersial, dua syarat — atribusi dan *share-alike*. Gambar produk di bawah lisensi terpisah, **CC BY-SA**. Komunitas global termasuk kontributor Indonesia aktif — satu-satunya sumber di antara yang ditelusuri dengan cakupan barcode produk pasar Indonesia yang memadai untuk fitur ini berguna. |
| **USDA FoodData Central — Branded Foods** (`gtinUpc`) | ✅ Ya — kolom `gtinUpc` pada rilis Branded/Global BFPD | ⚠️ **Dicatat sebagai alternatif, tidak dipakai sebagai sumber utama rilis ini** | Sama seperti katalog change 007: **domain publik, CC0 1.0** — nol kewajiban hukum, atribusi hanya diminta bukan diwajibkan. Tidak dipakai sebagai sumber utama karena cakupan barcode produk Indonesia jauh lebih tipis (himpunan ini didominasi produk pasar AS; cakupan GDSN internasional tidak merata). Tetap dicatat di sini sebagai kandidat bila Open Food Facts suatu saat tidak memenuhi syarat atau cakupannya mengecewakan — klien yang dapat diganti (Design D2) membuat penggantian ini tidak menyentuh layar. |
| **TKPI (Tabel Komposisi Pangan Indonesia)** | ❌ Tidak — tabel komposisi per bahan, bukan basis data produk bermerek | ⛔ **Tidak relevan untuk barcode** | Sama seperti kesimpulan `food-data-sources.md` Bagian 1: tidak ada pernyataan lisensi terbuka, dan sifatnya tabel komposisi bahan tunggal, bukan basis data produk kemasan bermerek dengan barcode. |
| **BPOM (data produk terdaftar)** | ⚠️ Sebagian — nomor registrasi BPOM bukan barcode GS1 | ⛔ **Tidak dipakai** | Tidak ditemukan API/ekspor publik dengan pernyataan lisensi untuk redistribusi nilai gizi per produk terhadap nomor barcode (EAN/UPC) GS1. Nomor registrasi BPOM adalah pengenal berbeda dari barcode kemasan. |

**Kesimpulan paket kerja 1:** Open Food Facts adalah satu-satunya sumber yang
ditelusuri dengan kewajiban lisensi yang jelas **dan** cakupan barcode yang
membuat fitur ini berguna untuk pengguna di Indonesia. Kewajiban ODbL-nya
dapat dipenuhi tanpa membebani jalur luring.

## 2. Kewajiban lisensi Open Food Facts dan cara memenuhinya

### 2.1 Data (ODbL 1.0)

Dua syarat ODbL yang mengikat pemakaian Mealora:

1. **Atribusi** — teks "© Open Food Facts contributors" (atau padanannya)
   SHALL tampil di setiap layar yang menampilkan nilai dari Open Food Facts,
   ditautkan ke halaman kewajiban lisensi proyek, **dan** di halaman
   legal/tentang aplikasi.
2. **Share-alike (berbagi serupa)** — mengikat ketika Mealora **menghasilkan
   basis data turunan** dari Open Food Facts (mis. mengekspor ulang/membagikan
   kembali potongan substansial dari basis datanya). ODbL §4.5 mengecualikan
   **ekstraksi dan pemakaian fakta individual** dalam "jalannya bisnis normal"
   dari definisi "basis data turunan" — inilah yang dilakukan Mealora: satu
   barcode dicari, satu rekaman produk diambil dan dipakai/disimpan di
   perangkat pengguna untuk pemakaiannya sendiri. Mealora **SHALL TIDAK**
   membangun fitur ekspor/pembagian ulang katalog produk kemasan yang
   terkumpul di banyak perangkat pengguna sebagai satu basis data — itu akan
   mengaktifkan kewajiban *share-alike* dan berada di luar cakupan change ini
   dan non-goals design.md ("Tidak ada katalog produk bermerek yang dibundel
   dalam aplikasi").

**Konsekuensi untuk implementasi**: task 4.1–4.2 (klien sumber data) dan
7.1 (layar tinjau produk) SHALL menampilkan atribusi di titik pemakaian
nilai, bukan hanya di halaman tentang aplikasi yang jarang dibuka.

### 2.2 Gambar (CC BY-SA)

Mealora **tidak menampilkan foto produk** pada rilis ini — spec `009` tidak
menyebut gambar sebagai bagian dari layar tinjau produk (`04`), dan jalur
foto label gizi adalah jalur berbeda yang belum tersedia (non-goal). Karena
itu kewajiban atribusi CC BY-SA untuk gambar **tidak berlaku pada rilis
ini** — dicatat di sini agar tidak terlewat bila gambar produk ditambahkan
pada change mendatang; saat itu terjadi, atribusi per gambar (bukan hanya
per layar) menjadi wajib.

### 2.3 Status rekaman komunitas

Open Food Facts adalah basis data yang diisi komunitas: nilai gizi per
produk **tidak diverifikasi produsen** dan dapat salah, tidak lengkap, atau
mengikuti kemasan versi lama (reformulasi). Ini sudah ditangani oleh spec
`009` secara langsung, bukan oleh dokumen ini:

- Jenis sumber (`sourceType = 'openfoodfacts'`) ditampilkan kepada pengguna
  sebelum ia mencatat (requirement "Produk ditinjau sebelum dicatat").
- Koreksi pengguna menang dan bertahan, tidak pernah ditimpa sumber daring
  tanpa persetujuan (requirement "Koreksi pengguna terhadap kemasan di
  tangannya").
- Nilai yang tidak ada pada rekaman tetap belum diketahui, tidak pernah
  dikarang menjadi nol (requirement "Nilai yang tidak diketahui tetap tidak
  diketahui").

Ketiga invarian ini bersama-sama adalah mitigasi untuk risiko "rekaman
komunitas memuat nilai yang salah" (design.md Risks).

### 2.4 Etiket pemakaian API

- Permintaan SHALL menyertakan header `User-Agent` khas aplikasi (mis.
  `Mealora/<versi> (<kontak>)`), bukan nilai bawaan pustaka HTTP — syarat
  etiket Open Food Facts untuk membedakan klien dan menghindari pemblokiran.
- Permintaan SHALL dibatasi satu panggilan per barcode yang tidak ditemukan
  di perangkat (task 4.3) — tidak ada pemanggilan berulang otomatis di
  latar belakang.
- Permintaan SHALL TIDAK menyertakan data pribadi pengguna atau gambar
  (requirement "Kamera dan jaringan dipakai seperlunya", design D3) — hanya
  nomor barcode yang dikirim.

## 3. Kesimpulan: pencarian daring diaktifkan pada rilis pertama

Dengan kewajiban Bagian 2 dipenuhi di implementasi (atribusi pada layar
tinjau produk dan halaman legal, tanpa fitur ekspor basis data, tanpa
gambar), **pencarian daring ke Open Food Facts diaktifkan pada rilis
pertama**. Jalur luring tetap berdiri sendiri sepenuhnya terlepas dari
keputusan ini (design.md D1, D11) — mematikan pencarian daring kelak,
bila lisensi atau kualitas data berubah, tidak mengubah satu baris pun pada
jalur pindai-produk-tersimpan, masukan manual, atau tinjau produk.

## 4. Menambahkan atau mengganti sumber daring di kemudian hari

Mengikuti pola `food-data-sources.md` Bagian 4: setiap sumber pengganti atau
tambahan harus melalui pemeriksaan yang sama dengan Bagian 1 dokumen ini —
cari pernyataan lisensi eksplisit yang mengizinkan pemakaian dalam aplikasi,
periksa kewajiban atribusi/*share-alike* secara spesifik (bukan sekadar
"dapat diakses publik"), dan dokumentasikan hasilnya di sini sebelum sumber
itu dipanggil dari klien sumber data produk (task 4.1).
