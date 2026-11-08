# Functional Requirements Specification

## Mealora — Mencatat Produk Kemasan lewat Barcode

| | |
|---|---|
| Change | 009-packaged-food-barcode |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Memindai barcode produk kemasan dengan kamera, dan mengetik nomor barcode secara manual.
- Mencari produk di perangkat lebih dulu, lalu ke sumber data produk ketika pengguna sedang daring.
- Meninjau nama, merek, ukuran kemasan, takaran saji, jumlah sajian per kemasan, dan nilai gizi sebelum mencatat.
- Memilih jumlah yang dimakan: satu sajian, beberapa sajian, atau satu kemasan penuh.
- Perhitungan yang benar antara nilai per sajian, per kemasan, dan per 100 g.
- Mengoreksi nilai ketika berbeda dengan kemasan yang ada di tangan pengguna.
- Menyimpan produk yang sudah dikonfirmasi agar dapat dipakai lagi tanpa koneksi.
- Keadaan ketika produk tidak ditemukan, kamera tidak tersedia, atau izin kamera ditolak.

### 1.2 Deferred Items (Not in This FRS Version)

- Memotret label gizi untuk membaca nilainya secara otomatis. Jalur ini ditawarkan ketika produk tidak ditemukan, tetapi dikirim pada pengiriman berikutnya.
- Pengenalan foto makanan.
- Katalog produk bermerek yang dibundel lengkap dalam aplikasi.
- Pembaruan massal nilai produk dari sumber daring.
- Pemindaian beberapa produk sekaligus dalam satu sesi.

## 2. Menemukan Produk

### 2.1 User Story

As a pengguna yang memegang kemasan makanan,
I want memindai barcode-nya dan langsung melihat produknya,
So that saya tidak perlu mengetik nama dan menebak variannya.

### 2.2 Functional Scope

- Pengguna dapat memindai barcode lewat kamera dari pilihan cara pencatatan.
- Mealora mencari produk yang tersimpan di perangkat lebih dulu. Bila tidak ada dan pengguna sedang daring, Mealora mencari ke sumber data produk.
- Pemindaian dan pencocokan terhadap produk tersimpan bekerja tanpa koneksi.
- Pengguna dapat mengetik nomor barcode secara manual kapan saja, tanpa memakai kamera.
- Bila izin kamera ditolak atau kamera tidak tersedia, Mealora menjelaskan keadaannya dan menawarkan pengetikan nomor barcode serta pencarian katalog — bukan layar yang gagal.
- Nomor barcode yang bentuknya tidak sah ditolak dengan penjelasan.
- Izin kamera hanya diminta ketika pengguna memilih jalur pemindaian, disertai keterangan untuk apa izin itu dipakai.
- Pada pencarian daring, yang dikirim hanya nomor barcode. Tidak ada gambar maupun data pribadi yang ikut terkirim.
- **Tidak termasuk:** memindai barcode untuk tujuan selain menemukan produk makanan.

### 2.3 Acceptance Criteria

2.3.1. The system shall let the user scan a barcode with the camera from the logging options.

2.3.2. The system shall search products stored on the device before searching any online source.

2.3.3. The system shall perform scanning and on-device matching without a network connection.

2.3.4. The system shall let the user enter a barcode number manually at any time, without using the camera.

2.3.5. The system shall explain the situation and offer manual barcode entry and catalogue search, rather than a failing screen, when camera permission is denied or the camera is unavailable.

2.3.6. The system shall reject a malformed barcode number with an explanation and perform no lookup.

2.3.7. The system shall request camera permission only when the user chooses the scanning path, with an explanation of its purpose.

2.3.8. The system shall send only the barcode number when searching an online source, and shall send no image or personal data.

---

## 3. Meninjau dan Mencatat Produk

### 3.1 User Story

As a pengguna yang akan mencatat makanan kemasan,
I want memastikan nilainya cocok dengan kemasan yang saya pegang,
So that catatan saya mencerminkan apa yang benar-benar saya makan.

### 3.2 Functional Scope

