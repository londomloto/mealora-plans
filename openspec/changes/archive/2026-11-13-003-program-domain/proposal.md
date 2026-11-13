# 003 · Domain program

## Why

Kebijakan gizi (change 002) menetapkan *angka apa* yang boleh diberikan kepada siapa, tetapi belum ada yang menentukan *bagaimana sebuah program hidup*: empat program apa yang ditawarkan, masukan apa yang diminta masing-masing, bagaimana sebuah proposal target berubah menjadi program aktif, dan apa yang terjadi ketika pengguna menjeda, mengganti, atau menyelesaikannya.

Assessment v1.1 menuntut pemisahan tegas: `NutritionCalculator` hanya memperkirakan fisiologi secara netral, sementara `ProgramEngine` memegang kebijakan, kelayakan, dan siklus hidup (§39). Keduanya harus bisa diuji sebagai Dart murni tanpa Flutter, Drift, atau jaringan (§46.3). Menuliskannya sekarang — sebelum tabel, DAO, dan layar — membuat aturan paling berbahaya di produk ini (target energi dan penolakan) dapat diuji habis-habisan tanpa tersangkut di infrastruktur.

Change ini **tidak** menyentuh basis data maupun UI. Yang dihasilkan adalah aturan katalog program dan siklus hidup yang dapat dijalankan dan diuji.

## What Changes

- **Katalog empat program** sebagai data acuan yang stabil: `weight_loss`, `weight_gain`, `maintenance`, dan `healthy_eating`, masing-masing dengan nama tampilan Indonesia (Turun Berat, Naik Berat, Pertahankan, Makan Sehat), maksud, apakah target berat diperlukan, dan masukan onboarding yang diminta.
- **Pemisahan tanggung jawab**: `NutritionCalculator` mengembalikan perkiraan energi netral beserta asumsi, peringatan, dan versi kalkulator; `ProgramEngine` mengambil perkiraan itu plus fakta profil, menerapkan kebijakan `np-1.0.0`, lalu mengembalikan proposal target atau keadaan tidak-disetujui bertipe.
- **Lima keadaan hasil** yang wajib dibedakan: `approved`, `needs_user_correction`, `needs_professional_review`, `unsupported_profile`, dan `missing_validated_policy`.
- **Mesin keadaan siklus hidup** program: `draft → active ↔ paused → completed`, `active/paused → changed`, dan `draft/active/paused → cancelled`, dengan keadaan akhir yang tidak dapat dilanjutkan.
- **Invarian satu program berjalan**: satu profil hanya boleh memiliki satu program `active` atau `paused` pada satu waktu, berapa kali pun perintah diulang.
- **Pergantian program yang utuh**: mengaktifkan program baru menandai program lama `changed`, menautkan keduanya, dan mencatat peristiwanya — seluruhnya berhasil atau tidak sama sekali.
- **Semantik jeda**: hari dalam keadaan jeda tidak dihitung sebagai hari aktif, sementara pencatatan makanan dan berat tetap berjalan.
- **Peristiwa siklus hidup** sebagai jejak yang dapat dijelaskan: setiap perpindahan keadaan mencatat keadaan asal, keadaan tujuan, waktu, dan kode alasan.
- **Perintah yang idempoten dan kesalahan bertipe**: mengulang perintah yang sama tidak menghasilkan keadaan ganda; perpindahan yang tidak sah mengembalikan kesalahan bertipe, bukan pengecualian umum.
- **Nilai terbungkus tipe** untuk energi, massa, dan tanggal lokal, sehingga satuan tidak dapat tertukar diam-diam.

Tidak ada perubahan BREAKING — belum ada kapabilitas program sebelumnya.

## Capabilities

### New Capabilities

- `program-catalog`: empat program yang ditawarkan Mealora, maksud masing-masing, masukan yang diminta sebelum sebuah program dapat diusulkan, dan aturan ketersediaannya.
- `program-lifecycle`: keadaan sebuah program dalam perjalanan pengguna, perpindahan yang sah di antaranya, invarian satu program berjalan, serta perilaku jeda, ganti, selesai, dan batal.

### Modified Capabilities

Tidak ada. `nutrition-policy` dari change 002 dipakai apa adanya; `app-shell` dan `local-data-foundation` dari change 001 tidak tersentuh.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: lapisan `domain/nutrition/` dan `domain/program/` berisi Dart murni — entitas, value object, mesin keadaan, antarmuka kalkulator dan mesin program, hasil bertipe — beserta ujinya. Tidak ada impor Flutter, Drift, jaringan, jam global, atau pembangkit ID langsung.
- **Bergantung pada** change 002: kebijakan `np-1.0.0` beserta vektor uji emasnya dipakai sebagai sumber nilai dan sebagai uji regresi. Mesin tetap gagal tertutup (mengembalikan `missing_validated_policy`) bila suatu saat menerima kebijakan berstatus draf — perilaku ini diuji eksplisit di sini sebagai jaring pengaman rekayasa, terlepas dari status `np-1.0.0` saat ini (final untuk MVP 1, `design.md` change 002 D13).
- **Bergantung pada** change 001 untuk kerangka proyek, sumber waktu, dan pembangkit pengenal yang di-inject.
- **Memblokir** change berikutnya: persistensi program (tabel, DAO, transaksi aktivasi), onboarding dan aktivasi di layar, serta progres dan riwayat program.
- **Belum tersentuh**: penyimpanan program, antarmuka pengguna, perhitungan progres harian dari buku harian, dan katalog makanan.
