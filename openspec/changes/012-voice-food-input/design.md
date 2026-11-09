# Design — 012 · Masukan makanan lewat suara

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 007 menyediakan katalog dan buku harian; change 010 menyediakan antarmuka penyedia model, proksi inferensi, batas biaya, dan aturan persetujuan untuk gambar; change 011 menyediakan peninjauan komponen, koreksi komponen, dan pencatatan banyak komponen dalam satu transaksi.

Belum ada satu pun layar suara di `docs/mealora-v2.pen`, dan belum ada akses mikrofon.

Assessment §17 menempatkan masukan kalimat bebas sebagai Level 4, dan §50 menyatakannya tetap di luar MVP 1. Pemilik produk memutuskan mempromosikannya. Yang tidak ikut berubah: §23 tetap berlaku — hasil AI selalu berupa perkiraan yang dapat disunting sebelum dicatat, dan tidak pernah disimpan diam-diam sebagai nilai pasti.

## Goals / Non-Goals

**Goals**

- Mencatat makan lengkap dalam satu kalimat, tanpa mengetik.
- Biaya layanan sekecil mungkin, dan nol pada jalur yang paling sering dipakai.
- Tidak ada rekaman suara yang meninggalkan perangkat tanpa pengguna tahu.
- Memakai ulang peninjauan komponen change 011 apa adanya, bukan membuat alur peninjauan kedua.

**Non-Goals**

- Tidak ada percakapan dua arah, perintah suara, atau asisten yang menjawab.
- Tidak ada masukan suara untuk fungsi lain mana pun: berat badan, pengelolaan program, profil, pengaturan, dan navigasi tetap memakai masukan biasa. Mikrofon hanya hidup di jalur pencatatan makanan.
- Tidak ada pengenalan suara penutur, dan tidak ada penyimpanan suara untuk pelatihan model apa pun.
- Tidak ada bahasa selain Indonesia pada evaluasi penguraian; bahasa lain tidak dijanjikan.
- Tidak ada perubahan pada aturan gambar change 010 maupun aturan buku harian change 007.

## Decisions

### D1 — Dua langkah terpisah: ucapan menjadi teks, lalu teks menjadi komponen

Jalur ini bukan satu panggilan "audio masuk, makanan keluar", melainkan dua langkah yang berdiri sendiri: pengenalan ucapan menghasilkan teks, lalu penguraian mengubah teks menjadi komponen.

Pemisahan ini menghasilkan tiga hal sekaligus: pengguna dapat memperbaiki satu kata tanpa merekam ulang; rekaman suara tidak perlu dikirim ke mana pun; dan langkah kedua menjadi masalah teks biasa yang jauh lebih murah dan lebih mudah diuji daripada audio.

### D2 — Pengenalan ucapan di perangkat sebagai jalur utama

Android menyediakan pengenalan ucapan di perangkat, termasuk untuk bahasa Indonesia pada perangkat yang mendukungnya. Itu dipakai lebih dulu: nol biaya, tanpa kuota, tanpa rekaman yang meninggalkan perangkat, dan bekerja tanpa koneksi pada perangkat yang mendukungnya.

Ini juga jawaban paling langsung atas permintaan "pakai kuota gratis": jalur yang paling sering dipakai tidak memanggil layanan berbayar sama sekali.

Ketika perangkat tidak mendukungnya, sistem menyatakannya dan menawarkan pengetikan kalimat. Mengirim rekaman suara ke layanan luar sebagai cadangan **tidak** dilakukan diam-diam — itu memerlukan persetujuan eksplisit untuk pengiriman tersebut, dan pada change ini tidak dibangun sama sekali.

*Alternatif:* langsung mengirim audio ke penyedia model yang mendukung masukan suara. Ditolak sebagai jalur utama: audio adalah jenis masukan termahal di hampir semua penyedia, kuota gratisnya paling mudah berubah, dan rekaman suara adalah data pribadi yang lebih sensitif daripada teks.

### D3 — Penguraian memakai penyedia yang sama dengan change 010 dan 011, dengan masukan teks

Permintaan pemilik produk adalah memakai penyedia yang sama bila memungkinkan. Itu terpenuhi: antarmuka penyedia, proksi inferensi, batas permintaan, dan batas biaya dari change 010 dipakai ulang tanpa perubahan. Yang berbeda hanya jenis masukannya — teks, bukan gambar.

Teks adalah masukan paling murah di seluruh penyedia dan paling mungkin tercakup kuota gratis. Satu kalimat pencatatan hanya berukuran puluhan token, berbanding ribuan token untuk sebuah gambar.

