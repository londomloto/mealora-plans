# Kebijakan Gizi Mealora — `np-1.0.0`

| | |
|---|---|
| Versi kebijakan | `np-1.0.0` |
| Versi kalkulator energi | `msj-1.0.0` (Mifflin–St Jeor) |
| Status | **Diterima untuk MVP 1** — lihat catatan status di bawah |
| Tanggal | 2026-11-08 |
| Change asal | `002-nutrition-policy-v1` |
| Sumber normatif | `openspec/changes/002-nutrition-policy-v1/specs/nutrition-policy/spec.md` |
| Tinjauan teknis | [`nutrition-policy-v1-technical-review.md`](./nutrition-policy-v1-technical-review.md) |
| Vektor uji emas | [`nutrition-policy-v1-golden-vectors.md`](./nutrition-policy-v1-golden-vectors.md) |

## Catatan status

Mealora MVP 1 adalah aplikasi lokal untuk pemakaian perorangan, dibangun tanpa tim
kesehatan berlisensi. Pemilik produk memutuskan kebijakan ini berlaku tanpa gerbang
persetujuan berlisensi (`openspec/changes/002-nutrition-policy-v1/design.md`, D13) —
seluruh nilai sudah melalui **tinjauan teknis** terhadap pedoman publik dan terhadap
kesesuaiannya untuk populasi dewasa Indonesia, tetapi bukan peninjauan oleh ahli
gizi berlisensi.

Yang tetap berlaku penuh: gagal tertutup untuk profil yang **tidak dicakup**
kebijakan ini (usia di luar rentang, kehamilan, kondisi yang dinyatakan, berat
tujuan di luar rentang aman). Profil itu tidak pernah menerima angka yang ditebak.

Bila Mealora dilepas ke pengguna umum di luar pemakaian perorangan, assessment §40
mensyaratkan peninjauan berlisensi menurut bunyinya sendiri — tinjauan teknis ini
tidak menggantikannya.

## 0. Cara membaca dokumen ini

Setiap baris di Bagian 2 adalah satu nilai atau satu aturan. Kolom **Jenis**
menyatakan asal nilai:

| Jenis | Artinya |
|---|---|
| *Pedoman* | nilai dikutip dari pedoman atau tinjauan yang dirujuk di Bagian 3 |
| *Turunan* | nilai dihitung dari baris lain yang berjenis *Pedoman* |
| **Produk** | **keputusan tim Mealora, bukan kutipan pedoman** — paling perlu diperiksa ulang bila ada keluhan pengguna |
| *Rekayasa* | batas teknis (pembulatan, bentuk keluaran) tanpa muatan klinis |

Kolom **Tinjauan** mencatat hasil tinjauan teknis per baris: `diterima` / `diubah`
(dengan nilai barunya) / `dihapus`. Rincian tiap perubahan ada di
[`nutrition-policy-v1-technical-review.md`](./nutrition-policy-v1-technical-review.md).

## 1. Batas cakupan

Kebijakan `np-1.0.0` **bukan** terapi gizi medis. Ia tidak mendiagnosis, tidak
menangani gejala, dan tidak menggantikan penilaian tenaga kesehatan. Ia juga
**tidak menjamin kecukupan mikronutrien** — lihat Bagian 4 dan catatan di tinjauan
teknis Bagian 6.

Tidak tercakup oleh kebijakan ini:

- anak dan remaja (usia di bawah 19 tahun) — Makan Sehat tetap bisa dipakai untuk
  mencatat makanan, tanpa target energi maupun makro;
- kehamilan dan menyusui;
- kondisi medis atau pengobatan yang dinyatakan pengguna — gangguan makan saat
  ini maupun di masa lalu, diabetes, penyakit ginjal, penyakit hati, atau obat
  yang memengaruhi berat badan dan nafsu makan (riwayat gangguan makan: Makan
  Sehat tetap tersedia tanpa angka, dengan alasan yang sama seperti remaja — lihat
  tinjauan teknis U6/U7);
- indeks massa tubuh di bawah 18,5 untuk program penurunan berat, dan 37,5 ke atas
  untuk program yang mengubah berat;
- perubahan berat tidak disengaja lebih dari 5 persen dalam 30 hari terakhir;
- berat tujuan yang menghasilkan IMT di bawah 18,5, atau yang arahnya berlawanan
  dengan program yang dipilih;
