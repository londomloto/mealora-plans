# energy-trend Specification

## Purpose
Menampilkan arah konsumsi energi (kkal) harian pengguna terhadap target program, untuk minggu berjalan maupun rentang tanggal pilihan pengguna, tanpa mengarang data untuk hari yang belum dicatat dan tanpa menilai pengguna.

## Requirements

### Requirement: Kartu energi minggu berjalan di ruang Program

Ruang Program SHALL menampilkan kartu "Energi minggu ini" yang memuat energi harian setiap tanggal minggu berjalan, dimulai dari hari awal minggu sesuai preferensi pengguna, beserta target energi program dan rata-rata energi dari hari yang tercatat.

Tanggal setelah hari ini SHALL ditampilkan tanpa titik data dan tanpa keterangan belum dicatat.

Mengetuk kartu SHALL membuka layar pantauan energi.

#### Scenario: Pertengahan minggu

- **WHEN** hari ini Kamis, awal minggu Senin, dan Senin–Kamis memiliki catatan makan
- **THEN** kartu menampilkan titik energi untuk Senin sampai Kamis, Jumat sampai Minggu tanpa titik, dan rata-rata dihitung dari empat hari tersebut

#### Scenario: Awal minggu mengikuti preferensi

- **WHEN** pengguna mengatur awal minggu ke Minggu
- **THEN** kartu dimulai dari hari Minggu dan berisi tujuh hari sampai Sabtu

#### Scenario: Membuka pantauan energi

- **WHEN** pengguna mengetuk kartu energi
- **THEN** layar pantauan energi terbuka

### Requirement: Hari tanpa catatan bukan nol

Untuk tanggal yang sudah lewat atau hari ini tetapi tidak memiliki catatan makan sama sekali, sistem SHALL menampilkannya sebagai belum dicatat: garis energi SHALL terputus di tanggal itu, tanggal itu SHALL ditandai belum dicatat dengan cara yang tidak bergantung pada warna saja, dan tanggal itu SHALL TIDAK dihitung dalam rata-rata.

Sistem SHALL TIDAK menampilkan 0 kkal, menyambung garis melewati tanggal itu, ataupun menampilkan teguran atas hari tanpa catatan.

#### Scenario: Satu hari kosong di tengah rentang

- **WHEN** Rabu tidak memiliki catatan makan sedangkan Selasa dan Kamis memiliki catatan
- **THEN** garis berhenti di Selasa, mulai lagi di Kamis, Rabu ditandai belum dicatat, dan rata-rata tidak menyertakan Rabu

#### Scenario: Seluruh rentang kosong

- **WHEN** tidak ada satu pun tanggal dalam rentang yang memiliki catatan makan
- **THEN** sistem menyatakan bahwa belum ada catatan energi pada rentang itu beserta tindakan untuk mencatat, tanpa garis dan tanpa rata-rata

### Requirement: Hari tercatat sebagian tampil apa adanya

Untuk tanggal yang memiliki catatan makan, sistem SHALL menampilkan total energi dari catatan yang ada pada tanggal itu dan SHALL mengikutsertakannya dalam rata-rata, tanpa penanda kelengkapan dan tanpa menebak energi waktu makan yang belum dicatat.

#### Scenario: Hanya sarapan tercatat

- **WHEN** suatu tanggal hanya memiliki catatan sarapan 400 kkal
- **THEN** titik tanggal itu bernilai 400 kkal dan ikut dihitung dalam rata-rata

#### Scenario: Catatan dengan energi tidak diketahui

- **WHEN** suatu tanggal hanya memiliki catatan makan yang energinya tidak diketahui
- **THEN** tanggal itu ditampilkan sebagai energi belum diketahui, tidak sebagai 0 kkal, dan tidak dihitung dalam rata-rata

### Requirement: Garis target energi

Sistem SHALL menampilkan target energi harian program yang berlaku pada setiap tanggal sebagai garis pembanding yang berbeda bentuknya dari garis energi. Untuk tanggal tanpa program yang berlaku, sistem SHALL TIDAK menampilkan target pada tanggal itu.

