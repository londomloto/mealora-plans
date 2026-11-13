# Functional Requirements Specification

## Mealora — Mencatat Makanan dengan Berbicara

| | |
|---|---|
| Change | 012-voice-food-input |
| Versi | v0.1-draft |
| Tanggal | 2026-11-08 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Mencatat makanan dengan berbicara satu kalimat, misalnya "tadi makan nasi satu piring, ayam bakar satu potong, dan tempe dua".
- Pengubahan ucapan menjadi teks di perangkat, tanpa mengirim rekaman suara ke luar.
- Menyunting teks hasil pengenalan sebelum diproses.
- Penguraian kalimat menjadi daftar makanan beserta jumlah dan satuannya.
- Meninjau, mengoreksi, menambah, dan menghapus komponen sebelum dicatat.
- Perlakuan ketika jumlah atau satuan tidak disebut pengguna.
- Mengetik kalimat sebagai jalur setara, tanpa mikrofon.
- Perilaku ketika pengenalan ucapan tidak tersedia, izin mikrofon ditolak, atau layanan penguraian tidak tersedia.
- Pengaturan penyimpanan rekaman suara.

### 1.2 Deferred Items (Not in This FRS Version)

- Percakapan dua arah atau asisten suara yang menjawab pengguna.
- Masukan suara untuk fungsi apa pun selain mencatat makanan. Mencatat berat badan, mengelola program, menyunting profil, mengubah pengaturan, dan berpindah layar tetap memakai masukan biasa, dan tidak ada kendali mikrofon di layar-layar itu.
- Bahasa selain Indonesia. Bahasa lain tidak dijanjikan pada pengiriman ini.
- Mengirim rekaman suara ke layanan luar sebagai cadangan ketika perangkat tidak mendukung pengenalan ucapan.

## 2. Berbicara untuk Mencatat

### 2.1 User Story

As a pengguna yang baru selesai makan dan malas mengetik,
I want menyebutkan apa yang saya makan dalam satu kalimat,
So that mencatat selesai dalam hitungan detik tanpa menyentuh papan ketik.

### 2.2 Functional Scope

- Mealora menyediakan jalur pencatatan lewat suara pada pilihan cara pencatatan, di samping foto, barcode, dan pencarian.
- Izin mikrofon diminta hanya ketika pengguna memilih jalur ini, disertai keterangan untuk apa izin itu dipakai.
- Saat perekaman berlangsung, Mealora menandainya dengan jelas — tidak hanya lewat warna — dan menyediakan cara menghentikannya.
- Bila izin mikrofon ditolak, Mealora menjelaskan keadaannya dan menawarkan pengetikan kalimat serta pencarian katalog, bukan layar yang gagal.
- Ucapan diubah menjadi teks di perangkat. Pada perangkat yang mendukungnya, tidak ada rekaman suara yang dikirim ke layanan mana pun.
- Bila perangkat tidak mendukung pengenalan ucapan, Mealora menyatakannya dan menawarkan pengetikan kalimat. Mealora tidak mengirim rekaman suara ke luar tanpa persetujuan pengguna untuk pengiriman itu.
- Rekaman suara dihapus setelah teksnya dihasilkan, kecuali pengguna menetapkan penyimpanan lewat pengaturan privasi. Rekaman yang disimpan berada di perangkat dan ikut terhapus ketika pengguna menghapus seluruh data lokal.
- Jalur suara hanya untuk mencatat apa yang dimakan. Bila ucapan pengguna berisi permintaan lain — misalnya mencatat berat badan atau mengganti program — Mealora tidak menjalankannya, menyatakan bahwa suara hanya untuk mencatat makanan, dan menunjukkan tempat yang tepat untuk melakukannya.
- Tidak ada kendali masukan suara di layar berat badan, program, profil, maupun pengaturan.
- **Tidak termasuk:** merekam tanpa sepengetahuan pengguna, menyimpan suara untuk keperluan selain yang dinyatakan, dan menjalankan perintah apa pun lewat suara.

### 2.3 Acceptance Criteria

2.3.0. The system shall limit voice input to logging what the user ate, and shall provide no voice input for weight, program management, profile, settings, or navigation.

2.3.1. The system shall offer voice logging among the logging options.

2.3.2. The system shall request microphone permission only when the user chooses the voice path, with an explanation of its purpose.

2.3.3. The system shall indicate clearly, without relying on colour alone, that recording is in progress, and provide a way to stop it.

2.3.4. The system shall explain the situation and offer typed entry and catalogue search, rather than a failing screen, when microphone permission is denied.

2.3.5. The system shall convert speech to text on the device where supported, sending no audio recording to any service.

2.3.6. The system shall state the situation and offer typed entry when the device does not support speech recognition.

2.3.7. The system shall not send an audio recording off the device without the user's consent for that transfer.

2.3.8. The system shall delete the audio recording once the transcript is produced, unless the user has chosen to retain it.

2.3.9. The system shall delete retained recordings together with all other data when the user deletes all local data.

