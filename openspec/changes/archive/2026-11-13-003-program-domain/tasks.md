## 1. mealora-mobile — Value object dan tipe hasil

- [x] 1.1 Baca ulang `docs/mealora_product_assessment_v1.1.md` §37–§48, spec change 002, dan layar `10`–`12`, `25`–`28`, `36`, `39` di `docs/mealora-v2.pen` sebelum menulis kode, agar bentuk masukan dan keluaran domain sesuai kebutuhan nyata
- [x] 1.2 Buat value object bersatuan di `lib/domain/`: energi (kkal), massa (kg), panjang (cm), tanggal lokal, dan persentase — masing-masing menolak nilai bukan-angka, tak hingga, dan nilai di luar rentang yang masuk akal
- [x] 1.3 Terapkan pembulatan kanonis di satu tempat per satuan: energi ke 10 kkal, zat gizi ke 1 g, massa ke 0,1 kg; pembulatan hanya pada nilai akhir, bukan nilai antara
- [x] 1.4 Buat tipe hasil tertutup dengan lima keadaan: `approved`, `needs_user_correction`, `needs_professional_review`, `unsupported_profile`, `missing_validated_policy`
- [x] 1.5 Buat enum kode alasan sesuai daftar tertutup di spec `nutrition-policy`; tidak ada kalimat bebas di domain dan tidak ada teks antarmuka pengguna
- [x] 1.6 Uji: satuan tidak dapat tertukar, nilai tidak sah ditolak, pembulatan konsisten pada nilai batas

## 2. mealora-mobile — NutritionCalculator

- [x] 2.1 Definisikan antarmuka kalkulator yang menerima fakta fisiologis dan mengembalikan perkiraan energi istirahat, perkiraan energi harian, asumsi, peringatan, dan `calculator_version`
- [x] 2.2 Implementasikan persamaan Mifflin–St Jeor sebagai `msj-1.0.0` dengan konstanta bernama dan terdokumentasi — tidak ada angka telanjang di dalam rumus
- [x] 2.3 Implementasikan tiga pengali aktivitas (1,2 / 1,55 / 1,725) sebagai data kebijakan yang dibaca, bukan konstanta yang ditanam di kalkulator
- [x] 2.4 Implementasikan validasi masukan kalkulator: usia, tinggi, berat, dan masukan biologis wajib ada dan berada dalam rentang yang masuk akal
- [x] 2.5 Pastikan kalkulator tidak mengetahui kode program, status program, defisit, surplus, maupun kebijakan apa pun
- [x] 2.6 Uji golden energi dari vektor change 002: profil acuan dan seluruh kasus batas masukan, membandingkan nilai sebelum dan sesudah pembulatan
- [x] 2.7 Uji yang membuktikan kalkulator tidak memuat rujukan apa pun ke tipe program atau status program

## 3. mealora-mobile — Katalog program

- [x] 3.1 Definisikan empat program sebagai data acuan domain dengan kode `weight_loss`, `weight_gain`, `maintenance`, `healthy_eating` beserta nama tampilan Turun Berat, Naik Berat, Pertahankan, Makan Sehat
- [x] 3.2 Definisikan masukan yang diminta per program sesuai spec `program-catalog`, termasuk berat tujuan wajib untuk dua program dan tanggal tujuan yang selalu opsional
- [x] 3.3 Definisikan penanda ketersediaan program sehingga program dapat ditarik tanpa menghapus definisinya
- [x] 3.4 Pastikan kode program yang dipakai di sini sama persis dengan yang akan dipakai seed tabel katalog pada change berikutnya
- [x] 3.5 Uji: katalog berisi tepat empat program, Makan Sehat tidak meminta berat tujuan, program yang ditarik hilang dari pilihan tetapi definisinya tetap dapat dibaca untuk riwayat

## 4. mealora-mobile — ProgramEngine: kelayakan

- [x] 4.1 Implementasikan pemeriksaan masukan wajib per program, mengembalikan `needs_user_correction` dengan `missing_required_input` beserta daftar masukan yang kurang
- [x] 4.2 Implementasikan aturan usia: di bawah 19 tahun `unsupported_profile` dengan `age_below_minimum`; 65 tahun ke atas `needs_professional_review` dengan `age_above_supported` untuk Turun Berat dan Naik Berat saja
- [x] 4.3 Implementasikan aturan kehamilan dan menyusui: `unsupported_profile` untuk Turun Berat, `needs_professional_review` untuk Naik Berat dan Pertahankan
- [x] 4.4 Implementasikan aturan IMT: di bawah 18,5 menolak Turun Berat dengan `underweight_bmi`; 40 ke atas `needs_professional_review` untuk program pengubah berat
- [x] 4.5 Implementasikan aturan kondisi yang dinyatakan dan perubahan berat tidak disengaja lebih dari 5 persen dalam 30 hari
- [x] 4.6 Pastikan setiap penolakan mengembalikan kode alasan bertipe dan tidak menghasilkan satu pun nilai target
- [x] 4.7 Uji setiap aturan kelayakan pada nilai tepat di bawah, tepat pada, dan tepat di atas ambangnya

## 5. mealora-mobile — ProgramEngine: kebijakan target

