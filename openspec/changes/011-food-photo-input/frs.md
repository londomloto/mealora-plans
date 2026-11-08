# Functional Requirements Specification

## Mealora — Mencatat Makanan lewat Foto

| | |
|---|---|
| Change | 011-food-photo-input |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Memotret makanan di piring untuk mendapatkan usulan komponen yang dapat ditinjau.
- Meninjau, mengoreksi, menambah, dan menghapus komponen sebelum apa pun dicatat.
- Mengubah porsi, metode masak, dan menambahkan bahan yang tidak terlihat seperti minyak atau saus.
- Jaminan bahwa nilai gizi selalu berasal dari makanan yang ada di katalog, makanan buatan pengguna, atau produk yang pernah dikonfirmasi.
- Perilaku ketika pengenalan tidak tersedia: luring, kuota habis, waktu tunggu lewat, atau layanan menolak.
- Pencatatan satu catatan per komponen, yang setelahnya dapat disunting dan dihapus sendiri-sendiri.
- Persetujuan unggah dan penyimpanan foto, mengikuti aturan yang sudah berlaku untuk foto label.

### 1.2 Deferred Items (Not in This FRS Version)

- Mencatat makanan dengan mengetik kalimat bebas.
- Menghitung berat makanan dari foto. Porsi selalu berupa perkiraan yang dikoreksi pengguna.
- Mengenali merek atau produk kemasan dari foto makanan; untuk itu tersedia jalur barcode.
- Pengenalan di perangkat tanpa koneksi.
- Menyimpan atau membagikan foto makanan di luar perangkat selain pengiriman yang disetujui pengguna.

## 2. Memotret Makanan

### 2.1 User Story

As a pengguna yang sedang makan sepiring nasi dengan beberapa lauk,
I want memotretnya sekali alih-alih mencari satu per satu,
So that mencatat makan lengkap tidak terasa seperti pekerjaan administrasi.

### 2.2 Functional Scope

- Pengguna dapat memotret makanannya dari pilihan cara pencatatan.
- Sebelum gambar dikirim, Mealora meminta persetujuan dan menyatakan bahwa analisis memerlukan koneksi, bahwa foto hanya diunggah bila diizinkan, dan bahwa catatan tetap tersimpan di perangkat.
- Pengguna dapat memilih pencatatan manual kapan saja, tanpa mengambil maupun mengirim gambar.
- Foto sumber disimpan atau dihapus setelah dicatat sesuai pengaturan privasi pengguna.
- **Tidak termasuk:** pengunggahan otomatis dan pengiriman foto tanpa persetujuan pada saat itu.

### 2.3 Acceptance Criteria

2.3.1. The system shall let the user photograph a meal from the logging options.

2.3.2. The system shall request consent before sending the image, stating that analysis requires a connection, that the photo is uploaded only with permission, and that records remain on the device.

2.3.3. The system shall offer manual logging at any point without capturing or sending an image.

2.3.4. The system shall retain or delete the source photo after logging according to the user's privacy setting.

---

## 3. Meninjau dan Mengoreksi Komponen

### 3.1 User Story

As a pengguna yang tahu persis apa yang ada di piringnya,
I want memperbaiki tebakan aplikasi sebelum dicatat,
So that catatan saya benar dan saya tidak perlu memperbaikinya nanti.

### 3.2 Functional Scope

