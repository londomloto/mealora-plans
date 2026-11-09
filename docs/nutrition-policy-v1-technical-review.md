# Tinjauan Teknis Kebijakan Gizi `np-1.0.0`

| | |
|---|---|
| Kebijakan yang ditinjau | `np-1.0.0` · kalkulator `msj-1.0.0` |
| Dokumen sumber | [`nutrition-policy-v1.md`](./nutrition-policy-v1.md) · [`spec.md`](../openspec/changes/002-nutrition-policy-v1/specs/nutrition-policy/spec.md) |
| Tanggal | 2026-11-08 |
| Change | `002-nutrition-policy-v1` |

## Status dan batas tinjauan ini

Tinjauan ini memeriksa setiap nilai kebijakan terhadap pedoman publik dan terhadap
kesesuaiannya untuk orang dewasa di Indonesia. Hasilnya berupa putusan per baris
beserta dasarnya.

Untuk MVP 1 — aplikasi lokal, pemakaian perorangan — pemilik produk menerima
tinjauan ini sebagai dasar yang memadai dan final (`design.md` D13).

## 1. Ringkasan putusan

66 baris aturan ditinjau.

| Putusan | Jumlah |
|---|---|
| Setuju apa adanya | 50 |
| Setuju dengan catatan | 6 |
| **Diubah** | **8** |
| Dihapus | 2 |

Dua yang dihapus adalah gerbang persetujuan (baris A4) dan kode alasan
`missing_validated_policy` — keputusan pemilik produk, bukan temuan gizi.

## 2. Nilai yang diubah

### U1 — Pengali aktivitas: 1,2 / 1,55 / 1,725 → **1,40 / 1,60 / 1,80**

Baris C3a–C3c. Perubahan paling berdampak dalam tinjauan ini.

**Alasan.** Skema 1,2 / 1,375 / 1,55 / 1,725 / 1,9 berasal dari tradisi kalkulator
web era Harris–Benedict, bukan dari rujukan asupan mana pun. Rujukan yang berlaku
adalah pita *physical activity level* FAO/WHO/UNU 2004, yang mendefinisikan PAL
sebagai pengeluaran energi total dibagi energi basal:

| Kategori | PAL |
|---|---|
| Sangat tidak aktif (mis. terikat kursi) | < 1,40 |
| Menetap atau aktivitas ringan (pekerja kantoran) | 1,40 – 1,69 |
| Aktif sedang | 1,70 – 1,99 |
| Sangat aktif | 2,00 – 2,40 |

**1,2 berada di bawah pita terendah untuk orang dewasa yang hidup bebas.** Nilai itu
menggambarkan orang yang berbaring atau terikat kursi sepanjang hari, bukan orang
yang bekerja sambil duduk. Memakainya berarti mengecilkan kebutuhan energi setiap
pengguna sedenter secara sistematis.

Nilai baru diambil di **batas bawah** tiap pita, bukan tengahnya, dengan dua alasan:
pita PAL disusun terhadap energi *basal* sedangkan Mifflin–St Jeor mengestimasi
energi *istirahat* yang beberapa persen lebih tinggi; dan tingkat aktivitas yang
dilaporkan sendiri cenderung dilebihkan.

**Dampak samping yang ikut selesai.** Pada pengali 1,2, target Turun Berat selalu
bernilai 0,8 × 1,2 = **0,96 kali energi istirahat** — selalu di bawah lantai energi
istirahat. Lantai itu menaikkan target, menyisakan defisit tepat 20 persen dari
energi istirahat, dan setiap pengguna sedenter dengan energi istirahat di bawah
1.500 kkal ditolak dengan `target_below_minimum_energy`. Itu mencakup sebagian
besar perempuan dewasa Indonesia. Pada pengali 1,40 target menjadi 1,12 kali energi
istirahat dan masalahnya hilang seluruhnya.

Contoh — profil acuan (perempuan 29 th, 165 cm, 68,4 kg) pada "Lebih banyak duduk":

| | Sebelum (1,2) | Sesudah (1,40) |
|---|---|---|
| Pengeluaran energi harian | 1.691 kkal | 1.973 kkal |
| Hasil | **ditolak** · `target_below_minimum_energy` | target **1.580 kkal**, defisit 395 kkal |

### U2 — Berat acuan makro: "IMT > 30 → setara IMT 25" → **min(berat saat ini, berat setara IMT 23)**