- target vitamin dan mineral — Angka Kecukupan Gizi Indonesia dipakai sebagai
  pembanding kewajaran (Bagian 4), bukan sebagai target yang dihitung aplikasi;
- atlet, pekerja fisik berat, dan siapa pun yang pengeluaran energinya di atas
  pengali aktivitas tertinggi yang disediakan (1,80).

Skrining kondisi bergantung sepenuhnya pada pernyataan pengguna. Aplikasi tidak
memverifikasinya dan tidak mengklaim dapat mendeteksi kondisi medis. Yang
dijamin kebijakan ini hanyalah: **bila dinyatakan, tidak ada target otomatis.**

## 2. Aturan dan nilai

### 2.A Versi kebijakan

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| A1 | Pengenal kebijakan | `np-1.0.0` | Rekayasa | penomoran internal | diterima |
| A2 | Pengenal kalkulator energi | `msj-1.0.0` | Rekayasa | menandai persamaan Mifflin–St Jeor (C1/C2) | diterima |
| A3 | Yang disimpan pada tiap target disetujui | versi kebijakan + versi kalkulator + salinan masukan | Rekayasa | ketertelusuran riwayat | diterima |
| A5 | Versi kebijakan baru terbit | target lama menyimpan nilai, asumsi, dan versi aslinya sampai pengguna menyetujui revisi | **Produk** | riwayat tidak ditulis ulang | diterima |

### 2.B Kelayakan menerima target otomatis

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| B1 | Keadaan keluaran kelayakan | tepat satu dari: disetujui, `needs_user_correction`, `needs_professional_review`, `unsupported_profile` | Rekayasa | bentuk keluaran mesin | diterima |
| B2 | Rentang usia tercakup | **19–64 tahun** | **Produk** | batas populasi sasaran MVP | diterima |
| B3 | Usia < 19 tahun | `unsupported_profile` · `age_below_minimum` untuk program pengubah berat; **Makan Sehat aktif tanpa target energi/makro** | **Produk** | Mifflin–St Jeor divalidasi pada dewasa; kebutuhan remaja mengikuti kurva pertumbuhan | **diubah (U6)** — sebelumnya Makan Sehat tetap menampilkan angka |
| B4 | Usia ≥ 65 tahun | `needs_professional_review` · `age_above_supported` untuk Turun Berat dan Naik Berat; Makan Sehat dan Pertahankan tetap tersedia dengan angka penuh | **Produk** | risiko sarkopenia dan kondisi penyerta; protein 1,4 g/kg di atas anjuran lansia | diterima |
| B5 | Hamil atau menyusui | `unsupported_profile` · `pregnancy_or_lactation` untuk Turun Berat; `needs_professional_review` untuk Naik Berat dan Pertahankan | **Produk** | kebutuhan gizi kehamilan/laktasi memerlukan pendampingan | diterima |
| B6 | Indeks massa tubuh < 18,5 | tolak Turun Berat · `underweight_bmi` | Pedoman | ambang berat badan kurang WHO | diterima |
| B7 | Indeks massa tubuh ≥ 37,5 | `needs_professional_review` · `bmi_above_supported` untuk Turun Berat dan Naik Berat | Pedoman | titik aksi kesehatan masyarakat WHO untuk populasi Asia (23/27,5/32,5/37,5) | **diubah (U3)** — sebelumnya ≥40 dengan skala global |
| B8 | Kondisi atau pengobatan dinyatakan | `needs_professional_review` · `declared_medical_condition` untuk diabetes, penyakit ginjal, penyakit hati, obat yang memengaruhi berat/nafsu makan. **Gangguan makan (kini atau lampau): Makan Sehat aktif tanpa target energi/makro**, bukan `needs_professional_review` | **Produk** | paparan target kalori adalah yang perlu dihindari, bukan ketidaktepatan angka | **diubah (U7)** — gangguan makan dipisah dari daftar rujukan |
| B9 | Perubahan berat tidak disengaja | **> 5 persen berat badan dalam 30 hari** → `needs_professional_review` · `rapid_unintended_weight_change` | Pedoman | kriteria skrining malnutrisi yang lazim | diterima |
| B10 | Masukan wajib belum lengkap | `needs_user_correction` · `missing_required_input`, **menyebut masukan mana** yang kurang | Rekayasa | kejelasan bagi pengguna | diterima |
| B11 | Urutan pemeriksaan | kelayakan dinilai **sebelum** nilai apa pun dihitung | Rekayasa | tidak ada angka yang bocor ke layar | diterima |

