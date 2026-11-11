## Purpose

Bagaimana Mealora memperlakukan gambar yang diambil pengguna ketika sebuah layanan model diperlukan untuk membacanya: persetujuan per gambar, kerahasiaan kredensial, batas biaya, perilaku ketika layanan gagal, retensi gambar, dan jaminan bahwa selalu ada jalur yang bekerja tanpa koneksi.

## ADDED Requirements

### Requirement: Tidak ada gambar terkirim tanpa persetujuan

Sistem SHALL meminta persetujuan eksplisit pengguna sebelum mengirimkan gambar apa pun ke layanan di luar perangkat. Persetujuan SHALL diminta untuk pengiriman yang bersangkutan, dan SHALL TIDAK disimpulkan dari persetujuan sebelumnya kecuali pengguna menetapkan pilihan tetap pada pengaturan privasi.

Sistem SHALL menyatakan sebelum pengiriman: bahwa gambar akan diunggah, untuk apa, bahwa pengunggahan memerlukan koneksi, dan bahwa jalur tanpa pengunggahan tersedia.

#### Scenario: Pengguna belum menyetujui

- **WHEN** pengguna mengambil gambar tetapi tidak memberi persetujuan unggah
- **THEN** tidak ada gambar yang terkirim dan sistem menawarkan jalur pengisian manual

#### Scenario: Persetujuan diberikan untuk satu gambar

- **WHEN** pengguna menyetujui pengunggahan sebuah gambar
- **THEN** hanya gambar itu yang dikirim, dan persetujuan itu tidak berlaku otomatis untuk gambar berikutnya kecuali pengguna memilih pilihan tetap pada pengaturan

#### Scenario: Pengaturan privasi menetapkan tanya setiap kali

- **WHEN** pengaturan privasi pengguna bernilai tanya setiap kali
- **THEN** sistem meminta persetujuan pada setiap pengunggahan

### Requirement: Kredensial layanan tidak berada di aplikasi

Sistem SHALL TIDAK menyertakan kunci API, token, atau kredensial penyedia model apa pun di dalam aplikasi yang didistribusikan.

Akses ke penyedia model SHALL melalui perantara yang menyimpan kredensial di sisi server. Perantara itu SHALL dibatasi pada keperluan inferensi, SHALL TIDAK menjadi sumber kebenaran data pengguna, dan SHALL TIDAK mewajibkan pembuatan akun.

#### Scenario: Aplikasi diperiksa isinya

- **WHEN** paket aplikasi yang didistribusikan diperiksa
- **THEN** tidak ditemukan kunci API maupun kredensial penyedia model di dalamnya

#### Scenario: Perantara tidak mengubah sumber kebenaran

- **WHEN** pengguna memakai jalur yang melibatkan layanan model
- **THEN** seluruh data yang diterima disimpan di perangkat, dan tidak ada data pengguna yang menjadi milik perantara

### Requirement: Batas biaya dan permintaan ditetapkan

Perantara inferensi SHALL menerapkan batas jumlah permintaan dan batas biaya yang ditetapkan secara eksplisit. Ketika batas terlampaui, sistem SHALL memberi tahu pengguna bahwa layanan sedang tidak tersedia dan SHALL mengarahkan ke jalur manual.

#### Scenario: Batas terlampaui

- **WHEN** batas permintaan atau biaya terlampaui
- **THEN** pengguna melihat pernyataan bahwa layanan sedang tidak tersedia beserta jalur manual, bukan kegagalan teknis tanpa penjelasan

### Requirement: Penyedia model dapat diganti dan dipilih lewat evaluasi

Akses ke penyedia model SHALL berada di balik antarmuka yang memungkinkan penggantian penyedia tanpa mengubah layar maupun aturan peninjauan hasil.

Pemilihan penyedia untuk rilis SHALL didasarkan pada evaluasi terdokumentasi terhadap himpunan uji yang mewakili, mencatat versi model, versi perintah, tanggal uji, wilayah penyedia, dan kasus kegagalan. Sistem SHALL TIDAK menetapkan penyedia sebagai pilihan tetap tanpa evaluasi itu.

#### Scenario: Penyedia diganti

- **WHEN** penyedia model diganti dengan penyedia lain
- **THEN** layar, aturan peninjauan, dan perilaku jalur manual tidak berubah

### Requirement: Kegagalan layanan cloud dicoba lewat OCR lokal sebelum jalur manual

Ketika layanan model cloud tidak tersedia — karena tidak ada koneksi, waktu tunggu terlampaui, kuota habis, atau penyedia menolak permintaan — sistem SHALL mencoba membaca gambar yang sama lewat pengenalan teks di perangkat (OCR lokal) sebelum menawarkan jalur manual. Langkah OCR ini SHALL TIDAK mengunggah gambar maupun memanggil perantara inferensi, dan SHALL TIDAK tunduk pada persetujuan unggah maupun batas biaya yang berlaku untuk layanan cloud.