Baris F2. Dua perubahan sekaligus: ambangnya, dan bentuk aturannya.

**Ambang 25 → 23.** Klasifikasi IMT yang berlaku untuk populasi Asia-Pasifik, dan
dipakai praktik klinis di Indonesia, adalah: normal 18,5–22,9; berat berlebih
≥23; obesitas ≥25. Memakai IMT 25 sebagai "berat acuan yang sehat" untuk pengguna
Indonesia berarti memakai angka yang pada skala itu **sudah tergolong obesitas**.
IMT 23 juga konsisten dengan tubuh acuan AKG PMK 28/2019 sendiri (perempuan 55 kg /
159 cm ≈ IMT 21,8; laki-laki 60 kg / 168 cm ≈ IMT 21,3).

**Bentuk ambang → bentuk `min()`.** Aturan "bila IMT di atas 30" menimbulkan
lompatan: pengguna pada IMT 29,9 memakai berat penuhnya, pada IMT 30,1 tiba-tiba
memakai berat setara IMT 25 — turun 17 persen, dan target proteinnya ikut turun
17 persen dalam satu langkah. Bentuk "nilai terkecil antara berat saat ini dan
berat setara IMT 23" berlaku kontinu: pada IMT tepat 23 kedua nilai sama, sehingga
tidak ada titik patah sama sekali.

### U3 — Ambang rujukan IMT: **≥ 40 → ≥ 37,5**

Baris B7. Ambang 40 adalah batas obesitas kelas III pada skala WHO global. Konsultasi
ahli WHO untuk populasi Asia menambahkan titik aksi kesehatan masyarakat pada
**23 / 27,5 / 32,5 / 37,5**, karena risiko diabetes dan kardiovaskular pada populasi
Asia muncul pada IMT yang lebih rendah. 37,5 adalah padanan terdekat dari maksud
"kelas III" pada skala itu.

### U4 — Kode alasan baru `bmi_above_supported`

Baris B7 dan I1. Sebelumnya IMT tinggi memakai kode `declared_medical_condition`,
padahal pengguna tidak menyatakan kondisi apa pun — kalimat yang dilihat pengguna
akan berbunyi "untuk kondisi yang kamu sebutkan" tanpa ada yang disebutkan. Kode
dan kalimatnya kini terpisah.

### U5 — `target_weight_out_of_range` mendapat aturan pemicu

Baris I1. Kode ini terdaftar tetapi tidak ada satu aturan pun yang memicunya.
Pemicunya kini ditetapkan: berat tujuan yang menghasilkan **IMT di bawah 18,5** pada
tinggi profil, atau berat tujuan yang **arahnya berlawanan** dengan program yang
dipilih.

Batas atas sengaja tidak ditetapkan: berat tujuan pada IMT 24 adalah sasaran antara
yang masuk akal bagi pengguna IMT 32, dan menolaknya akan terasa sewenang-wenang.

### U6 — Usia di bawah 19 tahun: Makan Sehat berjalan **tanpa angka**

Baris B3. Sebelumnya Makan Sehat tetap menampilkan target energi sama dengan
pengeluaran energi harian. Masalahnya: Mifflin–St Jeor divalidasi pada orang
dewasa, dan kebutuhan energi remaja mengikuti kurva pertumbuhan yang tidak dicakup
kebijakan ini. Menampilkan "2.100 kkal" kepada anak 16 tahun berarti menampilkan
angka yang tidak punya dasar.

Pencatatan makanan tetap berjalan. Yang dihilangkan hanya target dan angka
kalori hariannya.

### U7 — Gangguan makan yang dinyatakan: Makan Sehat berjalan **tanpa angka**

Baris B8. Alasannya berbeda dari U6: bukan ketepatan angkanya, melainkan
keberadaannya. Paparan target kalori harian justru hal yang perlu dihindari pada
riwayat gangguan makan. Menolak mereka sepenuhnya juga bukan jawaban — pencatatan
tanpa angka tetap berguna, dan lebih baik daripada mendorong mereka ke aplikasi
yang tidak sehati-hati ini.

### U8 — Gerbang persetujuan dihapus

Baris A4, dan kode `missing_validated_policy`. Keputusan pemilik produk, bukan
temuan gizi; dasarnya ada di `design.md` D13. Perilaku gagal tertutup untuk profil
yang **tidak dicakup kebijakan** tetap berlaku penuh, kini lewat `unsupported_profile`
dan `needs_professional_review`.

