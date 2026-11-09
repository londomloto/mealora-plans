# Functional Requirements Specification

## Mealora — Program: Pilihan dan Perjalanannya

| | |
|---|---|
| Change | 003-program-domain |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Empat program yang ditawarkan Mealora: Turun Berat, Naik Berat, Pertahankan, dan Makan Sehat, beserta maksud masing-masing.
- Informasi yang diminta Mealora sebelum sebuah program dapat diusulkan, dan perbedaannya antar program.
- Aturan bahwa seorang pengguna hanya menjalani satu program pada satu waktu.
- Perjalanan sebuah program: dimulai, dijeda, dilanjutkan, diganti, diselesaikan, atau dibatalkan — termasuk perpindahan mana yang tidak diperbolehkan.
- Jaminan bahwa mengganti atau menyelesaikan program tidak pernah menghapus atau memindahkan catatan makanan dan berat badan.
- Jaminan bahwa program yang sudah disetujui tetap menampilkan angka dan asumsi aslinya meski aturan atau profil berubah.
- Aturan bahwa program hanya aktif setelah pengguna meninjau dan menyetujui targetnya.

### 1.2 Deferred Items (Not in This FRS Version)

- Tampilan layar pemilihan program, pratinjau target, dan persetujuan. Dokumen ini menetapkan aturannya; layarnya dikirim pada change berikutnya.
- Penyimpanan program di perangkat, termasuk riwayat yang bertahan setelah aplikasi ditutup.
- Perhitungan kemajuan harian dari buku harian makanan, grafik berat, dan ringkasan mingguan.
- Angka target itu sendiri — besaran kalori, protein, lemak, karbohidrat, dan serat — sudah ditetapkan final pada change 002 (`np-1.0.0`); mengubahnya adalah change tersendiri, bukan pekerjaan dokumen ini.
- Pengingat, notifikasi, dan saran otomatis terkait program.

## 2. Pilihan Program

### 2.1 User Story

As a pengguna baru Mealora,
I want memilih arah yang sesuai dengan keadaan saya dari pilihan yang sedikit dan jelas,
So that saya tidak perlu memahami istilah gizi untuk mulai memakai aplikasi.

### 2.2 Functional Scope

- Mealora menawarkan tepat empat program: **Turun Berat**, **Naik Berat**, **Pertahankan**, dan **Makan Sehat**. Tidak lebih dan tidak kurang.
- Setiap program disertai keterangan maksudnya dalam bahasa sehari-hari.
- Turun Berat dan Naik Berat meminta berat tujuan. Tanggal tujuan boleh dikosongkan dan tidak menghalangi program dimulai.
- Pertahankan meminta berat saat ini; rentang pemeliharaan yang disukai bersifat pilihan.
- Makan Sehat tidak pernah meminta berat tujuan. Pengguna memilih fokus kebiasaan yang ingin diperhatikan.
- Seluruh program meminta data dasar yang sama: usia atau tanggal lahir, masukan biologis untuk persamaan energi, tinggi badan, berat saat ini, tingkat aktivitas, dan jawaban pertanyaan kelayakan.
- Bila ada data wajib yang belum diisi, Mealora menyebutkan data mana yang kurang alih-alih menolak tanpa keterangan.
- Kemajuan program Makan Sehat diukur dari kelengkapan pencatatan, bukan dari persentase perubahan berat. Mealora tidak menampilkan angka kemajuan berat untuk program ini.
- Bila sebuah program tidak lagi ditawarkan, program itu hilang dari daftar pilihan, tetapi tetap muncul utuh di riwayat pengguna yang pernah menjalaninya.
- **Tidak termasuk:** program buatan pengguna sendiri, program medis, dan program dengan aturan gizi khusus.

### 2.3 Acceptance Criteria

2.3.1. The system shall offer exactly four programs: Turun Berat, Naik Berat, Pertahankan, and Makan Sehat.

2.3.2. The system shall present the purpose of each program in plain language.

2.3.3. The system shall require a target weight for Turun Berat and Naik Berat, and shall not require one for Pertahankan and Makan Sehat.

2.3.4. The system shall allow a program to start without a target date.

2.3.5. The system shall name the missing information when required input is incomplete.

2.3.6. The system shall measure Makan Sehat progress by logging completeness and nutrition-range adherence, and shall not display any weight-progress percentage for that program.

2.3.7. The system shall remove a withdrawn program from the selection list while continuing to display it, with its original name and purpose, in the history of users who followed it.

2.3.8. The system shall keep the values, assumptions, and versions of a user's running or completed program unchanged when the catalogue description of that program is updated.

