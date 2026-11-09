# Pemetaan kode alasan ke kalimat (task 1.3 / 1.4)

Melanjutkan hasil change 002 (task 3.2–3.3), yang menulis pemetaan ini untuk
pertama kali tetapi tidak meninggalkan artefak tersendiri di repo manapun.
Dokumen ini adalah artefak itu, diperluas untuk kerangka layar `26 · Target
tidak dibuat` dan keadaan "masukan berubah sejak pratinjau" (Design D5).

Setiap kode dari `ReasonCode` (`lib/domain/shared/reason_code.dart`) dipetakan
ke: judul layar, isi penjelasan, dan tawaran langkah berikutnya. Kalimat
ditanam di lapisan tampilan oleh task 6.2 — domain hanya mengirim kode dan
`details` berupa angka/tanggal, tidak pernah kalimat siap tampil (lihat
`program_outcome.dart`).

## Tiga larangan (I2) — diperiksa untuk setiap baris di bawah

1. **Tidak mendiagnosis** — tidak ada kalimat yang menyebut kondisi medis,
   menyebut penyebab, atau menafsirkan keadaan tubuh pengguna.
2. **Tidak menjanjikan hasil** — tidak ada kalimat yang menyebut target,
   tanggal selesai, atau jaminan angka tertentu akan tercapai.
3. **Tidak menyalahkan pengguna** — tidak ada kalimat yang menyiratkan
   pengguna salah mengisi atau salah dalam keadaannya.

Isi wajib tiap baris (I3): menyebut alasan dalam bahasa awam, menyatakan
**tidak ada target yang dibuat**, dan menawarkan langkah berikutnya.

## Pemetaan

Setiap baris memakai kerangka layar `26` (judul + penjelasan + tawaran) kecuali
disebutkan lain. Kalimat "Tidak ada target yang dibuat, dan data serta
program sebelumnya tidak berubah." SHALL selalu tampil di setiap kode —
ditulis sekali di kerangka, bukan diulang di tiap baris di bawah.

| Kode | Judul layar | Penjelasan | Langkah berikutnya |
|---|---|---|---|
| `ageBelowMinimum` | Belum bisa membuat target otomatis | Mealora membuat target otomatis untuk rentang usia dewasa. Usia yang kamu isi berada di luar rentang itu. | Tawarkan program Makan Sehat (tidak memakai target perubahan berat), dan catatan bahwa pendampingan orang dewasa dibutuhkan untuk usia ini. |
| `ageAboveSupported` | Belum bisa membuat target otomatis | Mealora membuat target otomatis untuk rentang usia yang didukung kalkulatornya saat ini. Usia yang kamu isi berada di luar rentang itu. | Tawarkan program Makan Sehat, dan sebut bahwa dukungan untuk rentang usia ini bisa bertambah di versi mendatang. |
| `pregnancyOrLactation` | Belum bisa membuat target otomatis | Perkiraan kebutuhan energi berbeda pada masa kehamilan atau menyusui, dan kalkulator ini belum mendukungnya. | Tawarkan program Makan Sehat, dan sarankan berdiskusi dengan tenaga kesehatan untuk kebutuhan energi pada masa ini. |
| `underweightBmi` | Belum bisa membuat target otomatis | Kombinasi tinggi dan berat yang kamu isi berada di luar rentang yang bisa dihitung kalkulator ini secara otomatis. | Tawarkan program Makan Sehat, dan sarankan pendampingan tenaga kesehatan bila ingin mengubah berat badan. |
| `bmiAboveSupported` | Belum bisa membuat target otomatis | Kombinasi tinggi dan berat yang kamu isi berada di luar rentang yang bisa dihitung kalkulator ini secara otomatis. | Tawarkan program Makan Sehat, dan sarankan pendampingan tenaga kesehatan bila ingin mengubah berat badan. |
| `declaredMedicalCondition` | Belum bisa membuat target otomatis | Kamu menandai satu atau lebih kondisi yang membuat target perubahan berat perlu disesuaikan oleh tenaga kesehatan, bukan dihitung otomatis. | Tawarkan program Makan Sehat, dan sarankan berdiskusi dengan tenaga kesehatan sebelum menetapkan target perubahan berat. |
| `rapidUnintendedWeightChange` | Belum bisa membuat target otomatis | Kamu melaporkan perubahan berat yang cukup besar dalam waktu singkat belakangan ini. Kalkulator ini perlu masukan tambahan dari tenaga kesehatan sebelum menghitung target baru. | Tawarkan program Makan Sehat, dan sarankan berdiskusi dengan tenaga kesehatan tentang perubahan berat yang sudah terjadi. |
| `targetBelowMinimumEnergy` | Belum bisa membuat target otomatis | Permintaanmu membuat perkiraan asupan energi harian turun lebih rendah dari batas aman yang dipakai kalkulator ini. | Tawarkan mengubah berat tujuan atau tanggal tujuan menjadi lebih ringan, atau memilih program Makan Sehat. Tidak menyebut angka target yang ditolak. |
| `requestedPaceTooFast` | Tanggal ini butuh laju yang terlalu cepat | Perubahan berat yang kamu minta dalam rentang waktu ini lebih cepat dari batas aman yang dipakai kalkulator ini. Tanggal paling awal yang memenuhi batas: **{earliestSafeDate}**. | Minta pengguna mengubah tanggal tujuan atau berat tujuan. Tidak pernah menyesuaikan target secara diam-diam agar cocok dengan tanggal yang diminta (I5/5.3.6). |
| `requestedPaceTooSlow` | Laju ini lebih lambat dari yang didukung | Perubahan berat yang kamu minta dalam rentang waktu ini lebih lambat dari laju minimum yang dipakai kalkulator ini. | Minta pengguna mempercepat tanggal tujuan, memperbesar selisih berat, atau mengosongkan tanggal tujuan (opsional). |
| `targetWeightOutOfRange` | Berat tujuan ini di luar jangkauan kalkulator | Berat tujuan yang kamu isi berada di luar rentang yang bisa dihitung kalkulator ini secara otomatis dari berat saat ini. | Minta pengguna memeriksa kembali berat tujuan, atau memilih program Makan Sehat. |
| `missingRequiredInput` | Masih ada isian yang perlu dilengkapi | Satu atau lebih isian wajib pada langkah ini belum terisi: **{missingFields}**. | Tahan langkah saat ini dan arahkan ke isian yang kosong; tidak ada tawaran "langkah lain" karena ini bukan penolakan kebijakan, hanya isian belum lengkap. |

