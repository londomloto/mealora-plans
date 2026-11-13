# nutrition-policy Specification

## Purpose
Aturan gizi normatif Mealora: menentukan apakah sebuah profil berhak menerima target energi dan gizi otomatis, berapa nilai targetnya, berapa laju perubahan berat yang boleh dijanjikan, dan mengapa sebuah permintaan ditolak atau dibatasi — berikut versi kebijakan dan rujukan ilmiah yang melandasinya.

## Requirements

### Requirement: Kebijakan berversi

Sistem SHALL mengenali kebijakan gizi melalui pengenal versi. Kebijakan pertama SHALL bernama `np-1.0.0` dengan versi kalkulator energi `msj-1.0.0`. Setiap target yang disetujui pengguna SHALL menyimpan kedua versi tersebut beserta salinan masukan yang dipakai saat perhitungan.

Ketika kebijakan tidak mencakup sebuah profil atau program, sistem SHALL mengembalikan `unsupported_profile` atau `needs_professional_review` dengan kode alasan yang sesuai, dan SHALL TIDAK menghasilkan angka target dalam bentuk apa pun. Sistem SHALL TIDAK menebak nilai untuk kasus yang tidak diatur kebijakan.

#### Scenario: Profil di luar cakupan kebijakan

- **WHEN** pengguna meminta pratinjau target untuk profil yang tidak dicakup `np-1.0.0`
- **THEN** sistem mengembalikan keadaan tidak-disetujui dengan kode alasan yang sesuai, menjelaskan bahwa tidak ada target yang dibuat, dan tidak menampilkan angka energi maupun makro

#### Scenario: Versi tercatat pada target yang disetujui

- **WHEN** pengguna menyetujui sebuah target
- **THEN** target itu tersimpan bersama versi kebijakan, versi kalkulator, dan salinan masukan yang dipakai

#### Scenario: Kebijakan baru tidak mengubah riwayat

- **WHEN** versi kebijakan yang lebih baru tersedia
- **THEN** target yang sudah disetujui sebelumnya tetap menyimpan nilai, asumsi, dan versi aslinya sampai pengguna menyetujui revisi target yang baru

### Requirement: Kelayakan profil untuk target otomatis

Sistem SHALL menilai kelayakan sebelum menghitung target apa pun, dan SHALL mengembalikan salah satu keadaan: disetujui, `needs_user_correction`, `needs_professional_review`, atau `unsupported_profile`.

Kebijakan `np-1.0.0` berlaku untuk orang dewasa berusia **19 sampai 64 tahun**. Aturan kelayakan:

- Usia di bawah 19 tahun: sistem SHALL mengembalikan `unsupported_profile` untuk seluruh program yang mengubah berat, dengan alasan `age_below_minimum`. Program Makan Sehat SHALL tetap dapat diaktifkan, tetapi SHALL berjalan tanpa target energi maupun target zat gizi makro — persamaan `msj-1.0.0` hanya berlaku untuk orang dewasa, dan kebutuhan remaja mengikuti kurva pertumbuhan yang tidak dicakup kebijakan ini.
- Usia 65 tahun ke atas: sistem SHALL mengembalikan `needs_professional_review` untuk Turun Berat dan Naik Berat dengan alasan `age_above_supported`; Makan Sehat dan Pertahankan SHALL tetap tersedia.
- Kehamilan atau menyusui: sistem SHALL mengembalikan `unsupported_profile` untuk Turun Berat dengan alasan `pregnancy_or_lactation`, dan `needs_professional_review` untuk Naik Berat dan Pertahankan.
- Indeks massa tubuh di bawah 18,5: sistem SHALL menolak Turun Berat dengan alasan `underweight_bmi`.
- Indeks massa tubuh 37,5 ke atas: sistem SHALL mengembalikan `needs_professional_review` untuk Turun Berat dan Naik Berat dengan alasan `bmi_above_supported`. Ambang ini mengikuti titik aksi kesehatan masyarakat untuk populasi Asia, bukan ambang obesitas kelas III global.
- Kondisi atau pengobatan yang dinyatakan pengguna — gangguan makan saat ini atau di masa lalu, diabetes, penyakit ginjal, penyakit hati, atau pengobatan yang memengaruhi berat badan maupun nafsu makan: sistem SHALL mengembalikan `needs_professional_review` dengan alasan `declared_medical_condition`.
- Gangguan makan saat ini atau di masa lalu yang dinyatakan pengguna: program Makan Sehat SHALL tetap dapat diaktifkan, tetapi SHALL berjalan tanpa target energi maupun target zat gizi makro dan tanpa menampilkan angka kalori harian.
- Perubahan berat tidak disengaja lebih dari 5 persen berat badan dalam 30 hari terakhir: sistem SHALL mengembalikan `needs_professional_review` dengan alasan `rapid_unintended_weight_change`.

