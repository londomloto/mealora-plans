# Functional Requirements Specification

## Mealora — Ketahanan dan Kemajuan Program

| | |
|---|---|
| Change | 004-program-persistence |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Program yang dipilih pengguna beserta targetnya tetap ada setelah aplikasi ditutup dan dibuka kembali, tanpa internet.
- Jaminan bahwa pengguna tidak pernah berakhir dengan dua program berjalan sekaligus, atau tanpa program setelah sebuah pergantian gagal.
- Catatan kemajuan harian per tanggal, yang dapat dihitung ulang tanpa menggandakan angka.
- Perlakuan jujur terhadap hari yang belum dicatat: ditampilkan sebagai belum diketahui, bukan nol, dan bukan kegagalan memenuhi target.
- Hari-hari selama program dijeda tidak dihitung sebagai hari aktif, sementara pencatatan tetap tersimpan.
- Riwayat seluruh program yang pernah dijalani, lengkap dengan angka dan asumsi aslinya, yang tidak berubah meski aturan atau profil berubah.
- Perlakuan terhadap pengguna lama ketika aplikasi diperbarui: data lama tetap utuh dan tidak ada yang didaftarkan otomatis ke program.

### 1.2 Deferred Items (Not in This FRS Version)

- Layar yang menampilkan program, kemajuan, dan riwayat. Dokumen ini menetapkan perilakunya; layarnya dikirim pada change berikutnya.
- Pencatatan makanan itu sendiri — katalog, pencarian, dan buku harian — yang menjadi sumber angka kemajuan. Change ini menyiapkan tempat dan aturannya.
- Ukuran kualitas gizi yang dipakai program Makan Sehat untuk menilai konsistensi.
- Pencadangan, ekspor, impor, dan sinkronisasi antar perangkat.

## 2. Program yang Bertahan

### 2.1 User Story

As a pengguna yang memakai Mealora sehari-hari,
I want program dan targetnya tetap ada setiap kali saya membuka aplikasi,
So that saya tidak perlu mengatur ulang apa pun dan bisa memercayai aplikasi ini untuk jangka panjang.

### 2.2 Functional Scope

- Program yang sudah disetujui pengguna, beserta target, asumsi, peringatan, data yang dipakai menghitung, dan versi aturan yang berlaku, tetap ada setelah aplikasi ditutup sepenuhnya.
- Keadaan terakhir program dipulihkan apa adanya, termasuk keadaan dijeda beserta sejak kapan dijeda.
- Semua ini bekerja tanpa koneksi internet.
- Pengguna tidak pernah memiliki lebih dari satu program berjalan. Bila terjadi percobaan yang akan melanggar aturan itu — dari jalur mana pun — percobaan tersebut ditolak dan tidak ada yang tersimpan sebagian.
- Mengganti program berlangsung utuh: bila prosesnya gagal di tengah jalan, program lama tetap berjalan dan program baru tidak pernah ada.
- Catatan makanan dan berat badan tidak pernah dihapus, dipindahkan, atau diubah oleh perubahan program apa pun.
- **Tidak termasuk:** memulihkan program dari perangkat lain atau dari cadangan.

### 2.3 Acceptance Criteria

2.3.1. The system shall retain an activated program with its targets, assumptions, warnings, input snapshot, and versions after the application is fully closed and reopened.

2.3.2. The system shall restore the last lifecycle state, including a paused state with its original pause start time.

2.3.3. The system shall make all of the above available without a network connection.

2.3.4. The system shall reject any stored state in which one profile would have more than one running program, regardless of the path the write came from.

2.3.5. The system shall leave no partial change behind when such a write is rejected.

2.3.6. The system shall either store a program change in full or leave the previous program running, never both programs and never none.

2.3.7. The system shall preserve all food and weight records, unchanged and with the same ownership, across every program transition.

---

## 3. Kemajuan Harian

### 3.1 User Story

As a pengguna yang mengikuti sebuah program,
I want melihat kemajuan saya per hari secara jujur, termasuk hari yang belum saya catat,
So that saya tahu keadaan sebenarnya tanpa merasa dihukum oleh angka yang menyesatkan.

### 3.2 Functional Scope