### 2.C Perkiraan energi istirahat dan pengeluaran energi harian

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| C1 | Energi istirahat — masukan biologis laki-laki | `10 × berat(kg) + 6,25 × tinggi(cm) − 5 × usia(th) + 5` | Pedoman | Mifflin–St Jeor 1990 | diterima dengan catatan — belum ada validasi pada populasi Indonesia; lihat tinjauan Bagian 3 |
| C2 | Energi istirahat — masukan biologis perempuan | `10 × berat(kg) + 6,25 × tinggi(cm) − 5 × usia(th) − 161` | Pedoman | Mifflin–St Jeor 1990 | diterima dengan catatan (sama seperti C1) |
| C3a | Pengali aktivitas — "Lebih banyak duduk" | **1,40** | Pedoman | batas bawah PAL FAO/WHO/UNU 2004 untuk gaya hidup menetap (1,40–1,69) | **diubah (U1)** — sebelumnya 1,2, di bawah pita terendah untuk orang yang hidup bebas |
| C3b | Pengali aktivitas — "Cukup bergerak" | **1,60** | Pedoman | batas bawah PAL aktif sedang (1,70–1,99), diturunkan sedikit karena estimasi RMR lebih tinggi dari BMR | **diubah (U1)** — sebelumnya 1,55 |
| C3c | Pengali aktivitas — "Sangat aktif" | **1,80** | Pedoman | batas bawah PAL sangat aktif (2,00–2,40), dengan penyesuaian yang sama | **diubah (U1)** — sebelumnya 1,725 |
| C4 | Penyajian | kedua nilai disebut **perkiraan**, bukan pengukuran, diagnosis, atau jaminan | **Produk** | larangan janji hasil | diterima |

### 2.D Target energi harian per program

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| D1 | Turun Berat — besar defisit | **20 persen** dari pengeluaran energi harian | **Produk** | defisit proporsional, bukan angka tetap | diterima |
| D2 | Turun Berat — batas defisit | **300 – 750 kkal/hari** | Pedoman (atas) / **Produk** (bawah) | AHA/ACC/TOS 2013: defisit 500–750 kkal/hari | diterima dengan catatan — batas 300 tidak pernah mengikat secara aritmetika, dipertahankan sebagai dokumentasi niat |
| D3 | Lantai energi istirahat | target **tidak pernah di bawah energi istirahat** profil itu | **Produk** | jaring pengaman untuk perubahan nilai di masa depan | diterima dengan catatan — pada pengali 1,40 ke atas, lantai ini tidak pernah mengikat hari ini (target selalu ≥1,12× energi istirahat); lihat T8 |
| D4 | Lantai asupan mutlak | **1.200 kkal** (masukan biologis perempuan) · **1.500 kkal** (laki-laki) | Pedoman | AHA/ACC/TOS 2013: 1.200–1.500 (P), 1.500–1.800 (L) | diterima dengan catatan — dirancang untuk ukuran tubuh Amerika; bagi perempuan Indonesia bertubuh kecil 1.200 kkal mendekati energi istirahatnya sendiri |
| D5 | Target dinaikkan oleh lantai | target dinaikkan ke lantai **disertai peringatan** bahwa defisit menjadi lebih kecil | **Produk** | larangan memotong diam-diam | diterima |
| D6 | Defisit tersisa setelah lantai < 300 kkal | `needs_professional_review` · `target_below_minimum_energy`, tidak ada target defisit | **Produk** | mengaku tidak sanggup, bukan menjual program kosong | diterima |
| D7 | Batas keras | **tidak pernah menghasilkan target di bawah 800 kkal/hari** dalam keadaan apa pun | Pedoman | AHA/ACC/TOS 2013: VLCD <800 kkal hanya dengan pengawasan | diterima |
| D8 | Naik Berat — besar surplus | **10 persen** dari pengeluaran energi harian | **Produk** | surplus proporsional | diterima |
| D9 | Naik Berat — batas surplus | **250 – 500 kkal/hari** | Turunan | setara laju 0,125–0,5 kg/mgg pada ±7.700 kkal per kg | diterima |
| D10 | Pertahankan — target energi | sama dengan pengeluaran energi harian | Rekayasa | definisi program | diterima |
| D11 | Pertahankan — pita toleransi | **±5 persen**, sekurang-kurangnya **±100 kkal** | **Produk** | fluktuasi harian yang wajar | diterima |
| D12 | Makan Sehat — target energi (profil tercakup) | sama dengan pengeluaran energi harian; **tanpa** defisit, **tanpa** surplus, **tanpa** target berat wajib | **Produk** | jalur aman bagi profil yang tidak menerima target berat | diterima |
| D13 | Makan Sehat — ukuran kemajuan | kelengkapan pencatatan dan kesesuaian rentang gizi; **tidak** menampilkan persentase kemajuan berat | **Produk** | tidak memicu fokus berat badan | diterima |

