# Work Order

## Ringkasan

Perubahan klien saja di `mealora-apps/mealora-mobile`: kalkulator saran target (domain murni), pilihan saran di layar penolakan (onboarding & ganti program), dan petunjuk rentang aman di layar input. Tidak ada perubahan kebijakan, database, atau `mealora-model-proxy`. Dua tahap rilis internal, verifikasi akhir di emulator.

## Breakdown per Repository

### mealora-apps/mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Kalkulator saran + `safeRange` + detail `violation` di engine, dengan unit test | 0,75 | pasti | Fungsi murni, rumus di design.md |
| 2 | Pilihan saran di layar penolakan onboarding + terapkan & evaluasi ulang | 1 | pasti | `rejection_screen.dart`, controller |
| 3 | Saran berat minimum di penolakan ganti program | 0,5 | pasti | Tanpa tanggal |
| 4 | Petunjuk rentang aman + batas pemilih tanggal di layar input | 0,75 | pasti | `target_weight_screen.dart`, `change_program_flow.dart` |
| 5 | String l10n ID/EN + cek larangan copy | 0,25 | pasti | |
| 6 | Widget test + verifikasi emulator skenario tester | 0,5 | pasti | |

Total ±3,75 hari-orang.

## Dependensi Antar-Paket

- Paket 1 memblokir 2, 3, 4.
- Paket 5 berjalan bersama 2–4.
- Paket 6 setelah 2–5.

## Urutan Rilis

### Tahap 1 — Domain

**Isi:** paket 1.
**Prasyarat:** —
**Gate verifikasi:** `flutter test test/unit` hijau, termasuk kasus 165/70 → 60 & 57 kg; `flutter analyze` bersih.

### Tahap 2 — UI

**Isi:** paket 2–6.
**Prasyarat:** Tahap 1 selesai.
**Gate verifikasi:** `flutter test` & `flutter analyze` hijau; uji manual di emulator (`flutter run -d emulator-5554`) untuk skenario uji FRS §3.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Pembulatan menghasilkan saran yang tetap ditolak | Rework kalkulator | Validasi ulang kandidat dengan gerbang engine, unit test batas |
| Pemilih tanggal dinamis memicu state draft lama tidak valid | Bug UI kecil | Kosongkan tanggal di luar rentang dengan petunjuk, bukan diam-diam |
| Copy saran perlu review produk | Tertunda | Siapkan copy di awal paket 5 |
