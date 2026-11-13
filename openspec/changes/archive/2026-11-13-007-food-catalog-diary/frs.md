# Functional Requirements Specification

## Mealora — Mencatat Makanan dan Ringkasan Harian

| | |
|---|---|
| Change | 007-food-catalog-diary |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Katalog makanan yang tersedia di perangkat, lengkap dengan takaran saji dan nilai gizinya, termasuk makanan Indonesia yang umum.
- Asal-usul data gizi: dari mana nilainya berasal dan kapan terakhir diverifikasi.
- Pencarian makanan secara luring, beserta daftar makanan yang terakhir dicatat.
- Membuat makanan sendiri ketika sebuah makanan belum ada di katalog.
- Mencatat makanan ke empat waktu makan: Sarapan, Makan siang, Camilan, dan Makan malam.
- Menyunting, memindahkan antar waktu makan, dan menghapus catatan.
- Jaminan bahwa nilai gizi pada catatan lama tidak berubah ketika katalog diperbarui.
- Ringkasan hari ini: energi tercatat, target, sisa perkiraan, kemajuan zat gizi makro, dan daftar waktu makan.
- Perlakuan terhadap hari yang belum dicatat dan hari tanpa program berjalan.

### 1.2 Deferred Items (Not in This FRS Version)

- Pemantauan berat badan dan riwayat harian lintas tanggal, yang dikirim pada change tersendiri.
- Pencatatan lewat pemindaian barcode, foto label gizi, dan foto makanan. Pintunya terlihat di layar pilihan pencatatan, tetapi ditandai belum tersedia.
- Makanan favorit, template makan, menyalin makanan hari sebelumnya, pencatatan air minum, dan ringkasan mingguan.
- Target vitamin dan mineral. Nilai serat, gula, dan natrium disimpan bila sumbernya menyediakan, tetapi belum dijadikan target.
- Pencarian yang memaafkan salah ketik.

## 2. Katalog Makanan

### 2.1 User Story

As a pengguna yang mencatat makanan sehari-hari,
I want menemukan makanan yang biasa saya makan beserta takaran yang saya kenali,
So that mencatat tidak lebih merepotkan daripada makan itu sendiri.

### 2.2 Functional Scope

- Katalog tersedia dan dapat dicari sepenuhnya tanpa koneksi internet sejak aplikasi dipasang.
- Katalog memuat makanan yang lazim dikonsumsi di Indonesia: makanan pokok, lauk, sayur, jajanan, dan minuman umum.
- Setiap makanan memiliki satu atau beberapa takaran saji dengan label sehari-hari, misalnya "1 mangkuk" atau "1 potong", beserta padanan beratnya bila diketahui. Satu takaran menjadi pilihan bawaan.
- Setiap makanan bawaan menyimpan asal-usul nilai gizinya, dan pengguna dapat melihat penandanya.
- Nilai gizi tidak pernah dikarang. Makanan tanpa asal-usul yang lengkap tidak disertakan dalam katalog bawaan.
- Pencarian mengabaikan perbedaan huruf besar dan kecil, mencocokkan bagian mana pun dari nama, dan menampilkan hasil tanpa jeda yang terasa.
- Bila pencarian tidak menemukan apa pun, Mealora menyatakannya dan menawarkan pembuatan makanan sendiri.
- Sebelum pengguna mengetik, Mealora menampilkan makanan yang terakhir ia catat beserta takaran yang terakhir dipakai. Bagi pengguna yang belum pernah mencatat, bagian ini kosong dan tidak diisi contoh.
- **Tidak termasuk:** katalog produk kemasan bermerek secara lengkap, dan pencarian yang menebak maksud dari salah ketik.

### 2.3 Acceptance Criteria

2.3.1. The system shall make the food catalogue searchable without a network connection from the moment the application is installed.

2.3.2. The system shall include foods commonly eaten in Indonesia across staples, side dishes, vegetables, snacks, and common drinks.

2.3.3. The system shall give every food at least one serving size with a plain-language label, its amount and unit, its gram equivalent where known, and one serving marked as the default.