### 2.E Laju perubahan berat dan tanggal/berat tujuan

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| E1 | Turun Berat — laju | **0,25 – 0,75 kg per minggu** | Turunan | setara defisit 300–750 kkal/hari (±7.700 kkal per kg) | diterima |
| E2 | Turun Berat — batas relatif | **≤ 0,75 persen berat badan saat ini per minggu**, diambil yang **lebih kecil** antara E1 dan E2 | **Produk** | melindungi pengguna bertubuh kecil | diterima |
| E3 | Naik Berat — laju | **0,125 – 0,5 kg per minggu** | **Produk** | menahan penambahan massa lemak | diterima |
| E4 | Laju yang diminta di luar batas | `needs_user_correction` · `requested_pace_too_fast` atau `requested_pace_too_slow`, **menyebut tanggal paling awal yang memenuhi batas** | **Produk** | konflik dijelaskan, bukan dipotong | diterima |
| E5 | Larangan | **tidak boleh** memotong target diam-diam agar sesuai tanggal yang diminta | **Produk** | larangan kebohongan halus | diterima |
| E6 | Tanggal tujuan | **opsional**; ketiadaannya tidak menghalangi aktivasi program | **Produk** | tanggal bukan syarat | diterima |
| E7 | Berat tujuan — IMT di bawah 18,5 | `needs_user_correction` · `target_weight_out_of_range` | **Produk** | konsisten dengan B6 | **baru (U5)** — kode sebelumnya tidak punya aturan pemicu |
| E8 | Berat tujuan — arah berlawanan dengan program | `needs_user_correction` · `target_weight_out_of_range` | **Produk** | berat tujuan lebih tinggi pada Turun Berat, atau lebih rendah pada Naik Berat, adalah masukan yang tidak koheren | **baru (U5)** |

### 2.F Target protein, lemak, karbohidrat, dan serat

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| F1/F2 | Berat badan acuan | **nilai terkecil** antara berat badan saat ini dan berat yang setara IMT 23 pada tinggi profil | **Produk** | klasifikasi IMT Asia-Pasifik; bentuk `min()` menghindari lompatan nilai pada titik ambang | **diubah (U2)** — sebelumnya ambang IMT 30 dengan berat setara IMT 25 |
| F3 | Protein — Turun Berat | **1,6 g per kg berat acuan** | Pedoman | Leidy dkk. 2015; Phillips dkk. (1,2–1,6 g/kg) — Mealora memakai batas atas | diterima dengan catatan — di batas atas rentang bukti; lihat tinjauan Bagian 3 |
| F4 | Protein — Naik Berat, Pertahankan, Makan Sehat | **1,4 g per kg berat acuan** | Pedoman | idem, titik tengah rentang | diterima |
| F5 | Protein — pagar proporsi | **10 – 35 persen energi** | Pedoman | AMDR, IOM 2005 | diterima |
| F6 | Protein — lantai absolut | **≥ 0,8 g per kg berat acuan** | Pedoman | RDA protein sebagai kecukupan minimum | diterima |
| F7 | Lemak | **25 persen energi**, dalam rentang **20 – 35 persen** | Pedoman | AMDR, IOM 2005 | diterima |
| F8 | Karbohidrat | **sisa energi** setelah protein dan lemak, sasaran **45 – 65 persen** | Pedoman | AMDR, IOM 2005 | diterima |
| F9 | Serat | **14 g per 1.000 kkal** target energi | Pedoman | Adequate Intake DRI | diterima dengan catatan — aspiratif terhadap asupan rata-rata Indonesia; jangan menghukum pengguna yang tidak mencapainya |
| F10 | Serat — batas | **≥ 20 g**, **≤ 38 g** | **Produk** | mencegah target ekstrem di energi kecil/besar | diterima |
| F11 | Urutan penyesuaian bila karbohidrat < 45 % | (1) turunkan lemak sampai **20 persen energi**; (2) turunkan protein sampai **1,2 g/kg** | **Produk** | protein dipertahankan selama defisit | diterima dengan catatan — cabang ini secara aritmetika tidak pernah tercapai penuh (pagar F5 menjamin karbohidrat ≥45% setelah langkah 1); dipertahankan sebagai jaring pengaman |
| F12 | Bila karbohidrat tetap < 45 % | tetap usulkan target **disertai peringatan** | **Produk** | di bawah AMDR bukan bahaya akut | diterima (jaring pengaman, lihat F11) |
| F13 | Konsistensi | jumlah energi protein + lemak + karbohidrat konsisten dengan target energi **dalam toleransi pembulatan** | Rekayasa | — | diterima |

