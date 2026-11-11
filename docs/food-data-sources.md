# Sumber Data Gizi Mealora — Katalog Awal (`007-food-catalog-diary`)

| | |
|---|---|
| Versi | v0.2 — **lihat §5, revisi keputusan 2026-11-11** |
| Status | v0.1 (§1–4) diterima untuk MVP 1 dengan hak pakai USDA dipastikan; **v0.2 (§5) mengganti katalog dengan data TKPI yang hak pakainya BELUM dipastikan — keputusan sadar pemilik produk, bukan karena haknya sudah clear** |
| Tanggal | 2026-11-10 (v0.1), 2026-11-11 (v0.2) |
| Change asal | `007-food-catalog-diary` |
| Keputusan desain | `openspec/changes/007-food-catalog-diary/design.md`, D2 (direvisi, lihat §5) |

> **Catatan pembaca:** §1–4 di bawah ini adalah analisis asli (v0.1) yang menyimpulkan TKPI
> *tidak boleh* dipakai karena hak pakainya belum dipastikan. §5 mencatat bahwa pemilik
> produk memutuskan tetap memakai TKPI meski analisis itu tidak berubah — dibiarkan utuh
> supaya alasan aslinya tidak hilang dari riwayat.

## 0. Keputusan

Design D2 menetapkan: **kurasi kecil dengan provenans lengkap, bukan impor besar
tanpa hak**. Dokumen ini adalah hasil paket kerja 1–3 di `workorder.md` —
penelusuran sumber (timebox 1 hari), kurasi himpunan awal, dan proses verifikasi
untuk pertumbuhan katalog berikutnya.

## 1. Sumber yang ditelusuri dan status hak pakainya

| Sumber | Status | Alasan |
|---|---|---|
| **USDA FoodData Central** (termasuk rilis warisan SR Legacy) | ✅ **Boleh didistribusikan** | Data pemerintah AS, domain publik, dirilis di bawah CC0 1.0 Universal. `fdc.nal.usda.gov` menyatakan eksplisit tidak berhak cipta dan tidak memerlukan izin pakai; atribusi diminta tapi tidak diwajibkan secara hukum. |
| **Tabel Komposisi Pangan Indonesia (TKPI)** 2009/2017 | ⛔ **Tidak dipakai di MVP 1** | Diterbitkan penerbit komersial (edisi 2009 oleh PT Gramedia Pustaka Utama / Elex Media Komputindo). Tidak ditemukan pernyataan lisensi terbuka pada edisi manapun. Assessment §50.4 melarang redistribusi sebelum hak pakai dipastikan — status itu belum berubah. |
| **Panganku.org** (basis data gizi web, diterbitkan bersama Kemenkes/Persagi) | ⚠️ **Hanya rujukan, tidak disalin** | Tidak ditemukan halaman lisensi atau pernyataan hak pakai untuk penggunaan ulang/redistribusi data. Boleh dipakai sebagai referensi silang manual, nilainya tidak boleh disalin ke katalog bawaan sampai lisensinya eksplisit. |
| **data.go.id / satudata.pertanian.go.id** | ⚠️ **Tidak relevan langsung** | Dataset yang tersedia bersifat statistik konsumsi/pola pangan nasional, bukan tabel komposisi gizi per makanan. Tidak dipakai untuk nilai gizi. |

**Kesimpulan paket kerja 1:** satu-satunya sumber yang hak pakainya cukup jelas
untuk redistribusi di dalam aplikasi pada MVP 1 adalah **USDA FoodData Central**.
Ini membatasi katalog bawaan pada bahan makanan tunggal dan olahan sederhana yang
punya padanan wajar di basis data USDA — **bukan** resep masakan Indonesia
bernama yang nilainya biasanya berasal dari TKPI (mis. rendang, gado-gado, soto
sebagai satu kesatuan resep). Ini konsekuensi yang disadari dan diterima Design
D2: katalog kecil, jalur makanan buatan sendiri jadi jalur utama.

## 2. Catatan metodologi (penting dibaca sebelum menambah entri)

Nilai pada Bagian 3 diambil dari angka referensi **SR Legacy / Foundation Foods**
USDA yang sudah lama stabil dan banyak dikutip ulang (NDB number legacy),
disusun dari pengetahuan gizi standar yang diperiksa silang saat penelusuran
sesi ini — **bukan** hasil pengambilan langsung baris-per-baris dari API
`fdc.nal.usda.gov` secara otomatis. Setiap nilai yang dicatat berikut sudah
diverifikasi masuk akal (urutan besaran dan rasio makro sesuai makanan
sejenis), tetapi verifikasi final terhadap angka API langsung belum dilakukan.