- Mealora menampilkan daftar komponen yang dikenali beserta jumlahnya, masing-masing dengan padanan makanan dan perkiraan porsinya.
- Nilai gizi setiap komponen berasal dari padanan pada katalog, makanan buatan pengguna, atau produk yang pernah dikonfirmasi — tidak pernah diturunkan dari penampilan makanan pada foto.
- Bila sebuah komponen tidak punya padanan yang memadai, Mealora meminta pengguna mencari atau membuat makanannya, dan tidak menampilkan nilai gizi apa pun untuk komponen itu.
- Pengguna dapat mengubah padanan makanan, mengubah porsi, menetapkan metode masak, menambahkan bahan yang tidak terlihat seperti minyak atau saus, menambah komponen yang tidak terdeteksi, dan menghapus komponen yang keliru.
- Mealora menandai apa yang belum pasti pada setiap komponen: padanan makanan, porsi, atau metode masak.
- Mealora menyatakan bahwa foto tidak dapat memastikan minyak, resep, bahan tersembunyi, maupun berat yang sebenarnya.
- Perkiraan total menyesuaikan seketika setiap kali pengguna mengubah sesuatu.
- Tidak ada catatan yang dibuat sebelum pengguna mengonfirmasi. Menutup layar peninjauan tidak membuat catatan apa pun.
- **Tidak termasuk:** menyatakan nilai gizi sebagai hasil pengukuran atas makanan di foto.

### 3.3 Acceptance Criteria

3.3.1. The system shall display the recognised components with their count, each with its food match and estimated portion.

3.3.2. The system shall take every component's nutrition values from a catalogue food, a user-created food, or a previously confirmed product.

3.3.3. The system shall not derive nutrition values from the appearance of food in the photo.

3.3.4. The system shall ask the user to find or create a food, and display no nutrition values for that component, when no adequate match exists.

3.3.5. The system shall let the user change the food match, change the portion, set the cooking method, add unseen ingredients such as oil or sauce, add undetected components, and remove incorrect ones.

3.3.6. The system shall mark what is uncertain on each component: the food match, the portion, or the cooking method.

3.3.7. The system shall state that a photo cannot determine oil, recipe, hidden ingredients, or actual weight.

3.3.8. The system shall update the estimated total immediately after any change.

3.3.9. The system shall create no record until the user confirms, and none at all if the review screen is closed.

---

## 4. Ketika Pengenalan Tidak Tersedia

### 4.1 User Story

As a pengguna yang sinyalnya hilang tepat setelah memotret,
I want fotonya tidak terbuang dan tetap bisa mencatat,
So that saya tidak kehilangan momen mencatat hanya karena koneksi.

### 4.2 Functional Scope

- Ketika pengenalan tidak tersedia — tidak ada koneksi, kuota habis, waktu tunggu lewat, atau layanan menolak — Mealora menyimpan foto sebagai draf.
- Mealora menyatakan dengan jelas bahwa belum ada catatan makan yang dibuat, dan bahwa draf fotonya tidak hilang.
- Mealora mengarahkan pengguna ke pemilihan makanan secara manual, dengan pencarian katalog, penambahan bahan, dan pengaturan porsi sendiri.
- Komponen yang sudah diisi pengguna tidak hilang akibat kegagalan itu.
- Pesan yang ditampilkan memakai bahasa yang dapat dimengerti, tanpa istilah teknis dan tanpa kode kesalahan.
- **Tidak termasuk:** mengirim ulang foto secara otomatis begitu koneksi kembali tanpa persetujuan baru.

### 4.3 Acceptance Criteria

4.3.1. The system shall save the photo as a draft when recognition is unavailable.

4.3.2. The system shall state that no meal record has been created and that the photo draft is preserved.

4.3.3. The system shall direct the user to manual food selection with catalogue search, ingredient addition, and portion setting.

4.3.4. The system shall preserve components the user has already entered through such a failure.

4.3.5. The system shall use plain language without technical terms or error codes.

---

## 5. Mencatat Hasil Peninjauan

### 5.1 User Story

As a pengguna yang sudah memeriksa setiap komponen,
I want mencatatnya sekaligus tetapi tetap bisa memperbaiki satu bahan nanti,
So that satu kesalahan kecil tidak memaksa saya mengulang seluruh catatan.

### 5.2 Functional Scope

