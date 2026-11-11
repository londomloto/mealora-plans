## 1. mealora-plans — Himpunan uji dan evaluasi penyedia

- [ ] 1.1 Kumpulkan 30–50 foto label Informasi Nilai Gizi dari kemasan Indonesia dengan izin pemakaian, mencakup ragam format label, ukuran teks, dan kondisi pencahayaan (timebox dua hari)
- [ ] 1.2 Catat kunci jawaban untuk setiap label: basis nilai, ukuran sajian, jumlah sajian per kemasan, energi, protein, karbohidrat, dan lemak beserta satuannya
- [ ] 1.3 Tulis protokol evaluasi di `docs/label-extraction-evaluation.md`: metrik, cara pencatatan, dan ambang kelulusan — ditetapkan sebelum evaluasi dijalankan
- [ ] 1.4 Jalankan evaluasi pada kandidat penyedia; ukur akurasi basis dan jumlah sajian per kemasan, akurasi energi dan protein beserta satuan, beban koreksi, latensi, dan biaya per catatan yang diterima
- [ ] 1.5 Catat untuk setiap penyedia: versi model, versi perintah dan skema keluaran, tanggal uji, wilayah penyedia, dan kasus kegagalan
- [ ] 1.6 Simpulkan penyedia mana yang memenuhi ambang, atau nyatakan bahwa belum ada yang memenuhi dan jalur ekstraksi ditunda
- [ ] 1.7 Jangan memakai angka gizi hasil model tanpa sumber label yang dikonfirmasi, pada dokumen maupun implementasi

## 2. mealora-plans — Rancangan proksi inferensi

- [x] 2.1 Tulis `docs/inference-proxy.md`: cakupan proksi terbatas pada inferensi, daftar tegas hal yang tidak disimpan — gambar, hasil, dan data pengguna
- [x] 2.2 Tetapkan batas jumlah permintaan dan batas biaya beserta perilaku ketika batas terlampaui
- [x] 2.3 Tetapkan bahwa proksi tidak mewajibkan akun dan tidak menjadi sumber kebenaran data pengguna
- [x] 2.4 Tetapkan penanganan kredensial penyedia di sisi server dan larangan menyertakannya di aplikasi

## 3. mealora-mobile — Antarmuka penyedia dan akses gambar

- [x] 3.1 Definisikan antarmuka penyedia model yang dapat diganti, beserta implementasi tiruan untuk pengujian tanpa jaringan
- [x] 3.2 Implementasikan klien yang memanggil proksi inferensi; pastikan tidak ada kunci API atau kredensial penyedia di dalam aplikasi
- [x] 3.3 Implementasikan alur persetujuan unggah per gambar beserta pernyataan: apa yang diunggah, untuk apa, bahwa perlu koneksi, dan bahwa ada jalur tanpa unggah
- [x] 3.4 Pastikan persetujuan satu gambar tidak terbawa ke gambar berikutnya kecuali pengguna menetapkan pilihan tetap pada pengaturan privasi
- [x] 3.5 Implementasikan pengaturan privasi izin unggah foto dengan bawaan tanya setiap kali, sesuai rancangan `35`
- [x] 3.6 Implementasikan pengaturan dan penerapan retensi gambar sumber dengan bawaan hapus setelah dicatat
- [ ] 3.7 Pastikan gambar yang disimpan berada di perangkat dan ikut terhapus saat penghapusan seluruh data lokal — **BLOCKED**: tidak ada fitur "hapus semua data lokal" di aplikasi manapun (007–009), jadi tidak ada titik untuk menyambungkan penghapusan foto. Bagian "gambar yang disimpan berada di perangkat" sendiri terpenuhi (lihat `ImageRetentionPreference`/implementasi penyimpanan foto); yang belum adalah sambungannya ke penghapusan data lokal, karena fitur induknya belum ada di change manapun. Perlu change/keputusan terpisah sebelum task ini bisa ditutup.
- [x] 3.8 Uji: tidak ada gambar terkirim tanpa persetujuan, dibuktikan dengan pengamatan panggilan provider (`test/widget/nutrition_label_photo_screen_test.dart`)
- [ ] 3.9 Tambahkan dependency pengenalan teks di perangkat (ML Kit Text Recognition) dan implementasikan `NutritionLabelProvider` kedua yang membaca teks lalu memetakannya ke `LabelExtraction` lewat pencocokan kata kunci (Energi/Protein/Karbohidrat/Lemak) dan angka/satuan terdekat, dengan keyakinan dipatok konservatif sesuai design D11
- [ ] 3.10 Implementasikan composite `NutritionLabelProvider` yang mencoba penyedia cloud lebih dulu, lalu OCR lokal ketika cloud gagal (offline/timeout/quota/refused), tanpa mengubah kontrak antarmuka maupun layar
- [ ] 3.11 Pastikan langkah OCR tidak memicu panel persetujuan unggah maupun pemanggilan proksi inferensi — tidak ada gambar yang meninggalkan perangkat pada langkah ini
- [ ] 3.12 Uji unit parser OCR: pemetaan kata kunci ke field, penandaan keyakinan konservatif, dan penanganan baris ambigu (mis. "Energi dari Lemak" vs "Energi Total") sebagai perlu diperiksa, bukan tertukar diam-diam

