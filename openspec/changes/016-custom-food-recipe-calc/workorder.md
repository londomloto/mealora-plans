# Work Order

## Ringkasan

Change ini mengirim pilihan "Hitung dari bahan" untuk makanan buatan sendiri: penjumlahan gizi dari bahan, pembagian per porsi atau per 100 g hasil, penanganan bahan yang belum ada, dan penyimpanan resep (lihat `frs.md`). Isi manual tidak berubah. Repo yang tersentuh hanya `mealora-mobile`. Rilisnya satu tahap, sebaiknya setelah change 015.

## Breakdown per Repository

### mealora-mobile

| # | Paket pekerjaan | Effort (hari-orang) | Kepastian | Catatan |
|---|---|---|---|---|
| 1 | `RecipeCalculator` (fungsi murni) + test unit lengkap (gram, kelipatan, tidak lengkap, porsi, berat jadi, validasi) | 1 | pasti | |
| 2 | Migrasi skema (`recipe_ingredients`, `nutritionOrigin`, kolom hasil resep) + test migrasi | 1 | pasti | Nomor versi mengikuti urutan rilis vs 015 |
| 3 | Repository: simpan/baca/sunting resep, takaran porsi dan 100 g hasil, cegah hapus bahan yang dipakai | 1,5 | pasti | |
| 4 | UI layar buat/sunting: pilihan isi manual vs hitung dari bahan, daftar bahan, hasil resep, rincian, koreksi | 2,5 | pasti | Desain layar belum ada di `docs/mealora-v2.pen` |
| 5 | Pemilihan bahan: pakai ulang lembar komponen foto, buat bahan per 100 g, bahan tanpa data | 1 | pasti | |
| 6 | Test widget skenario spec + verifikasi emulator + gate repo | 1,5 | pasti | |
| 7 | Desain layar resep di `docs/mealora-v2.pen` | 1 | spike (timebox 1 hari) | Perlu persetujuan pemilik produk sebelum paket 4 |

Total kasar: **9,5 hari-orang**.

## Dependensi Antar-Paket

- Change 007 diarsipkan lebih dulu, karena spec `food-catalog` dimodifikasi.
- Disarankan setelah change 015 (takaran URT dan bentuk bahan), tapi tidak memblokir.
- #1 → #3 → #4. #2 → #3. #7 → #4. #5 paralel dengan #4.

## Urutan Rilis

### Tahap 1 — Hitung dari bahan

**Isi:** #1–#7.
**Prasyarat:** 007 diarsipkan. Idealnya 015 sudah live. Desain layar (#7) disetujui.
**Gate verifikasi:** `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test` (termasuk test kalkulator dan migrasi). Skenario uji FRS 1–9 dijalankan di emulator Android. Makanan buatan sendiri yang lama masih bisa dicatat dan disunting.

## Risiko Jadwal

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Desain layar resep belum ada | Paket UI tertunda | Spike desain 1 hari di awal, berjalan paralel dengan #1–#3 |
| Bentrok migrasi dengan 015 | Pengerjaan ulang kecil | Tentukan urutan rilis sebelum menulis migrasi |
| Layar menjadi terlalu padat | Butuh iterasi UX | Isi manual tetap bawaan. Resep di bagian terpisah yang bisa dibuka-tutup |
