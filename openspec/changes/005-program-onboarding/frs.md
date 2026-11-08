# Functional Requirements Specification

## Mealora — Perjalanan Pertama: Profil dan Program

| | |
|---|---|
| Change | 005-program-onboarding |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Perjalanan pengguna baru dari membuka aplikasi pertama kali sampai sebuah program berjalan.
- Pengisian data diri yang diperlukan untuk memperkirakan kebutuhan energi, termasuk mana yang wajib dan mana yang boleh dilewati.
- Pemilihan di antara empat program dan pengisian masukan tambahan yang sesuai program tersebut.
- Pratinjau target beserta dasar perhitungannya, dan persetujuan pengguna sebagai satu-satunya cara program menjadi aktif.
- Keadaan ketika Mealora tidak dapat membuat target: penjelasan yang aman, penegasan bahwa tidak ada yang berubah, dan tawaran langkah berikutnya.
- Keadaan ketika pengguna belum memiliki program, termasuk pengguna lama yang datang dari versi aplikasi sebelumnya.
- Perlakuan ketika data pengguna berubah antara pratinjau dan persetujuan.
- Perilaku ruang Hari ini segera setelah program aktif.

### 1.2 Deferred Items (Not in This FRS Version)

- Mengelola program yang sudah berjalan: menjeda, melanjutkan, mengganti, menyelesaikan, dan melihat riwayat program. Semua itu dikirim pada change berikutnya.
- Pencatatan makanan, pencarian katalog, buku harian, dan pemantauan berat badan.
- Pengaturan satuan, bahasa, privasi, dan penghapusan data; ruang Profil tetap kosong pada pengiriman ini.
- Jalur foto makanan, pemindaian barcode, dan pembacaan label gizi.
- Angka target itu sendiri, yang ditetapkan pada change 002 dan masih menunggu persetujuan peninjau gizi. Selama belum disetujui, onboarding berakhir pada keadaan "target belum tersedia".

## 2. Data Diri

### 2.1 User Story

As a pengguna yang baru memasang Mealora,
I want mengisi data seperlunya dan tahu untuk apa data itu dipakai,
So that saya merasa aman memberikannya tanpa harus membuat akun.

### 2.2 Functional Scope

- Mealora menyimpan satu profil di perangkat tanpa pendaftaran dan tanpa koneksi internet.
- Data yang wajib diisi: tanggal lahir, tinggi badan, berat badan saat ini, masukan biologis untuk persamaan energi, dan tingkat aktivitas. Nama panggilan boleh dikosongkan.
- Isian masukan biologis disertai keterangan bahwa nilai itu dipakai hanya untuk persamaan perkiraan energi, bukan sebagai identitas gender pengguna.
- Tingkat aktivitas ditawarkan sebagai tiga pilihan dengan penjelasan sehari-hari, disertai keterangan bahwa pilihan itu memengaruhi perkiraan dan dapat diubah nanti.
- Nilai yang mustahil ditolak dengan penjelasan rentang yang diterima, dan pengguna tidak dapat melanjutkan selama isian wajib pada langkah itu belum benar.
- Berat dan tinggi disimpan dalam kilogram dan sentimeter. Mengubah satuan tampilan tidak mengubah nilai yang tersimpan maupun angka pada target yang sudah disetujui.
- Mengubah data profil tidak langsung mengubah target program yang sedang berjalan. Mealora menawarkan peninjauan target baru, dan target baru berlaku hanya setelah disetujui.
- Data profil tidak pernah dikirim ke luar perangkat, dan ikut terhapus ketika pengguna menghapus seluruh data lokal.
- **Tidak termasuk:** foto profil, data kontak, dan data apa pun yang tidak dipakai perhitungan atau penilaian kelayakan.

### 2.3 Acceptance Criteria

2.3.1. The system shall store one local profile per device without registration, sign-in, or a network connection.

2.3.2. The system shall require date of birth, height, current weight, the biological input used by the energy equation, and activity level, and shall accept an empty nickname.

