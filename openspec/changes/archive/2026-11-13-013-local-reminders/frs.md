# Functional Requirements Specification

## Mealora - Pengingat Lokal dan Peringatan Makan Menjelang Tidur

| | |
|---|---|
| Change | 013-local-reminders |
| Versi | v0.1-draft |
| Tanggal | 2026-11-11 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Pengingat harian untuk sarapan, makan siang, camilan, dan makan malam.
- Pengingat timbang berat badan seminggu sekali.
- Permintaan izin notifikasi pada saat pengguna menyalakan pengingat.
- Pengaturan jam tidur dan peringatan informatif saat mencatat makanan menjelang tidur.
- Layar Pengingat yang dibuka dari menu Profil.

### 1.2 Deferred Items (Not in This FRS Version)

- Pengingat pintar yang tidak muncul bila makanan sudah dicatat. Ditunda agar versi pertama sederhana.
- Pengingat minum air, karena fitur pencatatan air belum ada.
- Berbagi ringkasan atau foto makanan ke media sosial, yang direncanakan pada change 014.
- Penyimpanan pengaturan pengingat di cloud, karena MVP 1 sepenuhnya offline.

## 2. Pengingat Lokal

### 2.1 User Story

As a pengguna Mealora,
I want diingatkan pada jam makan dan hari timbang yang saya pilih,
So that saya tidak lupa mencatat dan data kemajuan saya lebih lengkap.

### 2.2 Functional Scope

- Layar Pengingat menampilkan empat pengingat makan dan satu pengingat timbang. Masing-masing memiliki sakelar dan pilihan jam. Pengingat timbang juga memiliki pilihan hari.
- Semua pengingat mati saat aplikasi pertama kali dipasang.
- Jam default pengingat makan adalah 07:00 untuk sarapan, 12:00 untuk makan siang, 15:30 untuk camilan, dan 19:00 untuk makan malam. Pengingat timbang default-nya hari Senin pukul 07:00.
- Pengingat muncul sesuai jadwal tanpa memeriksa apakah makanan sudah dicatat.
- Waktu muncul notifikasi adalah perkiraan dan dapat bergeser beberapa menit karena penghematan baterai perangkat.
- Mengetuk pengingat makan membuka halaman Hari ini, sedangkan mengetuk pengingat timbang membuka halaman tambah berat.
- Izin notifikasi diminta saat pengguna pertama kali menyalakan pengingat, tidak saat pendaftaran awal. Bila izin ditolak, pengaturan tetap tersimpan, layar menampilkan bahwa notifikasi diblokir, dan tersedia tombol untuk membuka pengaturan HP.
- Pengingat tetap berjalan setelah HP dinyalakan ulang atau aplikasi diperbarui. Setelah pindah zona waktu, pengingat menyesuaikan jam lokal yang baru setelah aplikasi dibuka.
- Isi notifikasi hanya berupa ajakan mencatat, tanpa angka kalori atau berat badan.

### 2.3 Acceptance Criteria

2.3.1. The system shall provide separate on/off switches and time settings for breakfast, lunch, snack, and dinner reminders.

2.3.2. The system shall keep all reminders off by default.

2.3.3. The system shall show a meal reminder notification daily at approximately the chosen local time while that reminder is on.

2.3.4. The system shall show the meal reminder even if that meal has already been logged.

2.3.5. The system shall provide a weekly weigh-in reminder with a chosen day and time.

2.3.6. The system shall open the Today screen when a meal reminder is tapped and the add-weight screen when the weigh-in reminder is tapped.

2.3.7. The system shall request notification permission only when the user turns on a reminder, never during onboarding.

2.3.8. The system shall keep the reminder settings and show a blocked-notification notice with a link to system settings when permission is denied.

2.3.9. The system shall keep reminders scheduled after a device restart and after an app update.

2.3.10. The system shall follow the new local time after a time-zone change once the app is opened again.

2.3.11. The system shall not request exact-alarm permission.

2.3.12. The system shall not display calorie, weight, or other health figures in reminder notifications.

---

## 3. Peringatan Makan Menjelang Tidur

### 3.1 User Story

As a pengguna Mealora,
I want diberi tahu dengan lembut ketika saya mencatat makan menjelang tidur,
So that saya lebih sadar pola makan malam saya tanpa merasa dihakimi.

### 3.2 Functional Scope

- Layar Pengingat memiliki pengaturan jam tidur dengan default 22:00.
- Rentang peringatan dimulai 2 jam sebelum jam tidur dan berakhir pukul 04:00 dini hari.
- Ketika makanan untuk hari ini berhasil disimpan di dalam rentang itu, aplikasi menampilkan pesan singkat. Contoh: "Sudah dekat jam tidur. Makan berat menjelang tidur bisa membuat tidur kurang nyenyak. Pilih porsi ringan kalau masih lapar."
- Pesan tidak menghalangi apa pun, dan catatan tetap tersimpan.
- Pesan tidak memakai kata "berbahaya", tidak membuat klaim medis, dan tidak bernada menghakimi.
- Pesan muncul paling banyak sekali per malam.
- Pesan tidak muncul saat mengisi catatan untuk tanggal lampau atau bila penyimpanan gagal.

### 3.3 Acceptance Criteria

3.3.1. The system shall provide a bedtime setting with a default of 22:00.

3.3.2. The system shall treat the period from two hours before bedtime until 04:00 local time as the late-meal window.

3.3.3. The system shall show a non-blocking informational message after food is successfully logged for today within the late-meal window.

3.3.4. The system shall keep the logged food regardless of how the user responds to the message.

3.3.5. The system shall not use the word "berbahaya", medical claims, or judgmental wording in the message.

3.3.6. The system shall not show the message when food is logged for a date other than today.

3.3.7. The system shall not show the message when saving the food fails.

3.3.8. The system shall show the message at most once per late-meal window.

## 4. High Level Test Scenarios

| # | Kondisi awal | Aksi | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Pengingat makan siang mati, izin belum pernah diminta | Nyalakan pengingat makan siang jam 12:30, izinkan notifikasi | Notifikasi makan siang muncul sekitar 12:30 |
| 2 | Izin notifikasi belum diberikan | Nyalakan pengingat makan malam, tolak izin | Sakelar tetap menyala, muncul keterangan diblokir dan tombol ke pengaturan HP |
| 3 | Pengingat timbang menyala hari Sabtu 06:30 | Tunggu hari Sabtu, ketuk notifikasi | Aplikasi membuka halaman tambah berat |
| 4 | Pengingat sarapan menyala | Nyalakan ulang HP tanpa membuka aplikasi | Pengingat sarapan tetap muncul keesokan pagi |
| 5 | Jam tidur 22:00 | Catat camilan untuk hari ini pukul 21:15 | Catatan tersimpan dan pesan menjelang tidur muncul |
| 6 | Skenario 5 sudah terjadi | Catat makanan lagi pukul 21:40 | Catatan tersimpan tanpa pesan |
| 7 | Jam tidur 22:00 | Catat makan malam untuk tanggal kemarin dari Riwayat pukul 21:30 | Catatan tersimpan tanpa pesan |
| 8 | Jam tidur 22:00 | Catat makanan pukul 19:30 | Tidak ada pesan |