- Mealora menyimpan catatan kemajuan untuk setiap tanggal: berat badan bila ada, perubahan berat terhadap berat awal program bila berlaku, energi yang tercatat bila ada, kesesuaian terhadap target bila dapat dihitung, jumlah waktu makan yang tercatat, penanda kelengkapan buku harian, dan hari keberapa dalam program.
- Catatan makanan dan berat badan tetap menjadi sumber kebenaran. Catatan kemajuan adalah ringkasan yang dapat dihitung ulang kapan saja.
- Menghitung ulang kemajuan sebuah tanggal selalu menghasilkan satu catatan untuk tanggal itu, berapa kali pun dihitung ulang. Angka tidak pernah bertambah ganda.
- Bila pengguna menyunting catatan makanan pada tanggal yang sudah punya ringkasan, ringkasan itu mengikuti nilai terbaru.
- Hari yang belum dicatat ditampilkan sebagai belum diketahui, bukan 0 kkal, dan tidak dihitung sebagai target yang gagal.
- Hari-hari selama program dijeda tidak menambah hitungan hari aktif dan tidak ikut dalam penilaian kesesuaian target. Catatan makanan pada hari itu tetap tersimpan dan dapat dilihat.
- Tanggal sebuah catatan tidak berpindah meski pengguna berpindah zona waktu di kemudian hari.
- **Tidak termasuk:** prediksi, proyeksi tanggal tercapainya target, dan penilaian berupa skor atau nilai.

### 3.3 Acceptance Criteria

3.3.1. The system shall store a daily progress record per calendar date containing weight where available, weight change against the program's starting weight where applicable, recorded energy where available, target adherence where calculable, the number of recorded meal times, a diary completeness indicator, and the program day number.

3.3.2. The system shall treat food and weight records as the source of truth and daily progress records as a derived summary.

3.3.3. The system shall produce exactly one progress record per date regardless of how many times progress is recalculated.

3.3.4. The system shall not accumulate or duplicate values across recalculations.

3.3.5. The system shall reflect the latest edited values in the progress record after a food record on that date is changed and progress is recalculated.

3.3.6. The system shall present unrecorded values as unknown rather than zero, and shall not count such a day as a failed target.

3.3.7. The system shall exclude paused days from the active-day count and from target adherence, while keeping food records made on those days available.

3.3.8. The system shall keep a record on the same calendar date it was recorded on after the user changes time zone.

---

## 4. Riwayat Program

### 4.1 User Story

As a pengguna yang sudah berganti program beberapa kali,
I want melihat seluruh program yang pernah saya jalani dengan angka aslinya,
So that perjalanan saya punya catatan yang bisa saya percaya dan saya pahami.

### 4.2 Functional Scope

- Semua program yang pernah dijalani pengguna tersimpan beserta keadaan akhirnya — selesai, diganti, atau dibatalkan — dan dapat dilihat berurutan menurut waktu.
- Setiap entri memuat data yang dipakai menghitung, nilai target, asumsi, peringatan, versi aturan dan persamaan, alasan berakhir, serta rentang tanggal berjalannya.
- Angka pada entri riwayat tidak berubah ketika aturan gizi diperbarui, keterangan program diperbarui, profil disunting, atau program baru diaktifkan.
- Program yang sudah tidak ditawarkan lagi tetap muncul utuh di riwayat pengguna yang pernah menjalaninya.
- **Tidak termasuk:** menghapus satu entri riwayat secara terpisah. Penghapusan hanya tersedia sebagai penghapusan seluruh data lokal.

### 4.3 Acceptance Criteria

4.3.1. The system shall store every program the user has followed, together with its final state, and present them in chronological order.

4.3.2. The system shall include, in each history entry, the input snapshot, target values, assumptions, warnings, calculator version, policy version, ending reason, and the date range it ran.

4.3.3. The system shall leave history entry values unchanged when the nutrition policy, programme catalogue, or user profile is updated, or when a new program is activated.

4.3.4. The system shall continue to display a withdrawn program in the history of users who followed it.

---

## 5. Pembaruan Aplikasi bagi Pengguna Lama

### 5.1 User Story

As a pengguna yang sudah memakai Mealora sebelum fitur program ada,
I want pembaruan aplikasi tidak menghilangkan catatan saya dan tidak memasukkan saya ke program tanpa saya tahu,
So that saya tetap memegang kendali dan tidak kehilangan apa yang sudah saya kumpulkan.

