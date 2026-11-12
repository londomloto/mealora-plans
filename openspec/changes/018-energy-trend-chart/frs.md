# Functional Requirements Specification

## Mealora - Pantauan Energi Harian

| | |
|---|---|
| Change | 018-energy-trend-chart |
| Versi | v0.1-draft |
| Tanggal | 2026-11-12 |
| Status | Draft |

## 1. Scope and Deferred Items

### 1.1 In Scope for This FRS Version

- Kartu "Energi minggu ini" di halaman Program yang menunjukkan grafik garis energi harian minggu berjalan dibanding target.
- Halaman "Pantauan energi" dengan rentang tanggal yang dipilih sendiri oleh pengguna.
- Pemilih rentang tanggal berbentuk kalender.
- Perlakuan hari yang belum dicatat, hari yang energinya tidak diketahui, dan hari yang baru sebagian dicatat.
- Membuka Riwayat pada tanggal yang diketuk di grafik.

### 1.2 Deferred Items (Not in This FRS Version)

- Grafik protein, karbohidrat, lemak, atau berat di halaman yang sama.
- Pilihan cepat rentang (7 hari, 30 hari, bulan ini); versi ini hanya rentang bebas dengan bawaan 7 hari terakhir.
- Penanda hari yang pencatatannya belum lengkap.
- Mengingat rentang terakhir yang dipilih setelah halaman ditutup.
- Membagikan atau mengekspor grafik.

## 2. Kartu Energi Minggu Ini

### 2.1 User Story

As a pengguna Mealora,
I want melihat energi harian minggu ini dibanding target di halaman Program,
So that saya tahu arah pola makan saya minggu ini tanpa membuka setiap tanggal.

### 2.2 Functional Scope

- Kartu tampil di halaman Program, di bawah kartu "Kebiasaan minggu ini".
- Kartu berisi tujuh hari minggu berjalan, dimulai dari hari awal minggu yang dipilih pengguna di pengaturan.
- Setiap hari yang sudah dicatat tampil sebagai titik pada garis energi; target program tampil sebagai garis putus-putus.
- Kartu menampilkan rata-rata energi dari hari yang tercatat, target, dan jumlah hari tercatat.
- Hari setelah hari ini dibiarkan kosong tanpa keterangan.
- Mengetuk kartu membuka halaman Pantauan energi.

### 2.3 Acceptance Criteria

2.3.1. The system shall display the "Energi minggu ini" card on the Program page showing daily energy for each day of the current week starting from the user's chosen first day of the week.

2.3.2. The system shall show the program energy target as a comparison line on the card.

2.3.3. The system shall show the average energy calculated only from days that have meal records.

2.3.4. The system shall show days after today without a data point and without a "not recorded" label.

2.3.5. The system shall open the Pantauan energi page when the user taps the card.

---

## 3. Hari Belum Dicatat dan Hari Sebagian

### 3.1 User Story

As a pengguna yang kadang tidak sempat mencatat,
I want hari yang tidak saya catat tidak dianggap sebagai nol kalori,
So that grafik tidak memberi kesan saya tidak makan atau makan terlalu sedikit.

### 3.2 Functional Scope

- Hari tanpa catatan makan sama sekali: garis terputus di hari itu, tanggalnya diberi tanda "belum dicatat" (tidak hanya lewat warna), dan hari itu tidak dihitung dalam rata-rata.
- Hari yang hanya memiliki catatan dengan energi tidak diketahui ditampilkan sebagai energi belum diketahui dan tidak dihitung dalam rata-rata.
- Hari yang baru sebagian dicatat tampil dengan total dari catatan yang ada dan ikut dihitung dalam rata-rata, tanpa tanda khusus.
- Bila seluruh rentang tidak memiliki catatan, sistem menampilkan keterangan belum ada catatan beserta ajakan mencatat.
- Tidak ada kalimat yang memuji, menegur, atau menilai pengguna, baik untuk hari kosong maupun hari di atas atau di bawah target.