Hasil OCR SHALL diperlakukan dengan aturan yang sama seperti hasil cloud: nilai yang tidak terbaca atau meragukan SHALL ditandai belum diketahui atau perlu diperiksa, tidak pernah ditebak, dan konfirmasi tetap tertahan sesuai aturan nilai penting.

Jika OCR lokal sendiri gagal membaca apa pun yang berguna, sistem SHALL menyatakan keadaannya dalam bahasa yang dapat dimengerti pengguna dan SHALL menawarkan jalur manual yang setara.

Draf yang sudah dibuat pengguna, termasuk gambar yang diambil dan nilai yang sudah diisi, SHALL TIDAK hilang akibat kegagalan pada tahap mana pun.

#### Scenario: Koneksi terputus saat pengiriman ke cloud

- **WHEN** koneksi terputus setelah pengguna menyetujui pengunggahan
- **THEN** sistem mencoba OCR lokal pada gambar yang sama tanpa persetujuan unggah tambahan, dan draf serta gambar tetap ada

#### Scenario: Penyedia cloud menolak permintaan

- **WHEN** penyedia model cloud mengembalikan kegagalan atau melampaui waktu tunggu
- **THEN** sistem mencoba OCR lokal sebelum menyatakan jalur manual, tanpa istilah teknis dalam pernyataannya

#### Scenario: OCR lokal tidak menemukan teks yang berguna

- **WHEN** OCR lokal tidak dapat membaca nilai apa pun dari gambar
- **THEN** sistem menyatakan keadaannya dan menawarkan jalur manual yang setara, dan draf tidak hilang

#### Scenario: OCR membaca sebagian nilai

- **WHEN** OCR lokal membaca sebagian nilai dengan keyakinan rendah
- **THEN** nilai yang terbaca ditandai perlu diperiksa, nilai yang tidak terbaca ditandai belum diketahui, dan konfirmasi tertahan sesuai aturan nilai penting

### Requirement: Jalur tanpa koneksi selalu tersedia

Setiap kemampuan yang memakai layanan model SHALL memiliki jalur setara yang bekerja sepenuhnya tanpa koneksi. Sistem SHALL menyatakan dengan jelas kemampuan mana yang memerlukan koneksi.

Alur inti — buku harian, program, berat, dan riwayat — SHALL tetap bekerja sepenuhnya luring.

OCR lokal SHALL TIDAK dianggap sebagai jaminan jalur luring: ia SHALL diperlakukan sebagai upaya terbaik yang dapat gagal karena alasan teknis platform (mis. komponen pengenalan teks belum siap di perangkat), dan kegagalannya SHALL bermuara ke jalur manual yang sama seperti kegagalan lainnya.

#### Scenario: Pengguna luring membuka jalur yang memerlukan koneksi

- **WHEN** pengguna membuka jalur yang memerlukan layanan model tanpa koneksi
- **THEN** sistem menyatakan kebutuhan koneksi dan menawarkan jalur manual yang setara

#### Scenario: OCR lokal belum siap di perangkat

- **WHEN** pengguna offline dan komponen OCR lokal belum siap dipakai
- **THEN** sistem menyatakan jalur otomatis tidak tersedia dan menawarkan jalur manual, tanpa menganggap ini kegagalan tak terduga

### Requirement: Retensi gambar mengikuti pilihan pengguna

Sistem SHALL menyediakan pengaturan retensi gambar sumber: disimpan atau dihapus setelah catatan dibuat. Sistem SHALL menerapkan pilihan itu dan SHALL menyatakan perilakunya kepada pengguna.

Gambar yang disimpan SHALL berada di perangkat, SHALL TIDAK dikirim ke layanan mana pun di luar pengiriman yang disetujui, dan SHALL ikut terhapus ketika pengguna menghapus seluruh data lokal.

#### Scenario: Pengaturan hapus setelah dicatat

- **WHEN** pengaturan retensi bernilai hapus setelah dicatat dan pengguna menyelesaikan pencatatan
- **THEN** gambar sumber dihapus dari perangkat setelah catatan dibuat

#### Scenario: Penghapusan data lokal

- **WHEN** pengguna menghapus seluruh data lokal
- **THEN** seluruh gambar sumber yang tersimpan ikut terhapus

### Requirement: Hasil model tidak pernah menjadi data terverifikasi

Nilai yang dihasilkan model SHALL diperlakukan sebagai usulan yang memerlukan pemeriksaan pengguna. Sistem SHALL TIDAK menyimpan hasil model sebagai nilai gizi terverifikasi tanpa konfirmasi pengguna, dan SHALL menandai asal-usul nilai yang berasal dari ekstraksi.

#### Scenario: Hasil model disimpan tanpa konfirmasi

- **WHEN** hasil model tersedia dan pengguna belum mengonfirmasi
- **THEN** tidak ada catatan maupun rekaman produk terverifikasi yang dibuat
