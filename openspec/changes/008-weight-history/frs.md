# Functional Requirements Specification

## Mealora — Pemantauan Berat dan Riwayat Harian

| | |
|---|---|
| Change | 008-weight-history |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Mencatat berat badan beserta tanggal dan catatan bebas, sepenuhnya tanpa internet.
- Menyunting dan menghapus catatan berat.
- Melihat berat terbaru, perubahannya terhadap berat awal program, dan tren beberapa minggu terakhir.
- Menelusuri hari-hari sebelumnya lewat kalender dan membaca ringkasan gizi serta catatan makan hari itu.
- Menyunting catatan makan pada tanggal sebelumnya.
- Perlakuan terhadap hari yang tidak memiliki catatan, dan terhadap rentang waktu tanpa catatan berat.
- Hubungan antara catatan berat dan program yang berjalan, termasuk usulan meninjau target ketika berat berubah cukup jauh.

### 1.2 Deferred Items (Not in This FRS Version)

- Pencatatan lewat pemindaian barcode, foto label gizi, dan foto makanan — tiga pengiriman berikutnya.
- Ringkasan mingguan, rangkaian hari berturut-turut, skor nutrisi, dan lencana.
- Proyeksi kapan berat tujuan akan tercapai.
- Pengukuran tubuh lain seperti lingkar pinggang atau persentase lemak tubuh.
- Pengambilan berat otomatis dari timbangan pintar atau aplikasi kesehatan lain.

## 2. Mencatat Berat Badan

### 2.1 User Story

As a pengguna yang ingin tahu arah perubahan berat saya,
I want mencatat berat sesekali tanpa merasa diawasi,
So that saya punya gambaran jujur tanpa menjadikan angka itu penilaian atas diri saya.

### 2.2 Functional Scope

- Pengguna dapat mencatat berat badan beserta tanggal catatan dan catatan bebas yang opsional, sepenuhnya tanpa koneksi internet.
- Mealora menyatakan bahwa catatan berat hanya tersimpan di perangkat.
- Mencatat berat tidak diwajibkan setiap hari. Hari tanpa catatan berat tidak pernah ditandai sebagai kelalaian atau kegagalan.
- Nilai berat yang mustahil ditolak dengan penjelasan rentang yang diterima. Tanggal di masa depan juga ditolak.
- Pengguna dapat menyunting nilai, tanggal, dan catatan bebas, serta menghapus catatan. Perubahan itu memperbarui berat terbaru, tren, dan kemajuan program yang terpengaruh.
- Berat disimpan dalam kilogram. Mengubah satuan tampilan tidak mengubah nilai tersimpan.
- Catatan berat tidak pernah dikirim ke luar perangkat, dan ikut terhapus ketika pengguna menghapus seluruh data lokal.
- **Tidak termasuk:** pengingat menimbang, target frekuensi menimbang, dan pengambilan berat otomatis dari perangkat lain.

### 2.3 Acceptance Criteria

2.3.1. The system shall let the user record a body weight with its date and an optional free-text note, without a network connection.

2.3.2. The system shall state that weight records are stored only on the device.

2.3.3. The system shall not mark days without a weight record as a failure, omission, or lapse.

2.3.4. The system shall reject implausible weight values with an explanation of the accepted range, and shall reject a record date in the future.

2.3.5. The system shall let the user edit the value, date, and note of a weight record, and delete the record.

2.3.6. The system shall update the latest weight, the trend, and any affected program progress after an edit or deletion.

2.3.7. The system shall store weight in kilograms and leave stored values unchanged when the display unit changes.

2.3.8. The system shall never transmit weight records off the device, and shall delete them together with all other data when the user deletes all local data.

---

## 3. Melihat Perkembangan Berat

### 3.1 User Story

As a pengguna yang menjalani program berat,
I want melihat arah perubahan saya berdasarkan apa yang benar-benar saya catat,
So that saya bisa menilai sendiri tanpa disodori angka yang dikira-kira.

### 3.2 Functional Scope

- Mealora menampilkan berat terbaru beserta tanggalnya.
- Bila program yang berjalan memakai berat awal, Mealora menampilkan perubahannya terhadap berat awal itu, sebagai arah dan besaran apa adanya.
- Untuk program yang tidak memakai berat awal, misalnya Makan Sehat, Mealora menampilkan berat terbaru tanpa perbandingan.
- Mealora menampilkan tren beberapa minggu terakhir berdasarkan catatan yang ada. Rentang tanpa catatan tampak sebagai ketiadaan data — tidak disambung dari nilai terakhir dan tidak diisi nol.
- Bila baru ada satu catatan, Mealora menampilkan catatan itu dan menyatakan tren belum dapat ditampilkan.
- Bila belum ada catatan sama sekali, Mealora menyatakannya beserta tindakan untuk menambahkan, bukan menampilkan 0 kg atau grafik kosong tanpa keterangan.
- Mealora menampilkan daftar catatan terakhir beserta tanggalnya.
- Angka berat disajikan sebagai catatan, bukan nilai diri. Tidak ada pujian atas penurunan, tidak ada teguran atas kenaikan.
- **Tidak termasuk:** proyeksi tanggal tercapainya berat tujuan, dan perbandingan dengan pengguna lain.