2.3.3. The system shall display, next to the biological input, a statement that the value is used only for the energy estimation equation and not as the user's gender identity.

2.3.4. The system shall offer exactly three activity levels, each with a plain-language description, and state that the choice affects the estimate and can be changed later.

2.3.5. The system shall reject implausible values, explain the accepted range, and prevent the user from continuing while a required field on that step is invalid.

2.3.6. The system shall store height in centimetres and weight in kilograms, and shall leave stored values and approved targets unchanged when the display unit changes.

2.3.7. The system shall keep a running program's target in force when profile data changes, and shall require explicit approval before a recalculated target takes effect.

2.3.8. The system shall never transmit profile data off the device, and shall delete it together with all other data when the user deletes all local data.

---

## 3. Memilih Program

### 3.1 User Story

As a pengguna yang baru selesai mengisi data,
I want memilih arah yang sesuai keadaan saya dari pilihan yang jelas,
So that saya tahu untuk apa Mealora akan saya pakai sehari-hari.

### 3.2 Functional Scope

- Mealora menampilkan empat program beserta maksud masing-masing dalam bahasa sehari-hari, dan menyatakan bahwa program dapat diganti di kemudian hari.
- Mealora menyatakan bahwa rekomendasi berat tertentu memerlukan kebijakan gizi tervalidasi.
- Setelah memilih, masukan tambahan yang diminta mengikuti program: berat awal dan berat tujuan untuk Turun Berat dan Naik Berat, fokus kebiasaan untuk Makan Sehat. Pertahankan dan Makan Sehat tidak pernah meminta berat tujuan.
- Tanggal tujuan boleh dikosongkan dan tidak menghalangi program dimulai. Mealora menyatakan bahwa tanggal tidak pernah mengesampingkan aturan keselamatan.
- Sebelum pratinjau ditampilkan, pengguna mengakui bahwa target dan data makanan adalah perkiraan, bukan nasihat medis. Tanpa pengakuan itu, pratinjau tidak ditampilkan.
- Setiap layar menunjukkan langkah keberapa dari berapa, dan pengguna dapat kembali ke langkah sebelumnya tanpa kehilangan isian.
- Bila aplikasi ditutup di tengah proses, isian yang sudah tersimpan tidak hilang dan pengguna dapat melanjutkan.
- **Tidak termasuk:** program buatan pengguna sendiri dan penggabungan dua program sekaligus.

### 3.3 Acceptance Criteria

3.3.1. The system shall present four programs with their purposes in plain language, and state that the program can be changed later.

3.3.2. The system shall state that weight-related recommendations require a validated nutrition policy.

3.3.3. The system shall request a starting weight and a target weight for Turun Berat and Naik Berat, and shall not request a target weight for Pertahankan or Makan Sehat.

3.3.4. The system shall request a habit focus for Makan Sehat.

3.3.5. The system shall treat the target date as optional and state that a date never overrides safety rules.

3.3.6. The system shall require the user to acknowledge that targets and food data are estimates and not medical advice before any target preview is shown.

3.3.7. The system shall show the current step number and total on every onboarding screen.

3.3.8. The system shall preserve entered values when the user returns to a previous step.

3.3.9. The system shall preserve saved input when the application is closed mid-onboarding and allow the user to continue from where they left off.

---

## 4. Meninjau dan Menyetujui Target

### 4.1 User Story

As a pengguna yang akan memulai program,
I want melihat dari mana angka target saya berasal sebelum menyetujuinya,
So that saya memulai dengan sadar, bukan karena disodori angka.

### 4.2 Functional Scope