2.3.10. The system shall decline to act on a spoken request outside food logging, state that voice is only for logging food, and point the user to the right place.

2.3.11. The system shall display no voice input control on the weight, program, profile, or settings screens.

---

## 3. Memeriksa Teks Sebelum Diproses

### 3.1 User Story

As a pengguna yang nama makanannya sering salah dikenali,
I want memperbaiki satu kata alih-alih mengulang seluruh kalimat,
So that kesalahan kecil tidak membuat saya menyerah dan mengetik manual.

### 3.2 Functional Scope

- Mealora menampilkan teks hasil pengenalan sebelum diuraikan, dan pengguna dapat menyuntingnya.
- Mealora menyatakan bahwa teks itu hasil pengenalan dan dapat keliru.
- Bila pengenalan tidak menghasilkan teks apa pun, Mealora menyatakannya dan menawarkan perekaman ulang atau pengetikan kalimat, tanpa membuat catatan.
- Ketika kalimat diuraikan dengan bantuan layanan di luar perangkat, yang dikirim hanyalah teks — bukan rekaman suara.
- **Tidak termasuk:** memproses ucapan tanpa pengguna sempat melihat teksnya.

### 3.3 Acceptance Criteria

3.3.1. The system shall display the recognised text for editing before any parsing takes place.

3.3.2. The system shall state that the text is a recognition result and may be wrong.

3.3.3. The system shall state the outcome and offer re-recording or typed entry, creating no record, when recognition produces no text.

3.3.4. The system shall send only the transcript text, never the audio recording, when parsing uses a service outside the device.

---

## 4. Mengurai Kalimat Menjadi Makanan

### 4.1 User Story

As a pengguna yang menyebut beberapa makanan sekaligus,
I want aplikasi memisahkannya menjadi daftar yang bisa saya periksa,
So that satu kalimat menghasilkan catatan yang rapi tanpa saya susun sendiri.

### 4.2 Functional Scope

- Mealora menguraikan kalimat menjadi daftar makanan beserta jumlah dan satuan yang disebut pengguna.
- Hasil penguraian adalah usulan yang wajib ditinjau. Tidak ada catatan yang dibuat sebelum pengguna mengonfirmasi.
- Nilai gizi setiap makanan berasal dari katalog, makanan buatan pengguna, atau produk yang pernah dikonfirmasi — tidak pernah dari hasil penguraian itu sendiri.
- Bila sebuah makanan tidak punya padanan yang memadai, Mealora meminta pengguna mencari atau membuatnya, dan tidak menampilkan nilai gizi apa pun untuk makanan itu.
- Bila pengguna tidak menyebut jumlah, Mealora menandainya belum ditentukan dan meminta pengguna menetapkannya. Mealora tidak menebak jumlah dan tidak memakai takaran bawaan sebagai jumlah yang dianggap disetujui.
- Bila satuan yang disebut tidak dikenali — misalnya "sepotong besar" — Mealora menandainya perlu ditetapkan dan menawarkan takaran yang tersedia untuk makanan itu.
- Peninjauan memakai alur yang sama dengan jalur foto: mengubah padanan makanan, mengubah porsi, menambah makanan yang terlewat, dan menghapus yang keliru.
- Saat pengguna mengonfirmasi, Mealora membuat satu catatan per makanan pada waktu makan dan tanggal yang dipilih. Penulisan berhasil seluruhnya atau tidak sama sekali.
- **Tidak termasuk:** mencatat langsung tanpa peninjauan, meski kalimatnya terdengar lengkap.

### 4.3 Acceptance Criteria

4.3.1. The system shall parse the sentence into a list of foods with the quantities and units the user stated.

4.3.2. The system shall treat the parsed result as a proposal and create no record before the user confirms.

4.3.3. The system shall take every food's nutrition values from the catalogue, a user-created food, or a previously confirmed product, and never from the parsing result.

4.3.4. The system shall ask the user to find or create a food, displaying no nutrition values for it, when no adequate match exists.

4.3.5. The system shall mark a quantity as undetermined and ask the user to set it when none was stated.

4.3.6. The system shall not guess a quantity or treat a default serving as an approved amount.

4.3.7. The system shall mark an unrecognised unit as needing to be set and offer the servings available for that food.

4.3.8. The system shall use the same component review flow as the photo path for changing matches, changing portions, adding foods, and removing foods.

4.3.9. The system shall create one record per food on the chosen meal time and date when the user confirms, storing either all of them or none.

---

## 5. Ketika Suara atau Layanan Tidak Tersedia

### 5.1 User Story

As a pengguna yang sedang di tempat ramai atau tanpa kuota,
I want tetap punya cara cepat mencatat,
So that jalur suara yang gagal tidak memaksa saya kembali mengetik satu per satu.

### 5.2 Functional Scope

