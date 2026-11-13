## 1. mealora-plans — Dokumen kebijakan

- [x] 1.1 Buat `docs/nutrition-policy-v1.md` dengan kepala dokumen: versi kebijakan `np-1.0.0`, versi kalkulator `msj-1.0.0`, tanggal, dan rujukan ke tinjauan teknisnya
- [x] 1.2 Salin seluruh nilai dari `specs/nutrition-policy/spec.md` ke dokumen dalam bentuk tabel per aturan — tidak boleh ada nilai di spec yang tidak muncul di dokumen
- [x] 1.3 Lengkapi setiap baris dengan dasar rujukan dan pranala sumber: persamaan Mifflin–St Jeor, pita PAL FAO/WHO/UNU 2004, pedoman AHA/ACC/TOS 2013 (defisit 500–750 kkal; asupan 1.200–1.500 kkal perempuan dan 1.500–1.800 kkal laki-laki; VLCD <800 kkal hanya dengan pengawasan), AMDR IOM 2005, Adequate Intake serat 14 g/1.000 kkal, tinjauan protein Leidy dkk. 2015 serta Phillips dkk., dan klasifikasi IMT Asia-Pasifik
- [x] 1.4 Tandai eksplisit nilai yang merupakan keputusan produk, bukan kutipan pedoman — terutama defisit proporsional 20 persen, surplus 10 persen, dan batas laju relatif 0,75 persen berat badan
- [x] 1.5 Tambahkan kolom putusan per baris (setuju / ubah menjadi / tolak) beserta ruang catatan, agar tiap nilai dapat ditinjau ulang satu per satu di kemudian hari
- [x] 1.6 Tulis bagian batas cakupan: kebijakan ini bukan terapi gizi medis, tidak mencakup anak dan remaja, kehamilan, menyusui, kondisi medis yang dinyatakan, serta tidak menjamin kecukupan mikronutrien
- [x] 1.7 Selaraskan `docs/mealora-v2.pen` dengan kebijakan final: layar `26` menjadi layar penolakan umum, dan seluruh teks yang menyebut gerbang persetujuan dihapus

## 2. mealora-plans — Vektor uji emas

- [x] 2.1 Susun kasus uji normal untuk keempat program dengan satu profil acuan (perempuan 29 tahun, 165 cm, 68,4 kg, cukup bergerak), memuat energi istirahat, pengeluaran energi harian, target energi, dan seluruh target makro beserta serat
- [x] 2.2 Susun kasus batas untuk setiap ambang numerik — tepat di bawah, tepat pada, dan tepat di atas: usia 19 dan 64, IMT 18,5 dan 37,5, defisit 300 dan 750 kkal, surplus 250 dan 500 kkal, lantai 1.200 dan 1.500 kkal, laju 0,25 / 0,75 kg per minggu, batas 0,75 persen berat badan, ambang serat 20 dan 38 g, serta ambang hitung ulang 2 kg dan 90 hari
- [x] 2.3 Susun kasus untuk setiap kode alasan: `age_below_minimum`, `age_above_supported`, `pregnancy_or_lactation`, `underweight_bmi`, `bmi_above_supported`, `declared_medical_condition`, `rapid_unintended_weight_change`, `target_below_minimum_energy`, `requested_pace_too_fast`, `requested_pace_too_slow`, `target_weight_out_of_range`, `missing_required_input`
- [x] 2.4 Susun kasus khusus: berat acuan pada IMT di atas 23, penyesuaian karbohidrat di bawah 45 persen energi, lantai asupan 1.500 kkal yang menaikkan target, Makan Sehat tanpa target berat, dan Makan Sehat tanpa angka untuk profil di bawah 19 tahun
- [x] 2.5 Susun setiap kasus dari aturannya, bukan dari angka hasil, sehingga perubahan nilai hanya mengubah kolom hasil yang diharapkan
- [x] 2.6 Verifikasi aritmetika setiap kasus secara independen (hitung ulang terpisah, bukan menyalin dari spec) dan perbaiki bila ada selisih

## 3. mealora-plans — Pemeriksaan silang dan bahasa

- [x] 3.1 Bandingkan target protein, lemak, karbohidrat, dan serat pada profil acuan terhadap AKG Indonesia (PMK 28/2019) kelompok usia yang sesuai; catat kesesuaian dan selisihnya sebagai pemeriksaan kewajaran
- [x] 3.2 Tulis pemetaan setiap kode alasan ke kalimat berbahasa Indonesia yang dilihat pengguna
- [x] 3.3 Periksa setiap kalimat terhadap tiga larangan: tidak mendiagnosis, tidak menjanjikan hasil, tidak menyalahkan pengguna; selaraskan nadanya dengan layar `26 · Target tidak dibuat` dan `36 · Belum ada program` di `docs/mealora-v2.pen`
- [x] 3.4 Pastikan setiap penolakan menyebut bahwa tidak ada target yang dibuat dan menawarkan langkah berikutnya

## 4. mealora-plans — Tinjauan teknis kebijakan

- [x] 4.1 Tinjau setiap nilai pada `specs/nutrition-policy/spec.md` terhadap pedoman publik dan terhadap kesesuaiannya untuk populasi dewasa Indonesia; catat putusan per baris beserta dasarnya di `docs/nutrition-policy-v1-technical-review.md`
- [x] 4.2 Terapkan koreksi tinjauan ke `specs/nutrition-policy/spec.md`, `design.md`, `frs.md`, `proposal.md`, `workorder.md`, dan dokumen kebijakan secara serempak agar seluruhnya tidak berbeda
- [x] 4.3 Hitung ulang dan perbarui vektor uji emas untuk setiap nilai yang berubah
- [x] 4.4 Catat setiap nilai yang diubah beserta alasan dan dampaknya terhadap angka profil acuan
- [x] 4.5 Catat batas tinjauan ini dan apa yang sengaja ditunda ke change berikutnya

## 5. mealora-mobile — Data kebijakan dan fixture

- [x] 5.1 Tambahkan berkas data kebijakan berversi `np-1.0.0` yang memuat seluruh nilai numerik, ambang kelayakan, dan kode alasan — data saja, tanpa kode yang membacanya
- [x] 5.2 Tambahkan vektor uji emas sebagai fixture yang dapat dibaca perkakas uji, terikat ke versi kebijakan `np-1.0.0`
- [x] 5.3 Periksa baris per baris bahwa setiap nilai pada berkas data identik dengan `specs/nutrition-policy/spec.md`; perbedaan sekecil apa pun dibetulkan sebelum change ditutup
- [x] 5.4 Pastikan berkas data tidak memuat penanda status persetujuan, dan kode `missing_validated_policy` tidak lagi muncul di berkas mana pun
- [x] 5.5 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test` untuk memastikan penambahan berkas tidak merusak fondasi change 001, lalu laporkan hasilnya
