## 1. mealora-plans — Dokumen peninjauan kebijakan

- [ ] 1.1 Buat `docs/nutrition-policy-v1.md` dengan kepala dokumen: versi kebijakan `np-1.0.0`, versi kalkulator `msj-1.0.0`, status draf, tanggal, dan kolom untuk identitas serta tanggal persetujuan peninjau
- [ ] 1.2 Salin seluruh nilai dari `specs/nutrition-policy/spec.md` ke dokumen dalam bentuk tabel per aturan — tidak boleh ada nilai di spec yang tidak muncul di dokumen peninjauan
- [ ] 1.3 Lengkapi setiap baris dengan dasar rujukan dan pranala sumber: persamaan Mifflin–St Jeor, pedoman AHA/ACC/TOS 2013 (defisit 500–750 kkal; asupan 1.200–1.500 kkal perempuan dan 1.500–1.800 kkal laki-laki; VLCD <800 kkal hanya dengan pengawasan), AMDR IOM 2005, Adequate Intake serat 14 g/1.000 kkal, dan tinjauan protein Leidy dkk. 2015 serta Phillips dkk.
- [ ] 1.4 Tandai eksplisit nilai yang merupakan keputusan produk, bukan kutipan pedoman — terutama ketiga pengali aktivitas (1,2 / 1,55 / 1,725) dan defisit proporsional 20 persen
- [ ] 1.5 Tambahkan kolom keputusan peninjau per baris: setuju / ubah menjadi / tolak, beserta ruang catatan
- [ ] 1.6 Tulis bagian batas cakupan: kebijakan ini bukan terapi gizi medis, tidak mencakup anak dan remaja, kehamilan, menyusui, serta kondisi medis yang dinyatakan

## 2. mealora-plans — Vektor uji emas

- [ ] 2.1 Susun kasus uji normal untuk keempat program dengan satu profil acuan (perempuan 29 tahun, 165 cm, 68,4 kg, cukup bergerak), memuat energi istirahat, pengeluaran energi harian, target energi, dan seluruh target makro beserta serat
- [ ] 2.2 Susun kasus batas untuk setiap ambang numerik — tepat di bawah, tepat pada, dan tepat di atas: usia 19 dan 64, IMT 18,5 dan 40, defisit 300 dan 750 kkal, surplus 250 dan 500 kkal, lantai 1.200 dan 1.500 kkal, laju 0,25 / 0,75 kg per minggu, batas 0,75 persen berat badan, ambang serat 20 dan 38 g, serta ambang hitung ulang 2 kg dan 90 hari
- [ ] 2.3 Susun kasus untuk setiap kode alasan: `age_below_minimum`, `age_above_supported`, `pregnancy_or_lactation`, `underweight_bmi`, `declared_medical_condition`, `rapid_unintended_weight_change`, `target_below_minimum_energy`, `requested_pace_too_fast`, `requested_pace_too_slow`, `target_weight_out_of_range`, `missing_required_input`, `missing_validated_policy`
- [ ] 2.4 Susun kasus khusus: lantai energi istirahat menaikkan target pada aktivitas rendah, penyesuaian karbohidrat di bawah 45 persen energi, berat badan acuan pada IMT di atas 30, dan Makan Sehat tanpa target berat
- [ ] 2.5 Susun setiap kasus dari aturannya, bukan dari angka hasil, sehingga perubahan nilai oleh peninjau hanya mengubah kolom hasil yang diharapkan
- [ ] 2.6 Verifikasi aritmetika setiap kasus secara independen (hitung ulang terpisah, bukan menyalin dari spec) dan perbaiki bila ada selisih

## 3. mealora-plans — Pemeriksaan silang dan bahasa

- [ ] 3.1 Bandingkan target protein, lemak, karbohidrat, dan serat pada profil acuan terhadap AKG Indonesia (PMK 28/2019) kelompok usia yang sesuai; catat kesesuaian dan selisihnya sebagai pemeriksaan kewajaran
- [ ] 3.2 Tulis pemetaan setiap kode alasan ke kalimat berbahasa Indonesia yang dilihat pengguna
- [ ] 3.3 Periksa setiap kalimat terhadap tiga larangan: tidak mendiagnosis, tidak menjanjikan hasil, tidak menyalahkan pengguna; selaraskan nadanya dengan layar `26 · Kebijakan belum tersedia` dan `36 · Belum ada program` di `docs/mealora.pen`
- [ ] 3.4 Pastikan setiap penolakan menyebut bahwa tidak ada target yang dibuat dan menawarkan langkah berikutnya

## 4. mealora-plans — Siklus peninjauan gizi

- [ ] 4.1 Ajukan `docs/nutrition-policy-v1.md` beserta vektor uji emas kepada peninjau gizi yang ditunjuk; sertakan permintaan keputusan per baris, bukan persetujuan menyeluruh
- [ ] 4.2 Terima koreksi peninjau dan terapkan ke `specs/nutrition-policy/spec.md`, `design.md`, `frs.md`, dan dokumen peninjauan secara serempak agar keempatnya tidak berbeda
- [ ] 4.3 Hitung ulang dan perbarui vektor uji emas untuk setiap nilai yang berubah
- [ ] 4.4 Catat identitas peninjau, tanggal persetujuan, dan cakupan yang disetujui di kepala dokumen; ubah status `np-1.0.0` dari draf menjadi disetujui
- [ ] 4.5 Bila peninjau menolak atau menahan sebagian aturan, catat bagian yang tidak disetujui dan pastikan spec tetap memerintahkan `missing_validated_policy` untuk bagian tersebut

## 5. mealora-mobile — Data kebijakan dan fixture

- [ ] 5.1 Tambahkan berkas data kebijakan berversi `np-1.0.0` yang memuat seluruh nilai numerik, ambang kelayakan, kode alasan, dan penanda status persetujuan — data saja, tanpa kode yang membacanya
- [ ] 5.2 Tambahkan vektor uji emas sebagai fixture yang dapat dibaca perkakas uji, terikat ke versi kebijakan `np-1.0.0`
- [ ] 5.3 Periksa baris per baris bahwa setiap nilai pada berkas data identik dengan `specs/nutrition-policy/spec.md`; perbedaan sekecil apa pun dibetulkan sebelum change ditutup
- [ ] 5.4 Pastikan penanda status pada berkas data hanya berubah menjadi disetujui setelah task 4.4 selesai
- [ ] 5.5 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test` untuk memastikan penambahan berkas tidak merusak fondasi change 001, lalu laporkan hasilnya