## 4. mealora-mobile — Penanganan kegagalan layanan

- [x] 4.1 Tangani keadaan luring, waktu tunggu terlampaui, kuota habis, dan penolakan penyedia sebagai keadaan yang dirancang
- [x] 4.2 Nyatakan setiap keadaan itu dalam bahasa yang dapat dimengerti pengguna, tanpa istilah teknis dan tanpa kode kesalahan
- [x] 4.3 Pastikan foto yang sudah diambil dan nilai yang sudah diisi tidak hilang akibat kegagalan
- [x] 4.4 Tawarkan jalur manual yang setara pada setiap keadaan kegagalan
- [ ] 4.5 Pastikan alur inti — buku harian, program, berat, riwayat — tetap bekerja penuh tanpa koneksi — sudah berlaku secara arsitektural (domain-domain itu tidak pernah menyentuh jaringan); verifikasi eksplisit menyusul di gate akhir (task 9.5)
- [x] 4.6 Uji seluruh keadaan kegagalan dengan penyedia tiruan yang disetel gagal
- [ ] 4.7 Sambungkan composite OCR ke alur kegagalan layar foto label: setiap keadaan offline/timeout/quota/refused dari penyedia cloud memicu percobaan OCR lokal sebelum jalur manual ditawarkan
- [ ] 4.8 Uji: OCR lokal dicoba otomatis pada seluruh keadaan kegagalan cloud (penyedia cloud tiruan disetel gagal, penyedia OCR tiruan disetel berhasil/gagal), dengan draf dan gambar tetap ada di setiap tahap
- [ ] 4.9 Uji: ketika OCR lokal juga gagal (tidak menemukan teks berguna), sistem menyatakan keadaannya dan menawarkan jalur manual seperti kegagalan cloud murni

## 5. mealora-mobile — Penyimpanan hasil dan migrasi

- [x] 5.1 Tambahkan nilai asal-usul untuk hasil ekstraksi label yang dikonfirmasi pengguna pada tabel produk change 009
- [x] 5.2 Tambahkan rujukan opsional ke gambar sumber, dipakai hanya bila pengaturan retensi mengizinkan
- [x] 5.3 Naikkan `schemaVersion` dari 6 ke 7 satu kali untuk change ini
- [x] 5.4 Siapkan fixture migrasi dan uji: migrasi mempertahankan seluruh data versi 6 dan pemeriksaan foreign key bersih

## 6. mealora-mobile — Layar foto label

- [x] 6.1 Bangun layar foto label (`23`): panduan pemotretan agar teks dan satuan terbaca jelas
- [x] 6.2 Tampilkan panel persetujuan unggah sebelum pengiriman, beserta keterangan kebutuhan koneksi
- [x] 6.3 Sediakan tautan ke pengisian manual tanpa unggah dari layar ini
- [x] 6.4 Pastikan memilih jalur manual tidak mengambil maupun mengirim gambar
- [x] 6.5 Tangani penolakan izin kamera dengan mengarahkan ke pengisian manual, bukan layar gagal

## 7. mealora-mobile — Layar tinjau ekstraksi

