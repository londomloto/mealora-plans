# Brief Desain UI — Change 013 (Pengingat) & 014 (Berbagi)

Dokumen ini adalah brief untuk mendesain layar baru di `mealora-v2.pen`. Gaya mengikuti layar yang sudah ada: glass card, gradien hero hijau, dan Plus Jakarta Sans. Frame baru diberi nomor lanjutan dari frame terakhir di file pen.

Spesifikasi lengkap ada di `openspec/changes/013-local-reminders/` dan `openspec/changes/014-social-share/`.

---

## Gaya dasar (wajib dipakai ulang)

| Variable pen | Hex | Pemakaian |
|---|---|---|
| `bg` | `#F2F7F3` | latar layar |
| `ink` | `#10291E` | teks utama |
| `muted` | `#5C7667` | teks sekunder |
| `primary-deep` | `#077A50` | tombol, sakelar aktif, teks hijau |
| `primary` | `#12A05C` | ikon/aksen (bukan teks di atas putih) |
| `lime` / `mint` | `#B6ED6A` / `#3FD5A0` | aksen gradien & highlight |
| `citrus` | `#FFB020` | peringatan lembut, makro karbohidrat |
| `coral` | `#FF7A5A` | makro lemak |
| `berry` | `#6E8BFF` | info, makro protein |
| `glass` / `glass-edge` | putih 65% / 72% | kartu |
| `font` | Plus Jakarta Sans | semua teks |
| `r` | 26 | radius dasar kartu |

Aturan:
- Pakai komponen yang sudah ada sebelum membuat yang baru, misalnya kartu, note card, primary button, empty state, dan baris setting gaya layar Profil.
- Jangan membuat warna atau bayangan baru tanpa alasan kuat.
- Teks di atas putih wajib kontras ≥ 4,5:1. Jangan pakai `primary` `#12A05C` untuk teks kecil.
- Ukuran frame HP 390×844, sama dengan layar lain.

---

# BAGIAN A — Change 013: Pengingat Lokal

## A1. Entri baru di menu Profil

- Tambahkan satu baris setting di kartu pengaturan Profil, dengan gaya sama seperti "Edit profil", "Program", dan "Privasi".
- Ikon lonceng (`notifications_outlined`) dengan warna `citrus` di atas latar `iconFieldAmber` (`#FFF4DA`).
- Label "Pengingat". Posisinya disarankan setelah "Riwayat program", sebelum "Satuan & bahasa".

## A2. Layar "Pengingat" (frame baru)

Header: tombol back dan judul "Pengingat". Subjudul muted: "Notifikasi muncul di HP ini saja. Waktunya bisa bergeser beberapa menit."

**Kartu 1 — Jam makan**

Empat baris. Tiap baris terdiri dari ikon waktu makan, label, jam (chip yang bisa diketuk untuk membuka time picker), dan sakelar di kanan.

| Baris | Jam default |
|---|---|
| Sarapan | 07:00 |
| Makan siang | 12:00 |
| Camilan | 15:30 |
| Makan malam | 19:00 |

- Semua sakelar mati secara default.
- Saat sakelar mati, chip jam tampil redup (muted) tetapi tetap bisa diubah.

**Kartu 2 — Timbang berat**

- Satu baris dengan label "Timbang berat", sub-teks "Seminggu sekali", dan sakelar.
- Di bawahnya ada pemilih hari berupa 7 chip bulat (S S R K J S M, Senin terpilih) dan chip jam 07:00.

**Kartu 3 — Jam tidur**

- Baris "Jam tidur" dengan chip jam 22:00.
- Sub-teks muted: "Dipakai untuk mengingatkan saat kamu mencatat makan menjelang tidur."
- Kartu ini tidak punya sakelar karena selalu aktif.

**State yang perlu dibuat (varian frame):**
1. **Default**: semua mati.
2. **Sebagian menyala**: misalnya makan siang dan timbang menyala.
3. **Izin diblokir**: sakelar menyala, tetapi di atas kartu 1 muncul note card warning (`noteWarning`, ikon citrus) berisi teks "Notifikasi diblokir. Pengingat tidak bisa muncul sampai kamu mengizinkannya." dan tombol teks "Buka pengaturan".

## A3. Dialog / bottom sheet pilih jam

- Gunakan time picker 24 jam bergaya bottom sheet Mealora (glass, radius 26).
- Tombol "Simpan" (primary) dan "Batal".

## A4. Permintaan izin

Dialog izin muncul dari sistem Android, jadi tidak perlu didesain. Opsional: satu sheet pra-izin sebelum dialog sistem, dengan judul "Izinkan notifikasi?", teks "Mealora butuh izin agar pengingat bisa muncul.", serta tombol "Lanjut" dan "Nanti".

## A5. Notifikasi (mockup saja)

Notifikasi memakai tampilan bawaan Android. Cukup buat mockup tray untuk referensi copy:
- Sarapan: **"Waktunya sarapan"** — "Jangan lupa catat sarapanmu di Mealora."
- Makan siang, camilan, dan makan malam memakai pola yang sama.
- Timbang: **"Waktunya timbang"** — "Catat berat badanmu minggu ini."
- Notifikasi tidak boleh memuat angka kalori atau berat badan.

## A6. Peringatan makan menjelang tidur

- Muncul setelah makanan berhasil disimpan, di halaman Hari ini.
- Bentuknya snackbar atau banner bawah yang tidak memblokir, di atas bottom nav, dengan latar glass kuat, ikon bulan sabit warna `citrus`, dan tombol tutup ×.
- Copy: **"Sudah dekat jam tidur."** Makan berat menjelang tidur bisa membuat tidur kurang nyenyak. Pilih porsi ringan kalau masih lapar.
- Jangan pakai warna merah atau `danger`, kata "berbahaya", atau ikon peringatan segitiga. Nadanya informatif, bukan teguran.
- Buat satu frame halaman Hari ini dengan banner ini tampil.

