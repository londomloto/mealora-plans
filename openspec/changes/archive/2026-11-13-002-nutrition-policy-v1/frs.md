# Functional Requirements Specification

## Mealora — Kebijakan Gizi Tervalidasi v1

| | |
|---|---|
| Change | 002-nutrition-policy-v1 |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Final untuk Mealora MVP 1 — lihat `docs/nutrition-policy-v1.md` |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Aturan yang menentukan siapa yang boleh menerima target kalori dan gizi otomatis dari Mealora, dan siapa yang diarahkan ke tenaga kesehatan.
- Cara Mealora memperkirakan kebutuhan energi harian seseorang dan bagaimana tingkat aktivitas memengaruhinya.
- Besaran pengurangan dan penambahan kalori untuk program Turun Berat dan Naik Berat, beserta batas asupan terendah yang tidak boleh dilewati.
- Laju penurunan dan penambahan berat badan yang boleh dijanjikan aplikasi, serta perlakuan terhadap tanggal tujuan yang diminta pengguna.
- Target protein, lemak, karbohidrat, dan serat harian.
- Aturan pembulatan angka, kapan target dihitung ulang, dan keharusan pengguna menyetujui target baru sebelum berlaku.
- Daftar alasan penolakan beserta cara Mealora menjelaskannya kepada pengguna.
- Penandaan versi kebijakan pada setiap target yang disetujui, sehingga target lama tetap dapat dijelaskan di kemudian hari.

### 1.2 Deferred Items (Not in This FRS Version)

- Tampilan dan alur layar yang memakai aturan ini. Dokumen ini menetapkan aturannya; layar pemilihan program, pratinjau target, dan persetujuan dikirim pada change berikutnya.
- Target vitamin dan mineral. Angka Kecukupan Gizi Indonesia dipakai sebagai pembanding, bukan sebagai target yang dihitung aplikasi.
- Penyesuaian target secara otomatis berdasarkan hasil yang dicapai pengguna.
- Panduan gizi untuk kondisi medis, kehamilan, menyusui, anak, dan remaja. Kelompok ini justru dikecualikan oleh dokumen ini.
- Rekomendasi menu, resep, atau jadwal makan.

**Catatan status:** seluruh angka dalam dokumen ini sudah melalui tinjauan teknis terhadap pedoman publik dan terhadap kesesuaiannya untuk populasi dewasa Indonesia, dengan hasil tercatat per baris di `docs/nutrition-policy-v1-technical-review.md`. Kebijakan ini final untuk Mealora MVP 1 (`design.md` D13).

## 2. Kelayakan Menerima Target Otomatis

### 2.1 User Story

As a pengguna yang ingin memulai program,
I want Mealora jujur ketika kondisi saya berada di luar yang bisa ia tangani dengan aman,
So that saya tidak mengikuti angka yang tidak pantas diberikan aplikasi kepada saya.

### 2.2 Functional Scope

- Mealora memeriksa kelayakan sebelum menghitung angka apa pun. Hasilnya salah satu dari: target disetujui, perlu diperbaiki pengguna, perlu ditinjau tenaga kesehatan, atau profil di luar cakupan.
- Aturan ini berlaku untuk orang dewasa berusia 19 sampai 64 tahun.
- Pengguna di bawah 19 tahun tidak menerima program yang mengubah berat badan dalam bentuk apa pun.
- Pengguna 65 tahun ke atas tetap dapat memakai Makan Sehat dan Pertahankan; untuk Turun Berat dan Naik Berat, Mealora mengarahkan ke tenaga kesehatan.
- Pengguna yang menyatakan sedang hamil tidak menerima program Turun Berat; untuk program lain diarahkan ke tenaga kesehatan. Hal yang sama berlaku untuk masa menyusui.
- Pengguna dengan berat badan tergolong kurang tidak menerima program Turun Berat. Pengguna dengan berat badan jauh di atas rentang yang didukung diarahkan ke tenaga kesehatan untuk program yang mengubah berat; Makan Sehat dan Pertahankan tetap tersedia.
- Pengguna yang menyatakan memiliki riwayat gangguan makan, diabetes, penyakit ginjal, penyakit hati, atau pengobatan yang memengaruhi berat badan dan nafsu makan diarahkan ke tenaga kesehatan.
- Pengguna yang beratnya berubah lebih dari 5 persen dalam 30 hari terakhir tanpa disengaja diarahkan ke tenaga kesehatan.
- Bila data yang dibutuhkan belum lengkap, Mealora menyebutkan data mana yang kurang, bukan sekadar menolak.
- Setiap penolakan menjelaskan bahwa tidak ada target yang dibuat dan menawarkan langkah berikutnya, misalnya program Makan Sehat yang tidak memakai target berat.
- **Tidak termasuk:** Mealora tidak mendeteksi kondisi medis. Pemeriksaan ini sepenuhnya bergantung pada apa yang dinyatakan pengguna.