- [x] 5.1 Muat nilai kebijakan dari berkas data `np-1.0.0` change 002; jangan menanam angka kebijakan di dalam kode mesin
- [x] 5.2 Implementasikan target Turun Berat: defisit 20 persen dengan batas 300–750 kkal, lantai energi istirahat, lantai 1.200/1.500 kkal, peringatan saat lantai menaikkan target, dan `target_below_minimum_energy` saat defisit tersisa kurang dari 300 kkal
- [x] 5.3 Implementasikan target Naik Berat: surplus 10 persen dengan batas 250–500 kkal
- [x] 5.4 Implementasikan target Pertahankan beserta pita toleransi 5 persen dengan minimum 100 kkal
- [x] 5.5 Implementasikan target Makan Sehat: sama dengan pengeluaran energi harian, tanpa defisit maupun surplus, tanpa target berat, dan tanpa nilai kemajuan berat
- [x] 5.6 Implementasikan target makro dan serat beserta berat badan acuan pada IMT di atas 30, serta urutan penyesuaian saat karbohidrat jatuh di bawah 45 persen energi
- [x] 5.7 Implementasikan batas laju perubahan berat dan penanganan tanggal tujuan: jelaskan konflik dan tawarkan tanggal paling awal yang memenuhi batas, jangan pernah memotong target diam-diam
- [x] 5.8 Implementasikan `missing_validated_policy` sebagai perilaku bawaan ketika kebijakan belum disetujui, tidak tersedia, atau tidak mencakup kasus tersebut
- [x] 5.9 Sertakan `policy_version` dan `calculator_version` pada setiap proposal yang dikembalikan
- [x] 5.10 Jalankan seluruh vektor uji emas change 002 sebagai uji regresi; setiap kasus harus lolos, termasuk setiap kode alasan
- [x] 5.11 Uji bahwa kebijakan yang berstatus draf menghasilkan `missing_validated_policy` dan tidak ada angka target yang bocor ke hasil

## 6. mealora-mobile — Mesin keadaan siklus hidup

- [x] 6.1 Definisikan enam keadaan dan tabel perpindahan sesuai spec `program-lifecycle`, dengan `completed`, `changed`, dan `cancelled` sebagai keadaan akhir
- [x] 6.2 Implementasikan kesalahan bertipe untuk perpindahan tidak sah, memuat keadaan saat ini dan perpindahan yang diminta
- [x] 6.3 Hasilkan uji matriks untuk seluruh pasangan (keadaan, perintah) dari tabel perpindahan; tidak boleh ada pasangan tanpa hasil yang ditegaskan
- [x] 6.4 Rumuskan invarian satu program berjalan sebagai aturan domain yang dapat diperiksa, siap ditegakkan ulang oleh basis data pada change berikutnya

## 7. mealora-mobile — Perintah siklus hidup

- [x] 7.1 Implementasikan perintah aktivasi: baca ulang fakta profil terkini, verifikasi proposal masih sesuai, wajibkan konfirmasi pengguna, tolak setiap hasil yang tidak disetujui
- [x] 7.2 Implementasikan pembatalan aktivasi ketika fakta berubah sejak pratinjau, dengan hasil bertipe yang menyatakan masukan telah berubah
- [x] 7.3 Implementasikan perintah pergantian sebagai satu kesatuan: tandai program lama `changed`, catat waktu berakhir, tautkan dua arah, catat peristiwa, aktifkan program baru
- [x] 7.4 Implementasikan pengembalian keadaan penuh saat pergantian gagal, diuji dengan kegagalan yang disuntikkan pada setiap langkah
- [x] 7.5 Implementasikan jeda dan lanjutkan sebagai rentang peristiwa, sehingga seluruh riwayat jeda tetap dapat ditelusuri setelah program dilanjutkan
- [x] 7.6 Implementasikan selesaikan dengan alasan dan ringkasan akhir, serta batalkan untuk program yang masih draf
- [x] 7.7 Implementasikan idempotensi perintah berulang dengan maksud yang sama, tanpa peristiwa ganda dan tanpa mengubah waktu mulai jeda
- [x] 7.8 Simpan salinan masukan, target yang disetujui, asumsi, peringatan, `calculator_version`, dan `policy_version` pada setiap program yang diaktifkan
- [x] 7.9 Uji seluruh perintah terhadap penyimpanan tiruan dalam memori — tanpa Drift dan tanpa basis data sungguhan

## 8. mealora-mobile — Uji properti dan gate verifikasi

- [x] 8.1 Uji properti: target yang dihasilkan tidak pernah melewati batas kebijakan mana pun, pada masukan acak dalam rentang yang sah
- [x] 8.2 Uji properti: tidak ada hasil yang memuat NaN atau nilai tak hingga
- [x] 8.3 Uji properti: urutan perintah siklus hidup acak tidak pernah menghasilkan dua program berjalan
- [x] 8.4 Uji arsitektur: lapisan domain tidak mengimpor Flutter, Drift, pustaka jaringan, jam global, atau pembangkit pengenal langsung
- [x] 8.5 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; seluruhnya harus hijau, lalu laporkan hasil beserta risiko yang tersisa
