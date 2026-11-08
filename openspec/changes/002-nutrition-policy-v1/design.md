# Design — 002 · Kebijakan gizi tervalidasi v1

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: belum ada kebijakan gizi apa pun; change 001 baru membangun kerangka aplikasi dan penyimpanan lokal. Assessment §40 menetapkan bahwa dokumen teknis hanya boleh menentukan *batas rekayasa*, sedangkan nilai klinis harus disetujui dan diberi versi oleh peninjau gizi atau medis sebelum dipakai di rilis publik.

Change ini berisi rancangan nilai beserta dasarnya, bukan kode. Sasarannya adalah dokumen yang cukup spesifik untuk diimplementasikan apa adanya dan cukup transparan untuk ditolak atau dikoreksi peninjau per baris.

## Goals / Non-Goals

**Goals**

- Setiap angka di `specs/nutrition-policy/spec.md` punya dasar yang dapat ditelusuri ke pedoman publik, dan setiap penyimpangan dari pedoman dinyatakan sebagai keputusan, bukan diselundupkan.
- Perilaku gagal tertutup dapat diuji: profil yang tidak tercakup tidak pernah menerima angka.
- Vektor uji emas menjadi jaring pengaman regresi untuk setiap perubahan kebijakan berikutnya.
- Kebijakan dapat diganti versinya tanpa menyentuh target yang pernah disetujui pengguna.

**Non-Goals**

- Bukan terapi gizi medis, bukan penanganan gejala, bukan panduan untuk kondisi klinis.
- Tidak menetapkan target mikronutrien (vitamin dan mineral) — AKG Indonesia dipakai sebagai rujukan pembanding, bukan sebagai target yang dihitung aplikasi.
- Tidak ada penyesuaian target adaptif berdasarkan hasil pengguna; itu pekerjaan masa depan di luar MVP 1.
- Tidak mengimplementasikan `ProgramEngine` — itu change berikutnya.

## Decisions

### D1 — Mifflin–St Jeor, bukan Harris–Benedict atau Katch–McArdle

Mifflin–St Jeor dipilih sesuai assessment §13 dan praktik dietetik arus utama untuk orang dewasa ketika kalorimetri tidak langsung tidak tersedia. Harris–Benedict cenderung melebihkan estimasi pada populasi masa kini; Katch–McArdle memerlukan persentase lemak tubuh yang tidak dimiliki Mealora. Persamaan diberi versi `msj-1.0.0` supaya penggantian persamaan di masa depan terlihat jelas di riwayat.

*Batas yang diakui:* persamaan prediktif tetap meleset pada individu. Inilah sebabnya seluruh UI menyebut hasilnya perkiraan, dan mengapa hitung ulang terjadwal (90 hari / perubahan berat 2 kg) lebih berguna daripada presisi semu di awal.

### D2 — Tiga tingkat aktivitas, bukan lima

Desain `09 · Aktivitas harian` menyediakan tiga pilihan. Memakai lima pengali (1,2 / 1,375 / 1,55 / 1,725 / 1,9) memaksa pemetaan yang tidak jujur dari tiga pilihan, atau mengubah desain. Dipilih tiga pengali: **1,2**, **1,55**, dan **1,725**.

1,9 sengaja tidak dipakai: tingkat itu menggambarkan atlet atau pekerja fisik berat dua sesi per hari, populasi yang bukan sasaran MVP dan yang kesalahannya paling mahal (surplus atau defisit yang jauh meleset). Pengguna seperti itu akan dilayani lebih baik oleh koreksi manual target di kemudian hari.

*Catatan kejujuran:* skema 1,2/1,375/1,55/1,725/1,9 beredar luas di kalkulator populer, tetapi penelusuran ke sumber primernya tidak sebersih yang diasumsikan orang — Academy of Nutrition and Dietetics sendiri memakai *rentang* kategori aktivitas, bukan lima nilai tunggal. Karena itu pengali di sini diperlakukan sebagai **pilihan produk yang harus disetujui peninjau**, bukan sebagai fakta ilmiah yang sudah final. Peninjau boleh menggantinya tanpa mengubah struktur kebijakan.

