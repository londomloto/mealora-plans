# Design — 002 · Kebijakan gizi tervalidasi v1

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: belum ada kebijakan gizi apa pun; change 001 baru membangun kerangka aplikasi dan penyimpanan lokal. Mealora MVP 1 adalah aplikasi lokal untuk pemakaian perorangan; pemilik produk memutuskan kebijakan ini berlaku penuh berdasarkan tinjauan teknis terhadap pedoman publik, tanpa menahan rilisnya di status draf — lihat D13. Yang tetap berlaku: nilai klinis diberi versi, dan kasus yang tidak diatur tidak pernah ditebak.

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

Desain `09 · Aktivitas harian` menyediakan tiga pilihan. Dipilih tiga pengali: **1,40**, **1,60**, dan **1,80**, diambil dari pita *physical activity level* FAO/WHO/UNU 2004 untuk orang dewasa yang hidup bebas — 1,40–1,69 untuk gaya hidup menetap atau ringan, 1,70–1,99 untuk aktif sedang, 2,00–2,40 untuk sangat aktif.

Rancangan awal memakai 1,2 / 1,55 / 1,725, skema yang beredar luas di kalkulator populer. Skema itu ditolak pada tinjauan teknis: **1,2 berada di bawah pita terendah FAO/WHO/UNU**, yang menggambarkan orang berbaring atau terikat kursi, bukan pekerja kantoran. Pemakaiannya juga menimbulkan akibat yang tidak diinginkan — pada pengali 1,2 target defisit 20 persen selalu jatuh di bawah energi istirahat (0,8 × 1,2 = 0,96), sehingga hampir setiap pengguna sedenter ditolak dengan `target_below_minimum_energy`.

Pita 2,00–2,40 sengaja tidak dipakai: tingkat itu menggambarkan atlet atau pekerja fisik berat dua sesi per hari, populasi yang bukan sasaran MVP dan yang kesalahannya paling mahal. Pengguna seperti itu akan dilayani lebih baik oleh koreksi manual target di kemudian hari.

*Catatan ketelitian:* pita PAL disusun terhadap energi **basal**, sedangkan Mifflin–St Jeor mengestimasi energi **istirahat** yang lazimnya beberapa persen lebih tinggi. Karena itu nilai diambil di bagian bawah tiap pita, bukan di tengahnya.

### D3 — Defisit 20 persen dengan batas 300–750 kkal

Pedoman AHA/ACC/TOS 2013 menyebut defisit 500–750 kkal/hari sebagai salah satu pendekatan yang diterima. Mealora memakai defisit **proporsional** (20 persen TDEE) alih-alih angka tetap, karena 500 kkal bagi orang dengan TDEE 1.600 adalah pemotongan 31 persen, sedangkan bagi TDEE 3.000 hanya 17 persen. Batas bawah 300 kkal menjaga agar program tetap bermakna; batas atas 750 kkal mengikuti batas atas pedoman.

### D4 — Batas bawah energi berlapis: energi istirahat, lalu 1.200/1.500 kkal

Pedoman AHA/ACC/TOS 2013 menyebut asupan 1.200–1.500 kkal/hari untuk perempuan dan 1.500–1.800 kkal/hari untuk laki-laki sebagai cara lazim mencapai defisit ≥500 kkal, dan menyatakan diet sangat rendah kalori (<800 kkal) hanya untuk keadaan terbatas di bawah pengawasan. Mealora mengambil **batas bawah rentang itu** sebagai lantai mutlak, lalu menambahkan lantai kedua: target tidak pernah di bawah energi istirahat profil itu sendiri.

Lantai energi istirahat adalah jaring pengaman, bukan aturan yang rutin bekerja. Dengan pengali terendah 1,40, target defisit selalu bernilai 0,8 × 1,40 = **1,12 kali energi istirahat**, sehingga lantai itu tidak pernah mengikat pada aritmetika `np-1.0.0`. Ia dipertahankan agar perubahan nilai di kemudian hari — pengali yang lebih rendah, atau defisit yang lebih dalam — tidak diam-diam mendorong target ke bawah energi istirahat. Bila suatu saat lantai mengikat, target dinaikkan dan pengguna diberi tahu bahwa defisitnya lebih kecil dari perhitungan awal, bukan dibiarkan diam-diam.