### 2.G Pembulatan dan penyajian

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| G1 | Target energi | kelipatan **10 kkal** terdekat | Rekayasa | keterbacaan | diterima |
| G2 | Makro dan serat | **gram** terdekat | Rekayasa | keterbacaan | diterima |
| G3 | Berat badan | **0,1 kg** terdekat | Rekayasa | ketelitian timbangan rumah | diterima |
| G4 | Letak pembulatan | hanya pada nilai akhir yang disajikan dan disimpan, bukan nilai antara | Rekayasa | urutan baku: Lampiran A | diterima |

### 2.H Hitung ulang dan persetujuan revisi

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| H1 | Pemicu — perubahan berat | berat terbaru berbeda **≥ 2 kg** dari berat pada salinan masukan target yang berlaku | **Produk** | di atas fluktuasi air tubuh harian | diterima |
| H2 | Pemicu — perubahan profil | tingkat aktivitas atau data profil berubah | Rekayasa | — | diterima |
| H3 | Pemicu — umur target | target berlaku berumur **≥ 90 hari** | **Produk** | peninjauan berkala | diterima |
| H4 | Pemberlakuan revisi | hanya setelah pengguna **meninjau dan menyetujui**; sampai itu target lama tetap berlaku | **Produk** | pengguna memegang kendali | diterima |
| H5 | Riwayat | tidak berubah oleh revisi maupun pergantian versi kebijakan | Rekayasa | — | diterima |

### 2.I Kode alasan dan batas bahasa

| # | Aturan | Nilai `np-1.0.0` | Jenis | Dasar | Tinjauan |
|---|---|---|---|---|---|
| I1 | Daftar kode alasan | `age_below_minimum`, `age_above_supported`, `pregnancy_or_lactation`, `underweight_bmi`, `bmi_above_supported`, `declared_medical_condition`, `rapid_unintended_weight_change`, `target_below_minimum_energy`, `requested_pace_too_fast`, `requested_pace_too_slow`, `target_weight_out_of_range`, `missing_required_input` | Rekayasa | 11 kode | **diubah** — `bmi_above_supported` ditambahkan (U4), `missing_validated_policy` dihapus (U8) |
| I2 | Larangan bahasa | tidak mendiagnosis · tidak menjanjikan hasil · tidak menyalahkan pengguna | **Produk** | batas etis produk | diterima |
| I3 | Isi wajib tiap penolakan | menyebut alasan · menyatakan **tidak ada target yang dibuat** · menawarkan langkah berikutnya | **Produk** | idem | diterima |

## 3. Rujukan