### D3 — Defisit 20 persen dengan batas 300–750 kkal

Pedoman AHA/ACC/TOS 2013 menyebut defisit 500–750 kkal/hari sebagai salah satu pendekatan yang diterima. Mealora memakai defisit **proporsional** (20 persen TDEE) alih-alih angka tetap, karena 500 kkal bagi orang dengan TDEE 1.600 adalah pemotongan 31 persen, sedangkan bagi TDEE 3.000 hanya 17 persen. Batas bawah 300 kkal menjaga agar program tetap bermakna; batas atas 750 kkal mengikuti batas atas pedoman.

### D4 — Batas bawah energi berlapis: energi istirahat, lalu 1.200/1.500 kkal

Pedoman AHA/ACC/TOS 2013 menyebut asupan 1.200–1.500 kkal/hari untuk perempuan dan 1.500–1.800 kkal/hari untuk laki-laki sebagai cara lazim mencapai defisit ≥500 kkal, dan menyatakan diet sangat rendah kalori (<800 kkal) hanya untuk keadaan terbatas di bawah pengawasan. Mealora mengambil **batas bawah rentang itu** sebagai lantai mutlak, lalu menambahkan lantai kedua: target tidak pernah di bawah energi istirahat profil itu sendiri.

Lantai energi istirahat penting untuk pengguna bertubuh besar dengan aktivitas rendah: pada pengali 1,2, defisit 20 persen bisa menembus energi istirahat. Dalam kasus itu target dinaikkan dan pengguna diberi tahu bahwa defisitnya lebih kecil dari perhitungan awal — bukan dibiarkan diam-diam.

Bila lantai menyisakan defisit kurang dari 300 kkal, kebijakan menyerah secara eksplisit (`needs_professional_review`). Ini pilihan sadar: lebih baik mengaku tidak sanggup daripada menjual program yang nyaris tidak menghasilkan apa-apa.

### D5 — Surplus 10 persen dengan batas 250–500 kkal

Penambahan berat yang terlalu cepat sebagian besar menjadi massa lemak. Surplus proporsional 10 persen dengan lantai 250 kkal dan plafon 500 kkal sejalan dengan laju 0,125–0,5 kg/minggu yang ditetapkan kebijakan (sekitar 7.700 kkal per kg jaringan).

*Alternatif:* surplus tetap 300–500 kkal untuk semua orang. Ditolak karena sama tidak adilnya dengan defisit tetap.

### D6 — Protein berbasis berat badan, dengan berat acuan pada obesitas

Protein 1,2–1,6 g/kg/hari didukung tinjauan Leidy dkk. (2015) dan Phillips dkk. untuk pengelolaan berat dan mempertahankan massa bebas lemak, jauh di atas RDA 0,8 g/kg yang merupakan kecukupan minimum, bukan nilai optimal. Dipilih **1,6 g/kg saat defisit** (kebutuhan mempertahankan massa otot paling tinggi justru ketika energi dikurangi) dan **1,4 g/kg** untuk program lain.

Pada indeks massa tubuh di atas 30, berat badan acuan diturunkan ke berat setara IMT 25. Tanpa aturan ini, pengguna 140 kg akan menerima target protein 224 g/hari — tidak realistis dan tidak bermanfaat, karena jaringan lemak tidak menambah kebutuhan protein secara proporsional.

### D7 — Lemak 25 persen, karbohidrat sebagai sisa, dengan urutan penyesuaian

AMDR dewasa (IOM 2005, dipakai Dietary Guidelines): karbohidrat 45–65 persen, lemak 20–35 persen, protein 10–35 persen energi. Mealora menetapkan lemak pada 25 persen dan menyisakan karbohidrat, karena protein sudah ditetapkan per kilogram.

Pada defisit dalam dengan protein 1,6 g/kg, karbohidrat bisa jatuh di bawah 45 persen. Urutan penyesuaian (turunkan lemak dulu ke 20 persen, lalu protein ke 1,2 g/kg) dipilih karena menurunkan protein saat defisit justru melawan tujuan mempertahankan massa otot. Bila setelah keduanya karbohidrat tetap di bawah 45 persen, kebijakan **tetap mengusulkan target disertai peringatan** alih-alih menolak: berada di bawah AMDR bukan bahaya akut, sedangkan menolak program karena aritmetika proporsi akan terasa sewenang-wenang bagi pengguna. Peninjau gizi berhak membalik keputusan ini.

