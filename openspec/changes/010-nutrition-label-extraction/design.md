# Design — 010 · Ekstraksi label Informasi Nilai Gizi

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 007 menyediakan buku harian dan potret nilai gizi; change 009 menyediakan tabel produk kemasan, provenans, aritmetika basis takaran, dan jalur "produk tidak ditemukan" yang menunjuk ke sini. Belum ada akses ke layanan model mana pun, dan belum ada komponen sisi server.

Batasan yang mengikat dari assessment §50.1 dan §50.3: hasil pembacaan mesin tidak pernah menjadi data terverifikasi; foto asli ditampilkan berdampingan dengan nilai yang terbaca; nilai yang hilang tetap tidak diketahui; kunci API tidak boleh ada di aplikasi; proksi dibatasi pada inferensi dan tidak mengubah SQLite sebagai sumber kebenaran; batas biaya ditetapkan tegas; gambar tidak pernah diunggah otomatis. §50.6 menetapkan evaluasi penyedia sebagai gerbang sebelum rilis.

## Goals / Non-Goals

**Goals**

- Menyalin label menjadi pekerjaan memeriksa, bukan mengetik.
- Tidak ada satu pun angka hasil mesin yang masuk ke buku harian tanpa dilihat pengguna.
- Jalur manual berdiri sendiri dan selalu bekerja luring.
- Fondasi akses model yang dapat dipakai ulang change foto makanan tanpa ditulis dua kali.

**Non-Goals**

- Tidak ada pengenalan foto makanan — itu change berikutnya, yang memakai ulang `image-ai-access`.
- Tidak ada model di perangkat pada change ini; antarmuka penyedia dibuat agar itu tetap mungkin kemudian.
- Proksi tidak menyimpan data pengguna, tidak mengelola akun, dan tidak melakukan sinkronisasi.
- Tidak ada pembacaan daftar bahan, klaim gizi, atau sertifikasi pada kemasan — hanya panel Informasi Nilai Gizi.

## Decisions

### D1 — Dua kapabilitas, karena yang satu dipakai ulang

`image-ai-access` memuat aturan yang berlaku untuk setiap jalur yang memerlukan layanan model: persetujuan, kredensial, batas biaya, kegagalan, retensi, dan jalur luring. `nutrition-label-extraction` memuat yang khas label.

Menuliskannya terpisah membuat change foto makanan memakai ulang aturan gambar apa adanya, bukan menyalinnya — dan salinan aturan privasi adalah tempat paling mudah terjadi penyimpangan diam-diam.

### D2 — Proksi inferensi: satu-satunya komponen server di MVP 1

Kunci API tidak boleh ada di aplikasi yang didistribusikan (§50.3), sehingga akses ke penyedia model harus lewat perantara. Cakupannya dibatasi keras: menerima gambar, meneruskan ke penyedia, mengembalikan hasil terstruktur. Tidak menyimpan gambar, tidak menyimpan hasil, tidak mengenal pengguna, tidak mewajibkan akun.

Ini keputusan yang perlu dinyatakan terang-terangan karena tampak melanggar prinsip "tanpa backend" di MVP 1. Yang dilanggar sebenarnya tidak ada: assessment §50.3 sendiri menetapkan proksi sebagai syarat jalur AI cloud, dan menegaskan bahwa itu tidak mengubah SQLite sebagai sumber kebenaran maupun mewajibkan login. Alur inti tetap bekerja penuh tanpa proksi — yang hilang hanyalah pembacaan otomatis.

*Alternatif:* model di perangkat. Menarik karena menghapus proksi dan masalah privasinya sekaligus, tetapi menambah ukuran aplikasi dan ketidakpastian akurasi pada label berbahasa Indonesia. Antarmuka penyedia dibuat agar pilihan ini tetap terbuka tanpa mengubah layar.

### D3 — Persetujuan per gambar, bukan persetujuan sekali seumur hidup

Pengaturan privasi menyediakan pilihan "tanya setiap kali" sebagai bawaan, sesuai rancangan `35`. Persetujuan untuk satu gambar tidak otomatis berlaku untuk gambar berikutnya kecuali pengguna sendiri menetapkan pilihan tetap.

Alasannya: yang diunggah adalah foto yang diambil di dapur, di minimarket, atau di meja makan — kadang memuat lebih dari sekadar kemasan. Persetujuan sekali seumur hidup membuat pengguna kehilangan jejak atas apa yang ia kirimkan.

### D4 — Foto asli berdampingan dengan hasil, bukan hasil saja

Layar peninjauan menampilkan foto label di sebelah nilai yang terbaca (§50.1, rancangan `24`). Ini bukan hiasan: memeriksa angka tanpa melihat sumbernya adalah memeriksa yang tidak mungkin, dan pengguna akan menyetujui apa pun yang ditampilkan.