Masukan wajib yang belum lengkap SHALL menghasilkan `needs_user_correction` dengan alasan `missing_required_input`, dan sistem SHALL menyebut masukan mana yang kurang.

#### Scenario: Pengguna di bawah usia minimum

- **WHEN** profil berusia 17 tahun meminta program Turun Berat
- **THEN** sistem mengembalikan `unsupported_profile` dengan alasan `age_below_minimum` dan tidak menghitung defisit apa pun

#### Scenario: Pengguna menyatakan sedang hamil

- **WHEN** profil menyatakan sedang hamil dan meminta program Turun Berat
- **THEN** sistem mengembalikan `unsupported_profile` dengan alasan `pregnancy_or_lactation`, menjelaskan bahwa kebutuhan gizi kehamilan memerlukan pendampingan tenaga kesehatan, dan menawarkan Makan Sehat sebagai alternatif tanpa target perubahan berat

#### Scenario: Berat badan kurang meminta penurunan berat

- **WHEN** profil dengan indeks massa tubuh 17,8 meminta program Turun Berat
- **THEN** sistem menolak dengan alasan `underweight_bmi` dan tidak menghasilkan target defisit

#### Scenario: Kondisi medis dinyatakan

- **WHEN** profil menyatakan memiliki penyakit ginjal dan meminta program Naik Berat
- **THEN** sistem mengembalikan `needs_professional_review` dengan alasan `declared_medical_condition` dan menjelaskan bahwa target otomatis tidak dibuat

#### Scenario: Masukan wajib belum lengkap

- **WHEN** profil belum memuat tinggi badan dan pengguna meminta pratinjau target
- **THEN** sistem mengembalikan `needs_user_correction` dengan alasan `missing_required_input` dan menyebut bahwa tinggi badan belum diisi

### Requirement: Estimasi energi istirahat dan pengeluaran energi harian

Sistem SHALL mengestimasi energi istirahat dengan persamaan Mifflin–St Jeor menggunakan berat badan dalam kilogram, tinggi badan dalam sentimeter, dan usia dalam tahun penuh:

- masukan biologis laki-laki: `10 × berat + 6,25 × tinggi − 5 × usia + 5`
- masukan biologis perempuan: `10 × berat + 6,25 × tinggi − 5 × usia − 161`

Sistem SHALL mengestimasi pengeluaran energi harian dengan mengalikan energi istirahat dengan pengali aktivitas berikut, sesuai tiga pilihan aktivitas yang tersedia bagi pengguna:

| Pilihan pengguna | Pengali |
|---|---|
| Lebih banyak duduk | 1,40 |
| Cukup bergerak | 1,60 |
| Sangat aktif | 1,80 |

Pengali ini mengikuti pita *physical activity level* FAO/WHO/UNU 2004 untuk orang dewasa yang hidup bebas: 1,40–1,69 untuk gaya hidup menetap atau ringan, dan 1,70–1,99 untuk aktif sedang. Sistem SHALL mengambil nilai di bagian bawah pita yang berlaku, karena persamaan `msj-1.0.0` mengestimasi energi istirahat yang sedikit lebih tinggi daripada energi basal yang menjadi dasar pita tersebut.

Sistem SHALL menyajikan kedua nilai tersebut sebagai perkiraan, dan SHALL TIDAK menyebutnya sebagai hasil pengukuran, diagnosis, atau jaminan.

#### Scenario: Perhitungan energi istirahat perempuan

- **WHEN** profil perempuan berusia 29 tahun, tinggi 165 cm, berat 68,4 kg dihitung
- **THEN** energi istirahat adalah 1.410 kkal setelah pembulatan (nilai sebelum pembulatan 1.409,25), dan pengeluaran energi harian pada tingkat "Cukup bergerak" adalah 2.250 kkal setelah pembulatan (nilai sebelum pembulatan 2.254,80)

#### Scenario: Nilai disebut sebagai perkiraan

- **WHEN** sistem menampilkan energi istirahat atau pengeluaran energi harian
- **THEN** nilai itu diberi label sebagai perkiraan, bukan hasil pengukuran atau jaminan

### Requirement: Target energi program Turun Berat