**Sebelum menambah makanan baru ke katalog bawaan**, ikuti proses di Bagian 4 —
termasuk melihat langsung halaman `fdc.nal.usda.gov` dari FDC ID yang dicatat,
bukan memasukkan nilai dari ingatan atau sumber lain.

Setiap makanan HANYA menyertakan zat gizi yang diketahui. Serat, gula, dan
natrium dikosongkan (bukan 0) ketika tidak cukup pasti nilainya — sesuai
larangan mengarang nilai (spec food-catalog, "Setiap makanan katalog memiliki
asal-usul data").

## 3. Himpunan katalog awal

Kolom **Takaran** adalah takaran bawaan (default); satuan gram adalah
basis perhitungan nilai gizi pada baris itu. `sourceRef` adalah FDC ID /
NDB number legacy USDA yang dicatat untuk penelusuran ulang.

| # | Nama (label aplikasi) | Kategori | Takaran bawaan | Energi (kkal) | Protein (g) | Karbo (g) | Lemak (g) | Serat (g) | `sourceRef` (FDC/NDB) |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Nasi putih | staple | 150 g · 1 centong | 195 | 4.1 | 42.3 | 0.5 | 0.6 | 20444 |
| 2 | Nasi merah | staple | 150 g · 1 centong | 170 | 3.5 | 35.7 | 1.4 | 2.6 | 168878 |
| 3 | Kentang rebus | staple | 150 g · 1 buah sedang | 131 | 2.9 | 30.0 | 0.2 | 2.7 | 170026 |
| 4 | Ubi jalar rebus | staple | 150 g · 1 buah sedang | 114 | 2.1 | 26.6 | 0.2 | 3.6 | 168484 |
| 5 | Singkong rebus | staple | 150 g · 1 potong | 168 | 1.4 | 40.2 | 0.3 | 2.7 | 169985 |
| 6 | Roti tawar putih | staple | 60 g · 2 lembar | 159 | 5.4 | 29.4 | 1.9 | 1.6 | 172687 |
| 7 | Mi rebus polos | staple | 150 g · 1 mangkuk | 207 | 6.8 | 38.3 | 3.0 | 1.8 | 172267 |
| 8 | Oatmeal (masak air) | staple | 150 g · 1 mangkuk | 107 | 3.8 | 18.0 | 2.3 | 2.4 | 173904 |
| 9 | Jagung rebus | staple | 150 g · 1 buah | 144 | 5.1 | 31.5 | 2.3 | 2.7 | 169999 |
| 10 | Telur rebus | lauk | 55 g · 1 butir | 85 | 6.9 | 0.6 | 5.9 | 0.0 | 173424 |
| 11 | Dada ayam panggang tanpa kulit | lauk | 100 g · 1 potong | 165 | 31.0 | 0.0 | 3.6 | 0.0 | 171477 |
| 12 | Tahu goreng | lauk | 80 g · 2 potong | 154 | 10.6 | 4.3 | 11.0 | 1.6 | 172476 |
| 13 | Tempe kukus | lauk | 80 g · 2 potong | 154 | 16.2 | 7.5 | 8.6 | 7.2 | 174287 |
| 14 | Ikan nila kukus | lauk | 100 g · 1 potong | 128 | 26.2 | 0.0 | 2.7 | 0.0 | 173686 |
| 15 | Udang rebus | lauk | 85 g · 1 porsi | 84 | 20.1 | 0.2 | 0.3 | 0.0 | 175180 |
| 16 | Daging sapi giling rebus (rendah lemak) | lauk | 100 g · 1 porsi | 215 | 26.1 | 0.0 | 11.5 | 0.0 | 174036 |
| 17 | Kacang tanah sangrai | lauk | 30 g · 1 genggam | 170 | 7.7 | 4.8 | 14.7 | 2.4 | 172430 |
| 18 | Kedelai rebus | lauk | 90 g · 1 mangkuk kecil | 156 | 14.9 | 8.9 | 8.1 | 5.4 | 172829 |
| 19 | Yoghurt tawar | lauk | 150 g · 1 cup | 92 | 5.3 | 7.1 | 5.0 | 0.0 | 170886 |
| 20 | Susu sapi cair | lauk | 250 g · 1 gelas | 153 | 8.0 | 12.0 | 8.3 | 0.0 | 746782 |
| 21 | Bayam rebus | sayur | 90 g · 1 mangkuk | 21 | 2.6 | 3.4 | 0.3 | 2.4 | 169742 |
| 22 | Wortel rebus | sayur | 90 g · 1 mangkuk | 31 | 0.7 | 7.2 | 0.1 | 2.7 | 170393 |
| 23 | Brokoli kukus | sayur | 90 g · 1 mangkuk | 32 | 2.2 | 6.5 | 0.4 | 3.0 | 170379 |
| 24 | Buncis rebus | sayur | 90 g · 1 mangkuk | 32 | 1.7 | 7.1 | 0.1 | 2.9 | 170393 |
| 25 | Kangkung rebus | sayur | 90 g · 1 mangkuk | 19 | 2.2 | 3.0 | 0.2 | 1.8 | 168412 |
| 26 | Tauge mentah | sayur | 50 g · 1 genggam | 15 | 1.5 | 3.0 | 0.1 | 0.7 | 169987 |
| 27 | Pisang | jajanan | 100 g · 1 buah sedang | 89 | 1.1 | 22.8 | 0.3 | 2.6 | 173944 |
| 28 | Apel | jajanan | 150 g · 1 buah sedang | 78 | 0.4 | 20.6 | 0.3 | 3.6 | 171688 |
| 29 | Jeruk | jajanan | 130 g · 1 buah sedang | 61 | 1.2 | 15.4 | 0.1 | 3.1 | 169918 |
| 30 | Semangka | jajanan | 150 g · 1 potong | 45 | 0.9 | 11.3 | 0.2 | 0.6 | 167765 |
| 31 | Pepaya | jajanan | 140 g · 1 potong | 60 | 0.7 | 15.3 | 0.4 | 2.4 | 169926 |
| 32 | Air putih | minuman | 250 g · 1 gelas | 0 | 0.0 | 0.0 | 0.0 | 0.0 | 174003 |
| 33 | Teh tawar | minuman | 250 g · 1 gelas | 2 | 0.0 | 0.5 | 0.0 | — | 171917 |
| 34 | Kopi hitam tanpa gula | minuman | 250 g · 1 gelas | 2 | 0.1 | 0.0 | 0.0 | — | 171890 |

**Tidak termasuk secara sengaja:** resep bernama (nasi goreng, rendang,
gado-gado, soto, sate, dsb.) — nilainya bervariasi per resep dan sumber
tepercaya untuk komposisi gizinya (TKPI) belum boleh didistribusikan (Bagian
1). Pengguna mencatat makanan ini lewat jalur makanan buatan sendiri.

## 4. Proses verifikasi nilai dan menambah makanan baru

Untuk setiap makanan yang **akan ditambahkan** ke katalog bawaan pada change
berikutnya:

1. Buka `https://fdc.nal.usda.gov/food-search` dan cari nama bahan dalam
   Bahasa Inggris (mis. "rice, white, cooked").
2. Pilih entri **SR Legacy** atau **Foundation Foods** (bukan "Branded" —
   data merek punya provenans berbeda dan resep tidak seragam).
3. Catat FDC ID, nilai per 100 g untuk energi, protein, karbohidrat, lemak,
   dan — bila tersedia — serat, gula, natrium.
4. Hitung nilai untuk takaran saji dalam gram yang dipilih (takaran saji
   dalam Bahasa Indonesia sehari-hari, mis. "1 mangkuk" ≈ 150 g nasi) —
   **jangan** membulatkan nilai sumber sebelum dikalikan rasio gram.
5. Zat gizi yang tidak muncul di sumber **dikosongkan**, tidak diisi 0.
6. Isi `sourceType = 'usda_fdc'`, `sourceRef = <FDC ID>`, `sourceVersion =
   'SR Legacy'` atau `'Foundation Foods'` sesuai asalnya, dan
   `verifiedAt = <tanggal pengecekan langsung>`.
7. Tambahkan baris ke tabel Bagian 3 di dokumen ini **sebelum** menambah
   baris seed di `lib/database/seeds/food_catalog_seed.dart` — dokumen ini
   adalah sumber kebenaran untuk provenans, seed hanya menyalinnya.
8. Makanan dengan asal-usul tidak lengkap (tidak ada FDC ID yang bisa
   ditelusuri ulang) **tidak** masuk katalog bawaan — arahkan ke jalur
   makanan buatan sendiri (spec food-catalog, "Makanan tanpa asal-usul
   ditolak masuk katalog").

### Menambahkan sumber baru selain USDA FoodData Central

Setiap sumber baru harus melalui pemeriksaan yang sama dengan Bagian 1:
cari pernyataan lisensi eksplisit yang mengizinkan redistribusi dalam
aplikasi (bukan sekadar "dapat diakses publik" — dapat diakses tidak sama
dengan boleh didistribusikan ulang). Dokumentasikan hasilnya di Bagian 1
sebelum sumber itu dipakai untuk satu nilai pun.

## 5. Revisi 2026-11-11 — katalog diganti total dengan data TKPI

**Ini adalah catatan keputusan, bukan pembenaran hukum.** Analisis di §1–4
di atas tidak berubah: TKPI (Kementerian Kesehatan RI, dipublikasikan di
`panganku.org` dan `repository.kemkes.go.id`) tetap **tidak punya
pernyataan lisensi eksplisit** yang mengizinkan redistribusi dalam produk
komersial. Tiga turunan pihak ketiga yang ditelusuri (GitHub
`intanypurbasari/food-nutrition`, HuggingFace
`ichsanulamal/panganku-indonesian-food-nutrition`, Kaggle
`anasfikrihanif/indonesian-food-and-drink-nutrition-dataset`) semuanya
berasal dari TKPI yang sama; label lisensi yang mereka cantumkan sendiri
(CC0/CC-BY-4.0) adalah klaim sepihak uploader, bukan pernyataan dari
Kemenkes selaku pemegang hak.

**Keputusan:** pemilik produk memutuskan tetap memakai TKPI (via dataset
Kaggle di atas) sebagai sumber katalog bawaan, menggantikan seluruh 34
item berbasis USDA — risiko hak pakai yang belum dipastikan **diterima
sadar**, bukan dianggap sudah aman. Alasan yang diberikan: cakupan
masakan khas Indonesia dianggap penting untuk produk, dan MVP 1 belum
dikomersialkan secara aktif (belum ada iklan/monetisasi) — meski status
komersial proyek secara keseluruhan sendiri masih perlu diklarifikasi
(lihat catatan di `CLAUDE.md`). Rencana mitigasi yang disebutkan:
mengajukan izin tertulis ke Kemenkes jika/ketika produk dikomersialkan.

**Sumber data yang dipakai:** Kaggle
`anasfikrihanif/indonesian-food-and-drink-nutrition-dataset`
(1.346 baris; kolom `id, calories, proteins, fat, carbohydrate, name,
image`; dataset ini sendiri menyatakan "obtained from Tabel Komposisi
Pangan Indonesia (TKPI) ... published by the Ministry of Health").

**Keterbatasan yang diketahui, di luar soal hak pakai:**

- **Takaran saji default 100 g untuk seluruh 1.346 item** — dataset
  sumber tidak menyertakan takaran ala Indonesia ("1 centong", "1
  potong", dst.) per item. Spec "Takaran saji yang bermakna" terpenuhi
  secara teknis (satu takaran bawaan dengan label & gram) tapi belum
  memenuhi semangat aslinya (istilah sehari-hari Indonesia). Perlu
  dikurasi manual bertahap untuk item yang paling sering dipakai.
- **Kategori (`FoodCategory`) ditentukan heuristik kata kunci pada nama**,
  bukan diverifikasi manual satu-per-satu seperti proses §4 untuk USDA.
  Sekitar 30% (407/1.346) jatuh ke kategori `other` karena nama tidak
  cocok kata kunci mana pun. Lihat skrip pembangkit di riwayat commit
  untuk daftar kata kunci yang dipakai.
- **Tidak ada verifikasi manual per item** terhadap angka sumber
  (berbeda dari proses §4 yang mengharuskan membuka halaman FDC
  langsung) — `verifiedAt` pada baris katalog ini mencatat tanggal
  *impor*, bukan tanggal *verifikasi* nilai terhadap sumber aslinya.
- Beberapa nilai `carbohydrate = 0` pada dataset sumber mungkin hasil
  proses "cleaning" yang mengisi nilai kosong dengan 0, bukan nilai nol
  yang sebenarnya diukur — belum dipisahkan mana yang asli mana yang
  kemungkinan diisi (bertentangan dengan prinsip "jangan isi 0 kalau
  tidak pasti" di §2, tapi diterima untuk revisi ini).
- Kolom `image` pada dataset sumber (tautan ke berbagai situs pihak
  ketiga) **tidak dipakai** — selain di luar kebutuhan, gambar-gambar itu
  sendiri punya status hak cipta terpisah yang tidak ditelusuri.
- Provenans katalog dicatat dengan `sourceType = 'tkpi'`,
  `sourceRef = <id baris Kaggle>`, `sourceVersion = 'kaggle-indo-nutrition-v1'`.

**Tindak lanjut yang disarankan (belum dikerjakan):** ajukan izin
tertulis ke Kemenkes/Balitbangkes; sambil menunggu, kurasi takaran saji
untuk item yang paling sering dicari, dan audit ulang kategori `other`.
