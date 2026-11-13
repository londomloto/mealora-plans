# Functional Requirements Specification

## Mealora — Fondasi Aplikasi (Kerangka & Penyimpanan Lokal)

| | |
|---|---|
| Change | 001-app-foundation |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Aplikasi Mealora dapat dipasang di ponsel, dibuka, dan dipakai tanpa membuat akun dan tanpa koneksi internet.
- Layar pembuka bermerek Mealora yang menyampaikan bahwa data pribadi tersimpan di perangkat pengguna.
- Empat ruang utama yang dapat dibuka pengguna: **Hari ini**, **Program**, **Riwayat**, dan **Profil**, masing-masing menjelaskan isinya meski belum ada data.
- Tampilan berbahasa Indonesia dengan penulisan angka, tanggal, dan satuan metrik sesuai kebiasaan Indonesia.
- Tampilan yang konsisten dengan rancangan visual Mealora yang sudah disetujui.
- Kemudahan akses: teks mengikuti ukuran huruf perangkat, warna cukup kontras, tombol cukup besar, dan status tidak hanya dibedakan lewat warna.
- Jaminan penyimpanan: data yang tercatat tetap ada setelah aplikasi ditutup, tidak pernah dikirim keluar perangkat, dan dapat dihapus pengguna di kemudian hari.
- Jaminan keandalan: pencatatan yang terdiri dari beberapa bagian tersimpan seluruhnya atau tidak sama sekali, serta nilai yang mustahil ditolak.

### 1.2 Deferred Items (Not in This FRS Version)

- Seluruh fitur produk — pengisian profil, pemilihan dan pengelolaan program, perhitungan target energi, katalog makanan, pencatatan buku harian, pemantauan berat, dan riwayat — dikirim pada change berikutnya.
- Pencatatan lewat foto makanan, pemindaian barcode, dan pembacaan label gizi, termasuk seluruh fungsi yang memerlukan internet.
- Angka kebijakan gizi apa pun (defisit, surplus, batas energi minimum, komposisi makro). Angka ini baru berlaku setelah ditinjau ahli gizi pada change tersendiri.
- Akun pengguna, pencadangan ke cloud, dan penggunaan di banyak perangkat.
- Mode gelap dan bahasa selain Indonesia; dasarnya disiapkan, tetapi belum dikirim.
- Dukungan iPhone. Arsitektur dijaga agar tetap memungkinkan, tetapi pengujian pada pengiriman ini hanya untuk Android.

## 2. Kerangka Aplikasi

### 2.1 User Story

As a pengguna yang ingin mencoba Mealora,
I want membuka aplikasi dan langsung memahami ke mana saja saya bisa pergi, tanpa mendaftar dan tanpa kuota internet,
So that saya bisa menilai apakah aplikasi ini cocok sebelum menyerahkan data atau waktu saya.

### 2.2 Functional Scope

- Setelah pemasangan, aplikasi dapat dibuka dan dipakai tanpa pendaftaran, tanpa login, dan tanpa koneksi internet. Tidak ada layar masuk akun di mana pun.
- Saat dibuka, aplikasi menampilkan layar pembuka bermerek Mealora beserta pernyataan bahwa data pribadi tersimpan di perangkat ini, lalu berpindah sendiri ke ruang utama tanpa pengguna perlu menekan apa pun.
- Bila penyimpanan di perangkat gagal disiapkan, pengguna melihat pesan yang dapat dimengerti beserta tindakan yang bisa dilakukan, bukan layar pembuka yang menggantung.
- Pengguna dapat berpindah kapan saja di antara empat ruang utama: Hari ini, Program, Riwayat, dan Profil. Ruang yang sedang dibuka ditandai dengan jelas, tidak hanya melalui perbedaan warna.
- Ruang yang terakhir dibuka pengguna tetap terpilih ketika aplikasi dibuka kembali.
- Selama belum ada data, setiap ruang menjelaskan apa yang akan muncul di sana dan tindakan yang tersedia. Aplikasi tidak menampilkan angka nol yang terkesan sebagai hasil pengukuran.
- Bila aplikasi diminta membuka halaman yang tidak dikenal, pengguna melihat pemberitahuan beserta jalan kembali ke ruang utama.
- Seluruh teks berbahasa Indonesia. Angka ribuan dan desimal ditulis sesuai kebiasaan Indonesia, misalnya "2.100 kkal" dan "68,4 kg". Satuan yang dipakai adalah metrik: kilogram, sentimeter, kilokalori, dan gram.
- Tampilan tetap terbaca utuh ketika pengguna memperbesar ukuran huruf di pengaturan perangkat, dan setiap kontrol dapat dikenali pembaca layar.
- **Tidak termasuk:** data nyata apa pun di keempat ruang tersebut. Pada pengiriman ini keempat ruang hanya menampilkan keadaan "belum ada data".