- Sebelum mencatat, Mealora menampilkan nama produk, merek, ukuran kemasan, takaran saji, jumlah sajian per kemasan, energi dan zat gizi makro, penanda asal data, dan tanggal verifikasi.
- Pengguna memilih jumlah yang dimakan: satu sajian, beberapa sajian, atau satu kemasan penuh.
- Mealora menampilkan basis nilai yang berlaku bersama angkanya, misalnya "per 1 sajian, 30 g, 2 sajian per kemasan".
- Satu kemasan penuh dihitung sebagai nilai per sajian dikalikan jumlah sajian per kemasan. Nilai berbasis per 100 g dihitung dari gram yang benar-benar dimakan.
- Tidak ada catatan yang dibuat sebelum pengguna mengonfirmasi. Menutup layar peninjauan tidak membuat catatan apa pun.
- Nilai gizi yang tidak ada pada rekaman produk ditandai belum diketahui, bukan nol. Pencatatan tetap bisa dilakukan, dan Mealora menyatakan nilai mana yang belum diketahui.
- Nilai pada catatan yang sudah tersimpan tidak berubah ketika rekaman produk diperbarui atau dikoreksi di kemudian hari.
- **Tidak termasuk:** menghitung porsi dari foto, dan menebak jumlah yang dimakan.

### 3.3 Acceptance Criteria

3.3.1. The system shall display the product name, brand, package size, serving size, servings per package, energy and macronutrients, data origin, and verification date before any record is created.

3.3.2. The system shall let the user choose the amount eaten as one serving, several servings, or a full package.

3.3.3. The system shall display the basis of the values alongside the figures.

3.3.4. The system shall calculate a full package as the per-serving values multiplied by the servings per package.

3.3.5. The system shall calculate per-100 g values from the grams actually eaten.

3.3.6. The system shall not mix per-100 g, per-serving, and per-package values.

3.3.7. The system shall create no record until the user confirms, and none at all if the review screen is closed.

3.3.8. The system shall mark a nutrition value missing from the product record as unknown rather than zero, while still allowing the record to be created.

3.3.9. The system shall leave stored records unchanged when the product record is later updated or corrected.

---

## 4. Memperbaiki dan Menyimpan Produk

### 4.1 User Story

As a pengguna yang kemasannya berbeda dengan data aplikasi,
I want memperbaiki nilainya sekali saja,
So that pemindaian berikutnya langsung benar tanpa saya perbaiki ulang.

### 4.2 Functional Scope

- Pengguna dapat mengoreksi nilai produk ketika berbeda dengan kemasan yang ia miliki.
- Nilai hasil koreksi dipakai untuk pencatatan, ditandai sebagai koreksi pengguna, dan tersimpan untuk pemakaian berikutnya.
- Mealora tidak menimpa koreksi pengguna dengan nilai dari sumber daring tanpa persetujuannya.
- Produk yang sudah dikonfirmasi tersimpan di perangkat beserta barcode, varian kemasan, asal data, basis takaran, dan tanggal verifikasi, sehingga dapat ditemukan kembali tanpa koneksi.
- Produk kemasan dapat dicari lewat nama dan muncul pada daftar makanan yang terakhir dicatat, seperti makanan lain.
- **Tidak termasuk:** mengirimkan koreksi pengguna ke sumber data mana pun.

### 4.3 Acceptance Criteria

4.3.1. The system shall let the user correct a product's values when they differ from the package in hand.

4.3.2. The system shall use corrected values for logging, mark them as user-corrected, and retain them for later use.

4.3.3. The system shall not overwrite user-corrected values with values from an online source without the user's consent.

4.3.4. The system shall store a confirmed product on the device with its barcode, package variant, data origin, serving basis, and verification date.

4.3.5. The system shall make stored products findable by name and include them in the recently-logged list.

4.3.6. The system shall not send user corrections to any external source.

---

## 5. Ketika Produk Tidak Ditemukan

### 5.1 User Story

As a pengguna yang memindai produk yang belum dikenal aplikasi,
I want tetap bisa mencatatnya hari itu juga,
So that satu produk yang tidak dikenal tidak membatalkan kebiasaan mencatat saya.

### 5.2 Functional Scope

