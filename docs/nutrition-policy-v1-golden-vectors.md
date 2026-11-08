# Vektor Uji Emas — Kebijakan Gizi `np-1.0.0`

| | |
|---|---|
| Versi kebijakan | `np-1.0.0` |
| Versi kalkulator | `msj-1.0.0` |
| Status | Nilai mengikuti [`nutrition-policy-v1.md`](./nutrition-policy-v1.md) setelah tinjauan teknis ([`nutrition-policy-v1-technical-review.md`](./nutrition-policy-v1-technical-review.md)) |
| Tanggal | 2026-11-08 |
| Fixture aplikasi | `mealora-apps/mealora-mobile/test/fixtures/nutrition_policy_golden_np-1.0.0.json` |

Setiap kasus disusun **dari aturannya**, bukan dari angka hasil: kolom *Aturan yang
diuji* menyebut baris kebijakan yang menjadi sebabnya. Bila sebuah nilai berubah
lagi di masa depan, yang berubah hanyalah kolom **Hasil yang diharapkan** pada
kasus-kasus yang menyebut baris itu.

Urutan perhitungan: Lampiran A pada dokumen kebijakan. Pembulatan **setengah ke
atas**. Energi: protein 4 kkal/g, karbohidrat 4 kkal/g, lemak 9 kkal/g.

Seluruh angka pada dokumen ini dihitung dua kali — sekali mengikuti
`specs/nutrition-policy/spec.md`, sekali lagi lewat implementasi terpisah dari
aturan — dan dicocokkan baris per baris.

## 1. Profil acuan dan kasus normal

**Profil acuan P-REF:** perempuan, 29 tahun, 165 cm, 68,4 kg, "Cukup bergerak".

Nilai turunan yang dipakai keempat kasus:

| Besaran | Nilai penuh | Nilai disajikan | Aturan |
|---|---|---|---|
| Indeks massa tubuh | 25,12 | 25,1 | — |
| Berat acuan makro | min(68,4 ; 23×1,65²=62,66) = 62,66 | **62,6 kg** | F1/F2 |
| Energi istirahat | 1.409,25 kkal | **1.410 kkal** | C2, G1 |
| Pengeluaran energi harian | 2.254,80 kkal | **2.250 kkal** | C3b, G1 |

| # | Program | Aturan yang diuji | Target energi | Protein | Lemak | Karbohidrat | Serat | Catatan |
|---|---|---|---|---|---|---|---|---|
| N1 | Turun Berat | D1, D2, D4, F1/F2, F3, F7, F8, F9, G1, G2 | **1.800 kkal** (defisit 450,96 kkal) | **100 g** (22,2 %) | **50 g** (25,0 %) | **238 g** (52,8 %) | **25 g** | di atas lantai 1.200 kkal; tanpa peringatan (lantai energi istirahat D3 tidak mengikat pada pengali manapun — lihat T8) |
| N2 | Naik Berat | D8, D9, F1/F2, F4, F7, F8, F9 | **2.500 kkal** (surplus 10 % = 225,48 → dinaikkan ke lantai 250) | **88 g** (14,1 %) | **69 g** (24,8 %) | **382 g** (61,1 %) | **35 g** | batas bawah surplus D9 mengikat |
| N3 | Pertahankan | D10, D11, F1/F2, F4, F7, F8, F9 | **2.250 kkal**, pita **2.137,5 – 2.362,5 kkal** | **88 g** (15,6 %) | **63 g** (25,2 %) | **333 g** (59,2 %) | **32 g** | pita ±5 % (112,5 kkal) > minimum ±100 kkal |
| N4 | Makan Sehat | D12, D13, F1/F2, F4, F7, F8, F9 | **2.250 kkal** | **88 g** (15,6 %) | **63 g** (25,2 %) | **333 g** (59,2 %) | **32 g** | tanpa target berat; tanpa persentase kemajuan berat |

Pemeriksaan konsistensi F13 — jumlah energi makro terhadap target:
N1 1.802/1.800 · N2 2.501/2.500 · N3 dan N4 2.251/2.250. Seluruhnya dalam
toleransi pembulatan (≤ 2 kkal).

## 2. Kasus batas