*Catatan kejujuran tentang kuota gratis:* penelusuran menunjukkan ketentuan kuota gratis penyedia berubah-ubah dan sumber pihak ketiga saling bertentangan. Karena itu design ini tidak menyebut angka kuota, tidak menyebut penyedia tertentu, dan tidak menjanjikan bahwa fitur ini gratis selamanya. Yang ditetapkan adalah strukturnya: jalur termahal dihindari, batas biaya proksi berlaku, dan ketika batas terlampaui pengguna diberi tahu dan diarahkan ke jalur manual. Verifikasi kuota dilakukan pada akun proyek yang sebenarnya, sebagai bagian paket evaluasi.

### D4 — Transkrip ditampilkan dan dapat disunting sebelum diurai

Pengenalan ucapan bahasa Indonesia akan tetap keliru pada nama makanan yang tidak lazim. Menampilkan transkrip untuk disunting mengubah kekeliruan itu dari "ulangi seluruh rekaman" menjadi "perbaiki satu kata".

Ini juga titik berhenti yang jujur: pengguna melihat persis apa yang akan dikirim untuk diuraikan, sebelum dikirim.

### D5 — Jumlah yang tidak disebut ditanyakan, bukan ditebak

Orang berkata "tadi makan tempe" tanpa menyebut berapa. Sistem menandai jumlah itu belum ditentukan dan meminta pengguna menetapkannya.

Memakai takaran bawaan sebagai jumlah yang dianggap disetujui adalah cara paling halus untuk memasukkan angka yang tidak pernah dikatakan siapa pun ke dalam buku harian. Satuan tidak baku seperti "sepotong besar" diperlakukan sama: ditandai, lalu pengguna memilih dari takaran yang tersedia.

### D6 — Nilai gizi tetap dari katalog, persis seperti jalur foto

Model penguraian mengusulkan **nama makanan, jumlah, dan satuan**. Nilai gizinya datang dari padanan katalog. Bila model mengembalikan angka gizi, angka itu diabaikan.

Aturan ini sama dengan change 011 D1 dan alasannya sama: model sanggup mengarang angka yang terdengar meyakinkan, dan angka itu tidak punya asal-usul.

### D7 — Peninjauan memakai ulang layar komponen change 011

Setelah penguraian, pengguna mendarat pada peninjauan komponen yang sama dengan jalur foto: padanan makanan, porsi, penambahan, penghapusan, dan penanda ketidakpastian.

Membangun layar peninjauan kedua akan menghasilkan dua tempat yang harus sama-sama benar tentang aturan paling berisiko — nilai dari katalog, tidak ada catatan sebelum konfirmasi, penulisan utuh.

Yang khas suara hanya dua layar baru: rekam suara, dan tinjau transkrip.

### D8 — Rekaman suara dihapus setelah transkrip jadi

Bawaannya menghapus, konsisten dengan retensi gambar change 010 yang juga bawaannya menghapus. Rekaman suara hanya berguna bila pengguna ingin mendengarnya kembali — dan itu kebutuhan yang langka dibanding nilai privasinya.

### D9 — Izin mikrofon diminta saat dipakai, penolakannya bukan jalan buntu

Sama dengan pola izin kamera change 009: izin diminta ketika jalur suara dipilih, disertai penjelasan, dan penolakan mengarahkan ke pengetikan kalimat serta pencarian katalog.

### D10 — Empat layar baru, sudah dirancang

Rancangan sudah ditambahkan ke `docs/mealora-v2.pen` sebagai **Section · 07 / Masukan suara**:

- `42 · Rekam suara` — keadaan siap, memuat contoh ucapan, tombol mikrofon, pernyataan batas cakupan, dan jalur ketik kalimat.
- `43 · Sedang merekam` — penanda perekaman, gelombang suara, transkrip sementara, dan penegasan bahwa suara diproses di perangkat.
- `44 · Tinjau transkrip` — teks yang dapat disunting, penegasan bahwa rekaman sudah dihapus, keterangan bahwa yang dikirim hanya teks, serta rekam ulang dan jalur katalog.
- `45 · Suara tidak tersedia` — izin ditolak atau perangkat tidak mendukung, dengan pengetikan kalimat sebagai jalur setara.

Jalur "Catat dengan suara" ditambahkan pada lembar pilihan pencatatan `02`. Urutan kartu ditetapkan pemilik produk: **Cari / input manual, Catat dengan suara, Foto makanan, Scan barcode**.

Input manual di urutan teratas adalah pilihan yang konsisten dengan prinsip produk: ia satu-satunya jalur yang selalu bekerja — tanpa internet, tanpa izin kamera maupun mikrofon, tanpa kuota layanan, dan tanpa bergantung pada dukungan perangkat. Tiga jalur lain mempercepat, tetapi masing-masing punya keadaan di mana ia tidak tersedia. Menaruh jalur yang paling bisa diandalkan di tempat pertama berarti pengguna tidak pernah menemui jalan buntu di layar ini.

