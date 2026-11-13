## Why

Tester melaporkan: profil 165 cm / 70 kg yang ingin turun ke 60 atau 57 kg berulang kali ditolak, lalu harus menebak-nebak berat/tanggal sampai akhirnya lolos. Batas aman sebenarnya bisa dihitung langsung dari kebijakan `np-1.0.0` (BMI tujuan ≥ 18,5; laju turun 0,25 kg/minggu sampai min(0,75 kg; 0,75% berat badan); laju naik 0,125–0,5 kg/minggu). Untuk profil tersebut batas lajunya 0,525 kg/minggu, jadi turun 10 kg butuh ±19 minggu. Saat ini aplikasi hanya menampilkan tanggal paling awal sebagai teks dan tidak memberi pilihan yang bisa langsung diterapkan.

## What Changes

- Saat proposal ditolak karena **target berat di luar rentang** atau **laju terlalu cepat/lambat**, sistem menghitung saran yang memenuhi kebijakan:
  - BMI tujuan terlalu rendah → berat tujuan minimum yang aman.
  - Laju terlalu cepat → (a) pertahankan berat, mundurkan ke tanggal paling awal yang aman; (b) pertahankan tanggal, ganti ke berat terdekat yang bisa dicapai.
  - Laju terlalu lambat → (a) pertahankan berat, majukan ke tanggal paling lambat yang masih memenuhi laju minimum; (b) pertahankan tanggal, ganti ke berat yang memenuhi laju minimum (hanya bila berat itu tetap lolos batas BMI).
- Layar penolakan menampilkan saran sebagai pilihan yang bisa diketuk. Memilih saran mengisi ulang masukan lalu menjalankan evaluasi lagi. Tidak ada yang diubah diam-diam.
- Pencegahan sejak awal: layar berat tujuan menampilkan rentang aman (berat minimum, tanggal paling awal/lambat untuk berat yang diisi), dan pemilih tanggal dibatasi ke rentang yang aman. Alur ganti program (yang hanya meminta berat tujuan) menampilkan berat minimum yang aman.
- Penolakan **energi di bawah minimum** dan penolakan kelayakan lain (usia, BMI saat ini, kondisi medis, kehamilan, perubahan berat cepat) tetap seperti sekarang, tanpa saran berat/tanggal, karena mengubah berat/tanggal tidak menyelesaikannya.
- Kebijakan `np-1.0.0` dan kode alasan (`ReasonCode`) tidak berubah. Tidak ada perubahan skema database.

## Capabilities

### New Capabilities
- `target-adjustment-suggestions`: menghitung dan menyajikan saran berat/tanggal tujuan yang aman ketika target atau laju ditolak, plus petunjuk rentang aman di layar input.

### Modified Capabilities
<!-- Requirement "Keadaan tidak dapat disetujui dijelaskan dengan aman" (program-onboarding, change 005) tetap berlaku apa adanya; perilaku baru ditambahkan sebagai kapabilitas tersendiri. Spec utama belum diarsipkan ke openspec/specs. -->

## Impact

- `mealora-apps/mealora-mobile`:
  - `lib/domain/program/` — fungsi murni penghitung saran (baru), memakai batas dari `NutritionPolicy`; `program_engine.dart` hanya menambah detail ke outcome penolakan bila perlu.
  - `lib/features/onboarding/rejection_screen.dart`, `rejection_copy.dart`, `target_weight_screen.dart`, `onboarding_controller.dart`.
  - `lib/features/program/change_program_flow.dart`, `program_revision_review_screen.dart`.
  - `lib/l10n/` — string baru (ID/EN).
  - Unit test domain + widget test layar penolakan/target.
- Tidak menyentuh `mealora-model-proxy`, tidak ada bump versi.
