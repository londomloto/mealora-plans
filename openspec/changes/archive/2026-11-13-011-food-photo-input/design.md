# Design — 011 · Masukan foto makanan

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 007 menyediakan katalog, buku harian, dan potret nilai gizi; change 009 menyediakan produk kemasan; change 010 menyediakan seluruh aturan akses gambar — persetujuan, kredensial, batas biaya, penanganan kegagalan, retensi, jalur luring — beserta antarmuka penyedia model dan proksi inferensi.

Batasan yang mengikat dari assessment §50.2: foto tidak dapat memastikan minyak, resep, bahan tersembunyi, maupun massa; nilai ditampilkan sebagai perkiraan dan tidak pernah disajikan sebagai pengukuran; dukungan beberapa makanan dalam satu gambar; penghapusan dan penambahan komponen; penyuntingan jumlah; pembatalan tanpa membuat catatan; nilai gizi tidak diturunkan dari penampilan ketika tidak ada catatan makanan atau resep yang kredibel.

## Goals / Non-Goals

**Goals**

- Mencatat sepiring makanan dengan beberapa komponen menjadi satu alur, bukan empat pencarian terpisah.
- Setiap angka yang masuk ke buku harian tetap berasal dari catatan makanan yang dapat ditelusuri.
- Ketidakpastian terlihat per komponen, bukan disembunyikan di balik satu angka total.
- Kegagalan layanan tidak pernah menghapus pekerjaan pengguna.

**Non-Goals**

- Tidak ada masukan lewat kalimat bebas — tetap di luar MVP 1.
- Tidak ada penghitungan massa dari foto; porsi selalu berupa perkiraan yang dikoreksi pengguna.
- Tidak ada penyimpanan foto ke luar perangkat di luar pengiriman yang disetujui.
- Tidak ada aturan baru tentang gambar; seluruhnya memakai ulang `image-ai-access` dari change 010.

## Decisions

### D1 — Model mengusulkan komponen, katalog yang memberi angka

Pembagian tugas yang tegas: penyedia model mengusulkan **apa** yang ada di piring dan **kira-kira seberapa banyak**; nilai gizinya selalu diambil dari padanan katalog, makanan buatan pengguna, atau produk yang pernah dikonfirmasi.

Ini batas terpenting dalam change ini. Model bahasa-penglihatan dapat menghasilkan angka gizi yang terdengar meyakinkan untuk makanan apa pun, dan angka itu tidak punya asal-usul. §50.2 melarangnya, dan spec menuliskannya sebagai requirement tersendiri dengan skenario "komponen tanpa padanan" → tidak ada nilai gizi yang ditampilkan sama sekali.

Konsekuensi yang diterima: untuk makanan yang belum ada di katalog, pengguna tetap harus memilih atau membuat makanannya. Alur foto memperbaiki pekerjaan menemukan dan mengelompokkan, bukan menghapus kebutuhan akan data yang sah.

### D2 — Memakai ulang `image-ai-access` apa adanya

Persetujuan unggah, larangan kredensial di aplikasi, batas biaya, penanganan kegagalan, retensi gambar, dan jalur luring tidak ditulis ulang di sini. Change ini hanya menambahkan yang khas foto makanan.

Itulah sebabnya kapabilitas itu dipisahkan di change 010 (D1 di sana). Menyalin aturan privasi ke change kedua adalah cara paling mudah membuat keduanya berbeda diam-diam setelah beberapa kali penyuntingan.

### D3 — Satu catatan per komponen, bukan satu catatan gabungan

Empat komponen menghasilkan empat catatan di buku harian, bukan satu catatan "Makan siang dari foto". Alasannya praktis: pengguna sering ingin menghapus satu bahan ("ternyata tempenya tidak saya makan") atau mengubah porsinya saja, dan catatan gabungan memaksa membatalkan seluruhnya.

Seluruh komponen ditulis dalam satu transaksi: berhasil semua atau tidak sama sekali. Setengah piring yang tercatat lebih buruk daripada tidak tercatat sama sekali, karena pengguna tidak punya cara tahu mana yang kurang.

### D4 — Ketidakpastian ditampilkan per komponen, dengan sebab yang spesifik

Rancangan `38` sudah menunjukkan arah ini: "metode masak perlu dicek", "minyak tidak pasti", "tanpa saus". Penanda semacam itu jauh lebih berguna daripada satu label "perkiraan" di atas layar, karena ia memberi tahu pengguna **apa** yang harus ia periksa.

Tiga sumbu ketidakpastian yang ditandai: padanan makanan, porsi, dan metode masak.

### D5 — Bahan tak terlihat ditambahkan sebagai komponen biasa

Minyak, saus, dan gula ditambahkan lewat jalur yang sama dengan komponen lain — pengguna memilih makanannya dari katalog, lalu menetapkan jumlahnya. Tidak ada mekanisme khusus "tambahkan 1 sdm minyak" yang menebak nilainya sendiri.

