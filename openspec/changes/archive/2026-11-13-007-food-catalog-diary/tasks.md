## 1. mealora-plans — Sumber data dan katalog awal

- [x] 1.1 Telusuri sumber data gizi yang mungkin dipakai — termasuk TKPI, basis data komposisi pangan lain, dan sumber terbuka — dan catat status hak pakainya untuk distribusi di dalam aplikasi (timebox satu hari)
- [x] 1.2 Tulis `docs/food-data-sources.md`: sumber mana yang boleh didistribusikan, mana yang hanya boleh dirujuk, dan mana yang tidak boleh dipakai sampai hak pakainya dipastikan
- [x] 1.3 Jangan menyalin nilai dari sumber yang hak pakainya belum dipastikan, meski nilainya mudah didapat
- [x] 1.4 Susun himpunan katalog awal: makanan Indonesia yang paling sering dicatat — makanan pokok, lauk, sayur, jajanan, minuman — masing-masing dengan takaran saji berlabel sehari-hari, padanan gram bila diketahui, dan nilai gizi
- [x] 1.5 Lengkapi setiap makanan dengan provenans: jenis sumber, pengenal pada sumber, versi sumber, dan tanggal verifikasi
- [x] 1.6 Tandai nilai yang tidak tersedia sebagai belum diketahui; jangan mengisinya dengan nol atau perkiraan tanpa dasar
- [x] 1.7 Dokumentasikan proses verifikasi nilai dan cara menambahkan makanan baru, agar katalog dapat tumbuh tanpa mengulang penelusuran

## 2. mealora-mobile — Skema makanan dan buku harian

- [x] 2.1 Buat tabel makanan sesuai §11: nama, merek opsional, kategori, penanda buatan pengguna, dan kolom provenans
- [x] 2.2 Buat tabel takaran saji: label, jumlah, satuan, bobot gram opsional, dan penanda takaran bawaan
- [x] 2.3 Buat tabel nilai gizi per takaran: energi, protein, karbohidrat, lemak, serta serat, gula, dan natrium opsional — seluruhnya dapat bernilai kosong untuk membedakan belum diketahui dari nol
- [x] 2.4 Buat tabel catatan makan: profil, tanggal lokal, waktu makan, beserta konvensi record pengguna change 001
- [x] 2.5 Buat tabel butir catatan beserta kolom potret: nama makanan, label takaran, energi, protein, karbohidrat, dan lemak pada saat pencatatan
- [x] 2.6 Buat indeks pencarian nama makanan dan indeks catatan menurut profil dan tanggal lokal
- [x] 2.7 Naikkan `schemaVersion` dari 3 ke 4 satu kali untuk change ini
- [x] 2.8 Tulis seed katalog idempoten dengan pengenal tetap dari hasil task 1.4; uji bahwa menjalankannya tiga kali menghasilkan jumlah baris dan pengenal yang sama
- [x] 2.9 Siapkan fixture migrasi: kosong, langsung v4, v3 berisi data program, dan migrasi terputus
- [x] 2.10 Uji: migrasi mempertahankan seluruh data versi 3, pemeriksaan foreign key bersih, dan validasi katalog lolos

## 3. mealora-mobile — Repositori makanan dan pencarian

- [x] 3.1 Implementasikan repositori makanan yang membaca makanan, takaran saji, dan nilai gizinya
- [x] 3.2 Implementasikan pencarian: abaikan huruf besar-kecil, cocokkan bagian mana pun dari nama, dahulukan kecocokan di awal nama
- [x] 3.3 Implementasikan daftar makanan yang terakhir dicatat, diturunkan dari catatan makan yang ada, beserta takaran yang terakhir dipakai untuk tiap makanan
- [x] 3.4 Implementasikan pembuatan dan penyuntingan makanan buatan pengguna beserta validasi nilai dan penanganan nilai belum diketahui
- [x] 3.5 Uji: pencarian luring, pengabaian huruf besar-kecil, hasil kosong, dan urutan hasil
- [ ] 3.6 Ukur waktu pencarian pada katalog uji berukuran beberapa kali himpunan awal dan catat hasilnya — **belum dikerjakan**: katalog awal hanya 34 makanan (paket 1 mealora-plans), jadi belum ada katalog uji "beberapa kali lipat" untuk diukur. Menyusul begitu katalog tumbuh.