- Saat pengguna mengonfirmasi, Mealora membuat satu catatan per komponen pada waktu makan dan tanggal yang dipilih.
- Setiap catatan membekukan nilai gizinya saat dicatat, seperti catatan makanan lain.
- Penulisan seluruh komponen berhasil sepenuhnya atau tidak sama sekali. Tidak pernah ada setengah piring yang tercatat.
- Setelah tercatat, setiap komponen dapat disunting, dipindahkan waktu makannya, dan dihapus sendiri-sendiri seperti catatan makanan lain.
- Ringkasan hari dan kemajuan program menyesuaikan setelah pencatatan.
- **Tidak termasuk:** catatan gabungan yang hanya bisa dihapus seluruhnya.

### 5.3 Acceptance Criteria

5.3.1. The system shall create one meal record per component, on the chosen meal time and date, when the user confirms.

5.3.2. The system shall freeze each record's nutrition values at the time of logging.

5.3.3. The system shall store either all components or none, never a partial set.

5.3.4. The system shall allow each logged component to be edited, moved between meal times, and deleted individually.

5.3.5. The system shall update the day's summary and the program progress after logging.

---

## 6. High Level Test Scenarios

6.1. **Memotret dan mencatat** — Pengguna memotret sepiring nasi dengan ayam bakar, tempe, dan lalapan, menyetujui unggah, meninjau empat komponen, mengoreksi porsi satu di antaranya, lalu mengonfirmasi → empat catatan dibuat dan ringkasan hari menyesuaikan.

6.2. **Menolak unggah** — Pengguna membuka foto makanan lalu tidak menyetujui unggah → tidak ada gambar terkirim dan Mealora menawarkan pemilihan makanan manual.

6.3. **Komponen tanpa padanan** — Salah satu komponen tidak punya padanan di katalog → Mealora meminta pengguna mencari atau membuat makanannya, dan tidak menampilkan nilai gizi apa pun untuk komponen itu.

6.4. **Menghapus komponen keliru** — Mealora mengusulkan makanan yang tidak ada di piring → pengguna menghapusnya → komponen hilang, perkiraan total menyesuaikan, dan komponen itu tidak pernah tercatat.

6.5. **Menambah bahan tak terlihat** — Pengguna menambahkan minyak goreng pada tempe → nilai komponen menyesuaikan berdasarkan makanan yang dipilih untuk minyak itu.

6.6. **Metode masak belum pasti** — Sebuah komponen ditandai metode masaknya perlu dicek → pengguna menetapkannya → nilai dan total menyesuaikan.

6.7. **Mengubah porsi** — Pengguna mengubah perkiraan porsi nasi → nilai komponen dan perkiraan total menyesuaikan seketika.

6.8. **Peninjauan dibatalkan** — Pengguna menutup peninjauan tanpa mengonfirmasi → tidak ada catatan yang dibuat, dan foto diperlakukan sesuai pengaturan retensi.

6.9. **Luring saat memotret** — Mode pesawat → pengguna memotret makanan → foto tersimpan sebagai draf, Mealora menyatakan belum ada catatan yang dibuat, dan menawarkan pemilihan manual.

6.10. **Layanan gagal di tengah** — Layanan pengenalan gagal setelah unggah disetujui → draf foto dan komponen yang sudah diisi tetap ada, jalur manual ditawarkan, pesannya tanpa istilah teknis.

6.11. **Kegagalan saat menyimpan** — Penyimpanan gagal pada komponen terakhir → tidak ada satu pun komponen yang tersimpan dan buku harian tidak berubah.

6.12. **Menyunting komponen setelah tercatat** — Pengguna menghapus satu dari empat komponen hasil foto di buku harian → hanya komponen itu yang hilang dan total hari menyesuaikan.

6.13. **Bahasa peninjauan** — Teks pada layar peninjauan diperiksa → menyatakan nilai berasal dari padanan katalog dan porsi perlu dicek, tanpa menyiratkan pengukuran atas makanan di foto.

6.14. **Huruf diperbesar dan pembaca layar** — Layar foto, peninjauan, dan koreksi komponen diperiksa pada skala teks besar dan dengan pembaca layar → teks terbaca utuh, dan penanda ketidakpastian dapat dikenali tanpa bergantung pada warna.