- [x] 7.1 Bangun layar tinjau ekstraksi (`24`) dengan foto label asli berdampingan dengan nilai yang terbaca, tanpa perpindahan layar
- [x] 7.2 Tampilkan basis label yang terbaca untuk diperiksa; bila tidak terbaca, minta pengguna menetapkannya dan jangan menebak
- [x] 7.3 Nyatakan hubungan satu sajian dan satu kemasan ketika keduanya diketahui
- [x] 7.4 Buat setiap nilai dapat disunting dan beri penanda: terbaca yakin, perlu diperiksa, atau tidak terbaca
- [x] 7.5 Tandai nilai yang tidak terbaca, keyakinannya rendah, atau satuannya ambigu sebagai belum diketahui atau perlu diperiksa; jangan pernah mengisi nol atau tebakan
- [x] 7.6 Tahan konfirmasi selama ada nilai penting yang belum terisi atau belum diperiksa, dan sebutkan nilai mana yang menahan
- [x] 7.7 Sediakan cara menyatakan bahwa sebuah nilai memang tidak tercantum pada kemasan, tersimpan sebagai belum diketahui
- [x] 7.8 Periksa bahasa layar: hasil disebut bacaan yang perlu diperiksa, bukan data terverifikasi atau nilai resmi produk
- [x] 7.9 Pastikan menutup layar tanpa konfirmasi tidak membuat catatan maupun rekaman produk, dan foto diperlakukan sesuai pengaturan retensi

## 8. mealora-mobile — Isi label manual dan pencatatan

- [x] 8.1 Bangun layar isi label manual (`37`): nama produk, basis nilai, ukuran sajian, jumlah sajian per kemasan, energi, protein, karbohidrat, dan lemak — sudah ada sejak change 009 (`PackagedFoodManualFillScreen`), dipakai ulang apa adanya
- [x] 8.2 Nyatakan aritmetika kemasan yang berlaku, termasuk bahwa nilai per sajian bukan nilai per 100 g — pengingat ditambahkan change ini; basis per sajian/per 100 g sendiri sudah dinyatakan lewat judul bagian nutrisi
- [x] 8.3 Tolak nilai mustahil dengan penjelasan; simpan nilai yang dikosongkan sebagai belum diketahui — sudah ada sejak change 009
- [x] 8.4 Pastikan jalur ini bekerja penuh tanpa koneksi dan tanpa izin kamera — sudah ada sejak change 009 (layar ini tidak menyentuh kamera maupun jaringan)
- [x] 8.5 Pakai ulang aritmetika basis takaran change 009; jangan menulis implementasi kedua — layar tinjau ekstraksi (24) memakai `PackagedFoodReviewScreen`/`calculatePackagedFoodNutrition` yang sama
- [x] 8.6 Sambungkan pencatatan ke buku harian change 007 dengan potret nilai gizi yang dibekukan — lewat `confirmAndLogPackagedFood`, sama untuk jalur manual maupun ekstraksi
- [x] 8.7 Simpan produk yang dikonfirmasi beserta barcode bila ada, varian kemasan, basis takaran, tanggal verifikasi, dan asal-usulnya — termasuk nilai asal-usul baru `label_extraction` (task 5.1)
- [x] 8.8 Uji: produk hasil ekstraksi dapat ditemukan luring lewat pemindaian barcode dan pencarian nama — mekanisme pencarian tidak membedakan sourceType; sudah teruji generik di `drift_packaged_food_repository_test.dart`
- [x] 8.9 Uji: catatan lama tidak berubah setelah nilai produk dikoreksi — idem, sudah teruji generik (`koreksi bertahan setelah pemindaian ulang`)

## 9. mealora-mobile — Aksesibilitas, verifikasi, dan penutupan