Kasus pada bagian ini memberi **energi istirahat dan pengeluaran energi harian
secara langsung**, karena yang diuji adalah ambangnya, bukan persamaannya.
Tanda: *bawah* = tepat di bawah ambang · *tepat* = persis pada ambang ·
*atas* = tepat di atas ambang.

### 2.1 Usia tercakup (B2, B3, B4)

| # | Usia | Program | Hasil yang diharapkan |
|---|---|---|---|
| B-AGE-01 | 18 | Turun Berat | `unsupported_profile` · `age_below_minimum` |
| B-AGE-02 | 19 | Turun Berat | tercakup — lanjut ke perhitungan |
| B-AGE-03 | 64 | Turun Berat | tercakup — lanjut ke perhitungan |
| B-AGE-04 | 65 | Turun Berat | `needs_professional_review` · `age_above_supported` |
| B-AGE-05 | 65 | Makan Sehat | tercakup dengan angka penuh |
| B-AGE-06 | 18 | Makan Sehat | aktif, **tanpa target energi/makro** (B3) |

### 2.2 Indeks massa tubuh (B6, B7)

| # | IMT | Program | Hasil yang diharapkan |
|---|---|---|---|
| B-BMI-01 | 18,4 | Turun Berat | ditolak · `underweight_bmi` |
| B-BMI-02 | 18,5 | Turun Berat | tercakup |
| B-BMI-03 | 18,6 | Turun Berat | tercakup |
| B-BMI-04 | 37,4 | Turun Berat | tercakup |
| B-BMI-05 | 37,5 | Turun Berat | `needs_professional_review` · `bmi_above_supported` |
| B-BMI-06 | 37,6 | Naik Berat | `needs_professional_review` · `bmi_above_supported` |
| B-BMI-07 | 37,6 | Makan Sehat | tercakup dengan angka penuh |

### 2.3 Sisa defisit 300 kkal setelah lantai 1.200 kkal (D4, D6)

Masukan biologis perempuan, pengali 1,40.

| # | Energi istirahat | Pengeluaran harian | Sisa defisit | Hasil yang diharapkan |
|---|---|---|---|---|
| B-D6-01 *bawah* | 1.067,86 kkal | 1.495 kkal | 295 kkal | `needs_professional_review` · `target_below_minimum_energy`, tanpa target |
| B-D6-02 *tepat* | 1.071,43 kkal | 1.500 kkal | 300 kkal | target **1.200 kkal** (lantai D4) |
| B-D6-03 *atas* | 1.075,00 kkal | 1.505 kkal | 301 kkal | target **1.200 kkal** |

### 2.4 Batas atas defisit 750 kkal (D2)

Masukan biologis perempuan, pengali 1,60.

| # | Pengeluaran harian | Defisit 20 % | Defisit dipakai | Target energi |
|---|---|---|---|---|
| B-DEF-01 *bawah* | 3.700 kkal | 740 kkal | 740 kkal | **2.960 kkal** |
| B-DEF-02 *tepat* | 3.750 kkal | 750 kkal | 750 kkal | **3.000 kkal** |
| B-DEF-03 *atas* | 3.800 kkal | 760 kkal | **750 kkal** (dibatasi) | **3.050 kkal** |

### 2.5 Lantai 1.200 kkal — masukan biologis perempuan (D4)

Pengali 1,60.

| # | Energi istirahat | Pengeluaran harian | Target sebelum lantai | Hasil yang diharapkan |
|---|---|---|---|---|
| B-F12-01 *bawah* | 925,00 kkal | 1.480 kkal | 1.184 kkal | lantai menaikkan ke 1.200 → sisa defisit 280 kkal → `target_below_minimum_energy` |
| B-F12-02 *tepat* | 937,50 kkal | 1.500 kkal | 1.200 kkal | target **1.200 kkal**, sisa defisit 300 kkal, lantai tidak mengikat |
| B-F12-03 *atas* | 950,00 kkal | 1.520 kkal | 1.216 kkal | target **1.220 kkal** (dibulatkan) |

### 2.6 Lantai 1.500 kkal — masukan biologis laki-laki (D4)

Pengali 1,60.

