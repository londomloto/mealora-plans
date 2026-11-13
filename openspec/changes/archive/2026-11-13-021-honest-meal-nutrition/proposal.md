# 021 · Foto makanan & bagikan: nutrisi yang jujur dan bisa dilengkapi

## Why

Uji HP change 020 menemukan masalah pada foto makanan (change 011) dan fitur bagikan (change 014). Contohnya foto kue dan kopi: AI mengenali cheesecake, muffin, dan kue kering dengan benar, tapi ketiganya belum ada di katalog.

- **Total menyesatkan.** Layar tinjau menulis "7 kkal", seolah itu total makanannya. Komponen tanpa padanan dilewati, dan nilai yang tidak diketahui ditampilkan sebagai 0. Kartu ringkasan harian dan kartu makanan juga menghitung energi yang tidak diketahui sebagai 0. Padahal kartu inilah yang dibagikan ke orang lain.
- **User mentok.** Komponen tanpa padanan wajib dipilih dari katalog dulu (spec 011). Kalau makanannya memang tidak ada di katalog, tidak ada jalan keluar dari layar itu, sehingga makanan tidak bisa dicatat maupun dibagikan.
- **Takaran tanpa satuan.** Sheet koreksi hanya menampilkan "1,0".

Change 020 sudah menyediakan alat untuk mengisi gizi dari teks dan foto info gizi, jadi celah ini sekarang bisa ditutup.

## What Changes

- **Total yang jujur.** Di tinjau foto, Hari ini, kartu makanan, dan kartu ringkasan harian, nilai yang belum diketahui tidak pernah dihitung sebagai 0. Total ditulis misalnya "7 kkal + 3 belum diketahui". Kalau seluruhnya belum diketahui, totalnya ditandai belum diketahui.
- **Melengkapi komponen tanpa padanan:**
  - Komponen tanpa padanan di tinjau foto bertanda "belum ada di katalog" dan punya aksi **Lengkapi**. Tombol utama menjadi **"Lengkapi N bahan"**.
  - Sheet Ubah komponen untuk komponen itu menawarkan **Cari di katalog** atau **Buat makanan ini**.
  - **Buat makanan ini** membuka form Buat makanan yang nama dan sajiannya sudah terisi, beserta alat Tempel teks dan Foto info gizi dari change 020. Setelah disimpan, makanan baru itu otomatis menjadi padanan komponen tersebut.
  - Aturan 011 tetap berlaku: komponen tanpa padanan tidak bisa dicatat, dan sistem tidak pernah mengarang nilai.
- **Satuan takaran.** Takaran di sheet menampilkan sajian padanannya, misalnya "1 potong" atau "1,5 × 1 cangkir".
- **Bagikan tanpa mencatat.** Selama masih ada komponen tanpa padanan, tinjau foto menyediakan tautan **"Bagikan saja tanpa mencatat"**:
  - Tautan membuka pratinjau bagikan dengan kartu **tanpa kalori dan makro** (foto, nama makanan, label "Dibagikan dari Mealora"), plus catatan bahwa makanan belum dicatat.
  - Tidak ada yang masuk ke buku harian. Draf foto tetap ada, dan setelah dibagikan atau ditutup user kembali ke tinjau foto.
- **Tersimpan dengan nutrisi belum lengkap.** Kasus ini terjadi kalau makanan yang dipilih punya nilai kosong di katalog. Layar Tersimpan lalu menawarkan **Lengkapi dulu** dan **Bagikan tanpa total**, dan kartunya tidak menampilkan total yang menyesatkan.

## Capabilities

### New Capabilities

- `meal-nutrition-honesty`: aturan tampilan total gizi saat sebagian nilai belum diketahui (tinjau foto, Hari ini, dan kedua kartu bagikan), alur melengkapi komponen foto tanpa padanan lewat Buat makanan, satuan takaran di koreksi komponen, serta berbagi kartu makanan tanpa total, baik tanpa mencatat maupun setelah tersimpan.

### Modified Capabilities

(tidak ada)

Main spec belum ada di store; spec 011 dan 014 masih berada di change masing-masing. Ada satu hal yang bertentangan dengan requirement 014 "Bagikan makanan dari jalur foto". Requirement itu menyebut kartu makanan memuat total energi dan Bagikan hanya muncul setelah konfirmasi. Change ini menambah dua hal:
- kartu tanpa total saat nilainya belum lengkap;
- Bagikan tanpa mencatat dari tinjau foto. Fitur ini tetap hanya ada di jalur foto.

Requirement 014 perlu diselaraskan saat 014 dan 021 diarsipkan. Spec 011 tidak berubah, karena komponen tanpa padanan tetap tidak dapat dicatat.

## Impact

- **mealora-mobile**:
  - `food_photo_review_screen.dart`: baris "belum ada di katalog" dengan aksi Lengkapi, tombol "Lengkapi N bahan", total jujur, dan tautan Bagikan saja tanpa mencatat.
  - `food_component_correction_screen.dart`: pilihan Cari di katalog / Buat makanan ini, dan satuan takaran.
  - `custom_food_screen.dart`: mode yang mengembalikan makanan baru ke pemanggil.
  - `today_screen.dart` dan `daily_summary_share_card.dart`: energi yang belum diketahui tidak lagi dihitung 0.
  - `meal_share_card.dart`: varian tanpa total.
  - `share_preview_screen.dart` dan `food_photo_saved_screen.dart`.
  - Fungsi murni untuk menghitung total parsial, beserta unit test, dan string l10n baru.
- **Desain**: `mealora-plans/docs/mealora-v2.pen`, section 14, layar 92–97.
- **Ketergantungan**: memakai `NutritionTextImportScreen` dan Foto info gizi dari change **020**, jadi 020 harus selesai lebih dulu. Change ini juga menyentuh alur 011 dan 014.
- **Tanpa perubahan proxy, skema basis data, maupun data lama.** Catatan yang sudah ada tetap sama. Hanya cara menampilkan totalnya yang berubah.
- **Di luar cakupan**: menambah cheesecake, muffin, kue kering, dan makanan populer lain ke katalog. Ini diusulkan terpisah lewat kurasi katalog, dengan sumber resmi dulu.
