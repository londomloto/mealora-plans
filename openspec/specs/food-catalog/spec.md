# food-catalog Specification

## Purpose
Makanan yang tersedia bagi pengguna di perangkat: nilai gizi beserta asal-usulnya, takaran saji yang bermakna bagi orang Indonesia, cara menemukan makanan secara luring, dan cara pengguna menambahkan makanan yang belum ada di katalog.

## Requirements

### Requirement: Katalog tersedia sepenuhnya tanpa koneksi

Katalog makanan SHALL tersedia dan dapat dicari tanpa koneksi jaringan sejak aplikasi dipasang. Pencarian dan pembacaan nilai gizi SHALL TIDAK memerlukan permintaan jaringan apa pun.

#### Scenario: Mencari makanan dalam mode pesawat

- **WHEN** pengguna mencari makanan dengan seluruh koneksi dimatikan
- **THEN** hasil pencarian tampil dari katalog di perangkat tanpa pesan kesalahan jaringan

### Requirement: Setiap makanan katalog memiliki asal-usul data

Setiap makanan pada katalog bawaan SHALL menyimpan asal-usul nilai gizinya: jenis sumber, pengenal pada sumber tersebut, versi sumber, dan tanggal verifikasi terakhir. Sistem SHALL dapat menampilkan asal-usul itu kepada pengguna.

Nilai gizi per satuan berat SHALL berasal dari sumber yang dapat ditelusuri. Sistem SHALL TIDAK memuat nilai gizi yang dikarang atau diperkirakan tanpa dasar.

Setiap takaran saji pada katalog bawaan SHALL menyimpan asal-usul padanan beratnya sendiri, dengan salah satu tingkat berikut:
- **resmi**: dari sumber resmi atau penimbangan lapangan yang dapat ditelusuri, beserta rujukannya;
- **turunan**: dihitung secara matematis dari data terukur, beserta rujukan data asalnya;
- **perkiraan**: estimasi ukuran yang realistis karena sumber terukur tidak tersedia, beserta catatan dasar perkiraannya.

Tingkat "perkiraan" SHALL hanya dipakai untuk padanan berat sebuah takaran, tidak pernah untuk nilai gizi per satuan berat.

#### Scenario: Pengguna memeriksa asal data

- **WHEN** pengguna membuka detail sebuah makanan katalog
- **THEN** sistem menampilkan penanda asal data makanan itu

#### Scenario: Makanan tanpa asal-usul ditolak masuk katalog

- **WHEN** sebuah makanan bawaan tidak memiliki asal-usul yang lengkap
- **THEN** makanan itu tidak disertakan dalam katalog bawaan

#### Scenario: Takaran tanpa asal-usul ditolak masuk katalog

- **WHEN** sebuah takaran saji bawaan tidak memiliki tingkat asal-usul beserta rujukan atau catatan dasarnya
- **THEN** takaran itu tidak disertakan dalam katalog bawaan

#### Scenario: Takaran perkiraan ditandai

- **WHEN** pengguna memilih takaran yang padanan beratnya bertingkat "perkiraan"
- **THEN** sistem menandai takaran itu sebagai perkiraan di samping padanan beratnya

### Requirement: Takaran saji yang bermakna

Setiap makanan SHALL memiliki sekurang-kurangnya satu takaran saji dengan label yang dapat dimengerti pengguna, jumlah, satuan, dan bobot dalam gram bila diketahui. Satu takaran SHALL ditandai sebagai takaran bawaan.

Label takaran SHALL memakai istilah sehari-hari Indonesia jika sesuai, misalnya "1 centong", "1 gelas", "1 sdm", atau "1 potong sedang", dan SHALL menyertakan padanan beratnya bila diketahui.

Bila sebuah makanan katalog memiliki takaran sehari-hari, takaran bawaannya SHALL berupa takaran sehari-hari yang paling lazim untuk makanan itu, bukan takaran berat murni. Takaran berdasarkan 100 g dari sumber asal SHALL tetap tersedia sebagai pilihan.

#### Scenario: Memilih takaran saji

- **WHEN** pengguna membuka sebuah makanan yang memiliki beberapa takaran saji
- **THEN** seluruh takaran tampil dengan label dan padanan beratnya, dan takaran bawaan terpilih lebih dulu

#### Scenario: Takaran bawaan sehari-hari

- **WHEN** pengguna membuka "Nasi putih" dari katalog
- **THEN** takaran bawaan yang terpilih adalah takaran sehari-hari seperti "1 centong", dan takaran "100 g" tetap dapat dipilih

#### Scenario: Takaran lama tetap berlaku

- **WHEN** pengguna sebelumnya mencatat makanan dengan takaran "100 g" dan kemudian katalog menambahkan takaran sehari-hari
- **THEN** bagian terakhir dicatat tetap menawarkan takaran "100 g" yang terakhir dipakai, dan catatan lama tidak berubah

### Requirement: Cakupan makanan Indonesia

Katalog bawaan SHALL memuat makanan yang lazim dikonsumsi di Indonesia, mencakup makanan pokok, lauk, sayur, jajanan, dan minuman yang umum.

#### Scenario: Mencari makanan Indonesia yang umum

- **WHEN** pengguna mencari "nasi"
- **THEN** hasil memuat beberapa makanan berbasis nasi yang lazim beserta takaran sajinya

### Requirement: Pencarian luring yang memaafkan

Pencarian SHALL mengabaikan perbedaan huruf besar dan kecil, SHALL mencocokkan bagian mana pun dari nama makanan, dan SHALL menampilkan hasil tanpa jeda yang terasa pada ukuran katalog yang wajar.

Hasil SHALL menampilkan nama makanan dan takaran sajinya. Pencarian yang tidak menemukan apa pun SHALL menyatakan demikian dan SHALL menawarkan pembuatan makanan sendiri.

#### Scenario: Pencarian tanpa hasil

- **WHEN** pencarian pengguna tidak cocok dengan satu pun makanan
- **THEN** sistem menyatakan tidak ada hasil dan menawarkan pembuatan makanan sendiri

#### Scenario: Huruf besar-kecil diabaikan

- **WHEN** pengguna mengetik "NASI" atau "nasi"
- **THEN** hasil yang ditampilkan sama

### Requirement: Makanan yang terakhir dicatat muncul lebih dulu

Sebelum pengguna mengetik apa pun, sistem SHALL menampilkan makanan yang terakhir ia catat sebagai pilihan cepat, beserta takaran yang terakhir dipakai untuk makanan itu.

#### Scenario: Membuka pencarian setelah pernah mencatat

- **WHEN** pengguna membuka pencarian makanan setelah sebelumnya mencatat beberapa makanan
- **THEN** makanan yang terakhir dicatat tampil lebih dulu beserta takaran yang terakhir dipakai

#### Scenario: Pengguna baru

- **WHEN** pengguna membuka pencarian sebelum pernah mencatat apa pun
- **THEN** bagian terakhir dicatat tidak ditampilkan atau dinyatakan masih kosong, bukan diisi contoh

### Requirement: Pengguna dapat membuat makanan sendiri

Sistem SHALL memungkinkan pengguna membuat makanan yang tidak ada di katalog, dengan masukan sekurang-kurangnya: nama, ukuran sajian, energi, protein, karbohidrat, dan lemak.

Sistem SHALL menyediakan dua cara mengisi nilai gizi: **isi manual**, yang menjadi cara bawaan, dan **hitung dari bahan** (lihat kapabilitas `custom-food-recipe`). Pengguna SHALL dapat memilih isi manual tanpa harus memasukkan bahan apa pun.

Sistem SHALL menyatakan bahwa nilai sebaiknya disalin dari sumber yang dipercaya pengguna, dan SHALL menyatakan bahwa nilai yang belum diketahui jangan diisi nol. Nilai yang dikosongkan SHALL disimpan sebagai belum diketahui.

Makanan buatan pengguna SHALL ditandai berbeda dari makanan katalog bawaan, SHALL mencatat apakah nilai gizinya diisi manual atau dihitung dari bahan, dan SHALL dapat dicari serta dicatat seperti makanan lain.

#### Scenario: Membuat makanan sendiri

- **WHEN** pengguna menyimpan makanan buatan sendiri dengan nama, ukuran sajian, dan nilai gizi
- **THEN** makanan itu tersedia pada pencarian berikutnya dan ditandai sebagai makanan buatan pengguna

#### Scenario: Isi manual tetap tersedia

- **WHEN** pengguna membuka layar buat makanan sendiri dan sudah mengetahui nilai gizinya
- **THEN** pengguna dapat langsung mengisi nilai gizi secara manual dan menyimpan tanpa menambahkan bahan

#### Scenario: Nilai gizi dikosongkan

- **WHEN** pengguna mengosongkan nilai lemak karena tidak mengetahuinya
- **THEN** nilai itu tersimpan sebagai belum diketahui dan tidak diubah menjadi nol

#### Scenario: Nilai tidak masuk akal

- **WHEN** pengguna memasukkan nilai gizi negatif atau ukuran sajian nol
- **THEN** sistem menolak dengan penjelasan dan tidak menyimpan makanan itu

### Requirement: Pembaruan katalog tidak mengubah catatan lama

Pembaruan nilai gizi pada katalog SHALL TIDAK mengubah nilai pada catatan makan yang sudah tersimpan.

#### Scenario: Nilai katalog diperbarui

- **WHEN** nilai gizi sebuah makanan katalog diperbarui setelah pengguna pernah mencatatnya
- **THEN** catatan lama tetap menampilkan nilai seperti saat dicatat

### Requirement: Jumlah bebas dalam satuan berat atau volume

Untuk makanan yang padanan beratnya diketahui, sistem SHALL memungkinkan pengguna mencatat jumlah langsung dalam gram, atau dalam mililiter untuk minuman yang punya padanan volume, selain memilih kelipatan takaran. Nilai gizi SHALL dihitung secara proporsional dari padanan berat tersebut.

Jumlah SHALL lebih besar dari nol. Sistem SHALL menolak jumlah nol atau negatif dengan penjelasan.

#### Scenario: Mencatat dalam gram

- **WHEN** pengguna memasukkan 150 g untuk makanan yang nilai gizinya diketahui per 100 g
- **THEN** sistem mencatat nilai gizi sebesar 1,5 kali nilai per 100 g

#### Scenario: Jumlah tidak sah

- **WHEN** pengguna memasukkan 0 g
- **THEN** sistem menolak dengan penjelasan dan tidak menyimpan catatan

#### Scenario: Padanan berat tidak diketahui

- **WHEN** takaran sebuah makanan tidak memiliki padanan berat
- **THEN** sistem tidak menawarkan masukan gram untuk takaran itu dan pengguna tetap dapat memilih kelipatan takaran

### Requirement: Bentuk siap konsumsi dibedakan dari bahan

Makanan katalog yang lazim dikonsumsi dalam bentuk olahan atau seduhan SHALL memiliki entri bentuk siap konsumsi yang terpisah dari entri bahan mentah atau keringnya, dengan nama yang menyatakan bentuknya, misalnya "Teh manis (seduh)" dan "Teh (daun kering)".

Saat pencarian cocok dengan keduanya, entri bentuk siap konsumsi SHALL ditampilkan lebih dulu daripada entri bahan mentah atau kering.

#### Scenario: Mencari minuman seduhan

- **WHEN** pengguna mencari "teh"
- **THEN** entri teh seduh tampil sebelum entri daun teh kering, dan nama keduanya menyatakan bentuknya

### Requirement: Sinonim pencarian yang lazim

Pencarian SHALL mencocokkan variasi ejaan dan sebutan sehari-hari yang lazim untuk makanan yang sama, misalnya "mie" dan "mi", atau "telor" dan "telur".

#### Scenario: Ejaan sehari-hari

- **WHEN** pengguna mengetik "telor ceplok"
- **THEN** hasil memuat makanan telur ceplok dari katalog
