# Mealora — palet `mealora-v2.pen`

Status: **berlaku**. Menggantikan `mealora_palette_baseline.md` dan
`mealora_palette_green_pop.md` (dihapus — keduanya untuk `mealora.pen` v1,
tidak pernah diperbarui untuk v2).

Sumber kebenaran palet adalah panel **Theme** di `mealora-v2.pen` sendiri
(sidebar kiri pen.dev, ikon diamond) — 16 variable, dibaca langsung dari
dokumen pada 2026-11-10. Tabel di bawah memetakan tiap variable ke token
`color_tokens.dart` yang memakainya.

## Variable inti (dari panel Theme pen.dev)

| Variable (pen.dev) | Hex | Token `color_tokens.dart` | Catatan |
|---|---|---|---|
| `bg` | `#F2F7F3` | `background` | sama persis |
| `ink` | `#10291E` | `ink` | sama persis |
| `primary` | `#12A05C` | `primaryBright` | dipakai untuk ikon/aksen non-teks, bukan teks di atas putih (kontras 3,38:1, di bawah ambang 4,5:1) |
| `primary-deep` | `#077A50` | `primary` | dipakai sebagai hijau merek di permukaan ber-teks (tombol, `ColorScheme.primary`) — kebalikan urutan nama dari pen.dev, sengaja, demi kontras |
| `muted` | `#5C7667` | `muted` = `#5A7465` | digelapkan ~2% dari nilai pen.dev agar mencapai ambang kontras 4,5:1 di atas `background` (lihat komentar token & `test/unit/theme_test.dart`) |
| `lime` | `#B6ED6A` | `lime` | sama persis |
| `mint` | `#3FD5A0` | `mint` | sama persis |
| `citrus` | `#FFB020` | `accent` | sama persis, nama berubah jadi semantik |
| `coral` | `#FF7A5A` | `peach` | sama persis, nama berubah jadi semantik |
| `berry` | `#6E8BFF` | `info` | sama persis, nama berubah jadi semantik |
| `glass` | putih 65% | `glassCard` = `#A6FFFFFF` | sama persis (0xA6 ≈ 65%) |
| `glass-edge` | putih 72% | `glassSoft` = `#B8FFFFFF` | sama persis (0xB8 ≈ 72%) |
| `on-dark` | `#FFFFFF` | `onPrimary` | sama persis |
| `on-dark-soft` | `#DFF3E6` | `onPrimaryMuted` | sama persis |
| `font` | Plus Jakarta Sans | `MealoraTypography.fontFamily` | sama persis |
| `r` | `26` | — | radius dasar; komponen individual memakai radius sendiri (lihat `spacing_tokens.dart` → `MealoraRadius`), bukan satu nilai tunggal di semua tempat |

## Token turunan (tidak ada di panel Theme pen.dev)

Token berikut ditambahkan di level kode untuk kebutuhan UI yang lebih rinci
daripada 16 variable dasar (gradien, permukaan, status, bayangan). Ini
**elaborasi yang disengaja**, bukan kesalahan — tapi karena tidak tercatat
sebagai variable bernama di sumber desain, penambahan token serupa untuk
layar baru SHOULD dicek dulu apakah token yang ada bisa dipakai ulang
sebelum membuat yang baru (lihat catatan konsistensi style di bawah):

- Gradien hero (`primaryDeep` `#0A6B4C`, `primaryLight` `#35C97E`) — titik
  gradien 3-stop, diturunkan dari `primary`/`primary-deep` untuk kartu
  hero/CTA penuh layar.
- Permukaan: `surface`, `line`, `track`, `softGreen`, `iconField`,
  `iconFieldAmber`, `selectionIdle`, `affordance`, `glassStrong`,
  `glassSelected`.
- Status/note: `danger`, `noteWarning`, `noteSuccess`, `noteInfo`,
  `historyActionTint`.
- Keluarga bayangan (9 warna berbeda — `shadowGlass`, `shadowHero`,
  `shadowButton`, `shadowButtonCore`, `shadowFab`, `shadowNavigation`,
  `shadowSheet`, `shadowSheetOption`, `shadowWelcomeButton`): masing-masing
  resep per komponen, bukan skala elevasi bersama. Sebelum menambah token
  bayangan baru untuk layar berikutnya, cek dulu apakah salah satu dari 9
  ini sudah cocok.

## Catatan konsistensi style

`mealora_components.dart` menyediakan komponen reusable (`MealoraCard`,
`MealoraNoteCard`, `MealoraPrimaryButton`, `MealoraEmptyState`, dll.) yang
sudah memakai token di atas. Layar baru SHOULD memakai komponen ini
daripada menulis `BoxDecoration` sendiri — penulisan `BoxDecoration` ad hoc
per layar adalah sumber drift style yang teramati di commit sebelumnya
(token bayangan/spacing baru per layar alih-alih dipakai ulang).
