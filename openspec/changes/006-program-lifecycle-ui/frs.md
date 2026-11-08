# Functional Requirements Specification

## Mealora — Mengelola Program yang Berjalan

| | |
|---|---|
| Change | 006-program-lifecycle-ui |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Ruang Program yang menampilkan keadaan program yang sedang berjalan, target hariannya, dan kemajuannya.
- Penjelasan asal-usul target: data yang dipakai, asumsi, peringatan, tanggal perhitungan terakhir, dan versi aturan yang berlaku.
- Menjeda program dan melanjutkannya kembali, termasuk apa yang berubah dan apa yang tetap berjalan selama dijeda.
- Mengganti program, dengan pratinjau pengganti sebelum apa pun berubah.
- Menyelesaikan program, dengan alasan yang dipilih pengguna dan ringkasan akhir yang disimpan.
- Riwayat seluruh program yang pernah dijalani, dan detail masing-masing dengan angka aslinya.
- Menyunting data profil dan meninjau target baru sebelum target itu berlaku.
- Keadaan khusus: belum ada program, profil belum lengkap, belum ada catatan berat, dan aturan gizi belum tersedia.

### 1.2 Deferred Items (Not in This FRS Version)

- Pencatatan makanan, pencarian katalog, dan buku harian harian. Karena itu, angka kemajuan yang bersumber dari catatan makanan masih ditampilkan sebagai belum diketahui pada pengiriman ini.
- Pencatatan dan pemantauan berat badan. Bagian berat pada ruang Program menampilkan catatan yang ada, tetapi belum ada cara menambahkannya dari dalam aplikasi.
- Pengaturan satuan, bahasa, privasi, dan penghapusan data lokal.
- Jalur foto makanan, pemindaian barcode, dan pembacaan label gizi.
- Pengingat, notifikasi, dan saran otomatis terkait program.

## 2. Melihat Program yang Berjalan

### 2.1 User Story

As a pengguna yang sedang menjalani program,
I want membuka satu tempat yang menunjukkan keadaan program saya apa adanya,
So that saya tahu di mana posisi saya tanpa harus menebak atau menghitung sendiri.

### 2.2 Functional Scope

- Ruang Program menampilkan nama program, keadaannya, target energi harian yang selalu disebut perkiraan, kemajuan yang sesuai jenis programnya, berat badan terbaru bila ada, dan tanggal perhitungan terakhir.
- Tersedia kendali untuk menjeda, mengganti, dan membuka riwayat program.
- Untuk program Makan Sehat, kemajuan ditampilkan sebagai kelengkapan pencatatan, bukan persentase perubahan berat.
- Nilai yang datanya belum ada ditampilkan sebagai belum diketahui. Mealora tidak menampilkan nol, grafik kosong tanpa keterangan, atau angka yang dikarang.
- Keadaan khusus ditangani secara sengaja: belum ada program berjalan, profil belum lengkap, belum ada catatan berat badan, dan aturan gizi belum tersedia. Masing-masing menjelaskan apa yang terjadi dan apa yang bisa dilakukan.
- **Tidak termasuk:** proyeksi kapan target akan tercapai, skor, dan peringkat.

### 2.3 Acceptance Criteria

2.3.1. The system shall display the program name, its state, the daily energy target labelled as an estimate, the applicable progress, the latest weight where available, and the date of the last calculation.

2.3.2. The system shall provide controls to pause, change, and open the history of programs.

2.3.3. The system shall display Makan Sehat progress as logging completeness and shall display no weight-progress percentage for it.

2.3.4. The system shall present values without data as unknown, and shall not display zero, an unlabelled empty chart, or an invented figure in their place.

2.3.5. The system shall provide a readable state for each of: no running program, incomplete profile, no weight records, and policy unavailable.

---

## 3. Memahami Asal-usul Target

### 3.1 User Story

As a pengguna yang sudah berminggu-minggu memakai satu target,
I want bisa membuka kembali dari mana angka itu berasal,
So that saya bisa menilai sendiri apakah angka itu masih masuk akal bagi saya.

### 3.2 Functional Scope

- Dari ruang Program, pengguna dapat membuka rincian yang menjelaskan asal-usul target yang berlaku.
- Rincian memuat data yang dipakai saat perhitungan, tingkat aktivitas, asumsi, peringatan yang berlaku, tanggal perhitungan terakhir, serta versi persamaan dan versi aturan gizi.
- Peringatan yang menyertai pembuatan target — misalnya bahwa batas bawah energi menaikkan targetnya — tetap dapat dibaca di sini, tidak hanya muncul sekali saat pratinjau.
- Semua nilai disebut sebagai perkiraan.
- **Tidak termasuk:** rumus, nama kolom, dan istilah teknis internal.

### 3.3 Acceptance Criteria