### 2.3 Acceptance Criteria

2.3.1. The system shall allow a newly installed application to be opened and navigated without account registration, sign-in, or an internet connection.

2.3.2. The system shall not display any sign-in or registration screen.

2.3.3. The system shall not perform any network request while launching or while the user moves between the four main spaces.

2.3.4. The system shall display a Mealora-branded opening screen that states that personal data is stored on the device, and shall proceed to the main space without requiring user interaction.

2.3.5. The system shall display a readable error state with a next action, instead of an indefinitely waiting opening screen, when local storage cannot be prepared.

2.3.6. The system shall provide persistent navigation to exactly four main spaces labelled "Hari ini", "Program", "Riwayat", and "Profil".

2.3.7. The system shall indicate the currently selected space through a cue other than colour alone.

2.3.8. The system shall restore the space the user had selected when the application is reopened.

2.3.9. The system shall present, in each main space without user data, an explanation of what will appear there and which actions are available, and shall not present zero values that suggest measured data.

2.3.10. The system shall present a readable "page not found" state with a route back to a main space when an unknown destination is requested.

2.3.11. The system shall display all user-facing text in Indonesian.

2.3.12. The system shall format numbers using Indonesian conventions, with a full stop as the thousands separator and a comma as the decimal separator.

2.3.13. The system shall display measurements in metric units: kilograms, centimetres, kilocalories, and grams.

2.3.14. The system shall keep all screen content readable, without truncated or overlapping text and without unreachable controls, when the device text size is increased to a large setting.

2.3.15. The system shall expose a meaningful name and selection state for every navigation destination and control to screen readers.

2.3.16. The system shall apply colour, typography, spacing, and component shapes consistently with the approved Mealora visual design across all screens.

---

## 3. Penyimpanan Data di Perangkat

### 3.1 User Story

As a pengguna yang merekam data makanan dan berat badan,
I want data saya tersimpan di ponsel saya sendiri, tidak hilang, dan tidak dikirim ke mana pun,
So that saya bisa memakai Mealora dengan tenang tanpa menyerahkan data kesehatan saya ke pihak lain.

### 3.2 Functional Scope

- Semua data yang dicatat pengguna disimpan di perangkat dan dapat dibaca kembali tanpa koneksi internet.
- Data pengguna tidak dikirim ke server, layanan pihak ketiga, maupun catatan log di luar perangkat. Aplikasi tidak memuat perangkat pelacak, analitik, atau iklan.
- Data tetap tersedia setelah aplikasi ditutup sepenuhnya dan dibuka kembali, termasuk setelah perangkat dimatikan.
- Setiap catatan menyimpan waktu pembuatan dan waktu perubahan terakhirnya, sehingga riwayat perubahan dapat dijelaskan di kemudian hari.
- Catatan yang dihapus pengguna langsung hilang dari semua tampilan dan semua perhitungan.
- Catatan tetap berada pada tanggal yang sama seperti saat dicatat, meskipun pengguna berpindah zona waktu atau mengubah pengaturan perangkat.
- Pencatatan yang terdiri dari beberapa bagian tersimpan seluruhnya atau tidak sama sekali; kegagalan di tengah jalan tidak meninggalkan catatan setengah jadi.
- Nilai yang mustahil ditolak, misalnya nilai gizi negatif atau jumlah nol. Nilai yang memang belum diketahui disimpan sebagai "belum diketahui" dan tidak pernah diubah menjadi nol.
- Ketika versi aplikasi berikutnya mengubah cara data disimpan, penyesuaian berlangsung otomatis saat aplikasi dibuka dan tidak menghilangkan data yang sudah ada. Bila penyesuaian terganggu, data tidak rusak dan percobaan berikutnya dapat dilanjutkan.
- **Tidak termasuk:** pencadangan, pemulihan, ekspor berkas, dan sinkronisasi antar perangkat.

