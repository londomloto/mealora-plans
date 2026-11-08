## Purpose

Empat program yang ditawarkan Mealora kepada pengguna: maksud masing-masing, masukan yang diminta sebelum sebuah target dapat diusulkan, apakah target berat diperlukan, dan bagaimana sebuah program ditarik dari penawaran tanpa merusak riwayat pengguna yang pernah memakainya.

## ADDED Requirements

### Requirement: Katalog berisi tepat empat program

Sistem SHALL menawarkan tepat empat program dengan kode tetap dan nama tampilan berbahasa Indonesia berikut:

| Kode | Nama tampilan | Maksud | Target berat |
|---|---|---|---|
| `weight_loss` | Turun Berat | Menurunkan berat badan dengan target terkawal | Diperlukan |
| `weight_gain` | Naik Berat | Menambah berat badan dengan target terkawal | Diperlukan |
| `maintenance` | Pertahankan | Menjaga keseimbangan berat dan energi | Tidak diperlukan |
| `healthy_eating` | Makan Sehat | Memperbaiki kualitas dan konsistensi makan | Tidak diperlukan |

Kode program SHALL stabil dan SHALL TIDAK berubah setelah dirilis. Sistem SHALL TIDAK menambah, mengganti, atau menghapus program tanpa change tersendiri.

#### Scenario: Pengguna melihat pilihan program

- **WHEN** pengguna membuka pemilihan program
- **THEN** sistem menampilkan tepat empat program dengan nama Turun Berat, Naik Berat, Pertahankan, dan Makan Sehat, masing-masing disertai maksudnya

### Requirement: Masukan yang diminta per program

Sistem SHALL menyatakan masukan yang diperlukan sebelum sebuah proposal target dapat dihitung, dan masukan itu SHALL berbeda menurut program:

- Seluruh program memerlukan: usia atau tanggal lahir, masukan biologis yang dipakai persamaan energi, tinggi badan, berat badan saat ini, tingkat aktivitas, serta jawaban atas pertanyaan skrining kelayakan yang berlaku.
- `weight_loss` dan `weight_gain` memerlukan tambahan: berat tujuan. Tanggal tujuan bersifat opsional.
- `maintenance` memerlukan berat badan saat ini; rentang pemeliharaan yang disukai bersifat opsional.
- `healthy_eating` memerlukan fokus kebiasaan yang dipilih pengguna; berat tujuan SHALL TIDAK diminta.

Bila masukan wajib belum lengkap, sistem SHALL mengembalikan `needs_user_correction` dengan alasan `missing_required_input` dan SHALL menyebut masukan mana yang kurang.

#### Scenario: Makan Sehat tidak meminta berat tujuan

- **WHEN** pengguna memilih Makan Sehat
- **THEN** sistem tidak meminta berat tujuan dan program dapat diusulkan tanpa nilai tersebut

#### Scenario: Turun Berat tanpa berat tujuan

- **WHEN** pengguna memilih Turun Berat tanpa mengisi berat tujuan
- **THEN** sistem mengembalikan `needs_user_correction` dengan alasan `missing_required_input` dan menyebut bahwa berat tujuan belum diisi

#### Scenario: Tanggal tujuan tetap opsional

- **WHEN** pengguna mengisi berat tujuan tanpa tanggal tujuan pada program Turun Berat
- **THEN** sistem tetap menghitung proposal target

### Requirement: Kemajuan Makan Sehat tidak memakai ukuran berat

Untuk `healthy_eating`, sistem SHALL mengukur kemajuan dari kelengkapan pencatatan dan kesesuaian terhadap rentang gizi yang berlaku. Sistem SHALL TIDAK menampilkan persentase kemajuan berat badan, dan SHALL TIDAK mengarang nilai kemajuan ketika tidak ada target berat.

#### Scenario: Tidak ada persentase berat yang dikarang

- **WHEN** program Makan Sehat aktif dan pengguna membuka ringkasan program
- **THEN** kemajuan ditampilkan sebagai kelengkapan pencatatan, dan tidak ada persentase kemajuan berat di layar mana pun

### Requirement: Program ditarik tanpa merusak riwayat

Ketika sebuah program tidak lagi ditawarkan, sistem SHALL menandainya tidak tersedia dan SHALL TIDAK menghapus definisinya. Program yang tidak tersedia SHALL TIDAK muncul pada pemilihan program baru, dan SHALL tetap dapat ditampilkan pada riwayat pengguna yang pernah memakainya, lengkap dengan nama dan maksud aslinya.

#### Scenario: Riwayat program yang sudah ditarik

- **WHEN** sebuah program ditandai tidak tersedia sementara seorang pengguna pernah menjalaninya
- **THEN** program itu hilang dari daftar pilihan, sedangkan entri riwayat pengguna tetap menampilkan nama dan maksud program tersebut

### Requirement: Definisi program terpisah dari program pengguna

Sistem SHALL membedakan definisi program di katalog dari pendaftaran seorang pengguna pada program tersebut. Perubahan pada definisi katalog SHALL TIDAK mengubah nilai target, asumsi, atau versi yang tersimpan pada program pengguna yang sudah berjalan maupun yang sudah selesai.

#### Scenario: Definisi katalog berubah

- **WHEN** deskripsi sebuah program di katalog diperbarui
- **THEN** target, asumsi, dan versi pada program pengguna yang sedang berjalan maupun yang ada di riwayat tetap seperti saat disetujui