### D5 — Konfirmasi tertahan selama nilai penting belum beres

Tombol konfirmasi tidak aktif selama ada nilai penting yang belum terisi atau belum diperiksa, dan sistem menyatakan nilai mana yang menahan — persis seperti rancangan `24` yang menampilkan "Lengkapi data untuk melanjutkan".

Pengguna yang memang tidak menemukan nilai lemak pada kemasannya dapat menyatakan bahwa nilai itu tidak tercantum; nilainya lalu tersimpan sebagai belum diketahui, bukan nol. Membedakan "belum diisi" dari "memang tidak ada" mencegah jalan buntu tanpa mengorbankan aturan nol.

### D6 — Basis label dibaca, tetapi tidak pernah ditebak

Basis adalah bagian paling berbahaya dari label: salah membaca "per 100 g" sebagai "per sajian" menggandakan atau membagi seluruh nilai. Karena itu basis ditampilkan untuk diperiksa, dan ketika tidak terbaca, sistem meminta pengguna menetapkannya alih-alih menebak.

Aritmetikanya memakai ulang implementasi change 009 (D4 di sana), bukan menulis yang kedua.

### D7 — Jalur manual bukan cadangan, melainkan jalur setara

Rancangan `37 · Isi label manual offline` adalah jalur penuh: basis nilai, ukuran sajian, jumlah sajian per kemasan, dan seluruh nilai gizi, dengan pengingat aritmetika kemasan. Ia bekerja tanpa koneksi, tanpa izin kamera, dan tanpa proksi.

Memperlakukannya sebagai jalur setara — bukan "kalau AI gagal" — membuat produk tetap berguna sepenuhnya meski penyedia model belum dipilih, kuota habis, atau pengguna menolak mengunggah apa pun selamanya.

### D8 — Penyedia dipilih lewat evaluasi, bukan ditetapkan di design

§50.6 menetapkan evaluasi dengan 30–50 label kemasan Indonesia yang berizin, membandingkan akurasi ukuran sajian dan jumlah sajian per kemasan, akurasi energi dan protein beserta satuannya, beban koreksi, latensi, dan biaya per catatan yang diterima.

Design ini sengaja tidak menyebut penyedia mana yang dipakai. Kandidat yang disebut assessment — Gemini, Qwen VL, DeepSeek — beserta kuota dan harganya berubah terus, dan menanamnya di sini akan membuat dokumen usang sebelum dibaca. Yang ditetapkan adalah antarmuka, gerbangnya, dan apa yang dicatat.

### D9 — Retensi gambar mengikuti pengaturan, bawaan menghapus

Rancangan `35 · Privasi & data lokal` sudah memuat "Simpan foto sumber: Hapus setelah dicatat" sebagai bawaan. Itu dipertahankan: menyimpan foto hanya berguna bila pengguna ingin memeriksanya kembali, sedangkan menyimpannya tanpa diminta menumpuk data pribadi tanpa alasan.

### D10 — Perubahan skema minimal

Hasil ekstraksi disimpan pada tabel produk kemasan change 009. Yang ditambahkan hanyalah nilai asal-usul baru yang menyatakan "ekstraksi label yang dikonfirmasi pengguna" dan rujukan opsional ke gambar sumber bila retensi mengizinkan. `schemaVersion` naik dari 6 ke 7 satu kali.

### D11 — OCR lokal sebagai langkah antara, bukan penyedia kedua yang melewati gerbang evaluasi

Ketika penyedia cloud gagal — offline, waktu tunggu, kuota habis, atau ditolak — sistem mencoba pembacaan OCR di perangkat (pengenalan teks lewat ML Kit) dilengkapi pencocokan kata kunci sederhana ("Energi"/"Protein"/"Karbohidrat"/"Lemak" beserta angka dan satuan terdekat) sebelum menawarkan jalur manual. Hasilnya mengisi `LabelExtraction` yang sama seperti hasil cloud — basis dan tiap nilai dengan `ReadingConfidence` — sehingga layar tinjau (24), penandaan keyakinan (D4), dan penahanan konfirmasi (D5) berlaku tanpa perubahan apa pun. Karena parser OCR tidak memahami struktur tabel seperti model vision, keyakinannya dipatok konservatif: `confident` hanya untuk kecocokan kata kunci yang tidak ambigu, selainnya `needsCheck`/`unread` — tidak pernah ditebak, mengikuti D6.

Ini sengaja bukan "penyedia kedua" yang melewati gerbang evaluasi D8: OCR tidak dipilih lewat perbandingan akurasi terhadap kandidat lain, karena perannya memang fallback berakurasi rendah yang tetap diperiksa pengguna, bukan jalur utama yang mengklaim akurasi setara. Secara arsitektur, ini `NutritionLabelProvider` kedua, dirangkai lewat satu composite yang mencoba penyedia cloud lebih dulu lalu OCR, tetap diekspos sebagai satu `NutritionLabelProvider` ke layar — selaras dengan D2 soal satu titik ganti yang tidak mengubah layar.

