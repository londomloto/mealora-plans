# Work Order

## Ringkasan

Change ini menambahkan pengisian gizi dari teks tempel dan dari satu layar Foto info gizi dengan pembacaan bertingkat (FRS bagian 2). Dua repo disentuh:

- `mealora-model-proxy`: dua route baru dengan format hasil seragam.
- `mealora-mobile`: layar tempel, layar Foto info gizi bertingkat, layar tinjau, routing hasil, dan perubahan menu.

Rilisnya dua tahap. Pertama, implementasi dan uji dengan proxy **lokal**. Kedua, setelah konfirmasi, deploy proxy ke server Koorva lalu rilis app.

## Breakdown per Repository

### mealora-model-proxy

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Skema hasil bersama + prompt inti (rentang, unread, basis, ignored, sourceKind) | 0.5 | pasti | Iterasi dengan contoh teks/foto tester |
| 2 | Route `/parse-nutrition-text` (helper route teks, `wrapTag`, batas body/karakter) | 0.25 | pasti | Route lama tidak berubah |
| 3 | Route `/read-nutrition-image` lewat `registerVisionRoute` | 0.25 | pasti | |
| 4 | Test `node:test` + README env | 0.25 | pasti | |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Domain `NutritionReading`: validasi, nilai tengah, batas wajar, pemetaan ke `LabelExtraction` + unit test | 0.75 | pasti | |
| 2 | Klien proxy teks & gambar + pemetaan kegagalan + test | 0.5 | pasti | |
| 3 | Pipeline bertingkat (vision → OCR+teks → OCR offline) + test dengan fake | 0.75 | pasti | Memakai ulang ML Kit & `LabelTextParser` |
| 4 | Layar Foto info gizi satu layar (teks baru, ikon galeri, `ImportOrigin`, routing hasil, sheet pilih jenis) | 1 | pasti | Dependency `image_picker` |
| 5 | Layar tempel + layar tinjau (normal & offline) + layar tanpa angka gizi | 1 | pasti | |
| 6 | Integrasi Buat makanan (chip, `prefill`) + teks menu + l10n | 0.5 | pasti | |
| 7 | Widget test + uji skenario FRS 1–15 + regresi alur barcode/label (010) di emulator | 0.75 | pasti | |

**Total kasar:** ±7 hari-orang.

## Dependensi Antar-Paket

- Skema hasil (proxy #1) mendahului domain dan klien mobile (mobile #1–2). Kontraknya sudah dikunci di design.md D1, jadi mobile bisa paralel memakai respons tiruan.
- Domain (mobile #1) mendahului pipeline (mobile #3) dan layar tinjau (mobile #5).
- Pipeline (mobile #3) mendahului layar Foto info gizi (mobile #4).
- Route proxy (#2–3) harus jalan lokal sebelum uji emulator (mobile #7).
- Proxy di server Koorva harus live sebelum app dirilis, karena app baru membutuhkan route baru.

## Urutan Rilis

### Tahap 1 — Implementasi dan uji dengan proxy lokal

**Isi:** semua paket proxy dan mobile.
**Prasyarat:** form Buat makanan (016) dan alur foto label (010) sudah ada di branch.
**Gate verifikasi:**
- Proxy:
  - `npm test`;
  - `curl` lokal ke `/parse-nutrition-text` dengan teks contoh tester;
  - `curl` lokal ke `/read-nutrition-image` dengan foto layar dan foto label;
  - route lama tetap normal.
- Mobile: `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`.
- Emulator (`flutter run -d emulator-5554`, proxy lokal di `10.0.2.2`): skenario FRS 1–15 dan regresi barcode/label 010.

### Tahap 2 — Deploy proxy ke server Koorva, lalu rilis app

**Isi:** deploy `mealora-model-proxy` dan build app untuk tester.
**Prasyarat:** Tahap 1 lolos dan ada **konfirmasi eksplisit** untuk deploy.
**Gate verifikasi:**
- `/health`, kedua route baru, dan route lama di server menjawab dengan benar;
- skenario FRS 1, 2, dan 5 diulang dengan app yang mengarah ke server.

Bila versi app di-bump, `latest_version`/`release_notes` di `/app-config` disinkronkan dalam pekerjaan yang sama.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Prompt butuh banyak iterasi untuk sumber yang beragam | Proxy #1 molor 0,5 hari | Kumpulkan 5–10 contoh teks/foto nyata dari tester sebagai fixture |
| Regresi alur label kemasan (010) karena route dan pemetaan baru | Mobile #4/#7 molor | Test pemetaan `NutritionReading` → `LabelExtraction` lebih awal; jalankan ulang skenario 010 |
| Klasifikasi `sourceKind` kurang tepat | UX membingungkan | Bila ragu → `unknown` → pengguna memilih |
| Konfigurasi `image_picker` | Mobile #4 molor | Photo picker sistem tanpa izin storage; cek di emulator awal |
| Akses deploy server Koorva | Tahap 2 tertunda | Jadwalkan bersama pemilik server setelah Tahap 1 |
