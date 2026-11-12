## 1. mealora-apps/mealora-mobile — Domain

- [x] 1.1 Tambah `details['violation']` (`belowMinBmi` / `wrongDirection`) pada penolakan `targetWeightOutOfRange` di `checkTargetWeightRange`
- [x] 1.2 Buat `lib/domain/program/target_suggestion.dart`: model `TargetSuggestion` + `TargetSuggestionCalculator.suggest(...)` sesuai rumus & pembulatan design.md
- [x] 1.3 Tambah `safeRange(...)` (berat minimum, tanggal paling awal/lambat untuk berat tertentu) memakai `NutritionPolicy`
- [x] 1.4 Validasi ulang kandidat dengan `checkTargetWeightRange` + `evaluatePace`; buang yang gagal
- [x] 1.5 Unit test: 165/70 → 60 kg/12 minggu (tanggal ±19 minggu, 63,7 kg), 57 kg, 48 kg → 50,4 kg, wrongDirection tanpa saran, terlalu lambat (2 kg/52 minggu → 8 minggu), naik berat cepat/lambat, saran berat di bawah BMI dibuang, energi tanpa saran
- [x] 1.6 `flutter analyze` + `flutter test test/unit` hijau

## 2. mealora-apps/mealora-mobile — UI

- [x] 2.1 String l10n ID/EN untuk judul pilihan, label saran, petunjuk rentang; cek terhadap larangan copy (tidak menjanjikan hasil)
- [x] 2.2 `OnboardingRejectionScreen` sesuai desain 26b/26c: kartu radio saran (pertama terpilih, badge "Disarankan"), tombol "Terapkan dan tinjau ulang" → perbarui draft + evaluasi ulang, link "Atur sendiri" ke layar input
- [x] 2.3 `program_revision_review_screen.dart`: saran berat minimum untuk `belowMinBmi`; ketuk → isi ulang & evaluasi ulang
- [x] 2.4 `target_weight_screen.dart`: petunjuk berat minimum; setelah berat valid, petunjuk tanggal paling awal/lambat dan `firstDate/lastDate` dinamis (dipotong ke rentang bawaan)
- [x] 2.5 `change_program_flow.dart`: petunjuk berat minimum aman
- [x] 2.6 Widget test: layar penolakan menampilkan/tidak menampilkan pilihan sesuai reason; memilih saran memicu evaluasi ulang
- [x] 2.7 `flutter analyze` + `flutter test` hijau

## 3. Verifikasi

- [x] 3.1 Uji manual di emulator (`flutter run -d emulator-5554`, tab Terminal) untuk skenario uji FRS §3, termasuk kasus tester 165 cm / 70 kg → 60 & 57 kg