OCR tidak menyentuh aturan `image-ai-access` soal persetujuan unggah (D3) maupun kerahasiaan kredensial dan batas biaya (D2): tidak ada gambar yang meninggalkan perangkat pada langkah ini, tidak ada proksi yang dipanggil. Yang tetap berlaku tanpa perubahan adalah retensi gambar (D9) dan aturan "hasil model tidak pernah menjadi data terverifikasi" — keduanya sudah generik terhadap penyedia.

*Catatan tentang jaminan luring:* pengenalan teks ML Kit di Android dapat memerlukan unduhan komponen lewat Google Play Services pada pemakaian pertama di perangkat. OCR karena itu diperlakukan sebagai upaya terbaik saat offline, bukan jaminan mutlak — bila komponen itu belum pernah terunduh dan pengguna offline, OCR pun gagal dan jatuh ke jalur manual yang sama, dinyatakan jujur sebagai bagian dari D7, bukan disembunyikan sebagai kegagalan teknis.

*Alternatif:* OCR yang bundel penuh model di aplikasi (mis. Tesseract) memberi jaminan luring mutlak sejak pemasangan pertama, tetapi menambah ukuran APK signifikan (model bahasa + pustaka native per ABI) untuk akurasi yang umumnya lebih rendah pada foto natural dibanding dokumen pindaian. Tidak dipilih karena produk ini menyasar foto kemasan di dapur/minimarket, bukan dokumen rapi.

## Risks / Trade-offs

- **Proksi adalah komponen operasional pertama** — perlu di-deploy, dipantau, dan dibayar. Mitigasi: cakupan dibatasi keras pada inferensi; batas biaya ditetapkan tegas; seluruh produk tetap berfungsi penuh tanpanya.
- **Biaya inferensi tidak dapat diprediksi** bila pemakaian naik → mitigasi: batas permintaan dan biaya pada proksi, serta pernyataan jujur kepada pengguna ketika batas terlampaui.
- **Akurasi pada label Indonesia belum diketahui** → mitigasi: evaluasi sebagai gerbang sebelum rilis dengan himpunan uji nyata; bila akurasinya tidak memadai, jalur manual tetap mengirimkan nilai produk, dan fitur ekstraksi dapat ditunda tanpa membatalkan change.
- **Pengguna menyetujui apa pun yang ditampilkan** tanpa benar-benar memeriksa → mitigasi: foto berdampingan, penanda keyakinan per nilai, konfirmasi tertahan untuk nilai yang belum diperiksa. Ini mengurangi risiko, tidak menghapusnya.
- **Foto label memuat hal lain di sekitarnya** → mitigasi: persetujuan per gambar, panduan pemotretan, retensi bawaan menghapus.
- **Himpunan uji berizin sulit dikumpulkan** → mitigasi: paket kerja tersendiri dengan timebox; bila belum cukup, rilis berjalan tanpa jalur ekstraksi sementara jalur manual tetap tersedia.
- **Parser OCR bisa salah memetakan baris label** (mis. tertukar antara "Energi Total" dan "Energi dari Lemak") → mitigasi: keyakinan dipatok konservatif (D11), nilai ambigu ditandai perlu diperiksa bukan ditebak, dan foto asli tetap berdampingan untuk verifikasi (D4).
- **Komponen ML Kit bisa memerlukan unduhan sekali di awal** sehingga OCR tidak selalu tersedia murni luring → mitigasi: OCR diperlakukan upaya terbaik (D11), kegagalannya bermuara ke jalur manual yang tanpa syarat tetap tersedia (D7).

## Migration Plan

1. Naikkan `schemaVersion` dari 6 ke 7 satu kali untuk change ini.
2. Tambahkan nilai asal-usul untuk hasil ekstraksi yang dikonfirmasi, dan rujukan opsional ke gambar sumber.
3. Pertahankan seluruh data versi 6 tanpa perubahan.
4. Jalankan verifikasi pasca-migrasi dan fixture sesuai pola change sebelumnya.
5. Siapkan proksi inferensi di lingkungan uji lebih dulu, dengan batas biaya yang sama dengan rencana rilis.

Rollback: penurunan versi tidak didukung. Mematikan jalur ekstraksi tidak memerlukan rollback skema — jalur manual tetap berjalan di atas skema yang sama.

## Open Questions

Satu pertanyaan yang dijawab lewat pekerjaan pada change ini, bukan sebelum: **penyedia model mana yang dipakai**. Jawabannya datang dari evaluasi pada paket kerja evaluasi, bukan dari dugaan, dan tidak mengubah spec, layar, maupun pemecahan task — antarmuka penyedia sudah ditetapkan agar penggantian tidak merembet.
