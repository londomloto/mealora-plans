# Functional Requirements Specification

## Mealora - Berbagi Ringkasan Harian dan Foto Makanan

| | |
|---|---|
| Change | 014-social-share |
| Versi | v0.1-draft |
| Tanggal | 2026-11-11 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Membagikan ringkasan gizi hari ini sebagai gambar dari halaman Hari ini.
- Membagikan makanan yang baru difoto sebagai gambar, tepat setelah hasil foto dikonfirmasi.
- Watermark Mealora pada setiap gambar.
- Pratinjau sebelum berbagi dan pemilihan aplikasi tujuan lewat menu berbagi HP.

### 1.2 Deferred Items (Not in This FRS Version)

- Share Progress (perkembangan berat badan atau konsistensi 7–30 hari). Tidak direncanakan.
- Berbagi makanan dari pencarian katalog, barcode, label gizi, atau suara. Hanya jalur foto yang didukung.
- Berbagi ringkasan dari halaman Riwayat untuk tanggal lampau.
- Pilihan tema kartu, menyembunyikan field, atau mematikan watermark.
- Tautan unduhan aplikasi atau deep link di dalam kartu.

## 2. Bagikan Ringkasan Harian

### 2.1 User Story

As a pengguna Mealora,
I want membagikan ringkasan kalori dan gizi hari ini sebagai gambar,
So that saya bisa menunjukkan konsistensi saya ke teman dan pengikut.

### 2.2 Functional Scope

- Halaman Hari ini memiliki tombol Bagikan.
- Kartu memuat tanggal, kalori tercatat dibanding target (mis. 1.650 / 2.000 kkal), persentase target, serta protein, karbohidrat, dan lemak dalam gram.
- Bila belum ada catatan hari ini, tombol tidak aktif dan aplikasi menjelaskan bahwa ringkasan bisa dibagikan setelah ada catatan.
- Pengguna melihat pratinjau, lalu memilih aplikasi tujuan dari menu berbagi HP, misalnya WhatsApp atau Instagram.
- Kartu tidak pernah memuat berat badan, tinggi, usia, nama program, atau data profil.
- Fitur berfungsi tanpa internet, dan Mealora tidak mengunggah apa pun.

### 2.3 Acceptance Criteria

2.3.1. The system shall provide a Share button on the Today screen that creates a daily summary card for today.

2.3.2. The system shall show the date, logged energy versus daily target, target percentage, and protein, carbohydrate, and fat grams on the daily summary card.

2.3.3. The system shall disable the daily summary Share button and explain why when nothing has been logged today.

---

## 3. Bagikan Makanan dari Foto

### 3.1 User Story

As a pengguna Mealora,
I want membagikan foto makanan saya beserta estimasi kalorinya setelah mencatatnya,
So that saya bisa memamerkan menu saya dengan informasi gizinya.

### 3.2 Functional Scope

- Setelah hasil foto makanan dikonfirmasi dan tersimpan, aplikasi menampilkan layar "Tersimpan" dengan tombol Bagikan dan Selesai.
- Kartu memuat foto makanan, nama dan porsi setiap komponen, estimasi kalori per komponen, dan total kalori.
- Menutup layar "Tersimpan" tanpa berbagi tidak menghapus catatan makan.
- Tombol Bagikan makanan hanya ada di jalur foto.
- Foto tidak disimpan ulang. Setelah layar "Tersimpan" ditutup, foto diperlakukan sesuai pengaturan penyimpanan gambar pengguna.

### 3.3 Acceptance Criteria

3.3.1. The system shall show a Saved screen with a Share button after a food photo result is confirmed and saved.

3.3.2. The system shall show the food photo, each component's name, portion, and estimated energy, and the total energy on the meal card.

3.3.3. The system shall return to the home screen and keep the logged meal when the user closes the Saved screen without sharing.

3.3.4. The system shall not offer a meal Share button on non-photo logging paths.

---

## 4. Aturan Umum Kartu

### 4.1 User Story

As a pemilik produk Mealora,
I want setiap kartu yang dibagikan membawa identitas Mealora dan menjaga privasi pengguna,
So that berbagi menjadi promosi yang aman.

### 4.2 Functional Scope

- Setiap kartu menampilkan logo dan nama Mealora yang tidak dapat dimatikan.
- Pratinjau selalu ditampilkan sebelum menu berbagi.
- Menutup menu berbagi tanpa memilih aplikasi kembali ke layar sebelumnya tanpa pesan galat.
- Gambar kartu hanya dibuat sementara dan dihapus setelah selesai.
- Teks kartu tidak membuat klaim medis atau bernada menghakimi.

### 4.3 Acceptance Criteria

4.3.1. The system shall include the Mealora logo and name on every shared card.

4.3.2. The system shall show a card preview before opening the system share sheet.

4.3.3. The system shall not upload cards, photos, or nutrition data to any server when sharing, and shall work offline.

4.3.4. The system shall return to the previous screen without an error when the share sheet is dismissed.

4.3.5. The system shall not include weight, height, age, program name, or other profile data on any card.

4.3.6. The system shall delete temporary card images after sharing finishes or is cancelled.

4.3.7. The system shall keep the food photo available until the Saved screen closes and then apply the user's image retention setting.

## 5. High Level Test Scenarios

| # | Kondisi awal | Aksi | Hasil yang diharapkan |
|---|---|---|---|
| 1 | Sudah ada catatan 1.650 kkal, target 2.000 | Ketuk Bagikan di Hari ini, pilih WhatsApp | Pratinjau dan gambar memuat 1.650 / 2.000 kkal, 83%, makro, dan watermark |
| 2 | Belum ada catatan hari ini | Lihat tombol Bagikan | Tombol tidak aktif dan ada keterangan |
| 3 | Mode pesawat aktif | Bagikan ringkasan | Pratinjau dan menu berbagi tetap muncul |
| 4 | Foto makanan dianalisis | Konfirmasi lalu ketuk Bagikan | Kartu memuat foto, komponen, porsi, kalori, total, dan watermark |
| 5 | Layar "Tersimpan" terbuka | Ketuk Selesai | Kembali ke halaman awal dan catatan tetap ada |
| 6 | Mencatat lewat barcode | Selesai menyimpan | Tidak ada tombol Bagikan makanan |
| 7 | Pengaturan "hapus setelah dicatat" | Bagikan foto lalu tutup layar "Tersimpan" | Foto tidak lagi tersimpan di HP |
| 8 | Pengguna program Turun Berat | Bagikan ringkasan | Kartu tidak menampilkan berat badan maupun nama program |