| # | Energi istirahat | Pengeluaran harian | Target sebelum lantai | Hasil yang diharapkan |
|---|---|---|---|---|
| B-F15-01 *bawah* | 1.162,50 kkal | 1.860 kkal | 1.488 kkal | lantai menaikkan ke **1.500 kkal**, sisa defisit 360 kkal, **peringatan D5** |
| B-F15-02 *tepat* | 1.171,88 kkal | 1.875 kkal | 1.500 kkal | target **1.500 kkal**, sisa defisit 375 kkal, tanpa peringatan |
| B-F15-03 *atas* | 1.181,25 kkal | 1.890 kkal | 1.512 kkal | target **1.510 kkal**, tanpa peringatan |

### 2.7 Batas surplus 250 dan 500 kkal (D9)

| # | Pengeluaran harian | Surplus 10 % | Surplus dipakai | Target energi |
|---|---|---|---|---|
| B-SUR-01 *bawah* | 2.450 kkal | 245 kkal | **250 kkal** (dinaikkan) | **2.700 kkal** |
| B-SUR-02 *tepat* | 2.500 kkal | 250 kkal | 250 kkal | **2.750 kkal** |
| B-SUR-03 *atas* | 2.550 kkal | 255 kkal | 255 kkal | **2.810 kkal** |
| B-SUR-04 *bawah* | 4.950 kkal | 495 kkal | 495 kkal | **5.450 kkal** |
| B-SUR-05 *tepat* | 5.000 kkal | 500 kkal | 500 kkal | **5.500 kkal** |
| B-SUR-06 *atas* | 5.050 kkal | 505 kkal | **500 kkal** (dibatasi) | **5.550 kkal** |

### 2.8 Laju perubahan berat (E1, E2, E3)

| # | Program | Berat saat ini | Laju diminta | Batas berlaku | Hasil yang diharapkan |
|---|---|---|---|---|---|
| B-PACE-01 | Turun Berat | 80 kg | 0,24 kg/mgg | 0,25 – 0,60 | `requested_pace_too_slow` |
| B-PACE-02 | Turun Berat | 80 kg | 0,25 kg/mgg | 0,25 – 0,60 | diterima |
| B-PACE-03 | Turun Berat | 101 kg | 0,75 kg/mgg | 0,25 – 0,75 | diterima (batas kg lebih kecil daripada 0,7575) |
| B-PACE-04 | Turun Berat | 101 kg | 0,76 kg/mgg | 0,25 – 0,75 | `requested_pace_too_fast` |
| B-PACE-05 | Turun Berat | 52 kg | 0,40 kg/mgg | 0,25 – **0,39** | `requested_pace_too_fast`; batas 0,75 % berat badan mengikat |
| B-PACE-06 | Turun Berat | 52 kg | 0,39 kg/mgg | 0,25 – **0,39** | diterima, disertai penjelasan pembatasan (E2) |
| B-PACE-07 | Turun Berat | 100 kg | 0,75 kg/mgg | 0,25 – 0,75 | diterima; kedua batas berimpit |
| B-PACE-08 | Naik Berat | 60 kg | 0,124 kg/mgg | 0,125 – 0,5 | `requested_pace_too_slow` |
| B-PACE-09 | Naik Berat | 60 kg | 0,5 kg/mgg | 0,125 – 0,5 | diterima |
| B-PACE-10 | Naik Berat | 60 kg | 0,51 kg/mgg | 0,125 – 0,5 | `requested_pace_too_fast` |
| B-PACE-11 | Turun Berat | 80 kg | 6 kg dalam 4 minggu (1,5 kg/mgg) | 0,25 – 0,60 | `requested_pace_too_fast`, menyebut tanggal paling awal yang memenuhi batas (10 minggu pada 0,60 kg/mgg) |

### 2.9 Berat tujuan (E7, E8)

| # | Program | Berat saat ini | Berat tujuan | Hasil yang diharapkan |
|---|---|---|---|---|
| B-TGT-01 | Turun Berat | 70 kg, 165 cm | 48 kg (IMT 17,6) | `needs_user_correction` · `target_weight_out_of_range` |
| B-TGT-02 | Turun Berat | 70 kg | 75 kg (lebih tinggi dari saat ini) | `needs_user_correction` · `target_weight_out_of_range` |
| B-TGT-03 | Naik Berat | 60 kg | 55 kg (lebih rendah dari saat ini) | `needs_user_correction` · `target_weight_out_of_range` |
| B-TGT-04 | Turun Berat | 70 kg | 63 kg (IMT 23,1) | diterima |

