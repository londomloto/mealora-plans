# 011 · Masukan foto makanan

## Why

Tiga jalur pencatatan sudah tersedia setelah change 007, 009, dan 010: pencarian katalog, barcode, dan label gizi. Semuanya bekerja baik untuk makanan yang punya nama atau kemasan — dan semuanya merepotkan untuk sepiring nasi dengan ayam bakar, tempe, dan lalapan, yang harus dicatat sebagai empat pencarian terpisah.

Foto menutup celah itu: satu jepretan mengusulkan seluruh komponen di piring, dan pengguna tinggal memeriksa serta mengoreksi. Assessment §50.2 menjadikannya jalur masukan MVP 1 dengan batas yang tegas — foto tidak dapat mengetahui minyak, resep, bahan tersembunyi, atau massa yang sebenarnya, sehingga seluruh hasilnya adalah perkiraan yang wajib ditinjau.

Change ini menutup MVP 1: setelah ini, pengguna dapat mencatat secara manual, lewat barcode, lewat label gizi, dan lewat foto makanan.

Rancangannya sudah ada di `docs/mealora.pen`: `19 · Foto makanan & izin`, `20 · Foto offline / AI gagal`, `03 · Tinjau foto makanan`, dan `38 · Koreksi komponen foto`.

## What Changes

- **Pemotretan makanan** (`19`) beserta panel persetujuan unggah, mengikuti aturan gambar yang sudah ditetapkan change 010.
- **Usulan komponen** dari foto: beberapa makanan dalam satu gambar, masing-masing dengan kemungkinan padanan katalog dan perkiraan porsi.
- **Tinjau foto makanan** (`03`): daftar komponen yang dapat diubah, perkiraan total, dan penegasan bahwa porsi perlu dicek.
- **Koreksi komponen** (`38`): mengubah padanan makanan, porsi, dan metode masak; menambah bahan, minyak, atau saus yang tidak terlihat; serta menghapus komponen yang salah.
- **Nilai gizi selalu berasal dari padanan katalog atau resep**, tidak pernah diturunkan dari penampilan makanan.
- **Ketidakpastian dinyatakan per komponen**: porsi yang perlu dicek, metode masak yang belum pasti, minyak yang tidak diketahui — seperti yang sudah dirancang di `38`.
- **Draf foto tidak hilang** (`20`): ketika luring, kuota habis, atau layanan gagal, foto tersimpan sebagai draf dan pengguna diarahkan ke pemilihan manual tanpa kehilangan apa pun.
- **Pembatalan tidak pernah membuat catatan**, dan gambar diperlakukan sesuai pengaturan retensi.
- **Satu catatan per komponen** di buku harian, sehingga tiap bahan dapat disunting dan dihapus sendiri sesudahnya.
- **Evaluasi penyedia untuk foto makanan** sebagai gerbang tersendiri, dengan himpunan uji makanan Indonesia — bukan memakai hasil evaluasi label.

## Capabilities

### New Capabilities

- `food-photo-input`: mengusulkan komponen makanan dari sebuah foto, meminta pengguna memeriksa dan mengoreksi setiap komponen beserta porsinya, lalu mencatatnya sebagai makanan biasa di buku harian — dengan nilai gizi yang selalu berasal dari catatan makanan yang dapat ditelusuri.

### Modified Capabilities

Tidak ada. `image-ai-access` dari change 010 dipakai apa adanya — persetujuan, kredensial, batas biaya, penanganan kegagalan, retensi gambar, dan jalur luring berlaku sama tanpa penulisan ulang.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: layar foto makanan, tinjau komponen, koreksi komponen, dan draf foto gagal; penyambungan ke penyedia model lewat antarmuka change 010; penyimpanan draf foto; pencatatan banyak komponen dalam satu transaksi.
- **Repo `mealora-plans`**: himpunan uji foto makanan Indonesia beserta hasil evaluasi penyedia untuk tugas ini.
- **Bergantung pada** change 007 (katalog, buku harian, potret nilai gizi) dan 010 (seluruh aturan akses gambar, antarmuka penyedia, proksi inferensi).
- **Menutup MVP 1**: setelah change ini, seluruh definisi MVP 1 pada assessment §50.7 terpenuhi — pencatatan manual, barcode, label gizi, dan foto makanan.
- **Belum tersentuh**: masukan lewat kalimat bebas, yang tetap berada di luar MVP 1.
- **Gerbang sebelum rilis**: evaluasi penyedia untuk pengenalan komponen makanan, dengan himpunan uji foto makanan Indonesia yang berizin, sesuai §50.6.