## 3. Disetujui dengan catatan

| Baris | Nilai | Catatan |
|---|---|---|
| C1, C2 | Mifflin–St Jeor | Persamaan dengan performa terbaik di antara pilihan umum, tetapi **belum ada validasi kalorimetri pada populasi Indonesia**. Satu laporan pada populasi Asia menyebut kelebihan estimasi sekitar 215 kkal/hari. Akurasinya juga lebih rendah pada obesitas. Inilah alasan hitung ulang berkala (90 hari) lebih berguna daripada presisi semu di awal. |
| F3 | Protein 1,6 g/kg saat defisit | Berada di **batas atas** rentang yang didukung bukti. Angka 1,62 g/kg dari meta-analisis Morton dkk. 2018 berasal dari populasi yang berlatih beban, sedangkan Mealora tidak tahu apakah penggunanya berlatih. Masih dalam rentang 1,2–1,6 g/kg yang dikutip Leidy dkk. 2015 untuk pengelolaan berat, jadi tidak diubah — tetapi antarmuka tidak boleh memperlakukan target protein yang tidak tercapai sebagai kegagalan, karena pola makan berbasis nasi membuat angka ini sulit dicapai. |
| D4 | Lantai 1.200 / 1.500 kkal | Berasal dari pedoman untuk ukuran tubuh Amerika. Untuk perempuan Indonesia bertubuh kecil, 1.200 kkal nyaris menyentuh energi istirahatnya sendiri. Lantai energi istirahat (D3) sudah menanganinya. |
| F9, F10 | Serat 14 g/1.000 kkal, 20–38 g | Konsisten dengan AKG. Asupan serat rata-rata di Indonesia jauh di bawah angka ini, sehingga target ini bersifat aspiratif — antarmuka tidak boleh menghukum pengguna yang tidak mencapainya. |
| B4 | Rujukan usia ≥ 65 | Benar untuk program pengubah berat. Catatan positif: Makan Sehat dan Pertahankan tetap tersedia dengan protein 1,4 g/kg, yang berada di atas anjuran 1,0–1,2 g/kg untuk lansia — jadi kelompok ini tidak dirugikan. |
| B9 | Perubahan berat >5 % / 30 hari | Sesuai kriteria skrining malnutrisi yang lazim (>5 % dalam 1 bulan tergolong berat). Tidak diubah. |

## 4. Dampak terhadap angka profil acuan

Profil acuan: perempuan 29 tahun, 165 cm, 68,4 kg, "Cukup bergerak".
Energi istirahat tidak berubah: 1.409,25 kkal.

| | Sebelum tinjauan | Sesudah tinjauan |
|---|---|---|
| Berat acuan makro | 68,4 kg | **62,6 kg** (IMT 23 pada 165 cm) |
| Pengeluaran energi harian | 2.180 kkal | **2.250 kkal** |
| **Turun Berat** — target | 1.750 kkal | **1.800 kkal** |
| protein | 109 g (24,9 %) | **100 g** (22,2 %) |
| lemak | 49 g (25,2 %) | **50 g** (25,0 %) |
| karbohidrat | 218 g (49,9 %) | **238 g** (52,8 %) |
| serat | 25 g | **25 g** |
| **Naik Berat** — target | 2.430 kkal | **2.500 kkal** |
| protein / lemak / karbohidrat / serat | 96 / 68 / 359 / 34 g | **88 / 69 / 382 / 35 g** |
| **Pertahankan & Makan Sehat** — target | 2.180 kkal | **2.250 kkal** |
| protein / lemak / karbohidrat / serat | 96 / 61 / 312 / 31 g | **88 / 63 / 333 / 32 g** |

Arah perubahannya konsisten: energi naik sekitar 3 persen karena pengali aktivitas
yang lebih jujur, dan protein turun sekitar 8 persen karena berat acuan mengikuti
IMT 23. Keduanya membuat target lebih dekat ke AKG Indonesia untuk kelompok usia
yang sesuai.

## 5. Status temuan T1–T7

