## Context

Lihat proposal.md (Why). Kondisi kode saat ini (`mealora-apps/mealora-mobile`):

- `ProgramEngine` (`lib/domain/program/program_engine.dart`) menjalankan gerbang berurutan: kelayakan → `checkTargetWeightRange` → `evaluatePace` → `computeEnergyTarget`. Penolakan target/laju dikembalikan sebagai `NeedsUserCorrection` dengan `ReasonCode` dan `details` (map). Untuk laju terlalu cepat, `details` sudah memuat `appliedCapKgPerWeek`, `earliestSafeWeeks`, `earliestSafeDate`.
- `checkTargetWeightRange` memakai satu kode `targetWeightOutOfRange` untuk tiga kasus (BMI < min, arah salah untuk turun, arah salah untuk naik); kasusnya tidak dibedakan di `details`.
- Laju hanya dievaluasi bila tanggal tujuan diisi (`requestedDeltaKg/requestedWeeks`); tanpa tanggal, laju tidak menolak.
- UI: `OnboardingRejectionScreen` menampilkan teks dari `rejection_copy.dart` dan satu tombol "ubah masukan" ke `OnboardingStep.targetWeight`. Alur ganti program (`change_program_flow.dart`) hanya meminta berat tujuan (tanpa tanggal) dan menampilkan penolakan lewat `program_revision_review_screen.dart`.
- Spec 005 mewajibkan "tanpa memotong target secara diam-diam" — selaras dengan keputusan saran-harus-dipilih.

## Goals / Non-Goals

**Goals:**
- Satu sumber kebenaran untuk batas aman: dihitung dari `NutritionPolicy` yang sama yang dipakai engine, sehingga saran selalu lolos gerbang target/laju.
- Fungsi murni, bebas Flutter, mudah di-unit test.

**Non-Goals:**
- Tidak mengubah angka kebijakan atau menambah `ReasonCode`.
- Tidak memberi saran untuk penolakan energi (butuh perubahan aktivitas/TDEE, di luar berat/tanggal).
- Tidak menambah field tanggal tujuan ke alur ganti program.

## Decisions

1. **Modul `TargetSuggestionCalculator` terpisah di `lib/domain/program/`**, dipanggil setelah engine menolak, bukan di dalam engine.
   - Input: outcome penolakan (reason + details), tinggi, berat saat ini, program, berat/tanggal yang diminta, `asOfDate`, `NutritionPolicy`.
   - Output: daftar `TargetSuggestion { targetWeightKg, targetDate?, kind }` (0–2 item).
   - Alternatif: menaruh saran di `details` engine. Ditolak agar kontrak engine tetap kecil; engine hanya ditambah satu detail (lihat no. 2).
   - Fungsi yang sama dipakai layar input untuk petunjuk rentang (`safeRange(...)` → berat minimum, tanggal paling awal/lambat).

2. **Bedakan sub-kasus `targetWeightOutOfRange` lewat `details['violation']`** (`belowMinBmi` / `wrongDirection`). Kode alasan tetap sama (kompatibel dengan copy dan persistensi yang ada); hanya `belowMinBmi` yang diberi saran angka.

3. **Rumus & pembulatan** (cap & min dari `WeightChangeRatePolicy`, `weeks = hari/7`):
   - Berat min = `ceil1(minBmi × h²)`.
   - Terlalu cepat: tanggal = `asOf + ceil(delta/cap × 7)` hari; berat = turun `ceil1(current − cap×weeks)` / naik `floor1(current + cap×weeks)`.
   - Terlalu lambat: tanggal = `asOf + floor(delta/min × 7)` hari; berat = turun `floor1(current − min×weeks)` / naik `ceil1(current + min×weeks)`.
   - Setiap kandidat divalidasi ulang dengan `checkTargetWeightRange` + `evaluatePace` milik engine; kandidat yang gagal dibuang (mis. akibat pembulatan atau BMI).
   - Cap turun berat memakai berat saat ini (sesuai engine), bukan berat rata-rata.

4. **Menerapkan saran** = memperbarui draft (onboarding) / form revisi (ganti program) lalu memicu evaluasi ulang yang sama dengan tombol "lanjut". Tidak ada jalur aktivasi baru.

5. **Pencegahan di input**: `MealoraDateField` diberi `firstDate/lastDate` dinamis dari `safeRange` saat berat tujuan valid; bila tidak valid memakai rentang bawaan (hari ini … +5 tahun). Rentang dari `safeRange` dipotong ke rentang bawaan. Petunjuk berupa teks di bawah field, bukan error.

6. **Interaksi saran: pilih lalu tombol** (desain `docs/mealora-v2.pen` layar 25b, 26b, 26c).
   - Saran tampil sebagai kartu radio di bawah label "Pilih penyesuaian"; saran pertama terpilih awal dan berlabel "Disarankan" (laju terlalu cepat: pertahankan berat; BMI: berat minimum).
   - Tombol utama "Terapkan dan tinjau ulang" menerapkan kartu terpilih lalu evaluasi ulang; link "Atur sendiri" kembali ke layar input tanpa mengubah apa pun.
   - Alternatif sekali-ketuk ditolak: rawan salah ketuk karena langsung memicu evaluasi ulang.
   - Penjelasan penolakan laju menyebut laju yang diminta dan batas aman (kg/minggu).

## Risks / Trade-offs

- [Pembulatan menghasilkan kandidat yang tetap ditolak] → validasi ulang kandidat dengan gerbang engine; buang yang gagal.
- [Batas laju bergantung pada berat saat ini; berat saat ini diubah setelah saran dihitung] → saran dihitung ulang setiap evaluasi, tidak disimpan.
- [Saran lolos laju tetapi gagal energi] → ditangani sebagai penolakan energi biasa (spec); diterima sebagai keterbatasan.
- [Copy saran terbaca sebagai "janji hasil"] → teks memakai "memenuhi batas aman", diperiksa terhadap larangan copy di `reason-code-copy.md` (change 005).

## Migration Plan

Murni perubahan klien; tidak ada migrasi data. Rollback = revert commit. Verifikasi manual di emulator (`flutter run -d emulator-5554`) dengan skenario tester (165 cm / 70 kg → 60 & 57 kg).
