# Functional Requirements Specification

## Mealora — Saran Target Berat & Tanggal yang Aman

| | |
|---|---|
| Change | 019-target-weight-rejection-suggestions |
| Versi | v0.1-draft |
| Tanggal | 2026-11-12 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Saran berat tujuan minimum yang aman bila berat tujuan terlalu rendah.
- Saran tanggal atau berat tujuan bila laju turun/naik berat terlalu cepat atau terlalu lambat.
- Pilihan saran yang bisa langsung diketuk, lalu dievaluasi ulang.
- Petunjuk rentang aman di layar pengisian berat dan tanggal tujuan, termasuk saat mengganti program.

### 1.2 Deferred Items (Not in This FRS Version)

- Saran untuk penolakan karena kebutuhan energi harian terlalu rendah. Penolakan ini tidak bisa diselesaikan dengan mengubah berat atau tanggal.
- Saran untuk penolakan kelayakan lain (usia, BMI saat ini, kehamilan/menyusui, kondisi medis, perubahan berat tak disengaja).
- Perubahan batas kebijakan gizi.
- Penambahan isian tanggal tujuan pada alur ganti program.

## 2. Saran Target yang Aman

### 2.1 User Story

As a pengguna yang ingin menurunkan atau menaikkan berat badan,
I want aplikasi langsung menunjukkan berat dan tanggal tujuan yang aman ketika pilihan saya ditolak,
So that saya tidak perlu menebak-nebak berulang kali sampai disetujui.

### 2.2 Functional Scope

- Bila berat tujuan terlalu rendah dibanding tinggi badan, layar penolakan menampilkan berat tujuan terendah yang diizinkan sebagai pilihan.
- Bila berat tujuan tidak searah dengan program (mis. program turun berat tetapi berat tujuan lebih besar), layar hanya menjelaskan tanpa angka saran.
- Bila target terlalu cepat dicapai, layar menawarkan dua pilihan: tetap pada berat tujuan dengan tanggal paling awal yang aman, atau tetap pada tanggal dengan berat yang realistis dicapai.
- Bila target terlalu lambat, layar menawarkan: tetap pada berat tujuan dengan tanggal paling lambat yang masih wajar, atau tetap pada tanggal dengan berat yang sesuai laju minimum.
- Pilihan yang tidak aman (mis. berat terlalu rendah) tidak ditampilkan.
- Saran tidak pernah diterapkan otomatis. Setelah pengguna memilih, aplikasi memeriksa ulang seluruh aturan dan menampilkan hasilnya.
- Pengguna tetap bisa mengubah isian secara manual.
- Di layar pengisian, aplikasi menampilkan berat tujuan minimum. Setelah berat diisi, aplikasi menampilkan rentang tanggal yang aman dan pemilih tanggal hanya mengizinkan rentang tersebut.

### 2.3 Acceptance Criteria

2.1.1. The system shall menawarkan berat tujuan minimum yang aman ketika berat tujuan terlalu rendah untuk tinggi badan pengguna.

2.1.2. The system shall tidak menampilkan angka saran ketika berat tujuan tidak searah dengan program yang dipilih.

2.1.3. The system shall menawarkan tanggal paling awal yang aman dan berat yang dapat dicapai pada tanggal terpilih ketika laju terlalu cepat.

2.1.4. The system shall menawarkan tanggal paling lambat yang wajar dan berat yang sesuai laju minimum ketika laju terlalu lambat, dan menyembunyikan pilihan berat bila berat itu di bawah batas aman.

2.1.5. The system shall tidak mengubah berat atau tanggal tujuan tanpa pilihan eksplisit pengguna.

2.1.6. The system shall memeriksa ulang seluruh aturan setelah pengguna memilih saran dan menampilkan hasil pemeriksaan tersebut.

2.1.7. The system shall tidak menampilkan saran berat atau tanggal untuk penolakan karena energi harian terlalu rendah atau alasan kelayakan lain.

2.1.8. The system shall menampilkan berat tujuan minimum yang aman di layar pengisian berat tujuan dan di alur ganti program.

2.1.9. The system shall membatasi pemilih tanggal tujuan ke rentang aman setelah berat tujuan yang valid diisi.

## 3. High Level Test Scenarios

1. Tinggi 165 cm, berat 70 kg, program turun berat, tujuan 60 kg dalam 12 minggu → ditolak; muncul pilihan "60 kg pada tanggal ±19 minggu lagi" dan "63,7 kg pada tanggal terpilih"; memilih salah satu → pratinjau target muncul.
2. Profil sama, tujuan 48 kg → ditolak; muncul pilihan 50,4 kg.
3. Profil sama, tujuan 68 kg dalam 52 minggu → ditolak karena terlalu lambat; muncul pilihan tanggal ±8 minggu lagi.
4. Profil sama, isi tujuan 60 kg di layar pengisian → tampil tanggal paling awal; tanggal sebelum itu tidak bisa dipilih.
5. Profil dengan kebutuhan energi rendah → penolakan energi tampil tanpa pilihan saran.