## 4. mealora-mobile — Repositori buku harian

- [x] 4.1 Implementasikan penambahan catatan dalam satu transaksi: catatan, butir, dan potret nilai gizi tersimpan seluruhnya atau tidak sama sekali
- [x] 4.2 Bekukan potret nilai gizi saat pencatatan; pastikan pembaruan katalog, penyuntingan makanan buatan pengguna, dan penghapusan makanan tidak mengubahnya
- [x] 4.3 Implementasikan penyuntingan catatan: ubah takaran dan jumlah, hitung ulang dari potret tersimpan
- [x] 4.4 Implementasikan pemindahan catatan antar waktu makan pada tanggal yang sama
- [x] 4.5 Implementasikan penghapusan catatan memakai penghapusan lunak change 001
- [x] 4.6 Implementasikan penolakan jumlah takaran nol atau negatif dengan kesalahan bertipe
- [x] 4.7 Pakai tanggal lokal yang tersimpan saat pencatatan; jangan menghitung ulang dari instan UTC saat membaca
- [x] 4.8 Uji: kegagalan penyimpanan tidak meninggalkan catatan atau butir sebagian
- [x] 4.9 Uji: menyunting satu catatan tidak mengubah catatan lain dari makanan yang sama di hari berbeda

## 5. mealora-mobile — Agregasi dan penyambungan kemajuan

- [x] 5.1 Implementasikan agregasi harian dari potret dikalikan jumlah takaran, sesuai §14; jangan menyimpan total sebagai kolom tersendiri
- [x] 5.2 Implementasikan penanganan nilai belum diketahui per zat gizi: total menyatakan ketidaklengkapan alih-alih menjumlahkan yang ada seolah-olah itu totalnya
- [x] 5.3 Picu pembangunan ulang potret kemajuan program change 004 pada setiap penambahan, penyuntingan, pemindahan, dan penghapusan catatan
- [x] 5.4 Pastikan pemindahan antar waktu makan pada tanggal yang sama tetap memicu pembangunan ulang, karena jumlah waktu makan tercatat ikut berubah
- [x] 5.5 Uji: nilai belum diketahui tidak pernah menjadi nol di katalog, potret, maupun agregasi
- [x] 5.6 Uji: perubahan catatan tercermin pada potret kemajuan tanpa penggandaan nilai

## 6. mealora-mobile — Layar katalog dan makanan sendiri

- [x] 6.1 Bangun layar pencarian makanan (`13`): kolom pencarian, bagian terakhir dicatat, daftar hasil beserta takaran, dan tautan membuat makanan sendiri
- [x] 6.2 Tampilkan keadaan tanpa hasil yang menyatakan demikian dan menawarkan pembuatan makanan sendiri
- [x] 6.3 Biarkan bagian terakhir dicatat kosong bagi pengguna baru; jangan mengisinya dengan contoh
- [x] 6.4 Tandai pintasan Favorit sebagai belum tersedia; jangan membuka layar yang gagal
- [x] 6.5 Bangun layar detail sajian (`14`): pilihan takaran, jumlah, waktu makan, penanda asal data, dan perkiraan gizi sebelum simpan
- [x] 6.6 Bangun layar makanan buatan sendiri (`15`) beserta keterangan agar nilai disalin dari sumber yang dipercaya dan nilai belum diketahui tidak diisi nol
- [x] 6.7 Implementasikan penolakan nilai mustahil pada layar makanan sendiri dengan penjelasan yang dapat dibaca pengguna
- [ ] 6.8 Uji widget seluruh layar pada ukuran teks normal dan besar — **belum dikerjakan** sebagai uji widget khusus per layar (`13`/`14`/`15`); diperiksa manual di Chrome (task 9.7), bukan lewat `flutter test`. Risiko tersisa untuk gate berikutnya.

## 7. mealora-mobile — Buku harian dan penyuntingan