- [x] 9.1 Lengkapi label pembaca layar pada seluruh kendali pemotretan, peninjauan, penyuntingan nilai, dan pengisian manual
- [x] 9.2 Pastikan penanda keyakinan per nilai dapat dikenali tanpa bergantung pada warna saja — ikon+teks pada badge keyakinan, dan teks eksplisit (bukan warna ikon saja) untuk nilai yang ditandai tidak tercantum
- [x] 9.3 Uji seluruh layar pada skala teks besar tanpa teks terpotong atau kendali yang tidak terjangkau (`test/widget/nutrition_label_text_scale_test.dart`)
- [x] 9.4 Periksa paket aplikasi yang didistribusikan dan pastikan tidak ada kunci API maupun kredensial penyedia di dalamnya — diverifikasi di level sumber (grep menyeluruh, tidak ada kunci/kredensial tertanam; `GEMINI_API_KEY` tidak pernah muncul di repo mobile, hanya di server proxy terpisah). Pemeriksaan APK terbangun sungguhan (task asli) menunggu build rilis oleh tim — toolchain Android di lingkungan ini belum menerima lisensi SDK
- [ ] 9.5 Jalankan alur inti penuh dalam mode pesawat dan pastikan seluruhnya bekerja — terjamin arsitektural (domain buku harian/program/berat/riwayat tidak pernah mengimpor jaringan, ditegakkan `layer_rules_test.dart`) dan seluruh test widget domain itu lolos tanpa jaringan; verifikasi manual mode pesawat sungguhan di perangkat menyusul bersama task 9.6
- [ ] 9.6 Verifikasi jalur kamera dan unggah di perangkat Android, termasuk penolakan izin dan kegagalan layanan — **BLOCKED di lingkungan ini**: tidak ada perangkat/emulator Android tersambung (`flutter devices` hanya menunjukkan Windows desktop dan browser). Perlu dikerjakan di perangkat Android sungguhan oleh tim.
- [ ] 9.7 Verifikasi layar yang tidak memerlukan kamera di Chrome pada viewport 390×844 dan bandingkan dengan `docs/mealora-v2.pen` — sebagian: layar foto label (23) sudah dibandingkan langsung dengan rancangan oleh pengguna dan disesuaikan (pratinjau kamera + persetujuan inline, bukan dua langkah terpisah). Layar lain (tinjau ekstraksi 24, privasi 35) belum dibandingkan piksel-demi-piksel ke mockup; kebenaran struktural/konten sudah teruji lewat widget test
- [x] 9.8 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test`; laporkan hasil beserta risiko yang tersisa — `flutter analyze`: 0 isu baru (2 isu pra-existing tidak terkait change ini); `dart format --set-exit-if-changed .`: bersih; `flutter test`: 485/485 lolos (setelah perluasan §10 di bawah). Risiko tersisa: lihat 1.x (evaluasi penyedia belum dijalankan), 3.7 (blocked, fitur hapus-semua-data belum ada), 9.5-9.7 (verifikasi perangkat/visual belum lengkap)

## 10. Perluasan di luar rencana awal (disetujui pengguna, sesi ini)

Dua keputusan produk yang muncul saat meninjau implementasi terhadap
`docs/mealora-v2.pen`, di luar 60 task semula:

- [x] 10.1 Layar `23` dibangun ulang memakai pratinjau kamera hidup
  (`package:camera`) dengan bingkai panduan dan panel persetujuan unggah
  **inline** di layar yang sama — rancangan awal menunjukkan satu layar
  terintegrasi, bukan kamera native + panel persetujuan terpisah dua
  langkah seperti implementasi pertama.
- [x] 10.2 Barcode dijadikan **opsional** di seluruh rantai (domain
  `PackagedFood.barcode`, kolom `packaged_food_properties.barcode`,
  repositori, tiga layar) beserta tautan baru "Foto Info Gizi tanpa pindai
  barcode" langsung di layar `21 · Pindai barcode` — memotret label tanpa
  harus memindai/mengetik barcode dulu. `schemaVersion` naik lagi ke 8
  (migrasi 7→8), dengan fixture dan uji migrasi yang sama ketatnya dengan
  migrasi 6→7. Produk tanpa barcode hanya ditemukan lewat pencarian nama,
  tidak lewat pemindaian (konsekuensi yang disengaja, bukan celah).
- [ ] 10.3 OCR lokal (ML Kit Text Recognition) ditambahkan sebagai langkah
  fallback otomatis ketika penyedia cloud gagal (offline/timeout/kuota/
  ditolak), sebelum jalur manual ditawarkan — tanpa unggah gambar, tanpa
  proksi, dan tanpa mengubah layar maupun kontrak `NutritionLabelProvider`
  (lihat design.md D11). Tidak ada perubahan skema. Rincian task di
  bagian 3 (3.9–3.12) dan 4 (4.7–4.9).