Konsisten dengan D1: setiap angka berasal dari catatan makanan yang dapat ditelusuri, termasuk angka untuk minyak.

### D6 — Draf foto bertahan melewati kegagalan

Foto yang sudah diambil dan komponen yang sudah diisi disimpan sebagai draf sejak sebelum pengiriman. Kegagalan layanan, kehilangan koneksi, atau penutupan aplikasi tidak menghapusnya.

Rancangan `20` sudah menetapkan nadanya: "Foto tersimpan sebagai draf. Belum ada catatan makan yang dibuat." Dua kalimat itu mengerjakan dua hal sekaligus — menenangkan pengguna soal pekerjaannya, dan menegaskan bahwa tidak ada yang tercatat diam-diam.

### D7 — Evaluasi penyedia untuk foto makanan berdiri sendiri

Hasil evaluasi penyedia untuk label gizi (change 010) tidak dapat dipakai untuk tugas ini: membaca teks tercetak dan mengenali makanan di piring adalah dua kemampuan yang berbeda, dan penyedia yang unggul pada satu belum tentu unggul pada yang lain.

Karena itu himpunan uji tersendiri, 30–50 foto makanan Indonesia berizin sesuai §50.6, dengan metrik yang sesuai: ketepatan identifikasi komponen, kewajaran perkiraan porsi, beban koreksi pengguna, latensi, dan biaya per catatan yang diterima.

Yang diukur bukan "akurasi gizi" — itu tidak bermakna, karena angkanya datang dari katalog, bukan dari model.

### D8 — Tidak ada perubahan skema

Komponen hasil foto masuk ke buku harian lewat jalur yang sama dengan makanan lain, dengan potret nilai gizi yang sama. Draf foto disimpan sebagai berkas di perangkat beserta rujukannya, memakai mekanisme retensi gambar change 010.

Bila sebuah layar membutuhkan kolom baru, itu pertanda layar tersebut menyimpan sesuatu yang belum pernah disetujui aturannya.

## Risks / Trade-offs

- **Pengguna menerima usulan tanpa memeriksa porsi** → ini risiko paling nyata, karena memeriksa porsi lebih sulit daripada memeriksa angka pada label. Mitigasi: penanda ketidakpastian per komponen dengan sebab spesifik, porsi selalu dapat disunting, dan bahasa yang menyatakan porsi perlu dicek. Risiko dikurangi, tidak dihapus — dan itu dinyatakan apa adanya.
- **Katalog kecil membuat banyak komponen tidak punya padanan** → alur foto terasa setengah jalan. Mitigasi: jalur pencarian dan pembuatan makanan tersedia langsung dari peninjauan; pertumbuhan katalog pada change 007 memperbaiki ini tanpa menyentuh change ini.
- **Biaya inferensi foto lebih besar daripada label** karena gambarnya lebih kaya → mitigasi: batas biaya pada proksi berlaku sama; evaluasi mencatat biaya per catatan yang diterima sebagai metrik, bukan catatan kaki.
- **Model mengusulkan makanan yang tidak ada di piring** → mitigasi: penghapusan komponen mudah dijangkau, dan komponen yang dihapus tidak pernah tercatat.
- **Foto makanan memuat orang lain atau tempat** → mitigasi: persetujuan per gambar dan retensi bawaan menghapus, seluruhnya dari change 010.
- **Pengguna mengira aplikasi "tahu" kandungan makanannya** → mitigasi: bahasa peninjauan menyatakan nilai berasal dari padanan katalog, bukan dari foto; diperiksa kalimat per kalimat sebagai bagian gate.

## Migration Plan

Tidak ada perubahan skema dan tidak ada migrasi. Urutan penerapan:

1. Himpunan uji dan evaluasi penyedia untuk pengenalan komponen.
2. Klien pengenalan di atas antarmuka penyedia change 010.
3. Layar foto makanan beserta persetujuan unggah dan jalur manual.
4. Peninjauan komponen dan koreksi komponen.
5. Draf foto dan penanganan kegagalan.
6. Pencatatan banyak komponen dalam satu transaksi.

Rollback: murni penambahan lapisan tampilan dan satu klien; membuang commit mengembalikan jalur foto ke keadaan belum tersedia tanpa memengaruhi data pengguna.

## Open Questions

Satu pertanyaan yang dijawab lewat pekerjaan pada change ini: **penyedia mana yang dipakai untuk pengenalan komponen**. Jawabannya datang dari evaluasi, bukan dugaan, dan tidak mengubah spec maupun layar — antarmuka penyedia sudah ditetapkan di change 010. Perlu ditegaskan sekali lagi agar tidak disalahpahami: hasil evaluasi label tidak berlaku untuk tugas ini.
