# Work Order

## Ringkasan

Change ini mengirim pengingat lokal (empat jam makan dan timbang mingguan) serta peringatan makan menjelang tidur, sesuai FRS 013. Hanya repo `mealora-apps/mealora-mobile` yang tersentuh. Tidak ada migrasi skema, tidak memakai jaringan, dan tidak memakai layanan AI. Rilis dilakukan dalam dua tahap: pengingat, lalu peringatan menjelang tidur.

## Breakdown per Repository

### mealora-apps/mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Dependensi notifikasi, timezone, manifest Android (izin, receiver boot) | 0,5 | pasti | Perlu verifikasi di emulator API 33+ |
| 2 | Repository pengaturan pengingat di preferensi lokal + default | 0,5 | pasti | Tanpa migrasi |
| 3 | Penjadwal dan rekonsiliasi (start, perubahan setting, zona waktu) | 1 | pasti | |
| 4 | Layar Pengingat + entri menu Profil + alur izin | 1,5 | pasti | Desain mengikuti gaya layar Profil yang ada |
| 5 | Navigasi saat notifikasi diketuk | 0,5 | pasti | |
| 6 | Logika rentang jam tidur (pure) + test | 0,5 | pasti | |
| 7 | Kait peringatan di semua jalur pencatatan + copy l10n | 1 | pasti | Jalur katalog, barcode/label, foto, dan suara |
| 8 | Test widget/unit + uji manual di emulator dan HP fisik | 1 | pasti | |

Total ±6,5 hari-orang.

## Dependensi Antar-Paket

- 1 → 3 → 4 → 5
- 2 → 3 dan 2 → 7
- 6 → 7
- 8 dilakukan setelah semua paket selesai.

## Urutan Rilis

### Tahap 1 — Pengingat lokal

**Isi:** paket 1–5, plus test untuk paket tersebut.
**Prasyarat:** tidak ada.
**Gate verifikasi:** `flutter analyze` bersih, `flutter test` hijau, build APK debug. Uji manual di emulator API 34: izin diberikan/ditolak, notifikasi muncul, ketuk notifikasi, restart emulator.

### Tahap 2 — Peringatan makan menjelang tidur

**Isi:** paket 6–7, plus sisa paket 8.
**Prasyarat:** Tahap 1 (layar Pengingat tempat jam tidur diatur).
**Gate verifikasi:** unit test rentang (termasuk lewat tengah malam), test widget sekali per malam dan tanggal lampau, serta uji manual tiap jalur pencatatan. Jalur foto dan suara dites setelah kuota Gemini tersedia lagi atau dengan proxy mock.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Perilaku alarm inexact berbeda antar-OEM | Uji manual memakan waktu | Uji di emulator + satu HP fisik, catat keterbatasan di layar |
| Kuota Gemini habis menghambat uji jalur foto/suara | Gate Tahap 2 tertunda | Uji dengan respons proxy mock, atau tunda uji manual jalur itu ke hari berikutnya |
| Versi plugin notifikasi butuh desugaring/compileSdk lebih baru | +0,5 hari | Aktifkan core library desugaring di Gradle sesuai dokumentasi plugin |
