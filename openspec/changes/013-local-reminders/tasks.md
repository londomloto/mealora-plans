## 1. Fondasi notifikasi (mealora-apps/mealora-mobile)

- [x] 1.1 Tambah `flutter_local_notifications` dan `timezone` ke `pubspec.yaml`; aktifkan core library desugaring di Gradle bila diminta plugin
- [x] 1.2 Tambah `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`, serta receiver plugin (boot dan `MY_PACKAGE_REPLACED`) di `AndroidManifest.xml`; jangan tambahkan `SCHEDULE_EXACT_ALARM`
- [x] 1.3 Inisialisasi plugin dan database timezone saat bootstrap aplikasi, dengan zona lokal dari `flutter_timezone`

## 2. Pengaturan dan penjadwal

- [x] 2.1 Buat `ReminderSettings` (domain) dan `ReminderSettingsRepository` di atas `UiPreferences` dengan key `reminder.*` dan default sesuai spec
- [x] 2.2 Buat `ReminderScheduler.reconcile` (batalkan ID 1001–1004/1010 lalu jadwalkan yang menyala, mode inexact, harian/mingguan)
- [x] 2.3 Panggil reconcile saat app start, saat setting berubah, dan saat resume bila zona waktu berbeda dari yang tersimpan
- [x] 2.4 Unit test repository (default, simpan/baca) dan scheduler dengan plugin fake

## 3. Layar Pengingat

- [x] 3.1 Buat layar Pengingat (4 pengingat makan, pengingat timbang dengan hari, jam tidur) dan tambahkan entri ke menu Profil
- [x] 3.2 Minta izin notifikasi saat sakelar pertama dinyalakan; tampilkan keterangan "diblokir" + tombol ke pengaturan sistem bila izin ditolak
- [x] 3.3 Tambahkan catatan bahwa waktu notifikasi bisa sedikit bergeser
- [x] 3.4 Tambahkan copy notifikasi dan layar ke ARB l10n (tanpa angka kalori/berat)
- [x] 3.5 Tangani ketukan notifikasi: makan → Hari ini, timbang → tambah berat (termasuk saat aplikasi dibuka dari keadaan mati)
- [x] 3.6 Test widget layar Pengingat (sakelar, izin ditolak)

## 4. Peringatan makan menjelang tidur

- [x] 4.1 Buat `LateMealWindow` (pure) yang mengembalikan kunci malam; unit test untuk 22:00, di luar rentang, lewat tengah malam, dan jam tidur 01:00
- [x] 4.2 Buat helper `maybeShowLateMealNotice` (cek tanggal = hari ini, rentang, `late_meal.last_notice_night`; tampilkan pesan tidak memblokir; simpan kunci)
- [x] 4.3 Panggil helper setelah `Ok` di semua pemanggil `logFoodEntry`/`logFoodEntries` (katalog/serving, custom food, barcode/label, foto, suara)
- [x] 4.4 Tambahkan copy peringatan ke ARB dan tinjau terhadap aturan copy nutrition-policy-v1
- [x] 4.5 Test widget: tampil sekali, tidak tampil di malam yang sama, tidak tampil untuk tanggal lampau, tidak tampil bila gagal

## 5. Verifikasi

- [ ] 5.1 `flutter analyze` dan `flutter test` hijau
- [x] 5.2 Uji manual di emulator API 34: izin diberikan/ditolak, notifikasi muncul, ketuk notifikasi, restart emulator, ganti zona waktu lalu buka aplikasi _(diuji di AVD API 36.1 pada 2026-11-11; satu-satunya AVD tersedia)_
- [ ] 5.3 Uji manual peringatan menjelang tidur di jalur katalog dan barcode; jalur foto/suara setelah kuota Gemini tersedia