Lantai yang benar-benar bekerja adalah 1.200/1.500 kkal, dan itu pun hanya pada profil bertubuh sangat kecil.

Bila lantai menyisakan defisit kurang dari 300 kkal, kebijakan menyerah secara eksplisit (`needs_professional_review`). Ini pilihan sadar: lebih baik mengaku tidak sanggup daripada menjual program yang nyaris tidak menghasilkan apa-apa.

### D5 — Surplus 10 persen dengan batas 250–500 kkal

Penambahan berat yang terlalu cepat sebagian besar menjadi massa lemak. Surplus proporsional 10 persen dengan lantai 250 kkal dan plafon 500 kkal sejalan dengan laju 0,125–0,5 kg/minggu yang ditetapkan kebijakan (sekitar 7.700 kkal per kg jaringan).

*Alternatif:* surplus tetap 300–500 kkal untuk semua orang. Ditolak karena sama tidak adilnya dengan defisit tetap.

### D6 — Protein berbasis berat badan, dengan berat acuan pada obesitas

Protein 1,2–1,6 g/kg/hari didukung tinjauan Leidy dkk. (2015) dan Phillips dkk. untuk pengelolaan berat dan mempertahankan massa bebas lemak, jauh di atas RDA 0,8 g/kg yang merupakan kecukupan minimum, bukan nilai optimal. Dipilih **1,6 g/kg saat defisit** (kebutuhan mempertahankan massa otot paling tinggi justru ketika energi dikurangi) dan **1,4 g/kg** untuk program lain.

Berat badan acuan adalah **nilai terkecil antara berat saat ini dan berat setara IMT 23**. Tanpa batas ini, pengguna 140 kg akan menerima target protein 224 g/hari — tidak realistis dan tidak bermanfaat, karena jaringan lemak tidak menambah kebutuhan protein secara proporsional.

Dua hal diubah pada tinjauan teknis. Ambang IMT 25 diganti **23**, mengikuti klasifikasi Asia-Pasifik yang berlaku di Indonesia (normal 18,5–22,9; berat berlebih ≥23; obesitas ≥25) — memakai 25 sebagai "berat acuan sehat" bagi pengguna Indonesia berarti memakai angka yang pada skala itu sudah tergolong obesitas. Bentuk aturan juga diubah dari "bila IMT di atas 30" menjadi "nilai terkecil", karena bentuk ambang menimbulkan lompatan 17 persen pada target protein tepat di IMT 30; bentuk `min()` berlaku kontinu dan tidak punya titik patah.

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

### D13 — Tanpa status draf menahan seluruh kebijakan; gagal tertutup tetap berlaku untuk cakupan

Rancangan awal menahan seluruh kebijakan di status draf sampai pemilik produk menandainya final di kode, dan memakai kode `missing_validated_policy` sebagai gerbangnya. Gerbang itu **dihapus**: kebijakan `np-1.0.0` berlaku penuh untuk Mealora MVP 1 sejak change ini ditutup, berdasarkan tinjauan teknis yang tercatat di `docs/nutrition-policy-v1-technical-review.md`. Menahan seluruh program menunggu penandaan yang tidak akan datang hanya memblokir change 003 ke atas tanpa menambah keamanan.

Yang **tidak** ikut dihapus adalah perilaku gagal tertutup untuk kasus yang tidak diatur. Profil di luar cakupan — usia di bawah 19, kehamilan, kondisi yang dinyatakan, IMT di luar rentang — tetap tidak menerima angka apa pun, kini lewat `unsupported_profile` dan `needs_professional_review`. Perbedaannya tegas: dulu aplikasi diam karena *belum ada izin*, sekarang aplikasi diam karena *aturannya memang tidak mencakup orang itu*. Yang kedua benar secara permanen; yang pertama hanya benar sampai seseorang menandatangani.

Akibatnya kode `missing_validated_policy` dihapus dari daftar, dan layar `26` berubah dari "Kebijakan belum tersedia" menjadi layar penolakan umum yang isinya ditentukan kode alasan.

### D14 — Profil berisiko mendapat pencatatan tanpa angka, bukan penolakan

Dua kelompok menerima perlakuan khusus pada Makan Sehat: usia di bawah 19 tahun, dan pengguna yang menyatakan gangguan makan saat ini atau di masa lalu. Keduanya tetap dapat memakai Makan Sehat, tetapi **tanpa target energi dan tanpa target makro**.

Alasannya berbeda untuk masing-masing. Untuk usia di bawah 19, Mifflin–St Jeor divalidasi pada orang dewasa dan kebutuhan remaja mengikuti kurva pertumbuhan — menampilkan "2.100 kkal" kepada anak 16 tahun berarti menampilkan angka yang tidak punya dasar. Untuk riwayat gangguan makan, masalahnya bukan ketepatan angkanya melainkan keberadaannya: paparan target kalori harian adalah hal yang justru perlu dihindari.

Alternatif yang ditolak: menolak mereka sepenuhnya. Pencatatan makanan tanpa angka target tetap berguna dan jauh lebih baik daripada mendorong mereka ke aplikasi lain yang tidak sehati-hati ini.

## Dasar rujukan

| Aturan | Nilai `np-1.0.0` | Dasar |
|---|---|---|
| Persamaan energi istirahat | Mifflin–St Jeor | Assessment §13; praktik dietetik untuk dewasa tanpa kalorimetri |
| Pengali aktivitas | 1,40 / 1,60 / 1,80 | Pita PAL FAO/WHO/UNU 2004, diambil di batas bawah tiap pita |
| Defisit | 20 % TDEE, batas 300–750 kkal | AHA/ACC/TOS 2013: defisit 500–750 kkal/hari |
| Lantai energi | ≥ energi istirahat; ≥1.200 kkal (P) / 1.500 kkal (L); tidak pernah <800 kkal | AHA/ACC/TOS 2013: 1.200–1.500 (P), 1.500–1.800 (L); VLCD <800 hanya dengan pengawasan |
| Laju turun berat | 0,25–0,75 kg/mgg; ≤0,75 %/mgg | Turunan dari defisit 300–750 kkal (±7.700 kkal per kg) |
| Surplus | 10 % TDEE, batas 250–500 kkal | Turunan dari laju 0,125–0,5 kg/mgg |
| Protein | 1,6 g/kg (defisit); 1,4 g/kg (lainnya); ≥0,8 g/kg | Leidy dkk. 2015; Phillips dkk.; RDA sebagai lantai |
| Lemak | 25 % energi (20–35 %) | AMDR, IOM 2005 |
| Karbohidrat | sisa, sasaran 45–65 % | AMDR, IOM 2005 |
| Serat | 14 g/1.000 kkal, 20–38 g | DRI Adequate Intake; pembanding AKG PMK 28/2019 |
| Usia tercakup | 19–64 tahun | Batas populasi sasaran; di luar itu dirujuk |
| Berat acuan makro | min(berat saat ini, berat setara IMT 23) | Klasifikasi IMT Asia-Pasifik yang berlaku di Indonesia |
| Ambang rujukan IMT | ≥37,5 | Titik aksi kesehatan masyarakat WHO untuk populasi Asia (23 / 27,5 / 32,5 / 37,5) |

Pranala rujukan lengkap dicatat di dokumen peninjauan (`docs/nutrition-policy-v1.md`) agar peninjau dapat membuka sumbernya langsung.

## Risks / Trade-offs

- **Angka dihitung dari rumus dan pedoman publik, bukan penilaian individual oleh tenaga kesehatan** → risiko inheren aplikasi yang memberi estimasi otomatis. Mitigasi: setiap nilai dapat ditelusuri ke pedoman publik dan tercatat baris per baris di `docs/nutrition-policy-v1.md`; nilai yang merupakan keputusan produk ditandai eksplisit; seluruh aturan diuji lewat vektor uji emas sehingga akibat tiap nilai terlihat; profil di luar cakupan kebijakan tidak pernah menerima angka (gagal tertutup, D13).
- **Pengali aktivitas paling lemah dasarnya** di antara seluruh nilai → mitigasi: ditandai eksplisit sebagai keputusan produk di tabel rujukan, dan dampaknya diuji lewat vektor emas sehingga penggantian nilai langsung terlihat akibatnya.
- **Skrining mengandalkan pernyataan pengguna** → pengguna bisa melewatinya dengan tidak menyatakan kondisinya. Mitigasi: pertanyaan skrining dirumuskan netral dan tidak menghakimi; bahasa penolakan tidak membuat pengguna merasa dihukum sehingga tidak terdorong berbohong. Tidak ada klaim bahwa aplikasi mendeteksi kondisi medis.
- **Pengguna dengan riwayat gangguan makan** dapat terpicu oleh target dan angka → mitigasi: `needs_professional_review` bila dinyatakan, Makan Sehat tanpa target berat sebagai jalur alternatif, bahasa yang menolak gagasan hari yang "gagal" (sudah tercermin di desain layar 18 dan 40).
- **Penyimpangan dari AMDR karbohidrat** pada defisit dalam dengan protein tinggi → mitigasi: peringatan eksplisit, bukan diam; peninjau boleh mengubah keputusan ini menjadi penolakan.
- **Kebijakan berubah di kemudian hari** dapat membuat riwayat tampak tidak konsisten → mitigasi: versi kebijakan dan kalkulator tersimpan pada setiap target; riwayat tidak pernah dihitung ulang.

## Migration Plan

Tidak ada data pengguna yang terdampak — belum ada pengguna. Urutan:

1. Dokumen kebijakan `docs/nutrition-policy-v1.md` disusun lengkap dengan pranala rujukan.
2. Vektor uji emas disusun dari aturan, lalu dihitung ulang secara independen.
3. Tinjauan teknis dijalankan terhadap seluruh nilai; koreksinya diterapkan serempak ke `specs/`, `design.md`, `frs.md`, dokumen kebijakan, berkas data, dan fixture.
4. Berkas data `np-1.0.0` dan fixture diturunkan ke `mealora-apps/mealora-mobile`.
5. Change berikutnya mengimplementasikan `ProgramEngine` terhadap kebijakan ini.

Rollback: belum ada pengguna dan belum ada mesin yang membaca berkas data, sehingga membatalkan change ini tidak berakibat apa pun. Setelah `ProgramEngine` dirilis, perubahan nilai wajib menjadi versi baru (`np-1.1.0` dan seterusnya) lewat change tersendiri — bukan suntingan di tempat.

## Open Questions

Tidak ada pertanyaan yang ditunda. Seluruh nilai sudah ditetapkan dan ditinjau secara teknis (`docs/nutrition-policy-v1-technical-review.md`). Perubahan nilai setelah change ini ditutup wajib menjadi versi kebijakan baru lewat change tersendiri.

Dua hal sengaja ditunda ke change berikutnya, bukan karena ragu melainkan karena di luar cakupan dokumen nilai:

- **Skrining gangguan makan** masih bergantung pada pernyataan sukarela. Instrumen tervalidasi seperti SCOFF (lima pertanyaan) akan jauh lebih andal dan layak dipertimbangkan saat layar onboarding dibangun.
- **Kecukupan mikronutrien** tidak dijamin kebijakan ini. Pada target mendekati lantai 1.200 kkal, kecukupan zat besi, kalsium, dan folat sulit tercapai — relevan khusus untuk pengguna perempuan usia subur di Indonesia. Kebijakan ini tidak boleh dibaca seolah menjamin hal itu.