### D8 — Serat 14 g per 1.000 kkal

Adequate Intake DRI menetapkan 14 g serat per 1.000 kkal. Pembanding Indonesia: AKG (PMK 28/2019) mencantumkan sekitar 30 g/hari untuk dewasa 30–49 tahun pada energi 2.150 kkal — konsisten dengan 14 g/1.000 kkal. Batas 20–38 g mencegah target yang terlalu rendah pada energi kecil dan terlalu tinggi pada energi besar.

### D9 — Kelayakan: menolak lebih awal, bukan mengoreksi belakangan

Pemisahan tiga keadaan dipakai agar penolakan tetap informatif:

- `unsupported_profile` — kebijakan ini memang tidak mencakup orang tersebut (anak dan remaja, kehamilan untuk Turun Berat). Tidak ada jalan pintas lewat UI.
- `needs_professional_review` — ada orang lain yang lebih berhak menentukan (usia 65+, IMT ≥40, kondisi medis yang dinyatakan, perubahan berat cepat yang tidak disengaja).
- `needs_user_correction` — pengguna bisa memperbaikinya sendiri (masukan kurang, laju yang diminta terlalu cepat).

Ambang perubahan berat tidak disengaja 5 persen dalam 30 hari dipakai karena itu penanda klinis lazim untuk penurunan berat yang perlu ditelusuri sebabnya, bukan dipercepat oleh aplikasi.

*Catatan:* skrining kondisi bergantung pada pernyataan pengguna sendiri. Aplikasi tidak bisa memverifikasinya dan tidak boleh berpura-pura bisa. Yang dijamin kebijakan hanyalah: bila dinyatakan, tidak ada target otomatis.

### D10 — Tanggal tujuan tidak pernah mengesampingkan batas

Bila tanggal yang diminta memerlukan laju di luar batas, sistem menjelaskan konflik dan menawarkan tanggal paling awal yang aman. Memotong target diam-diam akan membuat pengguna mengira tanggalnya tetap tercapai — tepat jenis kebohongan halus yang dilarang assessment §38.

### D11 — Revisi target selalu lewat persetujuan pengguna

Ambang hitung ulang (berat berubah ≥2 kg, profil atau aktivitas berubah, umur target ≥90 hari) dipilih agar target tidak bergerak-gerak karena fluktuasi air tubuh harian. Target baru tidak pernah berlaku diam-diam: pengguna meninjau dan menyetujui, dan riwayat lama tidak ditulis ulang.

### D12 — Kebijakan sebagai data berversi, bukan konstanta yang tersebar

Nilai kebijakan ditulis sebagai satu berkas data berversi yang dibaca mesin program, bukan konstanta yang berserak di kode. Dengan begitu, perbandingan antarversi kebijakan menjadi diff yang bisa ditinjau orang gizi tanpa membaca Dart, dan vektor uji emas bisa diikat ke versi tertentu.

## Dasar rujukan

| Aturan | Nilai `np-1.0.0` | Dasar |
|---|---|---|
| Persamaan energi istirahat | Mifflin–St Jeor | Assessment §13; praktik dietetik untuk dewasa tanpa kalorimetri |
| Pengali aktivitas | 1,2 / 1,55 / 1,725 | Konvensi luas; **keputusan produk**, menunggu persetujuan peninjau |
| Defisit | 20 % TDEE, batas 300–750 kkal | AHA/ACC/TOS 2013: defisit 500–750 kkal/hari |
| Lantai energi | ≥ energi istirahat; ≥1.200 kkal (P) / 1.500 kkal (L); tidak pernah <800 kkal | AHA/ACC/TOS 2013: 1.200–1.500 (P), 1.500–1.800 (L); VLCD <800 hanya dengan pengawasan |
| Laju turun berat | 0,25–0,75 kg/mgg; ≤0,75 %/mgg | Turunan dari defisit 300–750 kkal (±7.700 kkal per kg) |
| Surplus | 10 % TDEE, batas 250–500 kkal | Turunan dari laju 0,125–0,5 kg/mgg |
| Protein | 1,6 g/kg (defisit); 1,4 g/kg (lainnya); ≥0,8 g/kg | Leidy dkk. 2015; Phillips dkk.; RDA sebagai lantai |
| Lemak | 25 % energi (20–35 %) | AMDR, IOM 2005 |
| Karbohidrat | sisa, sasaran 45–65 % | AMDR, IOM 2005 |
| Serat | 14 g/1.000 kkal, 20–38 g | DRI Adequate Intake; pembanding AKG PMK 28/2019 |
| Usia tercakup | 19–64 tahun | Batas populasi sasaran; di luar itu dirujuk |