### 3.3 Acceptance Criteria

3.3.1. The system shall never display 0 kkal for a day without any meal record.

3.3.2. The system shall break the energy line at a day without meal records and mark that day as not recorded in a way that does not rely on color alone.

3.3.3. The system shall exclude days without meal records and days with unknown energy from the average.

3.3.4. The system shall display a partially recorded day using the total of its existing records and include it in the average.

3.3.5. The system shall display an empty-state message with an action to record a meal when no day in the range has meal records.

3.3.6. The system shall not display praise, reprimand, or warning colors for days above or below target or for unrecorded days.

---

## 4. Halaman Pantauan Energi dan Pemilih Rentang

### 4.1 User Story

As a pengguna Mealora,
I want memilih sendiri rentang tanggal untuk grafik energi,
So that saya bisa melihat pola makan pada periode yang saya inginkan.

### 4.2 Functional Scope

- Halaman menampilkan rentang yang sedang dipakai; saat dibuka, rentangnya 7 hari terakhir sampai hari ini.
- Mengetuk rentang membuka kalender. Pengguna memilih tanggal mulai lalu tanggal akhir; jumlah hari tampil sebelum menekan "Terapkan".
- Tanggal setelah hari ini dan tanggal sebelum catatan makan pertama pengguna tidak bisa dipilih. Rentang satu hari diperbolehkan.
- Ringkasan rata-rata, jumlah hari tercatat, target, dan grafik mengikuti rentang yang diterapkan.
- Bila target program berubah di dalam rentang, garis target ikut berubah pada tanggal tersebut dan ringkasan menyebut bahwa target berubah. Tanggal tanpa program yang berlaku tidak memiliki garis target.
- Rentang yang panjang dapat digeser ke samping supaya setiap tanggal tetap terbaca.
- Mengetuk titik atau tanggal menampilkan tanggal dan energinya, dengan pilihan untuk membuka Riwayat pada tanggal itu.

### 4.3 Acceptance Criteria

4.3.1. The system shall use the last seven days up to and including today as the default range when the page opens.

4.3.2. The system shall let the user select a start date and an end date from a calendar and show the number of days before applying.

4.3.3. The system shall prevent selecting dates after today or before the user's first meal record.

4.3.4. The system shall accept a single-day range.

4.3.5. The system shall update the average, recorded-day count, target, and chart to match the applied range.

4.3.6. The system shall show the target that applied on each date and state in the summary when the target changed within the range.

4.3.7. The system shall allow horizontal scrolling when the range does not fit the screen width.

4.3.8. The system shall show the date and energy (or "not recorded") when the user taps a date, with an action that opens Riwayat on that date.

4.3.9. The system shall provide a screen-reader label for every date stating the date and its energy or that it is not recorded.

## 5. High Level Test Scenarios

1. Pertengahan minggu, Senin sampai Kamis dicatat → buka Program → kartu menampilkan empat titik, Jumat sampai Minggu kosong, dan rata-rata dari empat hari.
2. Rabu tidak dicatat → lihat kartu → garis terputus di Rabu, Rabu bertanda "belum dicatat", dan rata-rata tidak menyertakan Rabu.
3. Satu hari hanya ada sarapan 400 kkal → lihat grafik → titik bernilai 400 kkal tanpa tanda khusus.
4. Buka Pantauan energi → rentang bawaan 7 hari terakhir.
5. Pilih 1–12 November lalu Terapkan → grafik berisi 12 tanggal dan ringkasan diperbarui.
6. Coba pilih tanggal besok → tanggal tidak bisa dipilih.
7. Target direvisi di tengah rentang → garis target berubah di tanggal revisi dan ringkasan menyebut target berubah.
8. Ketuk titik 7 November → buka Riwayat → Riwayat terbuka pada 7 November.
9. Aktifkan pembaca layar → fokus tanggal kosong → dibacakan tanggal dan "belum dicatat".