### 2.3 Acceptance Criteria

2.3.1. The system shall evaluate eligibility before calculating any target value.

2.3.2. The system shall return exactly one outcome per request: approved, needs user correction, needs professional review, unsupported profile, or missing validated policy.

2.3.3. The system shall refuse every weight-changing program for a profile under 19 years of age, and shall run the healthy-eating program without energy or macronutrient targets for that profile.

2.3.3a. The system shall run the healthy-eating program without energy or macronutrient targets for a profile that declares a current or past eating disorder.

2.3.4. The system shall refer profiles aged 65 or over to a health professional for weight-loss and weight-gain programs, while keeping healthy-eating and maintenance programs available.

2.3.5. The system shall refuse a weight-loss program for a profile that declares pregnancy or breastfeeding, and shall refer the remaining programs to a health professional.

2.3.6. The system shall refuse a weight-loss program for a profile whose body mass index is below 18.5.

2.3.6a. The system shall refer a profile whose body mass index is 37.5 or above to a health professional for weight-loss and weight-gain programs.

2.3.7. The system shall refer a profile that declares an eating disorder, diabetes, kidney disease, liver disease, or weight-affecting medication to a health professional.

2.3.8. The system shall refer a profile reporting more than 5 percent unintended body-weight change within the last 30 days to a health professional.

2.3.9. The system shall name the missing information when required input is incomplete.

2.3.10. The system shall state, in every refusal, that no target has been created, and shall offer a next step.

---

## 3. Perkiraan Kebutuhan Energi

### 3.1 User Story

As a pengguna yang mengisi profil,
I want melihat perkiraan kebutuhan energi harian saya beserta dasarnya,
So that saya mengerti dari mana angka target saya berasal dan bisa menilai apakah itu masuk akal.

### 3.2 Functional Scope

- Mealora memperkirakan kebutuhan energi istirahat dari berat badan, tinggi badan, usia, dan masukan biologis yang dipakai persamaan energi.
- Pengguna memilih satu dari tiga tingkat aktivitas: Lebih banyak duduk, Cukup bergerak, atau Sangat aktif. Pilihan ini menaikkan perkiraan kebutuhan energi harian.
- Kedua angka selalu disebut sebagai perkiraan. Mealora tidak menyebutnya hasil pengukuran, diagnosis, atau jaminan.
- Pengguna dapat melihat dasar perhitungan: data profil yang dipakai, tingkat aktivitas yang dipilih, dan versi persamaan yang berlaku.
- **Tidak termasuk:** pengukuran metabolisme yang sebenarnya. Perkiraan dari rumus selalu meleset pada sebagian orang, dan Mealora menyatakan hal itu alih-alih menyembunyikannya.

### 3.3 Acceptance Criteria

3.3.1. The system shall estimate resting energy from body weight, height, age, and the biological input used by the energy equation.

3.3.2. The system shall offer exactly three activity levels and apply a defined multiplier to each.

3.3.3. The system shall label estimated resting energy and estimated daily energy as estimates, and shall not present them as measurements, diagnoses, or guarantees.

3.3.4. The system shall make the profile data, activity level, and equation version used for a target visible to the user.

---

## 4. Target Harian per Program

### 4.1 User Story

As a pengguna yang memilih salah satu dari empat program,
I want target harian yang sesuai program saya dan tidak pernah turun ke tingkat yang tidak aman,
So that saya bisa mengikuti program tanpa mempertaruhkan kesehatan saya.

### 4.2 Functional Scope

