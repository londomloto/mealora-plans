# Work Order

## Ringkasan

Change ini mengirim fitur berbagi ringkasan harian dan berbagi makanan dari jalur foto sebagai kartu gambar bertanda Mealora, sesuai FRS 014. Hanya repo `mealora-apps/mealora-mobile` yang tersentuh. Tidak ada migrasi skema dan tidak ada server. Rilis dilakukan dalam dua tahap: ringkasan harian, lalu kartu makanan dari foto.

## Breakdown per Repository

### mealora-apps/mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Dependensi `share_plus`, perender kartu → PNG cache, pembersihan `share-cards/` | 0,5 | pasti | |
| 2 | Komponen kartu dasar (bingkai 9:16, watermark, tipografi) + layar pratinjau | 1 | pasti | Visual sebaiknya dirancang dulu di `mealora-v2.pen` |
| 3 | Kartu ringkasan harian + tombol Bagikan di Hari ini | 1 | pasti | Memakai total & target yang ada |
| 4 | Layar "Tersimpan" jalur foto + penundaan hapus foto + pembersihan berkas yatim | 1,5 | pasti | Menyentuh alur 011 |
| 5 | Kartu makanan (foto + komponen + total) | 1 | pasti | |
| 6 | Copy l10n + tinjauan policy | 0,5 | pasti | |
| 7 | Test widget/unit + uji manual share ke WA/IG | 1 | pasti | |

Total ±6,5 hari-orang.

## Dependensi Antar-Paket

- 1 → 2 → 3
- 2 → 5
- 4 → 5
- 6 dan 7 menyertai setiap tahap.

## Urutan Rilis

### Tahap 1 — Share Daily Summary

**Isi:** paket 1, 2, dan 3, plus copy dan test terkait.
**Prasyarat:** desain kartu disetujui.
**Gate verifikasi:** `flutter analyze` dan `flutter test` hijau. Uji manual di emulator: share ke aplikasi apa pun, tombol nonaktif saat kosong, offline, dan isi `share-cards/` bersih setelah share.

### Tahap 2 — Share Meal (jalur foto)

**Isi:** paket 4 dan 5, plus copy dan test terkait.
**Prasyarat:** Tahap 1, dan kuota Gemini tersedia untuk menguji jalur foto (atau respons proxy mock).
**Gate verifikasi:** test widget layar "Tersimpan" (share/selesai/back), test retensi (foto terhapus vs tetap), uji manual alur foto end-to-end, serta uji matikan aplikasi saat layar "Tersimpan" lalu buka lagi untuk memastikan berkas yatim dibersihkan.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Desain kartu belum ada | Iterasi visual memperpanjang paket 2 | Buat frame kartu di `mealora-v2.pen` sebelum Tahap 1 |
| Kuota Gemini habis | Uji Tahap 2 tertunda | Gunakan mock proxy atau jadwalkan uji setelah kuota pulih |
| Perubahan alur `_confirm()` 011 menimbulkan regresi | Draf muncul lagi atau foto tidak terhapus | Test regresi alur foto yang sudah ada tetap dijalankan |
