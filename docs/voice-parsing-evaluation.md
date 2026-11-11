# Evaluasi penguraian kalimat — change 012

Protokol ini menguji langkah kedua jalur suara (design D1): **teks → daftar makanan beserta jumlah dan satuan**. Pengenalan ucapan tidak diuji di sini; ia diverifikasi di perangkat (task 8.6).

Ambang kelulusan di bawah ditetapkan **sebelum** evaluasi dijalankan, dan tidak boleh diubah setelah melihat hasil. Bila ambang perlu diubah, ubah dokumen ini lewat commit tersendiri yang menyebut alasannya, lalu jalankan ulang seluruh himpunan.

## Himpunan uji

Berkas: [`voice-parsing-eval-set.jsonl`](voice-parsing-eval-set.jsonl) — satu kalimat per baris, 68 kalimat.

| Kategori | Kode | Jumlah | Yang diuji |
|---|---|---|---|
| Satu makanan | `single` | 8 | Bentuk dasar, termasuk gram dan setengah porsi |
| Beberapa makanan | `multi` | 14 | Pemisahan makanan dalam satu kalimat |
| Hidangan majemuk | `compound` | 10 | "nasi goreng", "soto ayam" tidak dipecah |
| Jumlah tidak disebut | `missing_qty` | 8 | Jumlah dibiarkan kosong, tidak ditebak |
| Satuan tidak baku | `nonstandard_unit` | 8 | "sepotong besar", "segenggam" ditandai |
| Bahasa lisan | `colloquial` | 6 | Kata pengisi, koreksi diri, negasi, ragam santai |
| Di luar cakupan | `out_of_scope` | 8 | Permintaan bukan makanan, termasuk injeksi perintah |
| Bercampur | `mixed` | 6 | Hanya bagian makanan yang diurai |

### Kunci jawaban

Setiap baris memuat:

- `text` — masukan persis yang dikirim.
- `in_scope` — `false` bila kalimat tidak mengandung makanan sama sekali.
- `items[]` — makanan yang benar: `name`, `qty` (angka, atau `null` bila tidak disebut), `unit` (atau `null`), dan `unit_status`:
  - `standard` — satuan dalam daftar baku di bawah.
  - `nonstandard` — satuan disebut tetapi tidak baku; harus ditandai perlu ditetapkan.
  - `missing` — satuan tidak disebut.
- `ignored` / `redirect` — maksud di luar pencatatan makanan yang harus diabaikan (informasi untuk penilai, bukan keluaran model).
- `note` — alasan kunci jawaban pada kasus yang bisa diperdebatkan.

**Satuan baku:** piring, mangkuk, porsi, potong, buah, butir, biji, lembar, tusuk, ekor, gelas, cangkir, cup, bungkus, centong, sendok makan, sendok teh, gram, ml. Ubahan ukuran ("besar", "kecil", "penuh", "jumbo") menjadikan satuan tidak baku.

## Cara menjalankan

1. Pakai penyedia, model, dan proksi yang sama dengan change 010 / 011, lewat jalur proksi sebenarnya (bukan panggilan langsung dari laptop), agar batas permintaan dan biaya ikut teruji.
2. Pakai perintah dan skema keluaran yang akan dipakai aplikasi (task 5.3). Satu kalimat = satu permintaan, tanpa riwayat percakapan.
3. Suhu sampling 0 bila penyedia mendukung. Jalankan seluruh himpunan **satu kali**, dengan jeda 4 detik antar kalimat. Panggilan yang gagal karena penyedia (5xx, waktu tunggu) diulang sekali setelah 30 detik; jumlah pengulangan dicatat di laporan.
   *Perubahan 2026-11-11, sebelum hasil sah mana pun dinilai:* semula tiga putaran dengan nilai terburuk. Diturunkan menjadi satu putaran karena kuota Gemini akun proyek habis pada percobaan pertama (lihat `eval-runs/voice-parsing/2026-11-11/aborted-quota/`). Ambang kelulusan tidak berubah. Konsekuensinya: variasi antar-putaran tidak terukur, dan itu disebut sebagai risiko di laporan.
4. Simpan keluaran mentah setiap permintaan, apa adanya, di `docs/eval-runs/voice-parsing/<tanggal>/` beserta token masuk/keluar dan latensi.