- Ketika produk tidak ditemukan, Mealora menampilkan nomor barcode yang terbaca dan menyatakan bahwa produk belum ada.
- Mealora menawarkan sekurang-kurangnya dua jalur: mengisi nilai dari kemasan secara manual, yang tersedia sepenuhnya tanpa koneksi, dan memotret label gizi.
- Jalur yang memerlukan koneksi ditandai demikian. Jalur yang belum tersedia pada versi aplikasi ditandai belum tersedia dan tidak dapat dibuka.
- Pengguna yang sedang luring dan memindai produk yang belum tersimpan tetap diarahkan ke pengisian manual, bukan ke jalan buntu.
- **Tidak termasuk:** permintaan agar pengguna menunggu sampai daring.

### 5.3 Acceptance Criteria

5.3.1. The system shall display the scanned barcode number and state that the product is not yet known, when no product is found.

5.3.2. The system shall offer manual entry of label values, available fully offline, and a nutrition-label photo path.

5.3.3. The system shall mark a path that requires a connection as such.

5.3.4. The system shall mark a path that is not yet available as unavailable and shall not open it.

5.3.5. The system shall direct an offline user whose scan finds nothing to manual entry rather than a dead end.

---

## 6. High Level Test Scenarios

6.1. **Produk tersimpan dipindai luring** — Mode pesawat, produk pernah dikonfirmasi sebelumnya → pengguna memindai barcode → produk tampil untuk ditinjau, pengguna memilih satu sajian dan mengonfirmasi → catatan dibuat dan ringkasan hari menyesuaikan.

6.2. **Satu kemasan, dua sajian** — Rekaman menyatakan 150 kkal per sajian dan 2 sajian per kemasan → pengguna mencatat satu kemasan penuh → catatan bernilai 300 kkal dan Mealora menyatakan satu kemasan sama dengan dua sajian.

6.3. **Label per 100 g** — Rekaman memakai basis per 100 g → pengguna menyatakan memakan 45 g → nilai dihitung dari 45 g, bukan dari satu sajian maupun satu kemasan.

6.4. **Basis terlihat sebelum memilih** — Pengguna membuka peninjauan produk → basis nilai tampil bersama angkanya sebelum ia memilih jumlah.

6.5. **Pemindaian dibatalkan** — Pengguna memindai lalu menutup layar peninjauan → tidak ada catatan yang dibuat.

6.6. **Produk tidak ditemukan, luring** — Mode pesawat, barcode tidak tersimpan → Mealora menampilkan nomor barcode, menyatakan produk belum ada, dan menawarkan pengisian manual yang bisa dipakai saat itu juga.

6.7. **Izin kamera ditolak** — Pengguna menolak izin kamera → Mealora menjelaskan dan menawarkan pengetikan nomor barcode serta pencarian katalog, tanpa layar gagal.

6.8. **Nomor barcode tidak sah** — Pengguna mengetik nomor yang bentuknya salah → ditolak dengan penjelasan dan tidak ada pencarian yang dilakukan.

6.9. **Koreksi pengguna bertahan** — Pengguna mengoreksi nilai energi karena berbeda dengan kemasannya → pemindaian berikutnya atas barcode yang sama memakai nilai koreksi itu dan menandainya sebagai koreksi pengguna.

6.10. **Sumber daring tidak menimpa koreksi** — Rekaman pada sumber daring berubah setelah koreksi → Mealora tetap memakai nilai koreksi pengguna.

6.11. **Nilai tidak diketahui** — Rekaman produk tidak memuat nilai lemak → catatan menyatakan lemak belum diketahui, bukan 0 g, dan ringkasan hari menyatakan ketidaklengkapannya.

6.12. **Riwayat tidak berubah** — Pengguna mencatat sebuah produk, lalu mengoreksi rekamannya → catatan lama tetap menampilkan nilai seperti saat dicatat.

6.13. **Produk muncul di jalur biasa** — Setelah dikonfirmasi, produk dapat ditemukan lewat pencarian nama dan muncul pada daftar terakhir dicatat.

6.14. **Tidak ada gambar terkirim** — Lalu lintas jaringan diamati saat pencarian daring → hanya nomor barcode yang terkirim.

6.15. **Huruf diperbesar dan pembaca layar** — Layar pindai, masukan manual, produk tidak ditemukan, dan tinjau produk diperiksa pada skala teks besar dan dengan pembaca layar → teks terbaca utuh dan setiap kendali punya nama yang bermakna.