| Temuan | Status setelah tinjauan |
|---|---|
| T1 — pengguna sedenter hampir selalu ditolak | **Selesai** oleh U1. |
| T2 — batas bawah defisit 300 kkal tidak pernah mengikat | **Masih berlaku.** Defisit mentah di bawah 300 kkal hanya terjadi bila pengeluaran harian di bawah 1.500 kkal, dan pada keadaan itu lantai 1.200 kkal selalu menolak lebih dulu. Dipertahankan sebagai ambang penolakan (D6), bukan sebagai pembatas defisit. |
| T3 — cabang peringatan karbohidrat <45 % tidak pernah tercapai | **Masih berlaku, dan makin jauh.** Pagar protein 35 % energi dan lemak minimum 20 % menjamin karbohidrat ≥45 %. Berat acuan IMT 23 menurunkan proporsi protein lebih jauh lagi. Dipertahankan sebagai jaring pengaman. |
| T4 — ambiguitas urutan pembulatan makro | **Selesai.** Urutan baku ditulis di Lampiran A dokumen kebijakan dan dipakai seluruh vektor uji. |
| T5 — `target_weight_out_of_range` tanpa aturan pemicu | **Selesai** oleh U5. |
| T6 — IMT tinggi memakai kode kondisi medis | **Selesai** oleh U4. |
| T7 — pembulatan dapat menembus lantai sampai 5 kkal | **Tidak lagi relevan untuk lantai energi istirahat**, karena lantai itu tidak pernah mengikat (lihat U1). Masih mungkin pada lantai 1.200/1.500 kkal, tetapi keduanya kelipatan 10 sehingga pembulatan tidak menembusnya. |

Temuan baru yang muncul dari U1:

| | |
|---|---|
| **T8** | Lantai energi istirahat (D3) kini **tidak pernah mengikat** — target Turun Berat selalu 1,12 kali energi istirahat atau lebih. Dipertahankan sebagai jaring pengaman agar perubahan nilai di masa depan tidak diam-diam menembusnya, bukan karena ia bekerja hari ini. |

## 6. Yang ditunda ke change berikutnya

Dua hal berada di luar cakupan dokumen nilai, tetapi perlu dicatat agar tidak hilang.

**Skrining gangguan makan.** Saat ini bergantung sepenuhnya pada pernyataan sukarela.
Instrumen tervalidasi seperti SCOFF — lima pertanyaan, dua jawaban positif sebagai
ambang rujukan — jauh lebih andal dan layak dipertimbangkan saat layar onboarding
dibangun. Ini celah klinis terbesar yang tersisa.

**Kecukupan mikronutrien.** Kebijakan ini tidak menghitung dan tidak menjamin
vitamin maupun mineral. Pada target mendekati lantai 1.200 kkal, kecukupan zat besi,
kalsium, dan folat sulit tercapai dari makanan saja. Relevan khusus untuk pengguna
perempuan usia subur di Indonesia, yang prevalensi anemianya tinggi — Riskesdas 2013
mencatat 22,7 persen pada perempuan usia 15 tahun ke atas. Program penurunan berat
yang memangkas energi 20 persen memangkas asupan zat besi kurang lebih
seproporsional. Antarmuka tidak boleh memberi kesan bahwa mengikuti target energi
dan makro sudah berarti gizi terpenuhi.

## 7. Rujukan tambahan tinjauan ini

| Kode | Rujukan | Dipakai pada |
|---|---|---|
| R8 | FAO/WHO/UNU. *Human Energy Requirements*, Report of a Joint Expert Consultation. Roma; 2004. (pita PAL) | U1 |
| R9 | WHO Expert Consultation. *Appropriate body-mass index for Asian populations and its implications for policy and intervention strategies.* Lancet. 2004;363(9403):157–163. | U2, U3 |
| R10 | Morton RW, Murphy KT, McKellar SR, dkk. *A systematic review, meta-analysis and meta-regression of the effect of protein supplementation on resistance training-induced gains in muscle mass and strength.* Br J Sports Med. 2018;52(6):376–384. | Bagian 3, F3 |
| R11 | Frankenfield D, Roth-Yousey L, Compher C. *Comparison of predictive equations for resting metabolic rate in healthy nonobese and obese adults: a systematic review.* J Am Diet Assoc. 2005;105(5):775–789. | Bagian 3, C1/C2 |
| R12 | Kementerian Kesehatan RI. Riskesdas 2013 — prevalensi anemia pada perempuan usia ≥15 tahun. | Bagian 6 |

Nilai AKG dan angka Riskesdas yang dikutip berasal dari sumber sekunder dan **perlu
dicocokkan dengan dokumen resmi** sebelum dipakai sebagai klaim di luar dokumen ini.