2.3.4. The system shall store, for every built-in food, the origin of its nutrition values and make that origin visible to the user.

2.3.5. The system shall exclude from the built-in catalogue any food whose data origin is incomplete.

2.3.6. The system shall match searches regardless of letter case and against any part of a food name.

2.3.7. The system shall state that there are no results and offer to create a custom food, when a search matches nothing.

2.3.8. The system shall display the foods most recently logged, with the serving last used for each, before the user types anything.

2.3.9. The system shall leave the recently-logged section empty, without example entries, for a user who has not logged anything.

---

## 3. Makanan Buatan Sendiri

### 3.1 User Story

As a pengguna yang sering makan masakan rumah,
I want menambahkan makanan saya sendiri beserta nilainya,
So that saya tetap bisa mencatat meski makanan itu tidak ada di katalog.

### 3.2 Functional Scope

- Pengguna dapat membuat makanan baru dengan mengisi nama, ukuran sajian, energi, protein, karbohidrat, dan lemak.
- Mealora menyatakan bahwa nilai sebaiknya disalin dari sumber yang dipercaya pengguna.
- Nilai yang belum diketahui dikosongkan, bukan diisi nol. Mealora menyimpannya sebagai belum diketahui.
- Nilai yang mustahil — misalnya nilai gizi negatif atau ukuran sajian nol — ditolak dengan penjelasan, dan makanan tidak disimpan.
- Makanan buatan pengguna ditandai berbeda dari makanan bawaan, dapat dicari, dan dapat dicatat seperti makanan lain.
- Menyunting makanan buatan sendiri tidak mengubah catatan yang sudah pernah dibuat dengan makanan itu.
- **Tidak termasuk:** berbagi makanan buatan sendiri ke pengguna lain, dan mengunggahnya ke mana pun.

### 3.3 Acceptance Criteria

3.3.1. The system shall let the user create a food with a name, serving size, energy, protein, carbohydrate, and fat.

3.3.2. The system shall state that values should be copied from a source the user trusts.

3.3.3. The system shall store an omitted nutrition value as unknown and shall not substitute zero.

3.3.4. The system shall reject negative nutrition values and a zero serving size with an explanation, and shall not save the food.

3.3.5. The system shall mark user-created foods distinctly from built-in foods, while making them searchable and loggable like any other food.

3.3.6. The system shall leave existing records unchanged when a user-created food is edited.

---

## 4. Mencatat Makanan

### 4.1 User Story

As a pengguna yang baru selesai makan,
I want mencatatnya dalam beberapa ketukan, bahkan tanpa sinyal,
So that mencatat jadi kebiasaan, bukan beban.

### 4.2 Functional Scope

- Catatan dikelompokkan ke empat waktu makan: Sarapan, Makan siang, Camilan, dan Makan malam. Setiap catatan berada pada satu waktu makan dan satu tanggal.
- Sebelum menyimpan, pengguna memilih takaran saji, menetapkan jumlah takaran, dan memilih waktu makan. Perkiraan nilai gizi dari pilihan itu tampil sebelum disimpan.
- Jumlah takaran harus lebih dari nol. Jumlah nol atau negatif ditolak dengan penjelasan.
- Seluruh pencatatan, penyuntingan, pemindahan, dan penghapusan bekerja tanpa koneksi, dan tersimpan seketika di perangkat.
- Setiap catatan membekukan nilai yang dipakai saat pencatatan: nama makanan, label takaran, energi, protein, karbohidrat, dan lemak. Nilai itu tidak berubah ketika katalog diperbarui, makanan buatan pengguna disunting, atau makanan dihapus dari katalog.
- Pengguna dapat mengubah takaran dan jumlah, memindahkan catatan ke waktu makan lain, dan menghapusnya. Perubahan hanya berlaku pada catatan tersebut.
- Ringkasan hari menyesuaikan segera setelah perubahan.
- Penyimpanan sebuah catatan berhasil seluruhnya atau tidak sama sekali; kegagalan tidak meninggalkan catatan setengah jadi.
- Pencatatan tetap tersedia meski tidak ada program berjalan atau program sedang dijeda.
- Tanggal sebuah catatan tidak berpindah meski pengguna berpindah zona waktu di kemudian hari.
- **Tidak termasuk:** mencatat untuk orang lain, dan mencatat ke tanggal di masa depan.