- Mengetik kalimat tersedia sebagai jalur setara, tanpa izin mikrofon dan tanpa pengenalan ucapan. Kalimat yang diketik diuraikan dengan aturan yang sama.
- Mealora menyatakan dengan jelas bila penguraian memerlukan koneksi.
- Bila penguraian tidak tersedia — tidak ada koneksi, kuota habis, waktu tunggu lewat, atau layanan menolak — Mealora menyatakannya dalam bahasa yang dapat dimengerti, mempertahankan teks yang sudah ada, dan menawarkan pencarian katalog yang bekerja sepenuhnya tanpa koneksi.
- Alur inti aplikasi tetap bekerja penuh tanpa koneksi.
- **Tidak termasuk:** mengantre kalimat untuk diuraikan otomatis begitu koneksi kembali tanpa pengguna meminta.

### 5.3 Acceptance Criteria

5.3.1. The system shall offer typed sentence entry that works without microphone permission and without speech recognition, parsed under the same rules.

5.3.2. The system shall state clearly when parsing requires a connection.

5.3.3. The system shall state the situation in plain language, preserve the existing text, and offer catalogue search, when parsing is unavailable.

5.3.4. The system shall keep the core flows fully functional without a connection.

---

## 6. High Level Test Scenarios

6.1. **Mencatat satu kalimat** — Pengguna memilih jalur suara, mengucapkan "nasi satu piring, ayam bakar satu potong, tempe dua", memeriksa teksnya, meninjau tiga komponen, lalu mengonfirmasi → tiga catatan dibuat dan ringkasan hari menyesuaikan.

6.2. **Izin mikrofon ditolak** — Pengguna menolak izin mikrofon → Mealora menjelaskan dan menawarkan pengetikan kalimat serta pencarian katalog, tanpa layar gagal.

6.3. **Tidak ada rekaman terkirim** — Lalu lintas jaringan diamati selama pengenalan ucapan di perangkat → tidak ada rekaman suara yang keluar dari perangkat.

6.4. **Yang dikirim hanya teks** — Lalu lintas jaringan diamati saat penguraian → yang terkirim hanyalah teks transkrip.

6.5. **Memperbaiki satu kata** — Hasil pengenalan salah pada satu nama makanan → pengguna memperbaikinya di layar transkrip tanpa merekam ulang.

6.6. **Transkrip kosong** — Pengenalan tidak menghasilkan teks → Mealora menyatakannya dan menawarkan rekam ulang atau ketik, tanpa membuat catatan.

6.7. **Jumlah tidak disebut** — Pengguna mengucapkan "tadi makan tempe" → jumlah ditandai belum ditentukan dan konfirmasi menunggu sampai pengguna menetapkannya.

6.8. **Satuan tidak baku** — Pengguna menyebut "sepotong besar" → satuan ditandai perlu ditetapkan dan Mealora menawarkan takaran yang tersedia.

6.9. **Makanan tanpa padanan** — Salah satu makanan tidak ada di katalog → Mealora meminta pengguna mencari atau membuatnya, dan tidak menampilkan nilai gizi apa pun untuk makanan itu.

6.10. **Model mengembalikan angka gizi** — Keluaran penguraian memuat nilai gizi → nilai itu diabaikan dan Mealora memakai nilai dari padanan katalog.

6.11. **Menghapus makanan yang keliru** — Penguraian menambahkan makanan yang tidak disebut → pengguna menghapusnya → makanan itu tidak pernah tercatat.

6.12. **Peninjauan dibatalkan** — Pengguna menutup peninjauan tanpa mengonfirmasi → tidak ada catatan yang dibuat.

6.13. **Mengetik kalimat** — Pengguna memilih mengetik alih-alih berbicara → kalimat diuraikan dengan aturan yang sama, tanpa permintaan izin mikrofon.

6.14. **Penguraian tidak tersedia** — Mode pesawat atau kuota habis → Mealora menyatakannya tanpa istilah teknis, teks yang sudah ada tetap tersimpan, dan pencarian katalog ditawarkan.

6.15. **Kegagalan saat menyimpan** — Penyimpanan gagal pada komponen terakhir → tidak ada satu pun komponen yang tersimpan dan buku harian tidak berubah.

6.16. **Permintaan di luar cakupan** — Pengguna mengucapkan "catat berat badan saya 68 kilo" → Mealora tidak mencatat berat apa pun, menyatakan bahwa suara hanya untuk mencatat makanan, dan menunjukkan tempat mencatat berat.

6.17. **Ucapan bercampur** — Pengguna menyebut makanan sekaligus permintaan lain dalam satu kalimat → hanya bagian makanannya yang diuraikan, dan tidak ada perintah yang dijalankan.

6.18. **Tidak ada mikrofon di layar lain** — Layar berat badan, program, profil, dan pengaturan diperiksa → tidak ada kendali masukan suara di mana pun.

6.19. **Huruf diperbesar dan pembaca layar** — Layar rekam suara, tinjau transkrip, dan tinjau komponen diperiksa pada skala teks besar dan dengan pembaca layar → teks terbaca utuh, keadaan sedang merekam diumumkan, dan setiap kendali punya nama yang bermakna.