Penanda keadaan merekam tidak bergantung pada warna saja: ada label "Merekam · 0:04", titik penanda, bingkai berbeda, ikon mikrofon, dan gelombang suara yang bergerak. Ini keadaan yang paling penting untuk disadari pengguna, karena mikrofon sedang aktif.

### D11 — Cakupan dikunci pada pencatatan makanan

Jalur suara hanya menerima satu jenis maksud: apa yang dimakan. Ucapan yang berisi permintaan lain tidak dijalankan — sistem menyatakan batasnya dan menunjukkan tempat yang tepat.

Keputusan ini datang dari pemilik produk, dan alasannya kuat secara rancangan. Masukan suara yang menerima perintah apa pun berubah menjadi asisten, dan asisten menuntut hal-hal yang tidak ada di MVP 1: pemahaman maksud yang luas, penanganan salah tafsir yang berisiko mengubah data, dan konfirmasi untuk setiap jenis tindakan. Satu maksud berarti satu bentuk keluaran yang dapat diuji habis, dan salah tafsir paling buruk hanya menghasilkan daftar makanan yang keliru — yang tetap ditinjau sebelum dicatat.

Pengunciannya ditegakkan di dua tempat: perintah penguraian hanya meminta daftar makanan, dan mikrofon tidak tersedia sebagai kendali di layar mana pun selain pencatatan makanan.

### D12 — Tidak ada perubahan skema

Komponen hasil suara masuk ke buku harian lewat jalur yang sama dengan jalur foto, dengan potret nilai gizi yang sama. Transkrip tidak disimpan sebagai catatan tersendiri setelah pencatatan selesai.

## Risks / Trade-offs

- **Pengenalan ucapan di perangkat tidak tersedia atau buruk untuk bahasa Indonesia pada sebagian perangkat** → jalur utama tidak bekerja merata. Mitigasi: pengetikan kalimat sebagai jalur setara yang selalu ada; keadaan "tidak tersedia di perangkat ini" dirancang sejak awal, bukan ditambal.
- **Kuota gratis penyedia berubah atau dicabut** → biaya muncul tanpa diduga. Mitigasi: penguraian memakai teks, masukan termurah; batas biaya proksi berlaku; ketika batas terlampaui pengguna diberi tahu dan diarahkan ke pencarian katalog.
- **Penguraian salah memisahkan makanan** — misalnya "nasi goreng" dipecah menjadi "nasi" dan "goreng" → mitigasi: himpunan uji berisi kalimat nyata berbahasa Indonesia, termasuk nama hidangan majemuk; peninjauan komponen memungkinkan penggabungan lewat penghapusan dan penambahan.
- **Pengguna menyetujui hasil tanpa memeriksa jumlah** → mitigasi: jumlah yang tidak disebut ditandai dan menahan konfirmasi; risiko berkurang, tidak hilang.
- **Mikrofon aktif tanpa disadari** → mitigasi: penanda perekaman yang jelas dan tidak bergantung warna, serta penghentian yang selalu terjangkau.
- **Fitur ini di luar MVP 1 menurut assessment** → menambah lingkup sebelum empat jalur lain terbukti. Mitigasi: change ini tidak memblokir apa pun dan dapat dijadwalkan setelah jalur lain stabil; keputusan urutannya ada pada pemilik produk.

## Migration Plan

Tidak ada perubahan skema dan tidak ada migrasi. Urutan penerapan:

1. Rancangan tiga layar di dokumen desain.
2. Himpunan uji kalimat pencatatan dan evaluasi penguraian.
3. Perekam suara, izin mikrofon, dan pengenalan ucapan di perangkat.
4. Layar rekam suara dan tinjau transkrip.
5. Klien penguraian di atas antarmuka penyedia change 010.
6. Penyambungan ke peninjauan komponen dan pencatatan change 011.

Rollback: murni penambahan satu jalur; membuang commit mengembalikan lembar pilihan pencatatan ke empat jalur tanpa memengaruhi data pengguna.

## Open Questions

Satu pertanyaan yang dijawab lewat pekerjaan pada change ini: **seberapa baik penguraian kalimat pencatatan berbahasa Indonesia pada penyedia yang sudah dipakai**, dan apakah kuota gratis pada akun proyek yang sebenarnya mencukupi. Keduanya diukur pada paket evaluasi, bukan diperkirakan sekarang, dan tidak mengubah spec maupun layar.