## Pencocokan

- **Nama makanan** cocok bila sama setelah normalisasi: huruf kecil, spasi dirapikan, sinonim lisan dipetakan ("sambel" → "sambal", "gw"/"aku" diabaikan). Sinonim yang dipakai dicatat di laporan; menambah sinonim setelah melihat hasil tidak diperbolehkan.
- Untuk catatan `C09` (nasi padang), kedua bentuk yang disebut di `note` diterima.
- **Jumlah** cocok bila sama persis secara numerik ("setengah" = 0,5). `null` hanya cocok dengan `null`.
- **Satuan** cocok bila sama setelah normalisasi; untuk `nonstandard`, cukup model menandainya tidak baku (bentuk teksnya tidak dinilai).

## Metrik dan ambang kelulusan

| # | Metrik | Cakupan | Ambang |
|---|---|---|---|
| M1 | F1 pemisahan makanan (nama) | semua kalimat `in_scope` | ≥ 0,90 |
| M2 | Hidangan majemuk tidak dipecah | `compound` | ≥ 9 dari 10 |
| M3 | Jumlah dan satuan tepat, pada makanan yang cocok | `single`, `multi`, `compound`, `colloquial`, `mixed` | ≥ 0,90 |
| M4 | **Jumlah tidak dikarang** — `qty` yang kuncinya `null` dikembalikan `null` | semua kalimat | **100%** |
| M5 | Satuan tidak baku ditandai | `nonstandard_unit`, plus item `nonstandard` di kategori lain | ≥ 0,85 |
| M6 | **Tidak ada item dari kalimat di luar cakupan** | `out_of_scope` | **100%** |
| M7 | Bercampur: tidak ada item yang berasal dari bagian bukan makanan | `mixed` | **100%** |
| M8 | Keluaran valid terhadap skema (dapat diparse) | permintaan yang menerima keluaran dari penyedia | ≥ 99% |

*Perubahan 2026-11-11 (keputusan pemilik produk, setelah percobaan 2):* M8 semula dihitung atas semua permintaan. Kini hanya atas permintaan yang menerima keluaran, karena M8 mengukur kepatuhan skema, bukan ketersediaan penyedia; kegagalan penyedia (5xx, waktu tunggu) dicatat terpisah dan ditangani cadangan di perangkat (design D14).

M4, M6, dan M7 bersifat mutlak karena menyentuh aturan spec yang tidak boleh dilanggar: jumlah tidak ditebak (D5), dan jalur suara tidak menjalankan apa pun selain pencatatan makanan (D11). Satu kegagalan pada salah satunya berarti **tidak lulus**, berapa pun metrik lain.

### Dicatat, tidak menentukan kelulusan

- Berapa kali keluaran model memuat angka gizi. Angka itu akan dibuang aplikasi (task 5.4), tetapi frekuensinya menunjukkan seberapa patuh perintahnya.
- Latensi p50 / p95 per kalimat lewat proksi.
- Token masuk / keluar rata-rata dan biaya per kalimat (lihat bagian berikut).

## Kuota dan biaya

Angka kuota dan harga **diambil dari akun proyek yang sebenarnya** (dasbor penagihan / pemakaian penyedia, pada hari evaluasi), bukan dari dokumentasi publik atau sumber pihak ketiga. Catat:

- Token rata-rata per kalimat dan biaya per kalimat pada tarif akun.
- Apakah pemakaian masuk kuota gratis akun, dan sisa kuota sebelum/sesudah evaluasi.
- Perkiraan biaya bulanan pada 3 kalimat per pengguna per hari, untuk 100 dan 1.000 pengguna aktif — sebagai ilustrasi, bukan janji.

## Laporan hasil

Tambahkan bagian **Hasil** di bawah dokumen ini setelah evaluasi, memuat:

- Tanggal uji, penyedia, versi model, wilayah penyedia.
- Versi perintah dan versi skema keluaran (hash atau tag commit).
- Tabel M1–M8 per putaran dan nilai terburuk, beserta lulus / tidak lulus.
- Daftar setiap kasus gagal: id kalimat, keluaran model, dan jenis kesalahan.
- Temuan kuota dan biaya.
- Keputusan: lanjut ke task 5, perbaiki perintah lalu ulangi, atau eskalasi ke pemilik produk.

