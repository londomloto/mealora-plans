## 1. mealora-mobile — Domain total parsial

- [x] 1.1 `PartialNutritionTotal.of(...)` (known, unknownCount, isComplete, isUnknown per nutrien) di `lib/domain/food` + unit test (semua diketahui, sebagian null, semua null, komponen tanpa padanan)
- [x] 1.2 Formatter `DiaryFormat.partialKcal` / makro ("7 kkal + 3 belum diketahui", "7 kkal", "–") + l10n + unit test

## 2. mealora-mobile — Total jujur

- [x] 2.1 Tinjau foto: `_TotalSummary` memakai total parsial; tidak ada lagi `?? 0` (design D1)
- [x] 2.2 Hari ini: ringkasan energi menampilkan penanda "+ N belum diketahui" dari catatan berenergi null hari itu
- [x] 2.3 Kartu ringkasan harian: `consumedKcal` parsial, persentase hanya bila lengkap; kartu makanan: `MealShareData.total` parsial
- [x] 2.4 Riwayat (kartu Tercatat + baris waktu makan) dan grafik energi Program memakai total parsial; repository energi harian menjumlah yang diketahui + jumlah catatan kosong; hari parsial tidak ikut rata-rata (tambahan cakupan dari uji HP)
- [x] 2.5 Hari ini: penanda energi kosong dipindah dari lingkaran ke catatan amber di bawah kartu ringkasan yang membuka buku harian; makro dan baris waktu makan parsial ("≥")

## 3. mealora-mobile — Melengkapi komponen

- [x] 3.1 Tinjau foto: baris "belum ada di katalog" + chip Lengkapi; tombol utama "Lengkapi N bahan" membuka komponen pertama yang belum lengkap (desain 92)
- [x] 3.2 `CustomFoodScreen(returnCreatedFood: true)`: makanan baru di-`pop` ke pemanggil, bukan ke `ServingDetailScreen` (design D2)
- [x] 3.3 Sheet koreksi untuk komponen tanpa padanan: kartu "Belum ada di katalog", opsi Cari di katalog / Buat makanan ini (prefill nama & sajian) → ikat makanan baru ke komponen (desain 93/94)
- [x] 3.4 Satuan takaran di stepper dan baris koreksi ("1 potong", "1,5 × 1 cangkir") (design D6)

## 4. mealora-mobile — Bagikan

- [x] 4.1 `MealShareCard` varian `showNutrition: false` (foto, nama, waktu makan, chip "Dibagikan dari Mealora"; tanpa angka) (desain 96)
- [x] 4.2 Tinjau foto: tautan "Bagikan saja tanpa mencatat" bila ada komponen tanpa padanan → pratinjau dengan catatan belum dicatat; kembali ke tinjau dengan draf utuh, tanpa tulis buku harian (desain 92/97)
- [x] 4.3 Layar Tersimpan: bila energi belum lengkap → catatan + "Lengkapi dulu" (buka buku harian tanggal itu) + "Bagikan tanpa total" (desain 95)

## 5. mealora-mobile — Verifikasi

- [x] 5.1 Widget test: total jujur di tinjau, tombol "Lengkapi N bahan", Buat makanan ini mengikat komponen, batal tetap belum lengkap, bagikan tanpa mencatat tidak menulis buku harian, kartu tanpa total tanpa angka
- [x] 5.2 Uji skenario FRS 1–9 di HP fisik + regresi foto makanan (011) dan bagikan (014) untuk makanan lengkap
- [x] 5.3 Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed lib test`, `flutter test`; laporkan hasil dan risiko tersisa

## 6. mealora-plans — Penutupan

- [ ] 6.1 Perbarui desain `.pen` section 14 bila ada penyesuaian selama implementasi
- [ ] 6.2 Selaraskan requirement 014 "Bagikan makanan dari jalur foto" saat arsip; `openspec validate 021-honest-meal-nutrition`, lalu arsipkan setelah rilis