Untuk program Turun Berat, sistem SHALL menghitung target energi harian sebagai pengeluaran energi harian dikurangi defisit sebesar **20 persen** dari pengeluaran energi harian, dibatasi pada rentang **300 sampai 750 kkal per hari**.

Sistem SHALL menerapkan batas bawah asupan: target energi harian SHALL TIDAK berada di bawah energi istirahat profil tersebut, dan SHALL TIDAK berada di bawah **1.200 kkal** untuk masukan biologis perempuan maupun **1.500 kkal** untuk masukan biologis laki-laki. Bila perhitungan menghasilkan nilai di bawah batas bawah, sistem SHALL menaikkan target ke batas bawah dan menyertakan peringatan bahwa defisit yang dihasilkan lebih kecil dari permintaan.

Bila batas bawah membuat defisit yang tersisa kurang dari 300 kkal per hari, sistem SHALL mengembalikan `needs_professional_review` dengan alasan `target_below_minimum_energy` dan SHALL TIDAK mengaktifkan target defisit otomatis.

Sistem SHALL TIDAK menghasilkan target di bawah 800 kkal per hari dalam keadaan apa pun.

#### Scenario: Defisit normal

- **WHEN** profil dengan pengeluaran energi harian 2.255 kkal dan energi istirahat 1.409 kkal memilih Turun Berat
- **THEN** defisit 20 persen bernilai 451 kkal, target energi harian menjadi 1.800 kkal setelah pembulatan, dan nilainya berada di atas energi istirahat maupun batas 1.200 kkal

#### Scenario: Batas bawah asupan menaikkan target

- **WHEN** profil dengan masukan biologis laki-laki, energi istirahat 1.163 kkal, dan pengeluaran energi harian 1.860 kkal memilih Turun Berat
- **THEN** perhitungan defisit menghasilkan 1.488 kkal yang berada di bawah batas 1.500 kkal, sehingga target dinaikkan menjadi 1.500 kkal, defisit yang tersisa 360 kkal, dan proposal disertai peringatan bahwa defisitnya lebih kecil daripada hasil perhitungan awal

#### Scenario: Defisit tersisa terlalu kecil

- **WHEN** profil dengan masukan biologis perempuan, energi istirahat 1.068 kkal, dan pengeluaran energi harian 1.495 kkal memilih Turun Berat
- **THEN** batas bawah 1.200 kkal menyisakan defisit 295 kkal per hari, sehingga sistem mengembalikan `needs_professional_review` dengan alasan `target_below_minimum_energy` dan tidak mengaktifkan target defisit

### Requirement: Target energi program Naik Berat

Untuk program Naik Berat, sistem SHALL menghitung target energi harian sebagai pengeluaran energi harian ditambah surplus sebesar **10 persen** dari pengeluaran energi harian, dibatasi pada rentang **250 sampai 500 kkal per hari**.

#### Scenario: Surplus normal

- **WHEN** profil dengan pengeluaran energi harian 2.255 kkal memilih Naik Berat
- **THEN** surplus 10 persen bernilai 225 kkal sehingga dinaikkan ke batas bawah 250 kkal, dan target energi harian menjadi 2.500 kkal setelah pembulatan

#### Scenario: Surplus dibatasi batas atas

- **WHEN** profil dengan pengeluaran energi harian 5.400 kkal memilih Naik Berat
- **THEN** surplus dibatasi pada 500 kkal dan target energi harian menjadi 5.900 kkal

### Requirement: Target energi program Pertahankan dan Makan Sehat

Untuk program Pertahankan, sistem SHALL menetapkan target energi harian sama dengan pengeluaran energi harian, dengan pita toleransi **±5 persen** dan sekurang-kurangnya **±100 kkal**. Konsumsi di dalam pita tersebut SHALL dianggap sesuai target.

Untuk program Makan Sehat, sistem SHALL menetapkan target energi harian sama dengan pengeluaran energi harian, SHALL TIDAK menerapkan defisit maupun surplus, dan SHALL TIDAK mewajibkan target berat. Kemajuan program Makan Sehat SHALL diukur dari kelengkapan pencatatan dan kesesuaian terhadap rentang gizi, dan SHALL TIDAK menampilkan persentase kemajuan berat badan.

#### Scenario: Pita toleransi Pertahankan

- **WHEN** target Pertahankan adalah 2.250 kkal, sehingga pita toleransi 5 persen membentang 2.140 sampai 2.360 kkal setelah pembulatan, dan konsumsi hari itu 2.200 kkal
- **THEN** hari tersebut dinilai berada di dalam pita toleransi

#### Scenario: Makan Sehat tanpa target berat