### 5.2 Functional Scope

- Ketika aplikasi diperbarui, seluruh data yang sudah ada tetap utuh: profil, catatan makanan, makanan buatan sendiri, favorit, dan riwayat berat badan.
- Tidak ada pengguna yang didaftarkan otomatis ke program mana pun.
- Setelah pembaruan, pengguna diajak memilih program, dan seluruh catatan lama tetap dapat dibuka selama ia belum memilih.
- Bila pembaruan struktur data terganggu sebelum selesai, data tidak rusak dan percobaan berikutnya menyelesaikannya.
- Bila target gizi lama dikonversi menjadi program, pengguna meninjau dan menyetujuinya lebih dulu; nilai aslinya tetap disimpan.
- **Tidak termasuk:** menurunkan aplikasi ke versi sebelumnya. Hal ini dinyatakan tidak didukung.

### 5.3 Acceptance Criteria

5.3.1. The system shall preserve every existing profile, food record, custom food, favourite, and weight record when the storage structure is upgraded.

5.3.2. The system shall not enrol any existing profile into a program during the upgrade.

5.3.3. The system shall offer program selection after the upgrade without blocking access to existing records.

5.3.4. The system shall leave user data intact and allow a later attempt to complete the upgrade, when an upgrade is interrupted.

5.3.5. The system shall require the user to review and confirm a converted legacy target before any program becomes active, and shall retain the original values.

---

## 6. High Level Test Scenarios

6.1. **Program bertahan** — Pengguna mengaktifkan program, menutup aplikasi sepenuhnya, mematikan dan menyalakan perangkat, lalu membuka aplikasi dalam mode pesawat → program yang sama tampil dengan target, asumsi, dan versi yang sama persis.

6.2. **Jeda bertahan** — Pengguna menjeda program lalu menutup dan membuka aplikasi → program tetap dijeda dengan tanggal mulai jeda yang sama, dan pencatatan tetap bisa dilakukan.

6.3. **Tidak pernah dua program** — Perintah aktivasi dijalankan dua kali berturut-turut → tetap ada tepat satu program berjalan dan tidak ada entri ganda di riwayat.

6.4. **Pergantian gagal** — Proses ganti program dihentikan paksa di tengah jalan → program lama tetap berjalan, program baru tidak ada, riwayat tidak bertambah, catatan makanan utuh.

6.5. **Hitung ulang tidak menggandakan** — Kemajuan satu tanggal dihitung ulang tiga kali → hanya ada satu catatan untuk tanggal itu dengan angka yang sama seperti hitungan pertama.

6.6. **Suntingan tercermin** — Pengguna menyunting porsi makan siang pada tanggal yang ringkasannya sudah ada → setelah dihitung ulang, ringkasan tanggal itu memakai nilai baru tanpa menggandakan nilai lama.

6.7. **Hari tanpa catatan** — Pengguna membuka tanggal yang belum dicatat → konsumsi tampil sebagai belum diketahui, bukan 0 kkal, dan hari itu tidak ditandai gagal.

6.8. **Hari jeda** — Program dijeda tiga hari dan pengguna tetap mencatat sarapan → ketiga hari tidak menambah hitungan hari aktif, sedangkan catatan sarapan tetap tersimpan dan terlihat.

6.9. **Zona waktu berubah** — Pengguna mencatat beberapa hari lalu berpindah zona waktu → catatan dan ringkasan lama tetap berada pada tanggal yang sama.

6.10. **Riwayat utuh** — Pengguna berganti program dua kali lalu membuka riwayat → ketiga program tampil berurutan dengan keadaan akhir masing-masing dan angka aslinya.

6.11. **Aturan diperbarui** — Versi aturan gizi diganti setelah pengguna menyelesaikan sebuah program → entri riwayat program itu tetap menampilkan target, asumsi, dan versi lama.

6.12. **Pengguna lama setelah pembaruan** — Aplikasi berisi data lama diperbarui ke versi yang mendukung program → seluruh catatan lama terbuka, tidak ada program aktif, dan pengguna diajak memilih program.

6.13. **Pembaruan terputus** — Pembaruan struktur data dihentikan paksa di tengah jalan → data pengguna tetap utuh dan pembukaan berikutnya menyelesaikan pembaruan.