### Kebijakan tidak tersedia (`MissingValidatedPolicy`, bukan `ReasonCode`)

Bukan anggota `ReasonCode` (I1, change 002 U8) — domain mengembalikan varian
`MissingValidatedPolicy` terpisah, dipetakan di lapisan tampilan ke kerangka
layar `26` yang sama. Kebijakan `np-1.0.0` sudah final untuk Mealora MVP 1
(change 002, D13); varian ini SHALL TIDAK muncul pada wiring yang benar
(task 5.3 mengonstruksi `NutritionPolicy` dengan status `approved`) — baris
di bawah hanya jaring pengaman rekayasa, bukan keadaan yang pernah dialami
pengguna sungguhan:

| Judul layar | Penjelasan | Langkah berikutnya |
|---|---|---|
| Target otomatis tidak tersedia | Mealora tidak bisa menghitung target otomatis saat ini. | Tawarkan program Makan Sehat (tidak memakai target perubahan berat). Tidak menyebut "menunggu peninjauan" — tidak ada peninjauan yang sedang berlangsung; ini jaring pengaman teknis. |

## Placeholder yang dipakai di atas

- `{earliestSafeDate}` — `PaceEvaluationResult.earliestSafeDate` /
  `NeedsUserCorrection.details['earliestSafeDate']`, diformat `d MMMM yyyy`
  lewat `IdFormatters` (konvensi change 001).
- `{missingFields}` — `NeedsUserCorrection.missingFields`, dipetakan ke label
  isian dalam bahasa Indonesia (mis. `weightKg` → "berat badan").

## Catatan implementasi untuk task 6.2

- Kalimat di atas ditanam sebagai fungsi murni di lapisan tampilan
  (`lib/features/onboarding/` atau sejenis), menerima `ReasonCode` (atau
  penanda `MissingValidatedPolicy`) beserta `details`, dan mengembalikan judul
  + penjelasan + daftar langkah berikutnya untuk kerangka layar `26`.
- `missingRequiredInput` tidak pernah tampil di kerangka `26` dalam alur
  onboarding — langkah yang bersangkutan menahan navigasi dan menampilkan
  kesalahan inline per isian (task 4.4), bukan penolakan kebijakan penuh
  layar. Baris di atas tetap didokumentasikan karena kode ini anggota
  `ReasonCode` yang sama dan bisa muncul dari jalur lain (mis. peninjauan
  ulang setelah perubahan profil).
