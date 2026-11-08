## 1. mealora-plans — Rancangan layar suara

- [x] 1.1 Rancang layar rekam suara di `docs/mealora.pen` lewat MCP pen.dev — dikerjakan sebagai `42 · Rekam suara` (siap) dan `43 · Sedang merekam`
- [x] 1.2 Pastikan keadaan sedang merekam dapat dikenali tanpa bergantung pada warna saja, dan cara menghentikannya selalu terjangkau — ditandai lewat label "Merekam · 0:04", titik, bingkai, ikon mikrofon, dan gelombang suara
- [x] 1.3 Rancang layar tinjau transkrip — dikerjakan sebagai `44 · Tinjau transkrip` beserta tindakan urai, rekam ulang, dan jalur katalog
- [x] 1.4 Tambahkan jalur suara pada lembar pilihan pencatatan (`02`) yang semula memuat tiga jalur — lembar ditinggikan menjadi 586, urutan kartu ditetapkan pemilik produk: Cari / input manual, Catat dengan suara, Foto makanan, Scan barcode
- [x] 1.5 Pastikan rancangan menyatakan bahwa jalur suara hanya untuk mencatat makanan — dinyatakan pada `42` dan `45`
- [x] 1.6 Rancang keadaan suara tidak tersedia — dikerjakan sebagai `45 · Suara tidak tersedia`, memuat izin ditolak, perangkat tidak mendukung, dan pengetikan kalimat
- [ ] 1.7 Tinjau keempat layar bersama pemilik produk sebelum implementasi dimulai

## 2. mealora-plans — Himpunan uji dan evaluasi penguraian

- [ ] 2.1 Susun 50–80 kalimat pencatatan berbahasa Indonesia yang nyata, mencakup beberapa makanan dalam satu kalimat, hidangan majemuk seperti nasi goreng dan soto ayam, jumlah yang tidak disebut, dan satuan tidak baku
- [ ] 2.2 Sertakan kalimat di luar cakupan — permintaan mencatat berat, mengganti program, membuka pengaturan — untuk menguji penolakan
- [ ] 2.3 Catat kunci jawaban tiap kalimat: daftar makanan, jumlah, dan satuan yang benar
- [ ] 2.4 Tulis protokol evaluasi di `docs/voice-parsing-evaluation.md` beserta ambang kelulusan, ditetapkan sebelum evaluasi dijalankan
- [ ] 2.5 Jalankan evaluasi pada penyedia yang sudah dipakai change 010 dan 011 dengan masukan teks; ukur ketepatan pemisahan makanan, ketepatan jumlah dan satuan, serta perilaku pada kalimat di luar cakupan
- [ ] 2.6 Verifikasi kuota dan biaya nyata per kalimat pada akun proyek yang sebenarnya; jangan mengutip angka kuota dari dokumentasi atau sumber pihak ketiga
- [ ] 2.7 Catat versi model, versi perintah dan skema keluaran, tanggal uji, wilayah penyedia, dan kasus kegagalan

## 3. mealora-mobile — Perekam dan pengenalan ucapan

- [ ] 3.1 Implementasikan perekam suara beserta permintaan izin mikrofon yang hanya muncul ketika jalur suara dipilih, disertai penjelasan
- [ ] 3.2 Tangani penolakan izin mikrofon dengan mengarahkan ke pengetikan kalimat dan pencarian katalog, bukan layar gagal
- [ ] 3.3 Implementasikan pengenalan ucapan di perangkat untuk bahasa Indonesia (timebox satu hari)
- [ ] 3.4 Tangani keadaan perangkat tidak mendukung pengenalan ucapan dengan pernyataan yang jelas dan tawaran pengetikan kalimat
- [ ] 3.5 Pastikan tidak ada rekaman suara yang dikirim ke layanan mana pun pada jalur pengenalan di perangkat
- [ ] 3.6 Tangani hasil pengenalan kosong dengan tawaran rekam ulang atau ketik, tanpa membuat catatan
- [ ] 3.7 Implementasikan penghapusan rekaman suara setelah transkrip dihasilkan, dengan bawaan menghapus, mengikuti pola retensi change 010
- [ ] 3.8 Uji: izin mikrofon tidak diminta ketika pengguna hanya membuka pilihan cara pencatatan

## 4. mealora-mobile — Layar rekam dan transkrip

- [ ] 4.1 Bangun layar rekam suara sesuai rancangan task 1.1 dengan ketiga keadaannya
- [ ] 4.2 Tandai keadaan sedang merekam tanpa bergantung pada warna saja dan sediakan penghentian yang mudah dijangkau
- [ ] 4.3 Bangun layar tinjau transkrip dengan teks yang dapat disunting sebelum diurai
- [ ] 4.4 Nyatakan bahwa teks adalah hasil pengenalan yang dapat keliru
- [ ] 4.5 Sediakan tindakan rekam ulang dan ketik kalimat dari layar ini
- [ ] 4.6 Pastikan jalur ketik kalimat bekerja tanpa izin mikrofon dan tanpa pengenalan ucapan
- [ ] 4.7 Tambahkan jalur suara pada lembar pilihan pencatatan (`02`) sesuai rancangan task 1.4
- [ ] 4.8 Uji widget seluruh layar pada ukuran teks normal dan besar