| Kode | Rujukan | Dipakai pada baris | Pranala |
|---|---|---|---|
| R1 | Mifflin MD, St Jeor ST, dkk. *A new predictive equation for resting energy expenditure in healthy individuals.* Am J Clin Nutr. 1990;51(2):241–247. | C1, C2 | <https://doi.org/10.1093/ajcn/51.2.241> |
| R2 | Jensen MD, Ryan DH, Apovian CM, dkk. *2013 AHA/ACC/TOS Guideline for the Management of Overweight and Obesity in Adults.* Circulation. 2014;129(25 Suppl 2):S102–S138. | D2, D4, D7 | <https://doi.org/10.1161/01.cir.0000437739.71477.ee> |
| R3 | Institute of Medicine. *Dietary Reference Intakes for Energy, Carbohydrate, Fiber, Fat, Fatty Acids, Cholesterol, Protein, and Amino Acids.* Washington DC: National Academies Press; 2005. (AMDR; Adequate Intake serat 14 g/1.000 kkal; RDA protein 0,8 g/kg) | F5–F9 | <https://doi.org/10.17226/10490> |
| R4 | Leidy HJ, Clifton PM, Astrup A, dkk. *The role of protein in weight loss and maintenance.* Am J Clin Nutr. 2015;101(6):1320S–1329S. | F3, F4 | <https://doi.org/10.3945/ajcn.114.084038> |
| R5 | Phillips SM, Chevalier S, Leidy HJ. *Protein requirements beyond the RDA: implications for optimizing health.* Appl Physiol Nutr Metab. 2016;41(5):565–572. | F3, F4, F6 | <https://doi.org/10.1139/apnm-2015-0550> |
| R6 | Peraturan Menteri Kesehatan RI No. 28 Tahun 2019 tentang Angka Kecukupan Gizi yang Dianjurkan untuk Masyarakat Indonesia. | Bagian 4 | <https://jdih.kemkes.go.id/> |
| R7 | WHO. *Body mass index* — klasifikasi berat badan kurang < 18,5. | B6 | <https://www.who.int/health-topics/obesity> |
| R8 | FAO/WHO/UNU. *Human Energy Requirements*, Report of a Joint Expert Consultation. Roma; 2004. | C3a–C3c | <https://www.fao.org/4/y5686e/y5686e00.htm> |
| R9 | WHO Expert Consultation. *Appropriate body-mass index for Asian populations and its implications for policy and intervention strategies.* Lancet. 2004;363(9403):157–163. | F1/F2, B7 | <https://doi.org/10.1016/S0140-6736(03)15268-3> |
| R10 | Morton RW, dkk. *Meta-analysis... protein supplementation on resistance training-induced gains.* Br J Sports Med. 2018;52(6):376–384. | F3 | <https://doi.org/10.1136/bjsports-2017-097608> |

> **Catatan verifikasi:** nilai AKG pada Bagian 4 dikutip dari tabel PMK 28/2019 dan
> **perlu dicocokkan dengan salinan resmi**, karena dokumen ini disusun tanpa akses
> langsung ke PDF lampirannya.

## 4. Pemeriksaan silang terhadap AKG Indonesia (PMK 28/2019)

Pembanding kewajaran, **bukan target yang dihitung aplikasi**. Profil acuan:
perempuan 29 tahun, 165 cm, 68,4 kg, "Cukup bergerak" → kelompok AKG
**perempuan 19–29 tahun** (berat acuan 55 kg, tinggi acuan 159 cm).

| Zat gizi | AKG P 19–29 th | Mealora — Makan Sehat (2.250 kkal) | Mealora — Turun Berat (1.800 kkal) | Catatan kesesuaian |
|---|---|---|---|---|
| Energi | 2.250 kkal | 2.250 kkal (0 %) | 1.800 kkal (−20 %) | Makan Sehat sama persis dengan AKG. Selisih Turun Berat adalah defisit yang memang disengaja. |
| Protein | 60 g | 88 g (+47 %) | 100 g (+67 %) | Di atas RDA sesuai F3/F4 (tinjauan Leidy/Phillips), lebih dekat ke AKG dibanding draf awal (96/109 g) karena berat acuan kini mengikuti IMT 23. Masih dalam AMDR (15,6 % dan 22,2 % energi). |
| Lemak | 65 g | 63 g (−3 %) | 50 g (−23 %) | Sebanding; keduanya 25 % energi, di dalam AMDR 20–35 %. |
| Karbohidrat | 360 g | 333 g (−8 %) | 238 g (−34 %) | Mengikuti energi yang lebih rendah; proporsi 59,2 % dan 52,8 % energi, di dalam AMDR 45–65 %. |
| Serat | 32 g | 32 g (0 %) | 25 g (−22 %) | Makan Sehat identik dengan AKG; konsisten dengan 14 g/1.000 kkal (F9). |

**Kesimpulan kewajaran:** pada energi pemeliharaan, target Mealora kini **sama
dengan AKG untuk energi dan serat**, dan mendekati untuk lemak — perbaikan dari
draf awal tinjauan teknis (sebelumnya meleset 3 persen pada energi). Protein tetap
di atas RDA secara sengaja. Pada program Turun Berat seluruh selisih adalah akibat
langsung dari defisit pada baris D1–D2. **Tidak ditemukan nilai yang tampak tidak
wajar** terhadap AKG setelah tinjauan.