3.3.1. The system shall let the user open, from the Program space, a detail view explaining the origin of the current target.

3.3.2. The system shall include in that view the input used, the activity level, assumptions, applicable warnings, the date of the last calculation, the calculator version, and the policy version.

3.3.3. The system shall display warnings issued when the target was created in that view, not only at preview time.

3.3.4. The system shall label the values in that view as estimates.

---

## 4. Menjeda, Mengganti, dan Menyelesaikan

### 4.1 User Story

As a pengguna yang keadaannya berubah,
I want mengubah arah program saya dan tahu persis akibatnya sebelum terjadi,
So that saya tidak kehilangan apa pun karena salah menekan.

### 4.2 Functional Scope

- Program yang dijeda ditandai jelas, disertai sejak kapan dijeda, keterangan bahwa hari jeda tidak dihitung sebagai hari aktif, dan keterangan bahwa pencatatan makanan serta berat badan tetap tersedia.
- Pada keadaan dijeda, pengguna dapat melanjutkan, mengganti, atau menyelesaikan program.
- Sebelum program diganti, Mealora menampilkan pratinjau yang memuat program sekarang, program pengganti beserta targetnya, penegasan bahwa program lama pindah ke riwayat, dan penegasan bahwa catatan makanan serta berat tetap utuh.
- Membatalkan pratinjau pergantian tidak mengubah apa pun.
- Bila aturan gizi tidak menyetujui program pengganti, Mealora menjelaskan keadaannya tanpa menampilkan angka target, dan program lama tetap berjalan.
- Sebelum program diselesaikan, pengguna memilih alasan. Mealora menyatakan bahwa ringkasan akhir disimpan dan bahwa program yang selesai tidak dapat dilanjutkan, serta menyediakan jalan membatalkan.
- Program yang sudah selesai tidak menampilkan kendali untuk melanjutkan.
- **Tidak termasuk:** menjalankan dua program sekaligus dan menghidupkan kembali program yang sudah selesai.

### 4.3 Acceptance Criteria

4.3.1. The system shall mark a paused program clearly, without relying on colour alone, and state the pause start date.

4.3.2. The system shall state, on a paused program, that paused days do not count as active days and that food and weight logging remain available.

4.3.3. The system shall offer resume, change, and complete controls for a paused program.

4.3.4. The system shall present a change preview containing the current program, the replacement program with its target, a statement that the current program moves to history, and a statement that food and weight records remain intact.

4.3.5. The system shall change nothing when the user cancels a change preview.

4.3.6. The system shall explain the refusal without displaying any target figure, and keep the current program running, when the policy does not approve the replacement.

4.3.7. The system shall require the user to select a reason before completing a program.

4.3.8. The system shall state, before completion, that a final summary is saved and that a completed program cannot be resumed, and shall offer a way to cancel.

4.3.9. The system shall offer no resume control for a completed program.

---

## 5. Riwayat Program

### 5.1 User Story

As a pengguna yang sudah menjalani beberapa program,
I want melihat perjalanan saya dengan angka aslinya,
So that riwayat saya tetap bermakna meski aturan aplikasi berubah.

### 5.2 Functional Scope

- Riwayat menampilkan seluruh program yang pernah dijalani berurutan menurut waktu, masing-masing beserta keadaan akhirnya dan rentang tanggal berjalannya.
- Membuka satu entri menampilkan data yang dipakai saat perhitungan, nilai target, asumsi, peringatan, versi persamaan dan aturan, alasan berakhir, serta kemajuan akhir yang tersedia.
- Angka pada entri riwayat tetap seperti saat program itu disetujui, meski aturan gizi sudah diperbarui sejak itu.
- Bila sebuah nilai memang tidak pernah tercatat — misalnya tidak ada catatan berat pada hari terakhir — Mealora menyatakannya apa adanya, tidak mengisinya dengan nilai terakhir yang diketahui.
- Mealora menegaskan bahwa riwayat program tidak mengubah catatan makanan dan berat badan yang pernah disimpan.
- **Tidak termasuk:** menghapus satu entri riwayat secara terpisah.

### 5.3 Acceptance Criteria

5.3.1. The system shall list every program the user has followed in chronological order, each with its final state and the date range it ran.

5.3.2. The system shall display, for a selected entry, the input used, target values, assumptions, warnings, calculator version, policy version, ending reason, and the final progress available.

5.3.3. The system shall keep those figures as they were when the program was approved, even after the nutrition policy is updated.

5.3.4. The system shall state that a value was never recorded rather than substituting the last known value.

5.3.5. The system shall state that program history does not alter stored food and weight records.

---

## 6. Mengubah Profil dan Meninjau Target Baru

### 6.1 User Story

As a pengguna yang berat badannya berubah,
I want memperbarui data saya tanpa target saya berubah diam-diam,
So that saya tetap yang memutuskan angka mana yang saya ikuti.