- **Turun Berat:** target harian adalah kebutuhan energi harian dikurangi 20 persen, dengan pengurangan paling sedikit 300 kkal dan paling banyak 750 kkal per hari.
- Target Turun Berat tidak pernah berada di bawah kebutuhan energi istirahat pengguna, dan tidak pernah di bawah 1.200 kkal untuk perempuan atau 1.500 kkal untuk laki-laki. Bila perhitungan menembus batas itu, target dinaikkan ke batas tersebut dan pengguna diberi tahu bahwa pengurangannya menjadi lebih kecil.
- Bila batas tersebut menyisakan pengurangan kurang dari 300 kkal per hari, Mealora menyatakan tidak dapat membuat target otomatis dan mengarahkan ke tenaga kesehatan.
- **Naik Berat:** target harian adalah kebutuhan energi harian ditambah 10 persen, dengan penambahan paling sedikit 250 kkal dan paling banyak 500 kkal per hari.
- **Pertahankan:** target harian sama dengan kebutuhan energi harian, dengan rentang toleransi 5 persen, sekurang-kurangnya 100 kkal, yang masih dianggap sesuai target.
- **Makan Sehat:** target harian sama dengan kebutuhan energi harian, tanpa pengurangan maupun penambahan, dan tanpa mewajibkan target berat. Kemajuannya diukur dari kelengkapan pencatatan dan kesesuaian gizi, bukan dari persentase perubahan berat.
- **Tidak termasuk:** target di bawah 800 kkal per hari tidak pernah dibuat dalam keadaan apa pun.

### 4.3 Acceptance Criteria

4.3.1. The system shall set the weight-loss daily target to estimated daily energy minus 20 percent, with the reduction constrained to between 300 and 750 kcal per day.

4.3.2. The system shall not set any weight-loss target below the profile's estimated resting energy.

4.3.3. The system shall not set any weight-loss target below 1,200 kcal per day for a female biological input or 1,500 kcal per day for a male biological input.

4.3.4. The system shall raise the target to the applicable floor and warn the user that the reduction is smaller than calculated, when the calculated target falls below that floor.

4.3.5. The system shall refuse an automatic weight-loss target and refer the user to a health professional when the applicable floor leaves a daily reduction of less than 300 kcal.

4.3.6. The system shall set the weight-gain daily target to estimated daily energy plus 10 percent, with the increase constrained to between 250 and 500 kcal per day.

4.3.7. The system shall set the maintenance daily target equal to estimated daily energy, and shall treat consumption within 5 percent, or at least 100 kcal, of that target as on target.

4.3.8. The system shall set the healthy-eating daily target equal to estimated daily energy, shall apply no deficit or surplus, and shall not require a target weight.

4.3.9. The system shall not display weight-progress percentages for a healthy-eating program.

4.3.10. The system shall not produce any daily target below 800 kcal.

---

## 5. Laju Perubahan Berat dan Tanggal Tujuan

### 5.1 User Story

As a pengguna yang punya tanggal tertentu di kepala,
I want Mealora berterus terang ketika tanggal itu menuntut laju yang tidak aman,
So that saya bisa memilih target yang realistis alih-alih mengejar jadwal yang tidak mungkin.

### 5.2 Functional Scope

- Penurunan berat yang dijanjikan berada antara 0,25 dan 0,75 kg per minggu, dan tidak melebihi 0,75 persen berat badan per minggu — yang mana lebih kecil.
- Penambahan berat yang dijanjikan berada antara 0,125 dan 0,5 kg per minggu.
- Tanggal tujuan bersifat opsional. Tidak mengisinya tidak menghalangi program dimulai.
- Bila berat tujuan dan tanggal tujuan menuntut laju di luar batas, Mealora menjelaskan konfliknya, menyebutkan tanggal paling awal yang memenuhi batas, dan meminta pengguna mengubah masukannya.
- Mealora tidak pernah memotong atau menyesuaikan target secara diam-diam agar cocok dengan tanggal yang diminta.
- **Tidak termasuk:** janji bahwa berat tertentu akan tercapai pada tanggal tertentu. Laju selalu disebut sebagai perkiraan.

### 5.3 Acceptance Criteria

5.3.1. The system shall constrain promised weight loss to between 0.25 and 0.75 kg per week, and to no more than 0.75 percent of current body weight per week, whichever is lower.

5.3.2. The system shall constrain promised weight gain to between 0.125 and 0.5 kg per week.

5.3.3. The system shall allow a program to be activated without a target date.

