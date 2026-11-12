## Context

Lihat proposal.md (Why). Keadaan kode `mealora-apps/mealora-mobile` saat ini:

- Foto makanan disimpan sebagai berkas draf di `food-photo-drafts/` (`food_photo_draft_storage.dart`). `_confirm()` di `food_photo_review_screen.dart` memanggil `logFoodEntries`, lalu `_discardDraft()` (membuang draf dan menghapus foto bila retensi `deleteAfterLogging`), lalu `popUntil(isFirst)`.
- Total harian dan target sudah dihitung untuk ruang Hari ini (`DailyNutritionTotal`, `today_screen.dart`).
- Aset logo `assets/mealora-symbol.png` dan font Plus Jakarta Sans sudah tersedia.
- Belum ada dependensi berbagi.

## Goals / Non-Goals

**Goals:**
- Kartu dirender di perangkat dengan tampilan yang konsisten, tidak bergantung pada ukuran layar.
- Tidak ada berkas permanen baru, dan aturan retensi change 010 tetap berlaku.

**Non-Goals:**
- Integrasi SDK khusus Instagram atau WhatsApp (misalnya sticker API), karena cukup memakai lembar berbagi sistem.
- Kustomisasi tema kartu dan pilihan menyembunyikan field.

## Decisions

**D1 — `share_plus` + `XFile` PNG di direktori cache.**
Lembar berbagi sistem sudah mencakup WA Status, IG Story, dan aplikasi lain tanpa SDK pihak ketiga. Alternatif SDK IG Stories tidak dipilih karena butuh Facebook App ID dan bertentangan dengan prinsip tanpa server.

**D2 — Kartu sebagai widget Flutter, dirender ke PNG lewat `RepaintBoundary.toImage`.**
Ukuran logis kartu tetap 360×640 (9:16) dengan `pixelRatio` 3, sehingga hasilnya 1080×1920. Kartu yang sama dipakai untuk pratinjau, jadi apa yang dilihat pengguna sama dengan yang dibagikan. Menggambar langsung di `Canvas` tidak dipilih karena lebih sulit dirawat dan tidak memakai ulang tema.

**D3 — Layar "Tersimpan" (`FoodPhotoSavedScreen`) di jalur foto.**
`_confirm()` menggantikan route review dengan layar ini dan membawa `PhotoDraft` (komponen + nilai gizi + path foto). Penghapusan draf dan foto dipindah dari `_confirm()` ke penutupan layar "Tersimpan" (tombol Selesai, back, atau dispose). Draf di DB tetap dibuang segera setelah log berhasil supaya tidak muncul lagi sebagai draf tertunda. Hanya berkas fotonya yang ditunda.

**D4 — Pembersihan berkas yatim saat start.**
Kalau aplikasi dimatikan saat layar "Tersimpan" terbuka, berkas foto bisa tertinggal walaupun retensinya `deleteAfterLogging`. Saat start, berkas di `food-photo-drafts/` yang tidak dirujuk draf mana pun dihapus bila retensi `deleteAfterLogging`. PNG kartu di subfolder cache `share-cards/` selalu dibersihkan saat start dan setelah share selesai.

**D5 — Format angka dan copy.**
Format angka memakai `diary_format` yang sudah ada (locale id: 1.650 kkal). Persentase dibulatkan ke bilangan bulat, dan boleh lebih dari 100%. Copy kartu (judul, label makro, "Estimasi") disimpan di ARB dan ditinjau terhadap nutrition-policy-v1.

**D6 — Tombol Bagikan ringkasan.**
Tombol ditempatkan sebagai ikon di header ruang Hari ini, dan dinonaktifkan bila total hari ini nol catatan.

## Risks / Trade-offs

- [Foto besar membuat render lambat atau boros memori] → Foto di-decode dengan `cacheWidth` sesuai ukuran kartu.
- [Aplikasi tujuan memotong gambar 9:16] → Elemen penting ditaruh di area aman tengah, dan watermark di bawah dengan margin.
- [Pengguna mengira kartu juga tersimpan di galeri] → Hal ini tidak dijanjikan. Simpan ke galeri bisa dilakukan lewat lembar berbagi bila OS menawarkannya.

## Migration Plan

Tidak ada migrasi skema. Rollback dilakukan dengan mengembalikan `_confirm()` ke alur lama dan menghapus dependensi.