### 2.10 Serat (F9, F10)

| # | Target energi | 14 g/1.000 kkal | Hasil yang diharapkan |
|---|---|---|---|
| B-FIB-01 *bawah* | 1.390 kkal | 19,46 g | **20 g** — lantai F10 mengikat |
| B-FIB-02 *tepat* | 1.430 kkal | 20,02 g | **20 g** |
| B-FIB-03 *atas* | 1.500 kkal | 21,00 g | **21 g** |
| B-FIB-04 *bawah* | 2.650 kkal | 37,10 g | **37 g** |
| B-FIB-05 *tepat* | 2.720 kkal | 38,08 g | **38 g** |
| B-FIB-06 *atas* | 2.800 kkal | 39,20 g | **38 g** — plafon F10 mengikat |

### 2.11 Ambang hitung ulang (H1, H3)

| # | Keadaan | Hasil yang diharapkan |
|---|---|---|
| B-REC-01 *bawah* | berat terbaru berbeda 1,9 kg | tidak mengusulkan revisi |
| B-REC-02 *tepat* | berat terbaru berbeda 2,0 kg | mengusulkan revisi, target lama tetap berlaku |
| B-REC-03 *atas* | berat terbaru berbeda 3,1 kg | mengusulkan revisi, target lama tetap berlaku |
| B-REC-04 *bawah* | umur target 89 hari | tidak mengusulkan revisi |
| B-REC-05 *tepat* | umur target 90 hari | mengusulkan revisi |
| B-REC-06 *atas* | umur target 91 hari | mengusulkan revisi |
| B-REC-07 | pengguna menutup layar revisi tanpa menyetujui | target lama tetap berlaku; tidak ada nilai riwayat yang berubah |

### 2.12 Pita toleransi Pertahankan (D11)

| # | Target | Pita | Konsumsi | Hasil |
|---|---|---|---|---|
| B-BAND-01 | 2.250 kkal | 2.137,5 – 2.362,5 | 2.200 kkal | di dalam pita |
| B-BAND-02 | 2.250 kkal | 2.137,5 – 2.362,5 | 2.100 kkal | di luar pita |
| B-BAND-03 | 1.800 kkal | 1.700 – 1.900 | — | ±5 % = 90 kkal < 100 kkal, sehingga minimum ±100 kkal yang berlaku |

## 3. Kasus per kode alasan

Satu kasus per kode. Seluruhnya mengharapkan **tidak ada angka target** yang
dihasilkan maupun ditampilkan, kecuali dicatat lain.

| # | Kode alasan | Masukan | Keadaan keluaran | Aturan |
|---|---|---|---|---|
| R-01 | `age_below_minimum` | 17 tahun, Turun Berat | `unsupported_profile` | B3 |
| R-02 | `age_above_supported` | 70 tahun, Naik Berat | `needs_professional_review` | B4 |
| R-03 | `pregnancy_or_lactation` | menyatakan hamil, Turun Berat | `unsupported_profile` | B5 |
| R-04 | `underweight_bmi` | IMT 17,8, Turun Berat | ditolak | B6 |
| R-05 | `bmi_above_supported` | IMT 39, Turun Berat | `needs_professional_review` | B7 |
| R-06 | `declared_medical_condition` | menyatakan penyakit ginjal, Naik Berat | `needs_professional_review` | B8 |
| R-07 | `rapid_unintended_weight_change` | turun 6 % berat badan dalam 30 hari tanpa disengaja | `needs_professional_review` | B9 |
| R-08 | `target_below_minimum_energy` | energi istirahat 1.071 kkal, pengeluaran harian 1.500 kkal, Turun Berat | `needs_professional_review` | D6 |
| R-09 | `requested_pace_too_fast` | turun 6 kg dalam 4 minggu | `needs_user_correction` | E4 |
| R-10 | `requested_pace_too_slow` | turun 1 kg dalam 20 minggu (0,05 kg/mgg) | `needs_user_correction` | E4 |
| R-11 | `target_weight_out_of_range` | berat tujuan menghasilkan IMT 17,6 | `needs_user_correction` | E7 |
| R-12 | `missing_required_input` | tinggi badan belum diisi | `needs_user_correction`, menyebut "tinggi badan" | B10 |

