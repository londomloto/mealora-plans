# 013 · Pengingat lokal dan peringatan makan menjelang tidur

## Why

Mealora hanya berguna bila pengguna konsisten mencatat, dan alasan paling umum catatan bolong adalah lupa. Saat ini aplikasi tidak pernah menyapa pengguna di luar sesi yang mereka buka sendiri. Pengingat lokal ada di daftar "MVP 1 — SHOULD HAVE" (assessment v1.1 §7), dan dapat dikerjakan sepenuhnya offline tanpa kuota layanan AI.

Selain itu, pengguna meminta sapaan lembut ketika mencatat makan menjelang jam tidur, agar mereka sadar pola makan larut tanpa merasa dihakimi.

## What Changes

- **Pengingat jam makan**: empat pengingat (sarapan, makan siang, camilan, makan malam), masing-masing bisa dinyalakan/dimatikan dan diatur jamnya. Semuanya mati secara default.
- **Pengingat timbang**: satu pengingat mingguan dengan hari dan jam yang dipilih pengguna. Mati secara default.
- **Pengingat biasa**: notifikasi muncul sesuai jadwal, tidak memeriksa apakah makanan sudah dicatat.
- **Izin notifikasi** diminta saat pengguna pertama kali menyalakan sebuah pengingat, bukan saat onboarding. Bila ditolak, pengaturan tetap tersimpan dan layar menjelaskan cara mengizinkan dari pengaturan sistem.
- **Jadwal tetap berlaku** setelah perangkat dinyalakan ulang, zona waktu berubah, atau aplikasi diperbarui.
- **Pengaturan jam tidur** (default 22:00) di layar Pengingat.
- **Peringatan makan menjelang tidur**: saat pengguna mencatat makanan untuk hari ini dalam rentang 2 jam sebelum jam tidur (atau setelahnya, sampai dini hari), aplikasi menampilkan pesan informatif yang tidak memblokir. Catatan tetap tersimpan, peringatan muncul paling banyak sekali per malam, dan tidak muncul saat mengisi catatan tanggal lampau.
- **Layar Pengingat baru**, dibuka dari menu Profil.

## Capabilities

### New Capabilities

- `local-reminders`: pengingat jam makan dan pengingat timbang yang dijadwalkan di perangkat, beserta izin notifikasi dan pemulihan jadwal.
- `late-meal-notice`: pengaturan jam tidur dan peringatan informatif saat mencatat makanan menjelang atau setelah jam tidur.

### Modified Capabilities

Tidak ada. `food-diary` tetap menyimpan catatan seperti sebelumnya; peringatan hanya ditampilkan setelah penyimpanan berhasil.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: dependensi notifikasi lokal, izin `POST_NOTIFICATIONS` dan penerima boot di manifest Android, layar Pengingat, entri menu Profil, penyimpanan pengaturan di preferensi lokal (tanpa migrasi skema), penjadwal, serta kait peringatan setelah pencatatan makanan berhasil.
- **Tanpa jaringan dan tanpa layanan AI**: dapat dikembangkan dan dites selama kuota Gemini habis.
- **Copy**: teks peringatan mengikuti aturan copy nutrition-policy-v1, yaitu tanpa klaim medis dan tanpa nada menghakimi.
- **Di luar cakupan**: pengingat pintar (melewati pengingat bila sudah tercatat), pengingat minum, dan berbagi ke media sosial (direncanakan sebagai change 014).
