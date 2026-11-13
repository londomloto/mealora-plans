## Context

Lihat proposal.md (Why). Keadaan kode `mealora-apps/mealora-mobile` saat ini:

- Belum ada dependensi notifikasi. Manifest Android hanya mendeklarasikan `CAMERA` dan `INTERNET`. SDK mengikuti default Flutter (`flutter.minSdkVersion`/`targetSdkVersion`), jadi target ≥ 33 dan `POST_NOTIFICATIONS` wajib diminta saat runtime.
- `flutter_timezone` sudah terpasang, dan `Clock` (`lib/core/clock`) sudah diinjeksi untuk test.
- Tabel `UiPreferences` (key/value, bukan user record, tidak disinkronkan) sudah ada. Tabel ini cocok untuk pengaturan perangkat seperti pengingat dan jam tidur, sehingga **tidak perlu migrasi skema** (tetap `kSchemaVersion = 9`).
- Semua jalur pencatatan bermuara di `logFoodEntry` / `logFoodEntries` (`lib/features/diary/diary_providers.dart`), yang menerima `date` opsional dan default-nya `clock.today()`.
- Menu Profil (`profile_screen.dart`) memakai daftar `_SettingsItem`, dan entri Pengingat ditambahkan di sana.

## Goals / Non-Goals

**Goals:**
- Penjadwalan yang dapat dipulihkan (boot, update, zona waktu) tanpa izin alarm tepat waktu.
- Logika rentang jam tidur yang murni (pure Dart) dan teruji dengan `FixedClock`.
- Satu titik kait peringatan untuk semua jalur pencatatan.

**Non-Goals:**
- Pengingat pintar, pengingat minum, dan pengingat iOS (arsitektur tetap iOS-ready, tetapi tidak diverifikasi).
- Menyinkronkan pengaturan ke cloud.

## Decisions

**D1 — `flutter_local_notifications` + `timezone`, mode `inexactAllowWhileIdle`.**
Plugin ini memakai `zonedSchedule` dengan `matchDateTimeComponents: time` untuk jadwal harian dan `dayOfWeekAndTime` untuk jadwal mingguan, serta sudah menyediakan receiver boot. Alternatif `workmanager` atau `android_alarm_manager_plus` tidak dipilih karena butuh callback isolate dan lebih berat. Mode exact tidak dipilih karena `SCHEDULE_EXACT_ALARM` dibatasi kebijakan Play Store dan ketepatan menit tidak dibutuhkan.

**D2 — Pengaturan di `UiPreferences` dengan key berprefiks `reminder.`.**
Contoh key: `reminder.meal.breakfast.enabled`, `reminder.meal.breakfast.time` (`HH:mm`), `reminder.weigh.weekday`, `reminder.bedtime`, dan `late_meal.last_notice_night` (`YYYY-MM-DD`). Semuanya dibungkus `ReminderSettingsRepository` dengan default di kode. Tabel baru tidak dipilih karena data ini adalah preferensi perangkat, bukan record pengguna yang perlu revisi atau soft-delete.

**D3 — Rekonsiliasi idempoten.**
`ReminderScheduler.reconcile(settings)` membatalkan semua ID pengingat yang dikenal (ID tetap 1001–1004 untuk makan dan 1010 untuk timbang), lalu menjadwalkan ulang yang menyala. Rekonsiliasi dipanggil saat pengaturan berubah, saat aplikasi dimulai, dan saat aplikasi kembali ke foreground setelah zona waktu berubah (dideteksi dengan membandingkan `flutter_timezone` terhadap nilai yang tersimpan). Jadwal setelah boot dan update ditangani oleh receiver plugin (`ScheduledNotificationBootReceiver`, `MY_PACKAGE_REPLACED`).

**D4 — Rentang peringatan sebagai fungsi murni.**
`LateMealWindow.contains(now, bedtime)` mengembalikan kunci malam (tanggal saat rentang dimulai) atau `null`. Rentang dimulai pada `bedtime − 2 jam` dan berakhir pukul 04:00 berikutnya. Dengan kunci malam, aturan "sekali per malam" tetap benar ketika pencatatan melewati tengah malam.

**D5 — Kait di lapisan UI setelah `Ok`.**
Helper `maybeShowLateMealNotice(context, ref, date)` dipanggil oleh layar-layar yang memanggil `logFoodEntry/logFoodEntries` setelah hasilnya `Ok`. Syaratnya `date` (atau default) sama dengan `clock.today()`, waktu saat ini berada di dalam rentang, dan kunci malam ≠ `late_meal.last_notice_night`. Pesan ditampilkan sebagai SnackBar panjang atau banner yang tidak memblokir, lalu kunci malam disimpan. Kait di repository tidak dipilih karena repository tidak boleh bergantung pada UI.

**D6 — Copy.**
Copy notifikasi dan peringatan disimpan di ARB l10n. Contoh peringatan: "Sudah dekat jam tidur. Makan berat menjelang tidur bisa membuat tidur kurang nyenyak. Pilih porsi ringan kalau masih lapar." Copy ditinjau terhadap aturan nutrition-policy-v1.

## Risks / Trade-offs

- [OEM agresif (Xiaomi, Oppo, dll.) menunda atau mematikan alarm inexact] → Layar Pengingat memberi catatan bahwa waktu dapat sedikit bergeser. Pengecualian baterai tidak diminta.
- [Rekonsiliasi zona waktu hanya terjadi saat aplikasi dibuka] → Pengguna yang tidak membuka aplikasi setelah pindah zona akan menerima pengingat di jam zona lama sampai aplikasi dibuka. Ini diterima untuk MVP dan dicatat di FRS sebagai perilaku.
- [Kait UI bisa terlewat di jalur pencatatan baru di masa depan] → Test widget untuk setiap jalur (katalog, barcode/label, foto, suara) memastikan helper dipanggil.

## Migration Plan

Tidak ada migrasi skema. Rilis aplikasi biasa. Rollback dilakukan dengan menghapus layar dan dependensi; key `reminder.*` yang tertinggal di `UiPreferences` tidak berbahaya dan diabaikan.
