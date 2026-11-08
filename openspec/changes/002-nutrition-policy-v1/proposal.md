# 002 · Kebijakan gizi tervalidasi v1

## Why

Assessment v1.1 melarang Mealora menebak aturan gizi: `ProgramEngine` harus gagal tertutup bila aturannya tidak ada (§39, §40), dan desain sudah menyiapkan layar untuk keadaan itu (`26 · Target tidak dibuat`). Artinya seluruh program Turun Berat, Naik Berat, Pertahankan, dan Makan Sehat tidak bisa diaktifkan sampai ada satu kebijakan berversi yang menetapkan angkanya — change ini adalah kebijakan tersebut.

Dikerjakan sekarang, sebelum `ProgramEngine` ditulis, karena kebijakan inilah yang menentukan bentuk masukan, hasil, dan kode alasan penolakan mesin itu. Menuliskannya belakangan berarti menulis mesin terhadap antarmuka kosong, lalu merombaknya begitu angka sebenarnya datang.

Change ini **tidak** menulis kode. Yang dihasilkan adalah kebijakan numerik berversi beserta rujukannya, vektor uji emas, dan jalur persetujuan — bahan yang dipakai change berikutnya.

## What Changes

- **Kebijakan berversi `np-1.0.0`** dan versi kalkulator `msj-1.0.0`, keduanya tercatat pada setiap target yang pernah disetujui pengguna sehingga riwayat tetap dapat dijelaskan.
- **Persamaan energi**: Mifflin–St Jeor untuk energi istirahat, dengan tiga tingkat aktivitas yang dipetakan ke pengali tetap — sesuai tiga pilihan pada layar `09 · Aktivitas harian`, bukan lima tingkat yang memberi kesan presisi palsu.
- **Aturan kelayakan**: siapa yang boleh menerima target otomatis, siapa yang dirujuk ke tenaga kesehatan, dan siapa yang sama sekali tidak menerima defisit/surplus otomatis (usia di luar rentang, kehamilan dan menyusui, berat badan kurang, indikasi gangguan makan, kondisi medis dan obat tertentu, perubahan berat yang cepat).
- **Batas energi**: besaran defisit dan surplus, batas bawah asupan harian, serta laju perubahan berat maksimum dan minimum per program.
- **Target makro**: protein berbasis berat badan, lemak dan karbohidrat dalam rentang distribusi yang berlaku, serta serat berbasis energi — lengkap dengan urutan penyesuaian ketika hasilnya keluar dari rentang.
- **Aturan tanggal tujuan**: tanggal yang diminta pengguna tidak pernah mengesampingkan batas keselamatan; konflik dijelaskan dan meminta masukan yang lebih aman, bukan dipotong diam-diam.
- **Pembulatan, toleransi, dan jadwal hitung ulang**, termasuk keharusan pengguna menyetujui revisi target sebelum berlaku.
- **Kode alasan** untuk setiap keadaan tidak-disetujui, dipetakan ke kalimat yang dilihat pengguna.
- **Vektor uji emas**: kasus uji berisi masukan dan hasil yang diharapkan untuk setiap aturan dan setiap batas, dipakai sebagai uji regresi di aplikasi.
- **Tinjauan teknis**: seluruh nilai ditinjau terhadap pedoman publik dan terhadap kesesuaiannya untuk populasi Indonesia, dengan hasil tercatat per baris. Tidak ada gerbang persetujuan berlisensi untuk MVP 1 — lihat `design.md` D13.

**BREAKING** — tidak ada, belum ada kebijakan sebelumnya. Perubahan angka di kemudian hari wajib menjadi change tersendiri dengan versi baru, dan tidak boleh mengubah target yang sudah disetujui pengguna di masa lalu.

## Capabilities

### New Capabilities

- `nutrition-policy`: aturan gizi normatif yang menentukan apakah sebuah profil berhak menerima target energi dan gizi otomatis, berapa nilainya, dan mengapa sebuah permintaan ditolak atau dibatasi — berikut versi dan rujukan ilmiahnya.

### Modified Capabilities

Tidak ada. `app-shell` dan `local-data-foundation` dari change 001 tidak tersentuh.

## Impact

- **Repo `mealora-plans`**: dokumen rujukan kebijakan, tabel vektor uji emas, dan hasil tinjauan teknis di `docs/`.
- **Repo `mealora-apps/mealora-mobile`**: berkas data kebijakan berversi dan fixture uji emas; belum ada mesin yang membacanya pada change ini.
- **Memblokir** change berikutnya: `ProgramEngine` (domain program), pratinjau dan aktivasi target pada onboarding, serta seluruh layar yang menampilkan angka target.
- **Keputusan terbuka yang ditutup** oleh change ini (assessment §33): pengali aktivitas, kebijakan defisit/surplus, batas usia minimum, dan penanganan kehamilan/menyusui.
- **Risiko utama**: angka di sini adalah rancangan berbasis pedoman publik, bukan nasihat klinis untuk individu, dan belum ditinjau ahli gizi berlisensi. Cukup untuk MVP perorangan; sebelum rilis publik ke pengguna umum, §40 mensyaratkan peninjauan berlisensi.