### 3.3 Acceptance Criteria

3.3.1. The system shall display the latest weight with its date.

3.3.2. The system shall display the change against the program's starting weight where the running program uses one, as direction and magnitude without judgement.

3.3.3. The system shall display the latest weight without a comparison for a program that does not use a starting weight.

3.3.4. The system shall display gaps in the weight trend as missing data, without connecting from the last value or substituting zero.

3.3.5. The system shall state that a trend cannot yet be shown when only one record exists.

3.3.6. The system shall state that no weight has been recorded, with an action to add one, rather than displaying 0 kg or an unlabelled empty chart.

3.3.7. The system shall list recent weight records with their dates.

3.3.8. The system shall avoid praise for weight loss, reproach for weight gain, and any language that judges the user's body.

---

## 4. Berat dan Program

### 4.1 User Story

As a pengguna yang beratnya berubah selama program berjalan,
I want aplikasi memperbarui kemajuan saya dan memberi tahu bila target perlu ditinjau,
So that target saya tetap relevan tanpa berubah diam-diam.

### 4.2 Functional Scope

- Saat sebuah program berjalan, menambah, menyunting, atau menghapus catatan berat memperbarui kemajuan program untuk tanggal yang bersangkutan.
- Bila berat terbaru berbeda cukup jauh dari berat yang dipakai target yang berlaku, Mealora mengusulkan peninjauan target baru.
- Usulan itu muncul di ruang Program, bukan sebagai sela tepat setelah pengguna mencatat berat.
- Target baru berlaku hanya setelah pengguna meninjau dan menyetujuinya. Selama belum disetujui, target lama tetap berlaku dan riwayat tidak berubah.
- **Tidak termasuk:** penyesuaian target otomatis, dan pengubahan target tanpa persetujuan.

### 4.3 Acceptance Criteria

4.3.1. The system shall update the program's progress for the relevant date when a weight record is added, edited, or deleted while a program is running.

4.3.2. The system shall propose a review of the target when the latest weight differs from the weight used for the current target beyond the threshold set by the nutrition policy.

4.3.3. The system shall present that proposal in the Program space rather than interrupting the user immediately after recording a weight.

4.3.4. The system shall apply a revised target only after the user reviews and approves it, keeping the previous target in force and the history unchanged until then.

---

## 5. Riwayat Harian

### 5.1 User Story

As a pengguna yang sudah mencatat beberapa minggu,
I want membuka hari-hari sebelumnya dan melihat apa yang saya makan,
So that saya bisa memahami kebiasaan saya tanpa merasa dinilai atas hari yang kosong.

### 5.2 Functional Scope

- Ruang Riwayat menampilkan kalender bulanan. Pengguna dapat memilih tanggal dan berpindah antar bulan. Tanggal di masa depan tidak dapat dipilih.
- Tanggal yang memiliki catatan ditandai sehingga mudah ditemukan. Penandaan itu bersifat informatif — bukan nilai, bukan peringkat, dan bukan rangkaian keberhasilan.
- Untuk tanggal yang dipilih, Mealora menampilkan energi dan zat gizi makro yang tercatat, daftar catatan makan beserta waktu makannya, dan berat badan yang tercatat pada tanggal itu bila ada.
- Hari tanpa catatan dinyatakan belum diketahui, bukan 0 kkal, dan tidak pernah ditandai sebagai hari yang gagal atau terlewat.
- Hari yang hanya sebagian tercatat menampilkan total dari yang ada, tanpa menyiratkan hari itu sudah lengkap.
- Pengguna dapat menyunting catatan makan pada tanggal sebelumnya dengan aturan yang sama seperti hari berjalan. Ringkasan tanggal itu dan kemajuan program untuk tanggal itu menyesuaikan.
- Ringkasan hari yang sudah lewat tidak berubah ketika katalog makanan diperbarui, makanan buatan pengguna disunting, profil diubah, atau program diganti.
- Tanggal sebuah catatan tidak berpindah meski pengguna berpindah zona waktu.
- **Tidak termasuk:** ringkasan mingguan dan bulanan, penilaian harian, dan ekspor riwayat.