Pranala rujukan lengkap dicatat di dokumen peninjauan (`docs/nutrition-policy-v1.md`) agar peninjau dapat membuka sumbernya langsung.

## Risks / Trade-offs

- **Angka ini dirancang agen, bukan ahli gizi berlisensi** → risiko paling serius dalam change ini. Mitigasi: kebijakan berstatus draf dan aplikasi gagal tertutup sampai peninjau gizi menyetujui; setiap nilai disajikan dengan dasarnya agar bisa dikoreksi satu per satu.
- **Pengali aktivitas paling lemah dasarnya** di antara seluruh nilai → mitigasi: ditandai eksplisit sebagai keputusan produk di tabel rujukan, dan dampaknya diuji lewat vektor emas sehingga penggantian nilai langsung terlihat akibatnya.
- **Skrining mengandalkan pernyataan pengguna** → pengguna bisa melewatinya dengan tidak menyatakan kondisinya. Mitigasi: pertanyaan skrining dirumuskan netral dan tidak menghakimi; bahasa penolakan tidak membuat pengguna merasa dihukum sehingga tidak terdorong berbohong. Tidak ada klaim bahwa aplikasi mendeteksi kondisi medis.
- **Pengguna dengan riwayat gangguan makan** dapat terpicu oleh target dan angka → mitigasi: `needs_professional_review` bila dinyatakan, Makan Sehat tanpa target berat sebagai jalur alternatif, bahasa yang menolak gagasan hari yang "gagal" (sudah tercermin di desain layar 18 dan 40).
- **Penyimpangan dari AMDR karbohidrat** pada defisit dalam dengan protein tinggi → mitigasi: peringatan eksplisit, bukan diam; peninjau boleh mengubah keputusan ini menjadi penolakan.
- **Kebijakan berubah di kemudian hari** dapat membuat riwayat tampak tidak konsisten → mitigasi: versi kebijakan dan kalkulator tersimpan pada setiap target; riwayat tidak pernah dihitung ulang.

## Migration Plan

Tidak ada data pengguna yang terdampak — belum ada pengguna. Urutan:

1. Dokumen peninjauan `docs/nutrition-policy-v1.md` disusun lengkap dengan pranala rujukan.
2. Vektor uji emas disusun dan ditinjau bersama dokumen kebijakan.
3. Peninjau gizi menyetujui atau mengoreksi; koreksi diterapkan sebelum status berubah menjadi disetujui.
4. Status kebijakan `np-1.0.0` diubah menjadi disetujui, beserta tanggal dan identitas peninjau.
5. Change berikutnya mengimplementasikan `ProgramEngine` terhadap kebijakan ini.

Rollback: selama belum disetujui, aplikasi tetap gagal tertutup, sehingga membatalkan change ini tidak berakibat apa pun pada pengguna. Setelah rilis, perubahan nilai wajib menjadi versi baru (`np-1.1.0` dan seterusnya) lewat change tersendiri — bukan suntingan di tempat.

## Open Questions

Tidak ada pertanyaan yang ditunda. Seluruh nilai sudah ditetapkan; yang tersisa adalah **persetujuan peninjau gizi**, yang merupakan langkah proses dalam `tasks.md`, bukan ketidakpastian rancangan. Bila peninjau mengubah sebuah nilai, perubahannya masuk ke change ini selama masih draf, atau ke versi kebijakan baru bila sudah disetujui.