Ringkasan rata-rata SHALL menyebut target yang berlaku; bila target berbeda di dalam rentang, ringkasan SHALL menyatakan bahwa target berubah dalam rentang itu alih-alih memilih salah satu nilai.

#### Scenario: Target tetap dalam rentang

- **WHEN** seluruh rentang berada dalam satu program dengan target 2.100 kkal
- **THEN** garis target datar di 2.100 kkal dan ringkasan menyebut target 2.100 kkal

#### Scenario: Target berubah di tengah rentang

- **WHEN** target program direvisi dari 2.100 menjadi 1.900 kkal di tengah rentang
- **THEN** garis target berpindah nilai pada tanggal revisi berlaku dan ringkasan menyatakan target berubah dalam rentang

### Requirement: Rentang tanggal bebas pada pantauan energi

Layar pantauan energi SHALL menampilkan rentang yang sedang dipakai dan SHALL memungkinkan pengguna memilih tanggal mulai dan tanggal akhir melalui kalender. Saat layar dibuka, rentang SHALL bawaan tujuh hari terakhir sampai dan termasuk hari ini.

Sistem SHALL TIDAK memungkinkan pemilihan tanggal setelah hari ini maupun sebelum tanggal catatan makan pertama pengguna. Sistem SHALL menampilkan jumlah hari dalam rentang terpilih sebelum diterapkan. Rentang satu hari SHALL diterima.

Ringkasan rata-rata, jumlah hari tercatat, dan grafik SHALL mengikuti rentang yang diterapkan.

#### Scenario: Rentang bawaan

- **WHEN** pengguna membuka pantauan energi pada 12 November 2026
- **THEN** rentang yang dipakai adalah 6 November sampai 12 November 2026

#### Scenario: Memilih rentang

- **WHEN** pengguna memilih 1 November sebagai mulai dan 12 November sebagai akhir lalu menerapkannya
- **THEN** layar menampilkan rentang "1 Nov – 12 Nov 2026", grafik berisi dua belas tanggal, dan rata-rata dihitung dari tanggal yang tercatat di antaranya

#### Scenario: Tanggal masa depan

- **WHEN** pengguna mencoba memilih tanggal setelah hari ini
- **THEN** tanggal itu tidak dapat dipilih

#### Scenario: Rentang panjang tetap terbaca

- **WHEN** pengguna memilih rentang yang lebih panjang daripada yang muat di lebar layar
- **THEN** setiap tanggal tetap tampil dengan jarak yang terbaca dan grafik dapat digeser mendatar

### Requirement: Detail hari dan navigasi ke Riwayat

Mengetuk titik atau tanggal pada grafik SHALL menampilkan tanggal dan energi hari itu (atau keterangan belum dicatat), dan SHALL menyediakan tindakan untuk membuka Riwayat pada tanggal tersebut.

Setiap tanggal pada grafik SHALL memiliki label pembaca layar yang menyebut tanggal dan energi apa adanya, atau menyatakan belum dicatat.

#### Scenario: Membuka Riwayat dari grafik

- **WHEN** pengguna mengetuk titik 7 November lalu memilih membuka detailnya
- **THEN** Riwayat terbuka dengan 7 November sebagai tanggal terpilih

#### Scenario: Pembaca layar

- **WHEN** pembaca layar memfokuskan tanggal yang belum dicatat
- **THEN** label yang dibacakan menyebut tanggal itu dan bahwa energinya belum dicatat

### Requirement: Bahasa tidak menilai

Teks pada kartu dan layar pantauan energi SHALL TIDAK memuji, menegur, atau menilai pengguna atas energi di atas atau di bawah target maupun atas hari tanpa catatan.

#### Scenario: Energi melampaui target

- **WHEN** energi suatu tanggal melampaui target
- **THEN** sistem menampilkan nilainya apa adanya tanpa warna peringatan atau kalimat teguran
