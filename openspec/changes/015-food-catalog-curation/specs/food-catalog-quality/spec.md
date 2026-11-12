## Purpose

Aturan mutu data katalog makanan bawaan yang diperiksa otomatis sebelum katalog dirilis. Tujuannya agar angka gizi dan takaran yang dilihat pengguna konsisten, dapat ditelusuri, dan bebas dari galat yang terdeteksi secara matematis.

## ADDED Requirements

### Requirement: Katalog bawaan lolos pemeriksaan mutu sebelum rilis

Setiap versi katalog bawaan SHALL lolos seluruh pemeriksaan mutu pada requirement ini sebelum disertakan dalam build rilis. Pemeriksaan yang gagal SHALL menggagalkan proses build dan menyebutkan makanan atau takaran yang melanggar beserta aturannya.

#### Scenario: Pelanggaran menggagalkan build

- **WHEN** satu makanan katalog melanggar aturan mutu
- **THEN** proses build gagal dan laporan menyebut nama makanan itu serta aturan yang dilanggar

### Requirement: Energi konsisten dengan makronutrien

Untuk setiap makanan dengan energi di atas 20 kkal per 100 g dan seluruh makronutrien utama diketahui, energi tercatat SHALL berada dalam batas toleransi terhadap energi hasil hitung 4 kkal/g protein, 4 kkal/g karbohidrat, dan 9 kkal/g lemak. Makanan di luar toleransi SHALL dikoreksi terhadap sumber, atau dikecualikan secara eksplisit beserta alasan yang terdokumentasi (mis. mengandung alkohol atau serat tinggi).

#### Scenario: Energi menyimpang tanpa pengecualian

- **WHEN** energi sebuah makanan menyimpang di luar toleransi dan tidak ada pengecualian terdokumentasi
- **THEN** pemeriksaan mutu gagal untuk makanan itu

#### Scenario: Pengecualian terdokumentasi

- **WHEN** energi minuman beralkohol menyimpang karena kontribusi alkohol dan pengecualiannya terdokumentasi
- **THEN** pemeriksaan mutu lolos untuk makanan itu

### Requirement: Nilai tidak diketahui tidak disimpan sebagai nol

Nilai gizi yang tidak terkonfirmasi oleh sumber SHALL disimpan sebagai belum diketahui, bukan nol. Nilai nol SHALL hanya dipakai bila sumber menyatakan nol atau nilainya terkonfirmasi secara wajar, misalnya karbohidrat pada daging tanpa olahan.

#### Scenario: Karbohidrat nol yang meragukan

- **WHEN** sumber turunan mencantumkan karbohidrat 0 untuk makanan berbahan tepung atau gula dan sumber resmi tidak mengonfirmasinya
- **THEN** karbohidrat makanan itu disimpan sebagai belum diketahui

### Requirement: Padanan berat takaran berada dalam rentang wajar

Padanan berat setiap takaran sehari-hari SHALL berada dalam rentang wajar yang ditetapkan untuk satuannya (mis. sendok teh, sendok makan, gelas, mangkuk, centong). Untuk minuman dan makanan cair, padanan beratnya SHALL konsisten dengan volume satuan dikali massa jenis yang terdokumentasi.

#### Scenario: Takaran di luar rentang

- **WHEN** sebuah takaran "1 sdm" memiliki padanan 80 g
- **THEN** pemeriksaan mutu gagal untuk takaran itu

### Requirement: Tidak ada makanan duplikat

Katalog bawaan SHALL TIDAK memuat dua makanan dengan nama ternormalisasi yang sama, yaitu nama setelah huruf besar-kecil dan spasi berlebih diabaikan.

#### Scenario: Nama ganda

- **WHEN** katalog memuat "Bika ambon" dan "Bika Ambon"
- **THEN** pemeriksaan mutu gagal dan menyebut kedua entri

### Requirement: Satu takaran bawaan per makanan

Setiap makanan katalog SHALL memiliki tepat satu takaran bawaan.

#### Scenario: Takaran bawaan ganda

- **WHEN** sebuah makanan memiliki dua takaran yang ditandai bawaan
- **THEN** pemeriksaan mutu gagal untuk makanan itu
