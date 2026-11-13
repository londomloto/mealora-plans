# Functional Requirements Specification

## Mealora — Foto Makanan & Bagikan: Nutrisi yang Jujur

| | |
|---|---|
| Change | 021-honest-meal-nutrition |
| Versi | v0.1-draft |
| Tanggal | 2026-11-12 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Total gizi yang jujur di tinjau foto makanan, ringkasan Hari ini, dan kedua kartu bagikan: bagian yang belum diketahui tidak dihitung nol.
- Melengkapi makanan dari foto yang belum ada di katalog, langsung dari layar tinjau.
- Satuan takaran yang jelas saat mengoreksi komponen foto.
- Membagikan makanan dari foto tanpa mencatatnya, dengan kartu tanpa angka gizi.
- Pilihan melengkapi atau membagikan tanpa total, setelah makanan tersimpan dengan nilai yang belum lengkap.

### 1.2 Deferred Items (Not in This FRS Version)

- **Mencatat makanan dari foto sebelum semua komponennya lengkap.** Komponen yang belum ada di katalog tetap harus dilengkapi dulu.
- **Perkiraan gizi otomatis oleh AI** untuk makanan yang tidak ada di katalog.
- **Penambahan makanan populer ke katalog** (mis. cheesecake, muffin, kue kering). Akan diusulkan terpisah.
- **Memilih ukuran sajian lain** saat mengganti makanan komponen.

## 2. Nutrisi Jujur pada Foto Makanan dan Bagikan

### 2.1 User Story

As a pengguna Mealora,
I want melihat total gizi yang jujur, bisa melengkapi makanan yang belum dikenal katalog, dan tetap bisa membagikan foto makananku,
So that catatan dan kartu yang saya bagikan tidak menyesatkan, dan saya tidak mentok saat makanan saya belum ada di katalog.

### 2.2 Functional Scope

- **Total yang jujur.** Bila sebagian nilai gizi belum diketahui, total menjumlahkan yang diketahui saja dan menyebut berapa yang belum diketahui, mis. "7 kkal + 3 belum diketahui". Total tidak pernah menganggap nilai yang belum diketahui sebagai nol. Ini berlaku di tinjau foto, ringkasan Hari ini, kartu makanan, dan kartu ringkasan harian. Kartu ringkasan harian tidak menampilkan persentase target bila energinya belum lengkap.
- **Komponen belum ada di katalog.** Di tinjau foto, komponen itu bertanda "belum ada di katalog" dengan aksi **Lengkapi**. Tombol utama berbunyi **"Lengkapi N bahan"**. Makanan baru bisa dicatat setelah semua komponen lengkap.
- **Cara melengkapi.** Pengguna memilih **Cari di katalog** atau **Buat makanan ini**. "Buat makanan ini" membuka form Buat makanan yang nama dan sajiannya sudah terisi. Nilai gizinya bisa diisi lewat Tempel teks atau Foto info gizi. Setelah disimpan, pengguna kembali ke tinjau foto dan makanan baru itu otomatis dipakai untuk komponen tersebut. Bila batal, komponen tetap belum lengkap.
- **Satuan takaran.** Takaran di layar koreksi selalu disertai satuan sajian, mis. "1 potong" atau "1,5 × 1 cangkir".
- **Bagikan saja tanpa mencatat.** Selama masih ada komponen yang belum lengkap, tinjau foto menyediakan tautan **"Bagikan saja tanpa mencatat"**:
  - Tautan membuka pratinjau kartu yang berisi foto, nama makanan, waktu makan, dan label "Dibagikan dari Mealora", tanpa kalori dan makro.
  - Ada catatan bahwa makanan belum dicatat di buku harian.
  - Setelah berbagi atau menutup pratinjau, pengguna kembali ke tinjau foto, dan semua komponen masih ada.
- **Tersimpan dengan nilai belum lengkap.** Ini terjadi bila makanan yang dipilih punya nilai kosong di katalog. Layar Tersimpan menyebut jumlah yang belum diketahui dan menawarkan **Lengkapi dulu** (membuka buku harian untuk mengganti makanannya) atau **Bagikan tanpa total**.

### 2.3 Acceptance Criteria

2.3.1. The system shall total only known nutrition values and show how many parts are unknown, never counting unknown values as zero.

2.3.2. The system shall show a total as unknown when no value in it is known.

2.3.3. The system shall apply the honest total on the food photo review, the Hari ini summary, the meal share card, and the daily summary share card.

2.3.4. The system shall not show a target percentage on the daily summary card when the energy total is incomplete.

2.3.5. The system shall mark photo components without a catalog match as "belum ada di katalog" with a "Lengkapi" action, and label the main button "Lengkapi N bahan".

2.3.6. The system shall not log a photo meal while any component lacks a catalog match.

2.3.7. The system shall offer "Cari di katalog" and "Buat makanan ini" for a component without a catalog match.

2.3.8. The system shall open Buat makanan prefilled with the component name and estimated serving, with Tempel teks and Foto info gizi available, and bind the saved food to the component and return to the photo review.

2.3.9. The system shall keep the component unmatched when the user cancels Buat makanan.

2.3.10. The system shall show the serving unit with every component quantity.

2.3.11. The system shall offer "Bagikan saja tanpa mencatat" while unmatched components exist, show a card without nutrition numbers and a not-logged note, write nothing to the diary, and return to the intact review afterwards.

2.3.12. The system shall show the card without totals with the photo, component names, meal time, and the label "Dibagikan dari Mealora".

2.3.13. The system shall, when a logged photo meal has unknown energy, offer "Lengkapi dulu" and "Bagikan tanpa total" on the saved screen.

## 3. High Level Test Scenarios

1. **Total jujur**: foto kue dan kopi dengan 3 kue belum ada di katalog → total "7 kkal + 3 belum diketahui", tombol "Lengkapi 3 bahan".
2. **Buat makanan ini**: Lengkapi cheesecake → Buat makanan ini → Tempel teks gizi cheesecake → Simpan → kembali ke tinjau, cheesecake punya nilai, dan sisa yang belum lengkap jadi 2.
3. **Cari di katalog**: Lengkapi muffin → Cari di katalog → pilih makanan serupa → komponen terisi.
4. **Batal**: Buat makanan ini → kembali tanpa menyimpan → komponen tetap belum lengkap.
5. **Satuan takaran**: buka kopi susu di koreksi → takaran tampil "1 cangkir" (atau "× 1 cangkir"), bukan "1,0".
6. **Bagikan tanpa mencatat**: di tinjau dengan komponen belum lengkap → Bagikan saja tanpa mencatat → kartu tanpa angka → tutup → kembali ke tinjau, komponen masih ada, dan buku harian tidak berubah.
7. **Semua lengkap**: setelah semua komponen lengkap → tautan Bagikan saja hilang → Konfirmasi & catat → layar Tersimpan seperti biasa.
8. **Nilai kosong dari katalog**: catat foto dengan padanan berenergi kosong → layar Tersimpan menampilkan "+ 1 belum diketahui", Lengkapi dulu, dan Bagikan tanpa total.
9. **Hari ini**: ada catatan berenergi kosong → ringkasan "X kkal + 1 belum diketahui" → kartu ringkasan harian tanpa persentase.