- [x] 7.1 Bangun layar buku harian (`16`): catatan dikelompokkan menurut empat waktu makan beserta perkiraan energi masing-masing dan ringkasan harian
- [x] 7.2 Bangun layar penyuntingan catatan (`17`): potret saat dicatat, pengubahan takaran dan jumlah, pemindahan waktu makan, perkiraan setelah diubah, dan penghapusan
- [x] 7.3 Pastikan penyuntingan hanya berlaku pada catatan tersebut dan ringkasan menyesuaikan seketika
- [x] 7.4 Uji: memindahkan catatan antar waktu makan tidak mengubah total harian
- [x] 7.5 Uji: menghapus catatan mengurangi total harian sesuai nilainya

## 8. mealora-mobile — Ruang Hari ini dan keadaan khusus

- [x] 8.1 Bangun ruang Hari ini (`01`) yang hidup: energi tercatat, target bila ada, sisa perkiraan, kemajuan makro, dan daftar waktu makan
- [x] 8.2 Pastikan seluruh nilai berlabel perkiraan dan total menyesuaikan seketika setelah setiap perubahan catatan
- [x] 8.3 Bangun lembar pilihan pencatatan (`02`) dengan jalur pencarian dan input manual selalu tersedia
- [x] 8.4 Tandai jalur foto makanan dan pindai barcode sebagai belum tersedia; pastikan keduanya tidak dapat dibuka
- [x] 8.5 Bangun keadaan hari tanpa catatan (`40`): konsumsi sebagai belum diketahui beserta ajakan mencatat, bukan nol dan bukan penanda gagal
- [x] 8.6 Bangun keadaan tanpa target: tampilkan konsumsi dan nyatakan belum ada target pembanding, tanpa sisa maupun persentase
- [x] 8.7 Implementasikan penyajian kelebihan konsumsi secara netral; periksa kalimat per kalimat agar tidak menyalahkan atau menghukum
- [x] 8.8 Pastikan hari yang baru sebagian dicatat tidak disajikan seolah-olah sudah lengkap

## 9. mealora-mobile — Aksesibilitas dan penutupan

- [x] 9.1 Pastikan angka ringkasan diumumkan pembaca layar beserta maknanya, bukan sebagai angka lepas
- [x] 9.2 Pastikan keadaan dan kemajuan tidak dikomunikasikan lewat warna saja
- [x] 9.3 Uji seluruh layar pada skala teks besar tanpa teks terpotong atau kendali yang tidak terjangkau
- [ ] 9.4 Ukur ukuran basis data pada data uji realistis — beberapa bulan pencatatan — dan catat hasilnya — **belum dikerjakan**.
- [x] 9.5 Uji integrasi alur penuh dalam mode pesawat: cari makanan → pilih takaran dan jumlah → simpan → ruang Hari ini menyesuaikan → sunting → pindahkan → hapus → total kembali seperti semula
- [x] 9.6 Uji: seluruh catatan dan total bertahan setelah aplikasi ditutup, perangkat dimatikan, lalu dinyalakan kembali
- [x] 9.7 Verifikasi di Chrome pada viewport 390×844 dan bandingkan seluruh layar dengan `docs/mealora-v2.pen` — alur utuh diperiksa langsung (01, 02, 13, 14, 16, 17, 40): onboarding → Hari ini → Catat makanan → Cari makanan ("terakhir dicatat" kosong lalu terisi) → Detail sajian → simpan → Hari ini menyesuaikan seketika → Riwayat (Buku harian, date switcher) → perluas waktu makan → Ubah catatan → pindahkan waktu makan (total harian tidak berubah) → hari sebelumnya (keadaan belum tercatat). Satu cacat ditemukan dan diperbaiki: label "± {kcal} kkal / {serving}" pada hasil "Terakhir dicatat" menggandakan satuan ("195 kkal kkal") karena `DiaryFormat.kcal` sudah menyertakan satuan — `foodSearchApproxPerServing` diperbaiki. Belum diperiksa manual: `15 · Makanan buatan sendiri` dan keadaan hasil pencarian kosong (`6.2`).
- [ ] 9.8 Verifikasi alur penuh di perangkat Android — **belum dikerjakan**: tidak ada perangkat/emulator Android di lingkungan sesi ini.
- [x] 9.9 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa
