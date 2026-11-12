## Purpose

Menghitung nilai gizi makanan buatan pengguna dari daftar bahan beserta jumlahnya, berdasarkan nilai gizi bahan yang tercatat, tanpa menebak nilai apa pun. Resepnya disimpan agar bisa disunting dan dihitung ulang.

## ADDED Requirements

### Requirement: Gizi dihitung dari bahan dan jumlahnya

Saat pengguna memilih "hitung dari bahan", sistem SHALL memungkinkan pengguna menambahkan satu atau lebih bahan, masing-masing dengan jumlah dalam gram atau dalam kelipatan takaran bahan. Total setiap zat gizi resep SHALL sama dengan jumlah kontribusi seluruh bahan. Kontribusi tiap bahan dihitung sebagai berikut:
- untuk jumlah dalam gram, atau dalam takaran yang padanan beratnya diketahui: nilai gizi bahan per 100 g × berat dalam gram / 100;
- untuk takaran tanpa padanan berat (mis. "1 porsi" makanan buatan pengguna): nilai gizi takaran itu × jumlah kelipatannya.

Masukan gram SHALL hanya ditawarkan untuk bahan yang padanan beratnya diketahui.

Jumlah setiap bahan SHALL lebih besar dari nol.

#### Scenario: Menjumlahkan bahan

- **WHEN** pengguna menambahkan bahan A sebanyak 150 g dengan energi 180 kkal per 100 g dan bahan B sebanyak 55 g dengan energi 160 kkal per 100 g
- **THEN** total energi resep adalah 270 + 88 = 358 kkal

#### Scenario: Jumlah dalam takaran

- **WHEN** pengguna menambahkan "1 butir" telur yang padanannya 55 g
- **THEN** sistem menghitung bahan itu sebagai 55 g

#### Scenario: Jumlah bahan tidak sah

- **WHEN** pengguna memasukkan jumlah bahan 0 g
- **THEN** sistem menolak dengan penjelasan dan tidak menambahkan bahan itu

### Requirement: Gizi per sajian dari jumlah porsi atau berat jadi

Sistem SHALL meminta pengguna menyatakan hasil resep, baik sebagai jumlah porsi atau sebagai berat jadi dalam gram. Gizi per sajian SHALL dihitung sebagai total gizi resep dibagi jumlah porsi. Bila berat jadi diberikan, sistem SHALL juga dapat menyediakan takaran per 100 g hasil masakan, yaitu total gizi resep × 100 / berat jadi.

Jumlah porsi dan berat jadi SHALL lebih besar dari nol.

#### Scenario: Dibagi per porsi

- **WHEN** total energi resep 1.200 kkal dan pengguna menyatakan hasilnya 4 porsi
- **THEN** energi per sajian adalah 300 kkal

#### Scenario: Berat jadi

- **WHEN** total energi resep 1.200 kkal dan berat jadinya 800 g
- **THEN** takaran per 100 g hasil masakan berenergi 150 kkal

### Requirement: Nilai yang tidak diketahui tidak dianggap nol

Bila sebuah zat gizi tidak diketahui pada salah satu bahan, total zat itu SHALL ditandai tidak lengkap. Sistem SHALL menyebut bahan yang menyebabkannya. Sistem SHALL TIDAK menghitung nilai yang tidak diketahui sebagai nol tanpa menandainya.

#### Scenario: Serat tidak diketahui pada satu bahan

- **WHEN** salah satu bahan tidak memiliki nilai serat
- **THEN** total serat ditandai tidak lengkap dan sistem menyebut bahan tersebut

### Requirement: Bahan yang belum ada di katalog

Pemilihan bahan SHALL mencakup makanan katalog dan makanan buatan pengguna. Bila bahan yang dicari tidak ada, sistem SHALL menawarkan pembuatan makanan sendiri langsung dari pemilihan bahan dan SHALL menambahkannya ke resep setelah disimpan.

Pengguna SHALL dapat menambahkan bahan tanpa data gizi, dengan nama dan jumlah saja. Bahan tersebut SHALL membuat seluruh total zat gizi resep ditandai tidak lengkap dengan menyebut bahan itu. Sistem SHALL TIDAK memperkirakan nilai gizi bahan tersebut.

#### Scenario: Membuat bahan baru dari pemilihan bahan

- **WHEN** pengguna mencari bahan yang tidak ada lalu membuatnya dengan nilai gizi per 100 g dari label kemasan
- **THEN** bahan itu tersimpan sebagai makanan buatan pengguna dan langsung masuk ke resep

#### Scenario: Bahan tanpa data gizi

- **WHEN** pengguna menambahkan "bumbu racik" tanpa nilai gizi
- **THEN** total gizi resep ditandai tidak lengkap dan menyebut "bumbu racik"

### Requirement: Hasil hitungan dapat ditinjau dan dikoreksi

Sistem SHALL menampilkan rincian kontribusi tiap bahan dan total per sajian sebelum disimpan. Hasil hitungan SHALL mengisi kolom gizi makanan, dan pengguna SHALL dapat mengoreksinya sebelum menyimpan. Bila pengguna mengoreksi nilai hasil hitungan, makanan itu SHALL dicatat sebagai diisi manual.

Sistem SHALL menampilkan bentuk bahan (mis. mentah, kering, siap makan) pada daftar bahan bila diketahui, dan SHALL mengingatkan bahwa minyak yang terserap saat menggoreng perlu ditambahkan sebagai bahan.

#### Scenario: Meninjau rincian

- **WHEN** pengguna selesai menambahkan bahan
- **THEN** sistem menampilkan kontribusi gizi tiap bahan dan total per sajian

#### Scenario: Mengoreksi hasil

- **WHEN** pengguna mengubah energi hasil hitungan sebelum menyimpan
- **THEN** makanan tersimpan dengan nilai koreksi dan ditandai diisi manual

### Requirement: Resep tersimpan dan dapat dihitung ulang

Untuk makanan yang gizinya dihitung dari bahan, sistem SHALL menyimpan daftar bahan, jumlahnya, dan hasil resepnya. Saat makanan itu disunting, sistem SHALL menampilkan resepnya dan menghitung ulang gizi dari nilai bahan yang berlaku saat itu.

Perubahan resep atau nilai bahan SHALL TIDAK mengubah catatan makan yang sudah tersimpan.

#### Scenario: Menyunting resep

- **WHEN** pengguna membuka makanan hasil hitungan dan mengurangi salah satu bahan
- **THEN** gizi dihitung ulang dari resep yang baru

#### Scenario: Catatan lama tidak berubah

- **WHEN** resep sebuah makanan diubah setelah makanan itu pernah dicatat
- **THEN** catatan lama tetap menampilkan nilai seperti saat dicatat