### 6.2 Functional Scope

- Saat pengguna menyunting data profil, Mealora menyatakan bahwa perubahan itu tidak langsung mengubah target yang berlaku.
- Mealora menawarkan peninjauan target baru. Peninjauan menampilkan nilai baru, dasar perhitungannya, asumsi, peringatan, dan versi yang berlaku, serta perbandingan terhadap target yang sedang berjalan.
- Target baru berlaku hanya setelah pengguna menyetujuinya. Bila tidak disetujui, target lama tetap berlaku dan riwayat tidak berubah.
- Bila profil yang diperbarui membuat aturan gizi tidak lagi menyetujui target otomatis, Mealora menjelaskannya tanpa angka target, dan target lama tetap berlaku sampai pengguna mengambil tindakan.
- **Tidak termasuk:** penyesuaian target otomatis tanpa persetujuan.

### 6.3 Acceptance Criteria

6.3.1. The system shall state, when profile data is edited, that the change does not immediately alter the current target.

6.3.2. The system shall offer a review of the recalculated target, showing its values, basis, assumptions, warnings, versions, and a comparison with the current target.

6.3.3. The system shall apply a recalculated target only after the user approves it.

6.3.4. The system shall keep the previous target in force, and the history unchanged, when the user does not approve.

6.3.5. The system shall explain the situation without displaying target figures, and keep the previous target in force, when the updated profile is no longer approved by the policy.

---

## 7. High Level Test Scenarios

7.1. **Melihat program berjalan** — Program aktif → pengguna membuka ruang Program → tampil nama program, target berlabel perkiraan, tanggal perhitungan terakhir, dan kendali jeda, ganti, serta riwayat.

7.2. **Kemajuan belum ada datanya** — Program baru diaktifkan dan belum ada catatan apa pun → kemajuan tampil sebagai belum diketahui, bukan nol atau grafik kosong tanpa keterangan.

7.3. **Membuka penjelasan perhitungan** — Pengguna membuka rincian "Bagaimana dihitung" → tampil data yang dipakai, tingkat aktivitas, asumsi, peringatan, tanggal perhitungan terakhir, dan kedua versi.

7.4. **Peringatan tetap terbaca** — Target dibuat dengan peringatan batas bawah energi → berminggu-minggu kemudian peringatan itu masih dapat dibaca di rincian penjelasan.

7.5. **Program dijeda** — Pengguna menjeda program → keadaan dijeda tampak jelas beserta tanggal mulai, keterangan hari jeda tidak dihitung, dan keterangan pencatatan tetap jalan.

7.6. **Melanjutkan program** — Pengguna melanjutkan program setelah beberapa hari dijeda → program kembali aktif, dan rentang jeda terlihat di riwayat.

7.7. **Membatalkan pergantian** — Pengguna membuka pratinjau ganti program lalu membatalkan → program lama tetap berjalan dengan target yang sama, riwayat tidak bertambah.

7.8. **Mengganti program** — Pengguna menyetujui program pengganti → program lama pindah ke riwayat dengan keadaan diganti, program baru berjalan, catatan makanan dan berat tetap utuh.

7.9. **Pengganti ditolak kebijakan** — Program pengganti tidak disetujui aturan gizi → Mealora menjelaskan tanpa angka target, program lama tetap berjalan.

7.10. **Membatalkan penyelesaian** — Pengguna membuka layar selesaikan lalu memilih tetap di program ini → tidak ada yang berubah.

7.11. **Menyelesaikan program** — Pengguna memilih alasan dan menyelesaikan → program pindah ke riwayat dengan alasan dan ringkasan akhir → tidak ada kendali melanjutkan → pengguna dapat memilih program baru.

7.12. **Riwayat utuh setelah aturan berubah** — Aturan gizi diperbarui setelah sebuah program selesai → entri riwayat program itu tetap menampilkan target, asumsi, dan versi lama.

7.13. **Nilai yang tidak pernah tercatat** — Program lama tidak punya catatan berat di hari terakhir → detail menyatakan data itu belum ada, bukan menampilkan nilai terakhir yang diketahui.

7.14. **Revisi target tidak disetujui** — Pengguna mengubah berat badan, membuka peninjauan target baru, lalu menutupnya tanpa menyetujui → target lama tetap berlaku dan riwayat tidak berubah.

7.15. **Revisi target disetujui** — Pengguna menyetujui target baru → target berlaku, dan riwayat target sebelumnya tetap tersimpan apa adanya.

7.16. **Huruf diperbesar dan pembaca layar** — Seluruh layar program, riwayat, dan detail diperiksa pada skala teks besar dan dengan pembaca layar → teks terbaca utuh, keadaan program dapat dikenali tanpa bergantung pada warna, dan setiap kendali punya nama yang bermakna.
