# Work Order

## Ringkasan

Change ini menambahkan pemberitahuan update dan wajib update ke aplikasi Mealora. Repo yang disentuh ada dua: `mealora-model-proxy` (endpoint konfigurasi versi) dan `mealora-mobile` (pengecekan, dialog, dan layar wajib update). Pekerjaan dibagi menjadi dua tahap rilis: proksi lebih dulu, lalu app. Requirement lengkap ada di FRS bagian 2.

## Breakdown per Repository

### mealora-model-proxy

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Config versi dari env + validasi saat start | 0.25 | pasti | |
| 2 | Route `GET /app-config` (publik, whitelist field, cache header) + test | 0.25 | pasti | |
| 3 | README: env baru dan prosedur rilis | 0.1 | pasti | |

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | Pembanding versi + logika keputusan (fungsi murni) + unit test | 0.5 | pasti | |
| 2 | Sumber konfigurasi via proksi + cache di preferensi lokal | 0.5 | pasti | |
| 3 | Provider status, pemicu saat buka & resume (throttle 1 jam) | 0.5 | pasti | |
| 4 | Desain layar wajib update + dialog di `.pen` dan persetujuan | 0.5 | pasti | |
| 5 | Implementasi layar wajib update, dialog, dan pembukaan toko (`url_launcher`) | 0.75 | pasti | Dependency baru |
| 6 | Widget test + uji skenario FRS di emulator | 0.5 | pasti | |

**Total kasar:** ±4 hari-orang.

## Dependensi Antar-Paket

- Kontrak respons `/app-config` (design D2) harus disepakati sebelum mobile #2 dikerjakan.
- Proksi harus live di lingkungan uji sebelum skenario FRS dijalankan (mobile #6).
- Mobile #4 (persetujuan desain) memblokir mobile #5.

## Urutan Rilis

### Tahap 1 — Endpoint konfigurasi versi

**Isi:** semua paket proksi.
**Prasyarat:** tidak ada.
**Gate verifikasi:** test proksi lulus; `curl /app-config` tanpa token mengembalikan field yang benar tanpa rahasia; proksi menolak start ketika min > latest; env diisi dengan versi live (`min = latest`).

### Tahap 2 — Cek update di app

**Isi:** semua paket mobile.
**Prasyarat:** Tahap 1 live, dan tautan toko Android/iOS sudah diketahui.
**Gate verifikasi:** `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`; skenario FRS 1–9 di emulator Android.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Tautan App Store belum ada karena app belum terbit di iOS | Tombol update di iOS tidak berfungsi | Kosongkan tautan iOS; app memperlakukannya sebagai fail-open dan tombol tidak tampil |
| Desain layar butuh beberapa putaran review | Paket mobile #5 bergeser | Gunakan komponen `MealoraErrorState`/tombol yang sudah ada |
| Uji force update di emulator perlu versi rendah | Waktu uji bertambah | Atur env proksi lokal (min > versi build) alih-alih membuat build lama |