---

# BAGIAN B — Change 014: Berbagi (mode pamer)

## B1. Tombol Bagikan di halaman Hari ini

- Ikon share (`ios_share` atau `share_rounded`) di header halaman Hari ini, sejajar elemen header yang ada.
- **Aktif**: ikon `ink`.
- **Nonaktif** (belum ada catatan hari ini): ikon muted. Saat diketuk, muncul tooltip atau snackbar "Catat makanan dulu untuk membagikan ringkasan."

## B2. Kartu "Ringkasan Harian" (artboard 360×640, rasio 9:16)

Kartu ini akan dirender menjadi gambar 1080×1920 untuk WA Status atau IG Story. Elemen penting ditaruh di **area aman tengah**, dengan margin atas dan bawah sekitar 64 px karena aplikasi tujuan menimpa bagian itu.

Susunan dari atas ke bawah:
1. **Latar**: gradien hero hijau (`#0A6B4C` → `#077A50` → `#35C97E`) dengan sedikit dekorasi lime/mint seperti hero onboarding.
2. **Judul**: "Ringkasan Hari Ini", diikuti tanggal (mis. "Rabu, 11 November 2026") dengan warna `on-dark-soft`.
3. **Hero angka**: cincin progres besar (lime di atas track putih transparan). Di tengahnya **1.650** (besar dan tebal), lalu "/ 2.000 kkal", lalu chip **83% target**.
4. **Tiga makro** dalam kartu glass putih: Protein (berry), Karbohidrat (citrus), Lemak (coral). Masing-masing berisi titik warna, label, dan gram (mis. "98 g").
5. **Watermark** di bawah: logo `mealora-symbol` dan wordmark "Mealora" berwarna putih, dengan tagline kecil opsional "Catat makan, pantau gizi". Watermark selalu ada.

Varian yang perlu dibuat:
- Normal (83%).
- Di atas target (mis. 2.350 / 2.000 → 118%). Tampilannya tetap netral, tanpa warna merah atau kata "berlebihan".
- Angka kecil (mis. 320 / 2.000 → 16%).

Aturan isi kartu: tidak boleh ada berat badan, nama program, nama pengguna, atau data profil.

## B3. Layar "Tersimpan" (jalur foto, frame baru)

Layar ini muncul setelah pengguna mengonfirmasi hasil foto makanan.

- Ikon centang dalam lingkaran `primary` dengan animasi ringan opsional.
- Judul **"Tersimpan!"**, sub-teks "Makan siang • 3 item • 640 kkal".
- Pratinjau kecil kartu makanan (thumbnail B4) di tengah.
- Tombol utama **"Bagikan"** (primary, ikon share) dan tombol sekunder **"Selesai"** (teks/outline).
- Tidak ada tombol back di app bar. Tombol back sistem berarti Selesai.

## B4. Kartu "Makanan" (artboard 360×640, rasio 9:16)

1. **Foto makanan** memenuhi sekitar 55% bagian atas (crop cover, sudut atas mengikuti radius kartu). Gradien gelap tipis di bawah foto supaya teks terbaca.
2. **Chip waktu makan** di atas foto, misalnya "Makan siang", dengan gaya glass.
3. **Panel bawah** putih atau glass berisi daftar komponen, maksimal 4 baris lalu "+2 lainnya". Tiap baris berisi nama makanan, porsi muted (mis. "1 piring • 250 g"), dan kkal di kanan.
4. **Total**: "Total ±640 kkal" dalam teks besar dengan label kecil "Estimasi dari foto".
5. **Watermark** Mealora di bawah (logo + wordmark, warna `primary-deep` karena latarnya terang).

Varian yang perlu dibuat:
- 2 komponen.
- 6 komponen (terpotong dengan "+2 lainnya").
- Nama makanan panjang yang dipotong dengan elipsis (1 baris).

## B5. Layar Pratinjau Bagikan

Layar ini dipakai untuk kedua kartu.

- Latar `bg`, header "Pratinjau" dengan tombol tutup ×.
- Kartu ditampilkan di tengah dengan skala muat layar dan bayangan halus.
- Tombol utama di bawah: **"Bagikan"**, yang membuka menu berbagi Android. Menu itu bawaan sistem dan tidak perlu didesain.
- Teks kecil muted: "Gambar dibuat di HP kamu. Mealora tidak mengunggah apa pun."

---

## Ringkasan frame yang perlu dibuat

| # | Frame | Change |
|---|---|---|
| 1 | Profil + entri "Pengingat" | 013 |
| 2 | Pengingat — default | 013 |
| 3 | Pengingat — sebagian menyala | 013 |
| 4 | Pengingat — izin diblokir | 013 |
| 5 | Sheet pilih jam | 013 |
| 6 | (opsional) Sheet pra-izin | 013 |
| 7 | Mockup notifikasi (makan & timbang) | 013 |
| 8 | Hari ini + banner menjelang tidur | 013 |
| 9 | Hari ini + tombol Bagikan (aktif & nonaktif) | 014 |
| 10 | Kartu Ringkasan Harian (3 varian) | 014 |
| 11 | Layar "Tersimpan" | 014 |
| 12 | Kartu Makanan (3 varian) | 014 |
| 13 | Pratinjau Bagikan | 014 |

## Copy — kata yang dilarang

Berlaku sesuai nutrition-policy-v1. Jangan pakai kata atau nada berikut di layar mana pun:
- "berbahaya"
- "gagal"
- "berlebihan"
- "buruk"
- "diet ketat"
- klaim medis apa pun
- nada menyalahkan pengguna