## 5. Bahasa yang dilihat pengguna

Nada mengikuti layar `26 · Target tidak dibuat` dan `36 · Belum ada program` pada
`docs/mealora.pen`: kalimat pendek, sapaan "kamu", menyebut apa yang **tidak**
terjadi, lalu menawarkan langkah berikutnya.

Setiap baris diperiksa terhadap tiga larangan (I2):
**D** = tidak mendiagnosis · **J** = tidak menjanjikan hasil · **S** = tidak menyalahkan pengguna.
Kolom "Langkah berikutnya" memenuhi I3.

| Kode alasan | Judul | Penjelasan | Langkah berikutnya | D | J | S |
|---|---|---|---|---|---|---|
| `age_below_minimum` | Program ini belum untuk usiamu | Mealora hanya menghitung target untuk usia 19 tahun ke atas. Tidak ada target yang dibuat. | Makan Sehat tetap bisa kamu pakai untuk mencatat makanan. | ✓ | ✓ | ✓ |
| `age_above_supported` | Sebaiknya dibicarakan dulu | Untuk usia 65 tahun ke atas, target penurunan atau penambahan berat lebih tepat ditentukan bersama tenaga kesehatan. Tidak ada target yang dibuat. | Makan Sehat dan Pertahankan tetap tersedia. | ✓ | ✓ | ✓ |
| `pregnancy_or_lactation` | Butuh pendampingan tenaga kesehatan | Kebutuhan gizi saat hamil dan menyusui berbeda dan memerlukan pendampingan. Tidak ada target yang dibuat. | Coba Makan Sehat, tanpa target perubahan berat. | ✓ | ✓ | ✓ |
| `underweight_bmi` | Program penurunan berat tidak dibuat | Dari tinggi dan berat yang kamu isi, Mealora tidak membuat target penurunan berat. | Makan Sehat atau Naik Berat bisa kamu lihat dulu. | ✓ | ✓ | ✓ |
| `bmi_above_supported` | Sebaiknya dibicarakan dulu | Untuk menentukan target perubahan berat yang aman pada kondisi ini, pendampingan tenaga kesehatan lebih tepat. Tidak ada target yang dibuat. | Makan Sehat dan Pertahankan tetap tersedia. | ✓ | ✓ | ✓ |
| `declared_medical_condition` | Sebaiknya dibicarakan dulu | Untuk kondisi atau pengobatan yang kamu sebutkan, target otomatis bukan hal yang pantas Mealora putuskan. Tidak ada target yang dibuat. | Simpan catatan makananmu lewat Makan Sehat, dan bicarakan targetnya dengan tenaga kesehatan. | ✓ | ✓ | ✓ |
| `rapid_unintended_weight_change` | Perubahan berat ini perlu ditelusuri | Beratmu berubah cukup banyak dalam waktu singkat tanpa kamu sengaja. Mealora tidak membuat target sebelum sebabnya diketahui. | Bicarakan dengan tenaga kesehatan. Catatan makanan dan beratmu tetap tersimpan. | ✓ | ✓ | ✓ |
| `target_below_minimum_energy` | Mealora tidak bisa membuat target yang aman | Dengan data ini, target yang tersisa terlalu dekat dengan kebutuhan istirahatmu untuk disebut program penurunan berat. Tidak ada target yang dibuat. | Coba Makan Sehat atau Pertahankan, atau bicarakan dengan tenaga kesehatan. | ✓ | ✓ | ✓ |
| `requested_pace_too_fast` | Tanggalnya terlalu dekat | Berat dan tanggal yang kamu isi memerlukan laju di atas batas yang Mealora pakai. Tidak ada target yang dibuat. | Tanggal paling awal yang memenuhi batas adalah **{tanggal}**. Kamu bisa memakai tanggal itu atau mengubah berat tujuan. | ✓ | ✓ | ✓ |
| `requested_pace_too_slow` | Tanggalnya terlalu jauh | Berat dan tanggal yang kamu isi menghasilkan perubahan yang terlalu kecil untuk dijadikan target. Tidak ada target yang dibuat. | Coba tanggal yang lebih dekat, atau pilih Pertahankan. | ✓ | ✓ | ✓ |
| `target_weight_out_of_range` | Berat tujuannya di luar rentang | Berat tujuan yang kamu isi berada di luar rentang yang Mealora dukung untuk tinggi badanmu. Tidak ada target yang dibuat. | Coba berat tujuan lain, atau pilih Makan Sehat. | ✓ | ✓ | ✓ |
| `missing_required_input` | Masih ada yang kosong | Mealora butuh **{daftar masukan}** sebelum bisa menghitung. Belum ada target yang dibuat. | Lengkapi datanya, lalu lihat pratinjau targetnya. | ✓ | ✓ | ✓ |