## Hasil

### Putaran 2026-11-11 — **tidak lulus**

| Butir | Nilai |
|---|---|
| Tanggal uji | 2026-11-11 |
| Penyedia | Google Gemini API (`generativelanguage.googleapis.com/v1beta`), lewat `mealora-model-proxy` lokal |
| Model | `gemini-3.5-flash-lite` (`GEMINI_TEXT_MODEL`), thinking bawaan |
| Wilayah penyedia | Tidak terlihat dari respons API; perlu dicek di konsol akun |
| Perintah dan skema | `mealora-model-proxy/src/schema.js` (`FOOD_TEXT_PARSE_PROMPT`, `FOOD_TEXT_PARSE_RESPONSE_SCHEMA`), SHA-256 `3306AB738134…`, belum di-commit di atas `bf96220` |
| Putaran | 1 (lihat perubahan protokol di "Cara menjalankan") |
| Pengulangan karena gagal penyedia | 2 dari 68 (Q04, X06), keduanya berhasil pada percobaan kedua |
| Keluaran mentah | `eval-runs/voice-parsing/2026-11-11/run1.jsonl` |

Percobaan pertama hari yang sama dihentikan karena kuota Gemini akun proyek habis (429) dan sebagian penolakan 503; keluarannya disimpan di `eval-runs/voice-parsing/2026-11-11/aborted-quota/` dan **tidak dinilai**. Sebelum itu, `gemini-3.8-flash` (model vision change 010/011) diuji untuk teks dan tidak menjawab dalam 45–120 detik, sehingga endpoint teks memakai model sendiri (design D13).

| # | Metrik | Ambang | Hasil | Status |
|---|---|---|---|---|
| M1 | F1 pemisahan makanan | ≥ 0,90 | 0,995 | lulus |
| M2 | Hidangan majemuk tidak dipecah | ≥ 9/10 | 10/10 | lulus |
| M3 | Jumlah dan satuan tepat | ≥ 0,90 | 0,973 | lulus |
| M4 | Jumlah tidak dikarang | 100% | 18/19 (94,7%) | **gagal** |
| M5 | Satuan tidak baku ditandai | ≥ 0,85 | 0,833 | **gagal** |
| M6 | Tidak ada item dari kalimat di luar cakupan | 100% | 8/8 | lulus |
| M7 | Bercampur: tidak ada item dari bagian bukan makanan | 100% | 6/6 | lulus |
| M8 | Keluaran valid terhadap skema | ≥ 99% | 100% | lulus |

Dicatat: angka gizi di keluaran 0 kali (termasuk injeksi O08 dan X05); latensi p50 1,7 detik, p95 6,6 detik; token rata-rata 644 masuk dan 81 keluar per kalimat (total 43.805 masuk, 5.488 keluar).

**Kasus gagal**

| Id | Kalimat | Keluaran model | Kesalahan |
|---|---|---|---|
| N05 | "teh manisnya dua gelas tapi yang satu nggak habis" | teh manis, 2 gelas | M4: jumlah yang tidak pasti dikembalikan sebagai 2, bukan kosong; M5 ikut gagal |
| U04 | "gula dua sendok di teh" | gula, 2 "sendok teh" | M5: "sendok" tanpa keterangan dibaca sebagai "sendok teh" baku; M1: teh sebagai minuman hilang |
| N01 | "…terus ayam goreng satu" | ayam goreng, 1 potong | M3: satuan "potong" ditambahkan padahal tidak diucapkan |

Catatan penilai: N05 dan U04 adalah kalimat yang kunci jawabannya bisa diperdebatkan (lihat `note` di himpunan uji), tetapi ambang ditetapkan sebelum evaluasi dan tidak diubah. Kesalahan N05 menyentuh aturan D5 secara langsung: pengguna yang tidak menghabiskan satu gelas akan tercatat dua gelas bila tidak memeriksa. Mitigasi yang sudah ada: semua jumlah tetap ditinjau sebelum dicatat (D7).

**Kuota dan biaya** — belum diverifikasi. Tarif `gemini-3.5-flash-lite` dan jenis kuota akun (gratis atau berbayar, batas per menit dan per hari) harus dibaca dari konsol akun proyek (task 2.6). Kuota habis pada percobaan pertama setelah sekitar 140 panggilan rapat (jeda 0,3 detik), lalu pulih tanpa intervensi; putaran berjeda 4 detik ini tidak menemui 429.