### 4.3 Acceptance Criteria

4.3.1. The system shall group records into Sarapan, Makan siang, Camilan, and Makan malam, each record belonging to exactly one meal time and one date.

4.3.2. The system shall let the user choose a serving, set a quantity, and choose a meal time before saving, and shall display the estimated nutrition for that choice beforehand.

4.3.3. The system shall reject a quantity of zero or less with an explanation and create no record.

4.3.4. The system shall perform all logging, editing, moving, and deleting without a network connection, storing the result on the device immediately.

4.3.5. The system shall freeze, on each record, the food name, serving label, energy, protein, carbohydrate, and fat used at the time of logging.

4.3.6. The system shall leave those frozen values unchanged when the catalogue is updated, a user-created food is edited, or a food is removed from the catalogue.

4.3.7. The system shall apply an edit only to the record being edited, leaving other records and the catalogue unchanged.

4.3.8. The system shall update the day's summary immediately after any change to a record.

4.3.9. The system shall store either a complete record or none of it, leaving no partial record when saving fails.

4.3.10. The system shall keep logging available when no program is running and while a program is paused.

4.3.11. The system shall keep a record on the date it was logged after the user changes time zone.

---

## 5. Ringkasan Hari Ini

### 5.1 User Story

As a pengguna yang ingin tahu posisi saya hari ini,
I want satu layar yang jujur tentang apa yang sudah saya makan,
So that saya bisa memutuskan sisa hari saya tanpa merasa dinilai.

### 5.2 Functional Scope

- Ruang Hari ini menampilkan energi yang sudah tercatat, target harian yang berlaku bila ada, sisa perkiraan, kemajuan protein, karbohidrat, dan lemak, serta daftar waktu makan beserta energinya.
- Semua nilai disebut perkiraan.
- Total menyesuaikan seketika setiap kali pengguna menambah, menyunting, memindahkan, atau menghapus catatan.
- Hari yang belum dicatat ditampilkan sebagai belum diketahui beserta ajakan mencatat — bukan 0 kkal, dan bukan hari yang gagal.
- Hari yang baru sebagian dicatat menampilkan total dari yang sudah ada, tanpa menyiratkan hari itu sudah lengkap.
- Bila tidak ada program berjalan atau belum ada target, Mealora tetap menampilkan konsumsi dan menyatakan bahwa belum ada target pembanding.
- Bila konsumsi melampaui target, Mealora menyatakannya secara netral sebagai kelebihan terhadap perkiraan, tanpa bahasa yang menyalahkan atau menghukum.
- Tindakan utama untuk mencatat makanan selalu tersedia, membuka pilihan cara pencatatan. Jalur pencarian dan pembuatan makanan sendiri selalu bisa dipakai; jalur yang belum tersedia ditandai demikian dan tidak dapat dibuka.
- Ketika sebuah program berjalan, perubahan catatan tercermin pada kemajuan program untuk tanggal itu. Hari selama program dijeda tidak menambah hitungan hari aktif, sementara catatannya tetap tersimpan dan terlihat.
- **Tidak termasuk:** skor harian, peringkat, lencana, dan proyeksi hasil.

### 5.3 Acceptance Criteria

5.3.1. The system shall display recorded energy, the applicable daily target where one exists, the estimated remainder, macronutrient progress, and the meal times with their energy.

5.3.2. The system shall label all displayed values as estimates.

5.3.3. The system shall update totals, remainder, and macronutrient progress immediately after a record is added, edited, moved, or deleted.

5.3.4. The system shall present an unlogged day as unknown with an invitation to log, and shall not present zero or a failure marker.

5.3.5. The system shall present the total of what has been logged for a partially logged day, without implying the day is complete.