### 3.3 Acceptance Criteria

3.3.1. The system shall store all user data on the device and allow it to be read and written without a network connection.

3.3.2. The system shall not transmit user data to any server, third-party service, or log outside the device.

3.3.3. The system shall not include analytics, advertising, or third-party tracking components.

3.3.4. The system shall make previously stored data available again after the application is fully closed and reopened.

3.3.5. The system shall record a creation time and a last-changed time for every user record, and shall leave the creation time unchanged when the record is updated.

3.3.6. The system shall exclude records deleted by the user from every display and every calculation.

3.3.7. The system shall keep a record grouped under the same calendar date it was recorded on, after a change of device time zone or display settings.

3.3.8. The system shall store either all parts of a multi-part record or none of them, leaving no partial record when an operation fails.

3.3.9. The system shall reject physically impossible or meaningless values, including negative nutrition values and zero or negative quantities.

3.3.10. The system shall store an unknown value as unknown and shall not substitute zero for it.

3.3.11. The system shall apply storage-structure updates automatically when the application is opened, preserving all existing user data.

3.3.12. The system shall leave user data intact and allow the update to be completed on a later attempt when a storage-structure update is interrupted.

3.3.13. The system shall give every user record an identifier that remains unchanged for the life of the record and cannot collide with an identifier created on another device.

---

## 4. High Level Test Scenarios

4.1. **Pemakaian pertama tanpa internet** — Perangkat dalam mode pesawat, aplikasi baru dipasang → pengguna membuka aplikasi → layar pembuka Mealora tampil dengan janji penyimpanan lokal, lalu ruang utama terbuka tanpa permintaan akun dan tanpa pesan kesalahan jaringan.

4.2. **Menjelajah empat ruang** — Aplikasi terbuka → pengguna menekan Hari ini, Program, Riwayat, dan Profil bergantian → setiap ruang terbuka, ruang aktif ditandai dengan jelas, dan masing-masing menjelaskan apa yang akan muncul di sana.

4.3. **Ruang kosong tidak menampilkan nol** — Pemasangan baru → pengguna membuka Hari ini → layar menyatakan belum ada catatan, bukan menampilkan "0 kkal" atau grafik kosong tanpa keterangan.

4.4. **Keadaan tetap setelah ditutup** — Pengguna membuka ruang Riwayat lalu menutup aplikasi sepenuhnya → pengguna membuka aplikasi kembali → aplikasi kembali ke ruang Riwayat.

4.5. **Huruf diperbesar** — Pengguna menaikkan ukuran huruf perangkat ke tingkat besar → pengguna membuka seluruh ruang utama → semua teks terbaca utuh, tidak terpotong atau tertindih, dan seluruh tombol tetap dapat ditekan.

4.6. **Pembaca layar** — Pembaca layar diaktifkan → pengguna menyusuri navigasi → setiap tujuan dibacakan dengan nama yang bermakna beserta keterangan ruang mana yang sedang aktif.

4.7. **Angka dan satuan Indonesia** — Layar menampilkan contoh nilai → nilai tampil sebagai "2.100 kkal" dan "68,4 kg", bukan "2,100 kcal" atau "68.4 kg".

4.8. **Tidak ada lalu lintas keluar** — Perangkat terhubung internet dan lalu lintas jaringan diamati → pengguna membuka aplikasi dan menjelajah seluruh ruang → tidak ada permintaan jaringan yang keluar dari aplikasi.

4.9. **Data bertahan** — Data uji tersimpan di perangkat → aplikasi ditutup sepenuhnya, perangkat dimatikan dan dinyalakan kembali → data yang sama tersedia kembali tanpa koneksi.

4.10. **Gangguan saat penyesuaian penyimpanan** — Penyesuaian struktur penyimpanan dihentikan di tengah jalan → aplikasi dibuka kembali → data pengguna tetap utuh dan penyesuaian berjalan sampai selesai.

4.11. **Nilai mustahil ditolak** — Percobaan menyimpan nilai gizi negatif → penyimpanan ditolak dengan pemberitahuan dan tidak ada data yang tersimpan.

4.12. **Kegagalan tidak meninggalkan sisa** — Pencatatan berisi beberapa bagian gagal pada bagian terakhir → tidak ada satu pun bagian dari pencatatan itu yang tersimpan.