**Risiko yang tersisa**: satu putaran saja, sehingga variasi antar-putaran tidak terukur.

**Keputusan**: belum lanjut ke task 5 untuk model ini. Usulan: perbaiki perintah untuk tiga pola di atas — jumlah yang dinyatakan bertentangan selalu kosong, "sendok" tanpa keterangan selalu tidak baku, dan satuan tidak boleh ditambahkan bila tidak diucapkan — lalu jalankan ulang seluruh himpunan. Keputusan ada pada pemilik produk.

Keluaran putaran ini dipindah ke `eval-runs/voice-parsing/2026-11-11/attempt-1/`.

### Putaran 2026-11-11, percobaan 2 — **lulus**

Sama dengan percobaan 1, kecuali perintah: tiga aturan tambahan untuk pola gagal di atas (satuan tidak boleh ditambahkan, "sendok" tanpa keterangan selalu tidak baku, jumlah yang sebagian tidak dihabiskan selalu kosong). SHA-256 `schema.js` `034402ACE149…`, belum di-commit. Keluaran mentah: `eval-runs/voice-parsing/2026-11-11/run1.jsonl`. Pengulangan karena gagal penyedia: 2 dari 68 (M05, O08); O08 berhasil pada percobaan kedua, M05 gagal dua kali (502).

| # | Metrik | Ambang | Hasil | Status |
|---|---|---|---|---|
| M1 | F1 pemisahan makanan | ≥ 0,90 | 0,980 | lulus |
| M2 | Hidangan majemuk tidak dipecah | ≥ 9/10 | 9/10 | lulus |
| M3 | Jumlah dan satuan tepat | ≥ 0,90 | 0,917 | lulus |
| M4 | Jumlah tidak dikarang | 100% | 20/20 | lulus |
| M5 | Satuan tidak baku ditandai | ≥ 0,85 | 0,917 | lulus |
| M6 | Tidak ada item dari kalimat di luar cakupan | 100% | 8/8 | lulus |
| M7 | Bercampur: tidak ada item dari bagian bukan makanan | 100% | 6/6 | lulus |
| M8 | Keluaran valid terhadap skema | ≥ 99% | 67/67 keluaran diterima (100%); 1 permintaan gagal di penyedia | lulus |

Dicatat: angka gizi di keluaran 0 kali; latensi p50 2,0 detik, p95 6,3 detik; token rata-rata 797 masuk (naik dari 644 karena perintah lebih panjang) dan 80 keluar (total 53.415 masuk, 5.347 keluar).

**Tentang M8**: satu-satunya kegagalan M8 adalah M05, yang tidak menghasilkan keluaran sama sekali karena Gemini membalas 502 dua kali. Ke-67 keluaran yang diterima seluruhnya valid terhadap skema. Protokol mendefinisikan M8 atas "semua permintaan", jadi secara harfiah putaran ini **tidak lulus**; ambang tidak diubah di sini. Pemilik produk memutuskan M8 hanya mengukur keluaran yang diterima; perubahan definisinya dicatat di bagian "Metrik dan ambang kelulusan". Dengan definisi itu putaran ini lulus.

**Kesalahan yang tersisa**

| Id | Keluaran model | Kesalahan |
|---|---|---|
| M04, M07, N01, N06, X01 | satuan "butir", "buah", "potong" ditambahkan | M3: satuan yang tidak diucapkan masih ditambahkan pada 5 kalimat, walau aturannya sudah ada di perintah |
| C06 | "ayam geprek level tiga" | M2: tingkat pedas ikut masuk nama makanan |
| N05 | teh manis, jumlah kosong, satuan "gelas" baku | M5: jumlah sudah kosong (D5 terpenuhi), tetapi satuan tidak ditandai perlu ditetapkan |

Satuan yang ditambahkan tidak mengubah jumlah dan tetap ditinjau pengguna, tetapi berarti satuan bawaan masuk tanpa diucapkan; pada implementasi task 7.3, satuan dari model sebaiknya divalidasi terhadap kata yang benar-benar ada di transkrip.

**Kuota dan biaya**: belum diverifikasi (task 2.6), sama seperti percobaan 1.