- **WHEN** pengguna mengaktifkan Makan Sehat tanpa mengisi target berat
- **THEN** program dapat diaktifkan, target energi sama dengan pengeluaran energi harian, dan tidak ada persentase kemajuan berat yang ditampilkan

### Requirement: Laju perubahan berat dan tanggal tujuan

Sistem SHALL membatasi laju perubahan berat yang dijanjikan:

- Turun Berat: **0,25 sampai 0,75 kg per minggu**, dan tidak lebih dari **0,75 persen berat badan saat ini per minggu**, mana yang lebih kecil.
- Naik Berat: **0,125 sampai 0,5 kg per minggu**.

Bila kombinasi berat tujuan dan tanggal tujuan yang diminta pengguna memerlukan laju di luar batas tersebut, sistem SHALL mengembalikan `needs_user_correction` dengan alasan `requested_pace_too_fast` atau `requested_pace_too_slow`, SHALL menjelaskan konflik beserta tanggal paling awal yang memenuhi batas, dan SHALL meminta masukan yang lebih aman. Sistem SHALL TIDAK memotong target secara diam-diam agar sesuai tanggal yang diminta.

Sistem SHALL menolak berat tujuan yang menghasilkan indeks massa tubuh di bawah **18,5** pada tinggi profil tersebut, dan berat tujuan yang arahnya berlawanan dengan program yang dipilih — berat tujuan lebih tinggi dari berat saat ini pada Turun Berat, atau lebih rendah pada Naik Berat. Keduanya SHALL mengembalikan `needs_user_correction` dengan alasan `target_weight_out_of_range`, dan SHALL menyebut rentang berat tujuan yang didukung.

Tanggal tujuan SHALL bersifat opsional. Ketidakhadiran tanggal tujuan SHALL TIDAK menghalangi aktivasi program.

#### Scenario: Tanggal tujuan terlalu cepat

- **WHEN** pengguna meminta turun 6 kg dalam 4 minggu
- **THEN** sistem mengembalikan `needs_user_correction` dengan alasan `requested_pace_too_fast`, menyebut laju maksimum yang berlaku, dan menawarkan tanggal paling awal yang memenuhi batas

#### Scenario: Tanpa tanggal tujuan

- **WHEN** pengguna mengisi berat tujuan tanpa tanggal tujuan
- **THEN** sistem tetap menghasilkan proposal target dan tidak mewajibkan tanggal

#### Scenario: Batas persentase berat badan berlaku

- **WHEN** profil dengan berat 52 kg meminta laju 0,75 kg per minggu
- **THEN** sistem membatasi laju pada 0,39 kg per minggu karena batas 0,75 persen berat badan lebih kecil, dan menjelaskan pembatasan itu

### Requirement: Target protein, lemak, karbohidrat, dan serat

Sistem SHALL menghitung target zat gizi makro dari target energi harian dan berat badan acuan. Berat badan acuan SHALL berupa nilai terkecil antara berat badan saat ini dan berat badan yang setara dengan indeks massa tubuh 23 pada tinggi profil tersebut. Ambang 23 mengikuti klasifikasi indeks massa tubuh Asia-Pasifik, dan bentuk "nilai terkecil" membuat batas ini berlaku tanpa lompatan nilai pada titik ambang.

- **Protein**: 1,6 g per kg berat badan acuan untuk Turun Berat; 1,4 g per kg untuk Naik Berat, Pertahankan, dan Makan Sehat. Nilai akhir SHALL berada dalam rentang 10 sampai 35 persen energi dan SHALL TIDAK kurang dari 0,8 g per kg berat badan acuan.
- **Lemak**: 25 persen energi, dalam rentang 20 sampai 35 persen energi.
- **Karbohidrat**: sisa energi setelah protein dan lemak, dengan sasaran rentang 45 sampai 65 persen energi.
- **Serat**: 14 g per 1.000 kkal target energi, dibulatkan ke gram terdekat, sekurang-kurangnya 20 g dan sebanyak-banyaknya 38 g.

Bila karbohidrat jatuh di bawah 45 persen energi, sistem SHALL menyesuaikan dengan urutan: turunkan lemak hingga batas 20 persen energi, lalu turunkan protein hingga batas 1,2 g per kg berat badan acuan. Bila karbohidrat masih di bawah 45 persen energi setelah kedua penyesuaian itu, sistem SHALL tetap mengusulkan target tersebut disertai peringatan bahwa proporsi karbohidrat berada di bawah rentang distribusi yang dianjurkan.