**Catatan:** `missing_validated_policy` dihapus dari daftar kode — kebijakan ini
berlaku tanpa gerbang persetujuan (lihat `design.md` D13). Dua kode alasan lama,
`eating_disorder` dan rujukan langsung untuk usia di bawah 19, kini tidak menolak
Makan Sehat — lihat kasus S5 dan S6 di Bagian 4.

## 4. Kasus khusus

### S1 — Lantai asupan mutlak menaikkan target (D4, D5)

Laki-laki, 64 tahun, 170 cm, **58 kg**, "Lebih banyak duduk" (IMT 20,1 — profil
bertubuh kecil, bukan bertubuh besar; lantai energi istirahat D3 tidak lagi
relevan untuk kasus ini, lihat T8 pada tinjauan teknis).

| Besaran | Nilai | Aturan |
|---|---|---|
| Energi istirahat | 1.327,50 kkal → **1.330 kkal** | C1 |
| Pengeluaran energi harian | 1.858,50 kkal → **1.860 kkal** | C3a |
| Defisit 20 % | 371,70 kkal | D1 |
| Target sebelum lantai | 1.486,80 kkal — **di bawah lantai 1.500 kkal** | — |
| Target setelah lantai | **1.500 kkal** | D4, G1 |
| Sisa defisit | 358,50 kkal ≥ 300 kkal → diterima | D6 |
| Peringatan | "defisit lebih kecil daripada perhitungan awal" | D5 |
| Berat acuan | IMT 20,1 < 23 → berat acuan = berat saat ini = 58 kg | F1/F2 |
| Protein / Lemak / Karbohidrat / Serat | **93 g** (24,8 %) / **42 g** (25,2 %) / **188 g** (50,0 %) / **21 g** | F3, F7, F8, F9 |

### S2 — Penyesuaian saat karbohidrat di bawah 45 persen energi (F11)

Perempuan, 64 tahun, 170 cm, 67 kg, "Lebih banyak duduk" (IMT 23,2 → berat acuan
= min(67 ; 23×1,70² = 66,49) = **66,5 kg**).

| Langkah | Nilai |
|---|---|
| Energi istirahat / pengeluaran harian | 1.251,50 / 1.750 kkal (dibulatkan 1.250 / 1.750) |
| Target energi | 1.400 kkal (di atas lantai; tanpa peringatan) |
| Protein | 1,6 × 66,5 = **106 g** (424 kkal, 30,3 % energi — di dalam pagar F5) |
| Lemak awal 25 % | 39 g (351 kkal) |
| Karbohidrat awal | sisa 625 kkal = **44,6 %** → di bawah 45 %, penyesuaian F11 dijalankan |
| Penyesuaian 1 — lemak ke 20 % | **31 g** (279 kkal, 19,9 %) |
| Karbohidrat setelah penyesuaian 1 | sisa 697 kkal = **49,8 %** → sudah di dalam rentang, penyesuaian 2 tidak diperlukan |
| **Hasil akhir** | protein **106 g** · lemak **31 g** · karbohidrat **174 g** · serat **20 g** |

Penyesuaian kedua (protein turun ke 1,2 g/kg) **tidak terpakai** pada kasus ini.
Kasus yang memicu penyesuaian langkah 1 menjadi lebih jarang setelah berat acuan
dibatasi IMT 23 (U2) — profil bertubuh lebih besar kini memakai berat acuan yang
lebih kecil, sehingga proporsi energi protein terhadap total menurun dan
karbohidrat yang tersisa biasanya sudah ≥45 % tanpa penyesuaian.

### S3 — Berat acuan pada IMT di atas 23 (F1/F2)

Perempuan, 40 tahun, 165 cm, 110 kg, "Lebih banyak duduk", program **Makan Sehat**.

> IMT 40,4 membuat profil ini `needs_professional_review` untuk Turun Berat dan
> Naik Berat (B7, ambang 37,5). Makan Sehat tetap tersedia, sehingga aturan berat
> acuan tetap dapat diuji.

