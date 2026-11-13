# target-adjustment-suggestions Specification

## Purpose
Membantu pengguna program turun/naik berat menemukan kombinasi berat tujuan dan tanggal tujuan yang memenuhi kebijakan gizi tanpa harus menebak berulang kali, dengan saran yang dihitung dari batas kebijakan dan hanya diterapkan atas pilihan pengguna.

## Requirements

### Requirement: Saran berat minimum saat BMI tujuan terlalu rendah

Ketika proposal ditolak karena berat tujuan menghasilkan BMI di bawah batas minimum kebijakan, sistem SHALL menyarankan berat tujuan minimum yang aman, yaitu batas BMI minimum dikali kuadrat tinggi badan dan dibulatkan ke atas ke 0,1 kg.

#### Scenario: Berat tujuan di bawah BMI 18,5

- **WHEN** pengguna setinggi 165 cm memilih program turun berat dengan berat tujuan 48 kg
- **THEN** sistem menolak dengan alasan target berat di luar rentang dan menawarkan pilihan berat tujuan 50,4 kg

#### Scenario: Berat tujuan tidak searah dengan program

- **WHEN** pengguna program turun berat mengisi berat tujuan yang sama atau lebih besar dari berat saat ini
- **THEN** sistem menolak dengan penjelasan dan tidak menawarkan angka saran

### Requirement: Saran saat laju terlalu cepat

Ketika kombinasi berat tujuan dan tanggal tujuan menuntut laju di atas batas kebijakan, sistem SHALL menawarkan dua pilihan: (a) mempertahankan berat tujuan dengan tanggal paling awal yang memenuhi batas laju, dan (b) mempertahankan tanggal tujuan dengan berat tujuan terdekat yang bisa dicapai pada batas laju. Pilihan (b) SHALL dibulatkan ke 0,1 kg ke arah yang lebih aman (lebih dekat ke berat saat ini) dan SHALL dihilangkan bila hasilnya tidak lolos batas BMI tujuan atau tidak berbeda dari berat saat ini.

#### Scenario: Turun 10 kg dalam 12 minggu

- **WHEN** pengguna 165 cm / 70 kg memilih turun ke 60 kg dengan tanggal tujuan 12 minggu dari hari ini (batas laju 0,525 kg/minggu)
- **THEN** sistem menawarkan "60 kg pada tanggal paling awal ±19 minggu dari hari ini" dan "63,7 kg pada tanggal yang dipilih"

#### Scenario: Program naik berat terlalu cepat

- **WHEN** pengguna program naik berat menuntut laju di atas 0,5 kg/minggu
- **THEN** sistem menawarkan tanggal paling awal untuk berat tujuan tersebut dan berat tujuan tertinggi yang bisa dicapai pada tanggal yang dipilih

### Requirement: Saran saat laju terlalu lambat

Ketika kombinasi berat tujuan dan tanggal tujuan menghasilkan laju di bawah laju minimum kebijakan, sistem SHALL menawarkan (a) mempertahankan berat tujuan dengan tanggal paling lambat yang masih memenuhi laju minimum, dan (b) mempertahankan tanggal dengan berat tujuan yang memenuhi laju minimum. Pilihan (b) SHALL dihilangkan bila hasilnya tidak lolos batas BMI tujuan.

#### Scenario: Turun 2 kg dalam satu tahun

- **WHEN** pengguna memilih turun 2 kg dengan tanggal tujuan 52 minggu lagi
- **THEN** sistem menawarkan tanggal paling lambat 8 minggu dari hari ini untuk berat tujuan tersebut, dan berat tujuan yang memenuhi laju 0,25 kg/minggu pada tanggal yang dipilih bila berat itu lolos batas BMI

### Requirement: Saran hanya diterapkan atas pilihan pengguna

Sistem SHALL TIDAK mengubah berat atau tanggal tujuan tanpa tindakan eksplisit pengguna. Ketika pengguna memilih sebuah saran, sistem SHALL mengisi masukan dengan nilai saran tersebut, SHALL menjalankan ulang seluruh evaluasi kebijakan, dan SHALL menampilkan hasil evaluasi ulang itu (disetujui atau penolakan lain) seperti biasa. Pengguna SHALL tetap dapat memilih untuk mengubah masukan secara manual.

#### Scenario: Pengguna memilih saran tanggal

- **WHEN** pengguna mengetuk saran "pertahankan berat, tanggal paling awal"
- **THEN** tanggal tujuan berubah ke tanggal saran, evaluasi dijalankan ulang, dan pengguna melihat pratinjau target bila disetujui

#### Scenario: Saran lolos laju tetapi ditolak alasan lain

- **WHEN** evaluasi ulang setelah memilih saran ditolak karena energi di bawah minimum
- **THEN** sistem menampilkan penolakan energi seperti biasa tanpa saran berat atau tanggal

### Requirement: Penolakan di luar target dan laju tidak diberi saran angka

Untuk penolakan karena energi di bawah minimum, usia, BMI saat ini, kehamilan/menyusui, kondisi medis, atau perubahan berat tak disengaja, sistem SHALL TIDAK menampilkan saran berat atau tanggal tujuan dan SHALL mempertahankan perilaku penolakan yang ada.

#### Scenario: Energi di bawah minimum

- **WHEN** proposal ditolak karena sisa defisit energi di bawah minimum kebijakan
- **THEN** layar penolakan tidak menampilkan pilihan berat atau tanggal saran

### Requirement: Rentang aman terlihat sebelum pengajuan

Pada layar input berat tujuan dan tanggal tujuan, sistem SHALL menampilkan berat tujuan minimum yang aman. Setelah berat tujuan yang valid diisi, sistem SHALL menampilkan tanggal paling awal (dan paling lambat) yang memenuhi batas laju dan SHALL membatasi pemilih tanggal ke rentang tersebut. Pada alur ganti program yang hanya meminta berat tujuan, sistem SHALL menampilkan berat tujuan minimum yang aman.

#### Scenario: Petunjuk tanggal setelah mengisi berat

- **WHEN** pengguna 165 cm / 70 kg mengisi berat tujuan 60 kg
- **THEN** layar menampilkan tanggal paling awal yang aman dan pemilih tanggal tidak mengizinkan tanggal sebelum itu

#### Scenario: Berat tujuan belum diisi

- **WHEN** berat tujuan masih kosong atau tidak valid
- **THEN** layar hanya menampilkan berat minimum yang aman dan pemilih tanggal memakai rentang bawaan