Jumlah energi dari ketiga zat gizi makro SHALL konsisten dengan target energi harian dalam toleransi pembulatan.

#### Scenario: Target makro program Turun Berat

- **WHEN** target energi harian 1.800 kkal dengan berat badan acuan 62,6 kg pada program Turun Berat
- **THEN** target protein 100 g (22,2 persen energi), lemak 50 g (25,0 persen energi), karbohidrat 238 g (52,8 persen energi), dan serat 25 g, dan seluruh nilai berada dalam rentang distribusi yang berlaku

#### Scenario: Penyesuaian saat karbohidrat terlalu rendah

- **WHEN** kombinasi protein dan lemak awal menyisakan karbohidrat 41 persen energi
- **THEN** sistem menurunkan lemak lebih dulu, lalu protein bila masih perlu, dan menyertakan peringatan bila karbohidrat tetap di bawah 45 persen energi

#### Scenario: Berat badan acuan pada obesitas

- **WHEN** profil setinggi 165 cm dengan berat 110 kg menghitung target protein
- **THEN** berat badan acuan yang dipakai adalah 62,6 kg — berat yang setara indeks massa tubuh 23 pada tinggi tersebut — bukan 110 kg

### Requirement: Pembulatan dan penyajian nilai

Sistem SHALL membulatkan target energi ke kelipatan **10 kkal** terdekat, target zat gizi makro dan serat ke **gram** terdekat, dan berat badan ke **0,1 kg** terdekat. Pembulatan SHALL dilakukan hanya pada nilai akhir yang disajikan dan disimpan, bukan pada nilai antara.

#### Scenario: Pembulatan target energi

- **WHEN** perhitungan menghasilkan 1.803,84 kkal
- **THEN** target yang disajikan dan disimpan adalah 1.800 kkal

### Requirement: Hitung ulang target dan persetujuan revisi

Sistem SHALL mengusulkan perhitungan ulang target ketika salah satu keadaan berikut terjadi: berat badan terbaru berbeda **2 kg atau lebih** dari berat pada salinan masukan target yang berlaku, tingkat aktivitas atau data profil berubah, atau target yang berlaku sudah berumur **90 hari atau lebih**.

Target hasil perhitungan ulang SHALL TIDAK berlaku sebelum pengguna meninjau dan menyetujuinya secara eksplisit. Sampai persetujuan diberikan, target yang berlaku SHALL tetap target sebelumnya, dan riwayat SHALL TIDAK berubah.

#### Scenario: Berat berubah melewati ambang

- **WHEN** berat terbaru 3,1 kg lebih rendah daripada berat pada salinan masukan target yang berlaku
- **THEN** sistem mengusulkan revisi target dan meminta persetujuan pengguna, sementara target lama tetap berlaku

#### Scenario: Revisi tidak disetujui

- **WHEN** pengguna menutup layar revisi tanpa menyetujui
- **THEN** target lama tetap berlaku dan tidak ada nilai riwayat yang berubah

### Requirement: Kode alasan dan bahasa yang dilihat pengguna

Setiap keadaan tidak-disetujui atau target yang dibatasi SHALL menyertakan kode alasan yang dapat dipetakan ke penjelasan berbahasa Indonesia yang aman bagi pengguna. Kode alasan yang berlaku pada `np-1.0.0`: `age_below_minimum`, `age_above_supported`, `pregnancy_or_lactation`, `underweight_bmi`, `bmi_above_supported`, `declared_medical_condition`, `rapid_unintended_weight_change`, `target_below_minimum_energy`, `requested_pace_too_fast`, `requested_pace_too_slow`, `target_weight_out_of_range`, dan `missing_required_input`.

Penjelasan yang dilihat pengguna SHALL menyebut hasil sebagai perkiraan, SHALL TIDAK menjanjikan hasil penurunan atau penambahan berat, SHALL TIDAK menyampaikan diagnosis, dan SHALL TIDAK memberikan terapi gizi medis atau penanganan gejala.

#### Scenario: Penolakan dijelaskan secara aman

- **WHEN** sistem menolak sebuah permintaan target
- **THEN** pengguna melihat penjelasan berbahasa Indonesia yang menyebut alasan penolakan, menyatakan bahwa tidak ada target yang dibuat, dan menawarkan langkah berikutnya tanpa menyampaikan diagnosis

#### Scenario: Tidak ada janji hasil

- **WHEN** sistem menampilkan target atau laju perubahan berat
- **THEN** teks menyebutnya sebagai perkiraan dan tidak menjanjikan hasil tertentu pada tanggal tertentu