- Pratinjau menampilkan target energi harian, dasar perkiraan berupa data profil dan tingkat aktivitas yang dipakai, asumsi yang berlaku, peringatan bila ada, serta versi persamaan dan versi aturan gizi.
- Pratinjau menyatakan bahwa belum ada program aktif sebelum pengguna menyetujui.
- Semua angka disebut sebagai perkiraan, bukan hasil pengukuran atau jaminan.
- Menutup pratinjau tanpa menyetujui tidak mengaktifkan program apa pun dan tidak menyimpan data program.
- Saat pengguna menyetujui, Mealora memeriksa kembali apakah data yang dipakai pratinjau masih berlaku. Bila ada yang berubah — misalnya berat badan baru saja diperbarui — Mealora membatalkan proses, menyebutkan nilai mana yang berubah beserta nilai lama dan barunya, lalu menampilkan pratinjau yang sudah diperbarui untuk ditinjau ulang.
- Setelah program aktif, pengguna mendarat di ruang Hari ini dan melihat program aktif beserta target hariannya. Bagian konsumsi masih berupa keadaan belum diketahui, karena pencatatan makanan belum tersedia pada pengiriman ini.
- **Tidak termasuk:** mengaktifkan program secara otomatis, dan menyimpan rancangan program yang belum disetujui.

### 4.3 Acceptance Criteria

4.3.1. The system shall display the daily energy target, the profile data and activity level used, applicable assumptions, any warnings, the equation version, and the policy version on the preview.

4.3.2. The system shall state on the preview that no program is active until the user approves.

4.3.3. The system shall label all displayed values as estimates.

4.3.4. The system shall activate no program and store no program data when the preview is closed without approval.

4.3.5. The system shall re-check, at the moment of approval, whether the data used for the preview still applies.

4.3.6. The system shall cancel the activation, name the values that changed with their previous and current values, and present an updated preview for review, when that data no longer applies.

4.3.7. The system shall not activate a program using outdated values.

4.3.8. The system shall take the user to the Hari ini space, showing the active program and its daily target, after a successful activation.

4.3.9. The system shall present consumption as unknown in the Hari ini space while food logging is not yet available.

---

## 5. Ketika Target Tidak Dapat Dibuat

### 5.1 User Story

As a pengguna yang keadaannya tidak bisa ditangani Mealora,
I want ditolak dengan penjelasan yang jelas dan tidak menghakimi,
So that saya tahu apa yang terjadi dan apa yang bisa saya lakukan, tanpa merasa ada yang salah dengan diri saya.

### 5.2 Functional Scope

- Ketika aturan gizi tidak mengizinkan pembuatan target, Mealora menjelaskan keadaannya tanpa menyampaikan diagnosis.
- Penjelasan menyatakan bahwa tidak ada target yang dibuat, dan bahwa data serta program sebelumnya tidak berubah.
- Mealora menawarkan langkah berikutnya yang lebih aman, misalnya program Makan Sehat yang tidak memakai target perubahan berat.
- Tidak ada angka target yang ditampilkan dalam keadaan ini — termasuk angka sebagian maupun angka contoh.
- Bila berat tujuan dan tanggal tujuan menuntut laju yang terlalu cepat, Mealora menjelaskan konfliknya, menyebutkan tanggal paling awal yang memenuhi batas, dan meminta pengguna mengubah masukan. Mealora tidak pernah menyesuaikan target diam-diam agar cocok dengan tanggal yang diminta.
- Keadaan "belum ada program" tersedia bagi pengguna yang melewati pemilihan, pengguna yang programnya sudah berakhir, dan pengguna dari versi aplikasi sebelum program ada. Keadaan ini menegaskan bahwa catatan makanan dan berat yang lama tetap ada dan dapat dibuka.
- **Tidak termasuk:** saran medis, rujukan ke penyedia layanan tertentu, dan penilaian atas kondisi pengguna.

### 5.3 Acceptance Criteria

5.3.1. The system shall explain a refusal without stating a diagnosis.

5.3.2. The system shall state that no target was created and that existing data and programs are unchanged.

5.3.3. The system shall offer a safer next step, such as a program without a weight-change target.

5.3.4. The system shall display no target figures in a refusal state, including partial or example figures.