---

## 3. Memulai Program

### 3.1 User Story

As a pengguna yang akan memulai program,
I want menyetujui target saya sendiri setelah melihat dasarnya,
So that tidak ada program yang berjalan atas nama saya tanpa saya ketahui.

### 3.2 Functional Scope

- Sebuah program hanya menjadi aktif setelah pengguna meninjau nilai target, asumsi, peringatan, serta versi aturan dan persamaan yang dipakai, lalu menyetujuinya secara tegas.
- Sebelum program diaktifkan, Mealora memeriksa kembali data terkini. Bila data yang dipakai saat pratinjau sudah berubah — misalnya berat badan diperbarui — Mealora membatalkan proses, memberi tahu bahwa masukan telah berubah, dan meminta pengguna meninjau ulang.
- Mealora tidak pernah mengaktifkan program atas dasar hasil yang tidak disetujui: profil di luar cakupan, perlu ditinjau tenaga kesehatan, perlu diperbaiki pengguna, atau aturan belum tersedia.
- Menyiapkan rencana program baru tidak mengganggu program yang sedang berjalan. Program lama tetap berjalan sampai pengguna menyetujui penggantinya.
- **Tidak termasuk:** aktivasi otomatis, program bawaan yang langsung berjalan setelah pemasangan, dan pendaftaran ulang otomatis pengguna lama.

### 3.3 Acceptance Criteria

3.3.1. The system shall activate a program only after the user has reviewed its target values, assumptions, warnings, and applicable versions, and has explicitly confirmed.

3.3.2. The system shall re-check current profile data immediately before activation.

3.3.3. The system shall cancel the activation, state that the input has changed since the preview, and ask the user to review again, when the data used for the preview no longer matches.

3.3.4. The system shall refuse activation for any proposal that is not approved by the applicable policy.

3.3.5. The system shall leave a running program unchanged while the user prepares a new program proposal.

---

## 4. Perjalanan Program

### 4.1 User Story

As a pengguna yang keadaannya berubah-ubah,
I want bisa menjeda, mengganti, atau menyelesaikan program tanpa kehilangan catatan saya,
So that program mengikuti hidup saya, bukan sebaliknya.

### 4.2 Functional Scope

- Pengguna menjalani paling banyak satu program pada satu waktu. Rencana program yang belum disetujui tidak dihitung sebagai program berjalan.
- Dari program yang berjalan, pengguna dapat: menjeda, melanjutkan kembali, mengganti dengan program lain, atau menyelesaikannya.
- Program yang dijeda ditandai jelas sebagai dijeda. Hari-hari selama jeda tidak dihitung sebagai hari aktif dan tidak ikut dalam penilaian kesesuaian target.
- Selama dijeda, pengguna tetap dapat mencatat makanan dan berat badan seperti biasa.
- Program yang sudah selesai, sudah diganti, atau sudah dibatalkan tidak dapat dilanjutkan lagi. Pengguna dapat memulai program baru kapan saja.
- Saat mengganti program, Mealora menampilkan pratinjau pengganti lebih dulu. Program lama berpindah ke riwayat hanya setelah pengganti disetujui. Membatalkan pratinjau tidak mengubah apa pun.
- Pergantian berlangsung utuh: bila proses gagal di tengah jalan, program lama tetap berjalan dan program baru tidak pernah ada. Pengguna tidak pernah berada dalam keadaan tanpa program atau dengan dua program sekaligus.
- Menyelesaikan program mencatat alasan yang dipilih pengguna dan menyimpan ringkasan akhir dari data yang tersedia.
- Catatan makanan dan berat badan tidak pernah dihapus, dipindahkan, atau ditulis ulang oleh perubahan program apa pun.
- Mengulang perintah yang sama — misalnya menjeda program yang sudah dijeda — tidak menimbulkan keadaan ganda dan tidak menampilkan kesalahan yang membingungkan.
- Pengguna dapat melihat perjalanan setiap program di riwayat: kapan dimulai, dijeda, dilanjutkan, diganti, atau diselesaikan.
- **Tidak termasuk:** menjalankan dua program sekaligus, dan membangkitkan kembali program yang sudah selesai.

### 4.3 Acceptance Criteria

4.3.1. The system shall allow at most one running program, whether active or paused, per profile at any time.

4.3.2. The system shall not count an unconfirmed program proposal as a running program.

4.3.3. The system shall refuse to resume a program that has been completed, changed, or cancelled, and shall explain why.

4.3.4. The system shall exclude paused days from the count of active days and from target adherence.

4.3.5. The system shall keep food and weight logging fully available while a program is paused.

4.3.6. The system shall present a preview of the replacement program before the current program is moved to history.

4.3.7. The system shall leave the current program and all records unchanged when the user cancels a change preview.

4.3.8. The system shall either complete a program change entirely or leave the previous program running, never both programs and never none.

4.3.9. The system shall record the user's stated reason and a final summary when a program is completed.

4.3.10. The system shall preserve all food and weight records across every program transition, without deleting, moving, or rewriting them.

4.3.11. The system shall treat a repeated lifecycle command with the same intent as already satisfied, without creating duplicate states or events.

4.3.12. The system shall make each program's sequence of lifecycle events, including every pause period, viewable in history.

---

## 5. Penjelasan Target Lama

### 5.1 User Story

As a pengguna yang sudah lama memakai Mealora,
I want target lama saya tetap bisa dijelaskan apa adanya,
So that riwayat saya bermakna dan tidak berubah di belakang saya.

### 5.2 Functional Scope

- Setiap program yang pernah aktif menyimpan salinan data yang dipakai saat perhitungan, nilai target yang disetujui, asumsi dan peringatan yang ditampilkan saat itu, serta versi aturan dan persamaan yang berlaku.
- Nilai-nilai tersebut tidak berubah ketika aturan gizi diperbarui, keterangan program di katalog diperbarui, atau profil pengguna disunting.
- Pengguna dapat membuka program lama di riwayat dan melihat seluruh dasar perhitungannya.
- **Tidak termasuk:** perhitungan ulang otomatis atas program yang sudah selesai.

### 5.3 Acceptance Criteria

5.3.1. The system shall store, for every activated program, the input snapshot, approved target values, assumptions, warnings, calculator version, and policy version.

5.3.2. The system shall leave those stored values unchanged when the nutrition policy, the programme catalogue, or the user profile is updated.

5.3.3. The system shall allow the user to open a past program and see the inputs, targets, assumptions, and versions it was approved with.

---

## 6. High Level Test Scenarios

6.1. **Empat pilihan** — Pengguna membuka pemilihan program → tampil tepat empat program beserta maksudnya, tidak ada pilihan tersembunyi atau tambahan.

6.2. **Makan Sehat tanpa berat tujuan** — Pengguna memilih Makan Sehat → tidak ada permintaan berat tujuan → program dapat diusulkan dan tidak ada persentase kemajuan berat di layar mana pun.

6.3. **Data wajib kurang** — Pengguna memilih Turun Berat tanpa berat tujuan → Mealora menyebut bahwa berat tujuan belum diisi, bukan menolak tanpa keterangan.

6.4. **Aktivasi perlu persetujuan** — Pengguna melihat pratinjau target lalu menutup layar tanpa menyetujui → tidak ada program yang aktif.

6.5. **Data berubah sejak pratinjau** — Pengguna melihat pratinjau, lalu berat badannya diperbarui, lalu menekan setujui → Mealora membatalkan aktivasi, menjelaskan bahwa masukan berubah, dan menampilkan pratinjau yang diperbarui.

6.6. **Satu program berjalan** — Pengguna menekan tombol setujui dua kali berturut-turut → tetap ada tepat satu program berjalan.

6.7. **Jeda dan catat** — Pengguna menjeda program lalu mencatat sarapan dan berat badan → kedua catatan tersimpan, dan hari jeda tidak menambah hari aktif program.

6.8. **Lanjutkan setelah jeda** — Pengguna melanjutkan program setelah tiga hari jeda → program kembali aktif, dan rentang jeda tetap terlihat di riwayat.

6.9. **Batalkan pergantian** — Pengguna membuka pratinjau ganti program lalu membatalkan → program lama tetap berjalan dengan target yang sama, riwayat tidak berubah.

6.10. **Ganti program** — Pengguna menyetujui program pengganti → program lama pindah ke riwayat dengan status diganti, program baru aktif, dan catatan makanan serta berat tetap utuh.

6.11. **Selesaikan program** — Pengguna menyelesaikan program dengan memilih alasan → program berstatus selesai dengan ringkasan akhir → percobaan melanjutkannya ditolak dengan penjelasan → pengguna dapat memilih program baru.

6.12. **Perintah berulang** — Pengguna menjeda program yang sudah dijeda → Mealora menyatakan program memang sudah dijeda, tanpa catatan ganda dan tanpa pesan kesalahan yang membingungkan.

6.13. **Target lama tetap utuh** — Aturan gizi diperbarui ke versi baru setelah pengguna menyelesaikan sebuah program → program lama di riwayat tetap menampilkan target, asumsi, dan versi aslinya.