| Besaran | Nilai |
|---|---|
| Indeks massa tubuh | 40,4 |
| Berat acuan | min(110 ; 23×1,65² = 62,63) = **62,6 kg** (bukan 110 kg, dan bukan 68,1 kg seperti pada ambang IMT 25 yang lama) |
| Energi istirahat / pengeluaran harian | 1.770,25 / 2.478,35 kkal |
| Target energi | **2.480 kkal** |
| Protein / Lemak / Karbohidrat / Serat | **88 g** (14,2 %) / **69 g** (25,0 %) / **377 g** (60,8 %) / **35 g** |

Dengan ambang lama (IMT 25, berat setara 68,1 kg), protein akan bernilai 95 g —
selisih 7 g terhadap hasil di atas, akibat langsung dari U2.

### S4 — Makan Sehat tanpa target berat (D12, D13)

Profil acuan P-REF, program Makan Sehat, **tanpa berat tujuan dan tanpa tanggal tujuan**.

| Besaran | Hasil yang diharapkan |
|---|---|
| Aktivasi program | berhasil — ketiadaan berat tujuan tidak menghalangi |
| Target energi | **2.250 kkal**, sama dengan pengeluaran energi harian |
| Makro dan serat | 88 g / 63 g / 333 g / 32 g (sama dengan N4) |
| Kemajuan yang ditampilkan | kelengkapan pencatatan dan kesesuaian rentang gizi |
| Yang **tidak** boleh muncul | persentase kemajuan berat badan di layar mana pun |

### S5 — Makan Sehat tanpa angka untuk usia di bawah 19 (B3, U6)

Profil 16 tahun, program Makan Sehat.

| Besaran | Hasil yang diharapkan |
|---|---|
| Aktivasi program | berhasil |
| Target energi | **tidak ditampilkan** — Mifflin–St Jeor tidak divalidasi untuk usia ini |
| Target makro | **tidak ditampilkan** |
| Pencatatan makanan | tetap berjalan normal |
| Turun Berat / Naik Berat / Pertahankan | `unsupported_profile` · `age_below_minimum` |

### S6 — Makan Sehat tanpa angka untuk riwayat gangguan makan (B8, U7)

Profil dewasa tercakup yang menyatakan riwayat gangguan makan, program Makan Sehat.

| Besaran | Hasil yang diharapkan |
|---|---|
| Aktivasi program | berhasil |
| Target energi | **tidak ditampilkan** |
| Target makro | **tidak ditampilkan** |
| Pencatatan makanan | tetap berjalan normal |
| Turun Berat / Naik Berat | `needs_professional_review` · `declared_medical_condition` |

## 5. Kasus versi dan riwayat (A3, A5, H4, H5)

| # | Keadaan | Hasil yang diharapkan |
|---|---|---|
| V-01 | pengguna menyetujui target N1 | tersimpan bersama `np-1.0.0`, `msj-1.0.0`, dan salinan masukan (29 th, 165 cm, 68,4 kg, "Cukup bergerak") |
| V-02 | versi kebijakan `np-1.1.0` terbit | target V-01 tetap menampilkan 1.800 kkal, asumsi aslinya, dan versi `np-1.0.0` |
| V-03 | pengguna menyetujui revisi target | target baru berlaku; catatan target lama tetap utuh di riwayat |

## 6. Catatan verifikasi aritmetika

| Catatan | Penjelasan |
|---|---|
| Lantai energi istirahat (D3) | Pada pengali terendah 1,40, target Turun Berat selalu bernilai 0,8 × 1,40 = 1,12 kali energi istirahat — lantai ini tidak pernah mengikat secara aritmetika pada `np-1.0.0`. Dipertahankan sebagai jaring pengaman (lihat tinjauan teknis T8). Kasus S1 didesain ulang memakai lantai absolut D4, bukan D3. |
| Batas bawah defisit 300 kkal (D2) | Tidak ada kasus yang berhasil memicunya, sama seperti sebelum tinjauan (T2). |
| Cabang peringatan F12 | Tidak ada kasus yang berhasil memicunya pada profil yang diuji; makin jauh dari tercapai setelah U2 (T3). |
| Karbohidrat N1 = 238 g (52,8 %) | Direproduksi dengan karbohidrat dihitung sebagai sisa energi setelah protein dan lemak yang sudah dibulatkan, sesuai Lampiran A. |