### 5.3 Acceptance Criteria

5.3.1. The system shall display a monthly calendar allowing date selection and movement between months, and shall not allow selection of a future date.

5.3.2. The system shall mark dates that have records in a way recognisable without relying on colour alone, and shall not use that marking as a score, rank, or streak.

5.3.3. The system shall display, for the selected date, the recorded energy and macronutrients, the meal records with their meal times, and any weight recorded on that date.

5.3.4. The system shall present a date without records as unknown rather than zero, and shall not mark it as failed or missed.

5.3.5. The system shall present the total of what has been recorded for a partially recorded day, without implying the day is complete.

5.3.6. The system shall let the user edit a meal record on a previous date under the same rules as the current day, updating that date's summary and the program progress for that date.

5.3.7. The system shall leave a past day's summary unchanged when the food catalogue, a user-created food, the profile, or the program changes.

5.3.8. The system shall keep a record on the date it was logged after the user changes time zone.

5.3.9. The system shall avoid any text that judges, blames, or penalises the user for an empty day or a day above target.

---

## 6. High Level Test Scenarios

6.1. **Mencatat berat tanpa sinyal** — Mode pesawat → pengguna mencatat berat 68,4 kg pada hari ini → catatan tersimpan dan tampil pada daftar, tanpa pesan kesalahan jaringan.

6.2. **Nilai dan tanggal tidak sah** — Pengguna memasukkan berat 0 kg, lalu mencoba tanggal besok → keduanya ditolak dengan penjelasan dan tidak ada catatan yang tersimpan.

6.3. **Memperbaiki salah ketik** — Pengguna mencatat 684 kg karena salah ketik lalu menyuntingnya menjadi 68,4 kg → berat terbaru, tren, dan kemajuan program menyesuaikan.

6.4. **Menghapus catatan terakhir** — Pengguna menghapus catatan berat terbarunya → berat terbaru kembali menunjuk catatan sebelumnya; bila tidak ada, dinyatakan belum ada catatan.

6.5. **Tren memakai tujuh catatan terakhir** — Pengguna mencatat berat tidak setiap hari, dengan jarak berhari-hari antar catatan → grafik tren tetap menampilkan tujuh catatan terakhirnya berurutan rapat (bukan jendela kalender dengan jalur kosong di tengah).

6.6. **Satu catatan saja** — Baru ada satu catatan berat → Mealora menampilkan catatan itu dan menyatakan tren belum dapat ditampilkan.

6.7. **Belum ada catatan** — Pengguna membuka pemantauan berat sebelum pernah mencatat → dinyatakan belum ada catatan beserta tindakan menambahkan, bukan 0 kg.

6.8. **Bahasa netral** — Pengguna mencatat berat yang lebih tinggi dari sebelumnya → perubahan disajikan netral tanpa teguran, ikon peringatan, atau penanda negatif.

6.9. **Berat memperbarui kemajuan** — Program berjalan, pengguna mencatat berat → kemajuan program untuk tanggal itu mencerminkan berat tersebut.

6.10. **Usulan tinjau target** — Berat berubah melewati ambang kebijakan → usulan peninjauan target muncul di ruang Program, bukan sebagai sela setelah menimbang → target lama tetap berlaku sampai pengguna menyetujui.

6.11. **Memilih tanggal lampau** — Pengguna membuka ruang Riwayat dan memilih tanggal minggu lalu → tampil ringkasan energi, makro, daftar catatan makan, dan berat bila ada.

6.12. **Hari kosong** — Pengguna memilih tanggal tanpa catatan → dinyatakan belum tercatat dengan konsumsi belum diketahui, bukan 0 kkal, dan tanpa penanda gagal.

6.13. **Menyunting catatan lama** — Pengguna menyunting porsi makan siang pada tanggal minggu lalu → ringkasan tanggal itu dan kemajuan program untuk tanggal itu menyesuaikan.

6.14. **Riwayat tidak berubah** — Katalog makanan diperbarui dan program diganti setelah beberapa minggu mencatat → ringkasan hari-hari sebelumnya tetap sama dan catatannya tidak berpindah.

6.15. **Zona waktu berubah** — Pengguna berpindah zona waktu → catatan lama tetap berada pada tanggal yang sama.

6.16. **Huruf diperbesar dan pembaca layar** — Kalender, ringkasan tanggal, pemantauan berat, dan tambah berat diperiksa pada skala teks besar dan dengan pembaca layar → kalender tidak pecah, setiap tanggal diumumkan beserta keterangan ada atau tidaknya catatan dan keadaan terpilihnya.