5.3.5. The system shall explain the conflict, state the earliest date that satisfies the limits, and ask the user to change the input, when the requested weight and date require an excessive rate.

5.3.6. The system shall not adjust a target silently to match a requested date.

5.3.7. The system shall provide a "no program yet" state that invites the user to choose a program and confirms that existing food and weight records remain available.

5.3.8. The system shall present that state to users who skip program selection, users whose program has ended, and users upgrading from a version without programs.

5.3.9. The system shall avoid, across every onboarding screen, text that promises a specific result, states a diagnosis, or blames the user.

---

## 6. High Level Test Scenarios

6.1. **Perjalanan pertama tanpa internet** — Perangkat dalam mode pesawat, aplikasi baru dipasang → pengguna melewati sambutan, mengisi profil, memilih aktivitas, memilih Makan Sehat, mengakui bahwa hasil adalah perkiraan, meninjau target, lalu menyetujui → program aktif dan pengguna mendarat di ruang Hari ini tanpa satu pun permintaan jaringan.

6.2. **Nama panggilan dilewati** — Pengguna mengosongkan nama panggilan → proses tetap berlanjut.

6.3. **Nilai tidak masuk akal** — Pengguna mengisi tinggi badan 15 cm → Mealora menolak dengan penjelasan rentang yang diterima dan tidak melanjutkan.

6.4. **Kembali tanpa kehilangan isian** — Pengguna maju ke langkah aktivitas lalu kembali ke profil → semua isian masih ada.

6.5. **Ditutup di tengah jalan** — Pengguna menutup aplikasi setelah mengisi profil, lalu membukanya kembali → isian profil masih ada dan pengguna melanjutkan dari langkah berikutnya.

6.6. **Makan Sehat tanpa berat tujuan** — Pengguna memilih Makan Sehat → tidak ada permintaan berat tujuan di seluruh alur.

6.7. **Pengakuan wajib** — Pengguna mencoba melihat pratinjau tanpa memberi pengakuan → Mealora menahan langkah dan menjelaskan apa yang perlu diakui.

6.8. **Pratinjau ditutup** — Pengguna melihat pratinjau lalu menutupnya → tidak ada program aktif dan tidak ada data program yang tersimpan.

6.9. **Data berubah sejak pratinjau** — Pengguna melihat pratinjau, berat badan diperbarui di latar, lalu pengguna menekan setujui → Mealora membatalkan aktivasi, menyebut berat lama dan berat baru, dan menampilkan pratinjau yang diperbarui.

6.10. **Kebijakan belum disetujui** — Aturan gizi masih berstatus draf → pengguna menyelesaikan seluruh masukan → Mealora menyatakan target belum tersedia, tidak menampilkan satu pun angka, dan menawarkan langkah berikutnya.

6.11. **Profil di luar cakupan** — Profil berusia 17 tahun memilih Turun Berat → Mealora menolak tanpa diagnosis, menyatakan tidak ada target yang dibuat, dan menawarkan langkah lain.

6.12. **Tanggal terlalu cepat** — Pengguna meminta turun 6 kg dalam 4 minggu → Mealora menjelaskan batas laju, menyebut tanggal paling awal yang memenuhi, dan meminta masukan diubah.

6.13. **Melewati pemilihan program** — Pengguna menutup aplikasi sebelum mengaktifkan program, lalu membukanya kembali → tampil keadaan belum ada program dengan ajakan memilih.

6.14. **Pengguna dari versi sebelumnya** — Aplikasi berisi catatan lama diperbarui → tidak ada program aktif, catatan lama tetap terbuka, pengguna diajak memilih program.

6.15. **Huruf diperbesar dan pembaca layar** — Seluruh layar onboarding diperiksa pada skala teks besar dan dengan pembaca layar → teks terbaca utuh, setiap isian dan tombol punya nama yang bermakna, dan pesan kesalahan dapat dikenali tanpa bergantung pada warna.