### 5.1 Peringatan dan pencatatan tanpa angka

| Keadaan | Kalimat | D | J | S |
|---|---|---|---|---|
| D5 — target dinaikkan ke lantai | Target harianmu dinaikkan agar tidak di bawah kebutuhan istirahatmu, jadi pengurangannya lebih kecil daripada perhitungan awal. | ✓ | ✓ | ✓ |
| E2 — laju dibatasi persentase berat | Lajunya dibatasi **{x} kg per minggu**, menyesuaikan berat badanmu saat ini. | ✓ | ✓ | ✓ |
| F12 — karbohidrat di bawah 45 % | Proporsi karbohidrat pada target ini sedikit di bawah rentang yang umum dianjurkan. | ✓ | ✓ | ✓ |
| C4 — seluruh angka | Semua angka ini perkiraan dari rumus, bukan hasil pengukuran. | ✓ | ✓ | ✓ |
| B3/B8 — Makan Sehat tanpa angka (usia atau riwayat gangguan makan) | Kamu bisa mencatat makanan seperti biasa. Mealora tidak menampilkan target kalori untuk kondisi ini. | ✓ | ✓ | ✓ |

Pemeriksaan larangan: tidak ada baris yang menyebut nama penyakit sebagai
kesimpulan Mealora (D); tidak ada baris yang menjanjikan berat tertentu pada
tanggal tertentu (J); tidak ada baris yang memakai kata "gagal", "salah", atau
memposisikan pengguna sebagai penyebab (S).

## Lampiran A — Urutan perhitungan baku

Urutan ini dipakai oleh seluruh vektor uji emas.

1. **Kelayakan** dinilai lebih dulu (B1–B11, E7–E8). Bila hasilnya bukan
   "disetujui", proses berhenti; tidak ada nilai yang dihitung — kecuali Makan
   Sehat pada B3/B8, yang berjalan tanpa energi maupun makro.
2. **Energi istirahat** `RMR` dari C1/C2 — nilai penuh, tanpa pembulatan.
3. **Pengeluaran energi harian** `TDEE = RMR × pengali` (C3) — tanpa pembulatan.
4. **Target energi mentah** per program (D1/D8/D10/D12), defisit atau surplus
   dibatasi lebih dulu oleh D2/D9.
5. **Lantai** diterapkan berurutan: D3 (energi istirahat), lalu D4 (1.200/1.500),
   lalu D7 (800 kkal keras). Bila ada lantai yang mengikat, catat peringatan D5.
6. **Uji D6**: bila defisit tersisa < 300 kkal → tolak, proses berhenti.
7. **Pembulatan target energi** ke kelipatan 10 kkal terdekat (G1). Seluruh
   langkah berikut memakai **nilai yang sudah dibulatkan** ini.
8. **Berat acuan** = min(berat saat ini, berat setara IMT 23 pada tinggi profil),
   dibulatkan ke 0,1 kg (G3, F1/F2).
9. **Protein (g)** = bulatkan(g per kg × berat acuan), lalu pagar F5/F6.
10. **Lemak (g)** = bulatkan(persentase energi × target energi ÷ 9).
11. **Karbohidrat (g)** = bulatkan((target energi − protein_g × 4 − lemak_g × 9) ÷ 4).
12. Bila proporsi karbohidrat < 45 %, ulangi langkah 10–11 mengikuti F11, lalu F12.
13. **Serat (g)** = bulatkan(14 × target energi ÷ 1.000), dibatasi 20–38 g (F9/F10).
14. **Persentase energi** dihitung dari gram yang sudah dibulatkan terhadap target
    energi yang sudah dibulatkan.

Pembulatan memakai aturan **setengah ke atas** (0,5 dibulatkan menjauhi nol).
Faktor energi: protein 4 kkal/g, karbohidrat 4 kkal/g, lemak 9 kkal/g.