5.3.4. The system shall explain the conflict and state the earliest date that satisfies the limits, when the requested target weight and date require a rate outside those limits.

5.3.5. The system shall not silently adjust a target to fit a requested date.

5.3.6. The system shall present any rate of weight change as an estimate and shall not promise a specific result on a specific date.

---

## 6. Target Zat Gizi Harian

### 6.1 User Story

As a pengguna yang ingin makan dengan komposisi yang masuk akal,
I want target protein, lemak, karbohidrat, dan serat yang sesuai program dan ukuran tubuh saya,
So that saya punya sasaran harian yang jelas, bukan sekadar angka kalori.

### 6.2 Functional Scope

- Target protein dihitung dari berat badan: lebih tinggi saat program Turun Berat, karena kebutuhan mempertahankan massa otot meningkat ketika kalori dikurangi.
- Untuk pengguna dengan indeks massa tubuh di atas 30, perhitungan protein memakai berat badan acuan yang lebih rendah agar targetnya tetap realistis.
- Target lemak ditetapkan pada seperempat energi harian, dalam rentang yang dianjurkan.
- Target karbohidrat adalah sisa energi setelah protein dan lemak.
- Target serat mengikuti besarnya energi harian, dengan batas bawah dan batas atas yang wajar.
- Bila komposisi membuat karbohidrat jatuh di bawah rentang yang dianjurkan, Mealora menyesuaikan lemak lebih dulu, lalu protein. Bila setelah itu karbohidrat masih di bawah rentang, target tetap diusulkan disertai pemberitahuan kepada pengguna.
- **Tidak termasuk:** target vitamin dan mineral, serta aturan gizi untuk kondisi medis tertentu.

### 6.3 Acceptance Criteria

6.3.1. The system shall calculate the protein target from a reference body weight, using a higher amount per kilogram for a weight-loss program than for other programs.

6.3.2. The system shall use a reference body weight corresponding to a body mass index of 25 when the profile's body mass index exceeds 30.

6.3.3. The system shall keep the protein target within 10 to 35 percent of daily energy and not below 0.8 g per kilogram of reference body weight.

6.3.4. The system shall set the fat target at 25 percent of daily energy, within a range of 20 to 35 percent.

6.3.5. The system shall set the carbohydrate target as the remaining energy, targeting a range of 45 to 65 percent of daily energy.

6.3.6. The system shall set the fibre target at 14 g per 1,000 kcal of daily energy, not below 20 g and not above 38 g.

6.3.7. The system shall reduce fat first, then protein, when the carbohydrate share falls below the recommended range.

6.3.8. The system shall still propose the target, together with a notice to the user, when the carbohydrate share remains below the recommended range after those adjustments.

6.3.9. The system shall keep the combined energy of the macronutrient targets consistent with the daily energy target within rounding tolerance.

---

## 7. Versi Kebijakan, Pembulatan, dan Revisi Target

### 7.1 User Story

As a pengguna yang memakai Mealora berbulan-bulan,
I want target lama saya tetap bisa dijelaskan meski aturannya diperbarui, dan target baru tidak berlaku tanpa persetujuan saya,
So that saya tetap memegang kendali atas program saya sendiri.

### 7.2 Functional Scope

- Setiap target yang pengguna setujui disimpan bersama versi aturan, versi persamaan, dan salinan data yang dipakai saat menghitung.
- Pembaruan aturan di kemudian hari tidak mengubah target yang sudah disetujui. Target lama tetap menampilkan nilai dan asumsi aslinya.
- Angka kalori dibulatkan ke kelipatan 10 kkal, zat gizi ke gram terdekat, dan berat badan ke 0,1 kg terdekat.
- Mealora mengusulkan perhitungan ulang ketika berat terbaru berbeda 2 kg atau lebih dari berat yang dipakai saat target dibuat, ketika data profil atau tingkat aktivitas berubah, atau ketika target sudah berumur 90 hari atau lebih.
- Target hasil perhitungan ulang hanya berlaku setelah pengguna meninjau dan menyetujuinya. Bila pengguna tidak menyetujui, target lama tetap berlaku.
- Bila aturan untuk sebuah profil memang tidak ada, Mealora tidak membuat target apa pun dan menjelaskan alasannya tanpa menampilkan angka — bukan menebak nilai pengganti.
- **Tidak termasuk:** perubahan target otomatis tanpa persetujuan pengguna.