## 5. mealora-mobile — Penguraian kalimat

- [ ] 5.1 Implementasikan klien penguraian teks di atas antarmuka penyedia change 010; pakai ulang proksi, batas permintaan, dan batas biaya apa adanya
- [ ] 5.2 Pastikan yang dikirim hanyalah teks transkrip — tidak pernah rekaman suara
- [ ] 5.3 Susun perintah penguraian yang hanya meminta daftar makanan beserta jumlah dan satuan; jangan meminta nilai gizi
- [ ] 5.4 Abaikan nilai gizi apa pun yang muncul pada keluaran model
- [ ] 5.5 Sediakan implementasi tiruan penyedia untuk pengujian tanpa jaringan, termasuk mode gagal
- [ ] 5.6 Tangani keadaan penguraian tidak tersedia — luring, kuota habis, waktu tunggu lewat, penolakan — dengan bahasa yang dapat dimengerti, mempertahankan teks yang sudah ada, dan menawarkan pencarian katalog
- [ ] 5.7 Uji: keluaran model yang memuat angka gizi tidak pernah masuk ke nilai komponen

## 6. mealora-mobile — Batas cakupan

- [ ] 6.1 Implementasikan penolakan permintaan di luar pencatatan makanan: nyatakan bahwa suara hanya untuk mencatat makanan dan tunjukkan tempat yang tepat
- [ ] 6.2 Pastikan ucapan bercampur hanya diuraikan bagian makanannya, tanpa menjalankan perintah apa pun
- [ ] 6.3 Pastikan tidak ada kendali masukan suara pada layar berat badan, program, profil, pengaturan, maupun navigasi
- [ ] 6.4 Pastikan mikrofon hanya aktif pada jalur pencatatan makanan
- [ ] 6.5 Uji dengan kalimat di luar cakupan dari himpunan uji task 2.2: tidak ada data yang berubah dan batas cakupan dinyatakan

## 7. mealora-mobile — Jumlah, satuan, dan pencatatan

- [ ] 7.1 Tandai jumlah yang tidak disebut pengguna sebagai belum ditentukan dan tahan konfirmasi sampai ia menetapkannya
- [ ] 7.2 Jangan menebak jumlah dan jangan memakai takaran bawaan sebagai jumlah yang dianggap disetujui
- [ ] 7.3 Tandai satuan tidak baku sebagai perlu ditetapkan dan tawarkan takaran yang tersedia untuk makanan itu
- [ ] 7.4 Padankan setiap makanan hasil penguraian ke katalog, makanan buatan pengguna, atau produk yang pernah dikonfirmasi
- [ ] 7.5 Untuk makanan tanpa padanan yang memadai, minta pengguna mencari atau membuatnya dan jangan tampilkan nilai gizi apa pun
- [ ] 7.6 Sambungkan ke layar peninjauan komponen change 011; jangan membangun layar peninjauan kedua
- [ ] 7.7 Sambungkan pencatatan ke jalur change 011: satu catatan per makanan dalam satu transaksi, dengan potret nilai gizi dibekukan
- [ ] 7.8 Uji: kegagalan pada komponen terakhir tidak menyisakan satu pun catatan
- [ ] 7.9 Uji: menutup peninjauan tanpa konfirmasi tidak membuat catatan apa pun

## 8. mealora-mobile — Aksesibilitas, verifikasi, dan penutupan

- [ ] 8.1 Pastikan keadaan sedang merekam diumumkan pembaca layar, beserta cara menghentikannya
- [ ] 8.2 Lengkapi label pembaca layar pada seluruh kendali rekam, transkrip, dan peninjauan
- [ ] 8.3 Uji seluruh layar pada skala teks besar tanpa teks terpotong atau kendali yang tidak terjangkau
- [ ] 8.4 Periksa bahasa seluruh layar: hasil pengenalan dan penguraian disebut perkiraan yang perlu diperiksa
- [ ] 8.5 Amati lalu lintas jaringan: tidak ada rekaman suara yang keluar dari perangkat, dan penguraian hanya mengirim teks
- [ ] 8.6 Verifikasi di perangkat Android: izin mikrofon, pengenalan ucapan bahasa Indonesia, penolakan izin, dan kegagalan penguraian
- [ ] 8.7 Verifikasi layar yang tidak memerlukan mikrofon di Chrome pada viewport 390×844 dan bandingkan dengan `docs/mealora.pen`
- [ ] 8.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