5.3.6. The system shall display consumption and state that no comparison target exists, when no program is running or no target is available.

5.3.7. The system shall state an excess over target neutrally, without language that blames or penalises the user.

5.3.8. The system shall keep the primary logging action available, opening a choice of logging methods.

5.3.9. The system shall keep catalogue search and custom food creation available at all times, including offline.

5.3.10. The system shall mark a logging method that is not yet available as unavailable, and shall not open a failing screen.

5.3.11. The system shall reflect record changes in the program's progress for that date while a program is running.

5.3.12. The system shall exclude paused days from the active-day count while keeping their records visible.

---

## 6. High Level Test Scenarios

6.1. **Mencatat tanpa sinyal** — Mode pesawat → pengguna mencari "nasi", memilih nasi putih, memilih takaran 150 g, jumlah 1, waktu makan Makan siang, lalu menyimpan → catatan tersimpan dan ruang Hari ini menyesuaikan, tanpa pesan kesalahan jaringan.

6.2. **Hasil pencarian kosong** — Pengguna mencari makanan yang tidak ada → Mealora menyatakan tidak ada hasil dan menawarkan pembuatan makanan sendiri.

6.3. **Terakhir dicatat** — Pengguna membuka pencarian setelah mencatat beberapa makanan → makanan yang terakhir dicatat tampil lebih dulu beserta takaran terakhirnya.

6.4. **Pengguna baru** — Pengguna membuka pencarian sebelum pernah mencatat → bagian terakhir dicatat kosong, tidak diisi contoh.

6.5. **Membuat makanan sendiri** — Pengguna membuat "Tumis buncis rumahan" dengan lemak dikosongkan → makanan tersimpan, nilai lemak tercatat sebagai belum diketahui, bukan 0 g.

6.6. **Nilai mustahil ditolak** — Pengguna memasukkan protein negatif → Mealora menolak dengan penjelasan dan tidak menyimpan.

6.7. **Riwayat tidak berubah** — Pengguna mencatat sebuah makanan, lalu nilai gizi makanan itu di katalog diperbarui → catatan lama tetap menunjukkan nilai seperti saat dicatat.

6.8. **Menyunting makanan sendiri** — Pengguna menyunting nilai makanan buatannya → catatan yang sudah ada tidak berubah, nilai baru hanya berlaku untuk pencatatan berikutnya.

6.9. **Memindahkan antar waktu makan** — Pengguna memindahkan catatan dari Camilan ke Makan malam → kedua ringkasan waktu makan menyesuaikan dan total harian tidak berubah.

6.10. **Menghapus catatan** — Pengguna menghapus satu catatan → catatan hilang dan total harian berkurang sesuai nilainya.

6.11. **Hari tanpa catatan** — Pengguna membuka hari yang belum dicatat → konsumsi tampil sebagai belum diketahui beserta ajakan mencatat, bukan 0 kkal.

6.12. **Tanpa program berjalan** — Pengguna mencatat makanan tanpa program aktif → total tampil, dan Mealora menyatakan belum ada target pembanding.

6.13. **Melampaui target** — Konsumsi melampaui target → Mealora menyatakan kelebihannya secara netral tanpa bahasa yang menyalahkan.

6.14. **Mencatat saat program dijeda** — Program dijeda, pengguna mencatat sarapan → catatan tersimpan dan terlihat, hari itu tidak menambah hitungan hari aktif.

6.15. **Jalur yang belum tersedia** — Pengguna membuka pilihan cara pencatatan → jalur foto dan barcode terlihat ditandai belum tersedia dan tidak membuka layar yang gagal.

6.16. **Data bertahan** — Pengguna mencatat beberapa makanan, menutup aplikasi, mematikan dan menyalakan perangkat → seluruh catatan dan total hari itu masih sama.

6.17. **Huruf diperbesar dan pembaca layar** — Layar pencarian, detail sajian, buku harian, dan ruang Hari ini diperiksa pada skala teks besar dan dengan pembaca layar → teks terbaca utuh, dan angka ringkasan diumumkan beserta maknanya.