### 7.3 Acceptance Criteria

7.3.1. The system shall store the policy version, equation version, and the input snapshot used, with every target the user approves.

7.3.2. The system shall leave previously approved targets, their values, and their assumptions unchanged when a newer policy version becomes available.

7.3.3. The system shall round energy targets to the nearest 10 kcal, nutrient targets to the nearest gram, and body weight to the nearest 0.1 kg.

7.3.4. The system shall propose a recalculation when the latest weight differs by 2 kg or more from the weight used for the current target, when profile data or activity level changes, or when the current target is 90 days old or older.

7.3.5. The system shall keep the previous target in force until the user explicitly approves a recalculated target.

7.3.6. The system shall produce no target values, and shall state the reason, whenever the applicable policy does not cover the profile.

---

## 8. High Level Test Scenarios

8.1. **Profil di luar cakupan** — Pengguna 16 tahun menyelesaikan profil dan meminta pratinjau target → Mealora menyatakan tidak ada target yang dibuat, menjelaskan alasannya, dan tidak menampilkan satu pun angka kalori → Makan Sehat tetap dapat diaktifkan sebagai pencatatan tanpa angka target.

8.2. **Pengguna dewasa yang tercakup** — Perempuan 29 tahun, 165 cm, 68,4 kg, cukup bergerak, memilih Turun Berat → Mealora menampilkan perkiraan kebutuhan harian 2.250 kkal dan target 1.800 kkal beserta dasar perhitungannya → pengguna dapat menyetujuinya.

8.3. **Pengguna di bawah umur** — Profil 17 tahun memilih Turun Berat → Mealora menolak, menyatakan program pengubah berat tidak tersedia untuk usia tersebut, dan tidak menampilkan angka target.

8.4. **Pengguna menyatakan hamil** — Profil menyatakan sedang hamil, memilih Turun Berat → Mealora menolak, menjelaskan kebutuhan gizi kehamilan memerlukan pendampingan tenaga kesehatan, dan menawarkan Makan Sehat.

8.5. **Berat badan kurang** — Profil dengan indeks massa tubuh 17,8 memilih Turun Berat → Mealora menolak dan tidak membuat target pengurangan kalori.

8.6. **Batas bawah kalori bekerja** — Profil laki-laki dengan kebutuhan istirahat 1.700 kkal dan aktivitas rendah memilih Turun Berat → target dinaikkan ke 1.700 kkal dan pengguna diberi tahu bahwa pengurangannya lebih kecil dari perhitungan awal.

8.7. **Mealora menyerah dengan jujur** — Profil yang batas bawahnya menyisakan pengurangan kurang dari 300 kkal → Mealora menyatakan tidak dapat membuat target otomatis dan mengarahkan ke tenaga kesehatan, bukan memaksakan angka.

8.8. **Tanggal tujuan terlalu cepat** — Pengguna meminta turun 6 kg dalam 4 minggu → Mealora menjelaskan laju maksimum yang berlaku, menyebut tanggal paling awal yang memenuhi batas, dan meminta pengguna mengubah masukan → tidak ada target yang dibuat sampai masukan diperbaiki.

8.9. **Tanpa tanggal tujuan** — Pengguna mengisi berat tujuan tanpa tanggal → program tetap dapat diaktifkan.

8.10. **Makan Sehat tanpa target berat** — Pengguna memilih Makan Sehat dan tidak mengisi berat tujuan → program aktif, target kalori sama dengan kebutuhan harian, dan tidak ada persentase kemajuan berat di layar mana pun.

8.11. **Target lama tetap utuh** — Pengguna menyetujui target, lalu aturan diperbarui ke versi berikutnya → target lama tetap menampilkan nilai, asumsi, dan versi aslinya di riwayat.

8.12. **Revisi perlu persetujuan** — Berat pengguna turun 3,1 kg dari berat saat target dibuat → Mealora menawarkan target baru → pengguna menutup layar tanpa menyetujui → target lama tetap berlaku dan riwayat tidak berubah.

8.13. **Bahasa penolakan** — Setiap skenario penolakan di atas diperiksa teksnya → tidak ada kalimat yang menyampaikan diagnosis, menjanjikan hasil, atau menyalahkan pengguna.
