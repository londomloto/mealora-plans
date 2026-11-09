# 012 · Masukan makanan lewat suara

## Why

Empat jalur pencatatan sudah terencana — pencarian katalog, barcode, label gizi, dan foto makanan — dan seluruhnya menuntut tangan: mengetik nama, mengarahkan kamera, memilih takaran. Padahal momen paling alami untuk mencatat adalah tepat setelah makan, ketika tangan sedang kotor, sedang menyetir, atau sekadar malas mengetik.

Berbicara menghapus seluruh gesekan itu: "tadi makan nasi satu piring, ayam bakar satu potong, sama tempe dua" selesai dalam lima detik, dan sisanya tinggal memeriksa.

Catatan penting soal cakupan: assessment §50 menyatakan masukan kalimat bebas tetap berada di luar MVP 1. Change ini **mempromosikannya ke dalam MVP 1** atas keputusan pemilik produk. Yang berubah hanyalah urutan pengerjaan — seluruh batas keselamatan tetap berlaku: nilai gizi berasal dari katalog, bukan dari model, dan tidak ada catatan yang dibuat tanpa pengguna memeriksanya.

## What Changes

- **Merekam ucapan** sebagai jalur pencatatan baru pada lembar pilihan pencatatan, di samping foto, barcode, dan pencarian.
- **Batas cakupan yang tegas**: suara hanya untuk mencatat apa yang dimakan. Tidak ada masukan suara untuk berat badan, pengelolaan program, profil, pengaturan, maupun navigasi aplikasi — dan tidak ada kendali mikrofon di layar-layar itu.
- **Pengubahan ucapan menjadi teks di perangkat** sebagai jalur utama: tanpa biaya, tanpa kuota, dan bekerja tanpa koneksi pada perangkat yang mendukungnya.
- **Transkrip yang dapat disunting** sebelum diurai, karena memperbaiki satu kata jauh lebih murah daripada mengulang seluruh rekaman.
- **Penguraian kalimat menjadi komponen makanan** — nama makanan, jumlah, dan satuan — memakai penyedia model yang sama dengan change 010 dan 011, dengan masukan berupa **teks**, bukan audio.
- **Peninjauan komponen** memakai ulang alur yang sudah ada pada change 011: padanan katalog, koreksi porsi, penambahan dan penghapusan komponen.
- **Nilai gizi selalu dari padanan katalog**, tidak pernah dari keluaran model — aturan yang sama dengan jalur foto.
- **Izin mikrofon** diminta saat jalur ini dipilih, disertai penjelasan, dan penolakannya tidak pernah menjadi jalan buntu.
- **Rekaman suara tidak disimpan** setelah transkrip jadi, kecuali pengguna menetapkan sebaliknya; bawaannya menghapus.
- **Jalur ketik kalimat** tersedia untuk pengguna yang tidak dapat atau tidak ingin berbicara, dan untuk perangkat tanpa pengenalan ucapan.
- **Rancangan layar baru**: belum ada satu pun layar suara di `docs/mealora-v2.pen`. Change ini merancang rekam suara, tinjau transkrip, dan penambahan jalur suara pada lembar pilihan pencatatan.

## Capabilities

### New Capabilities

- `voice-food-input`: mencatat makanan dengan berbicara — merekam ucapan, mengubahnya menjadi teks yang dapat disunting, menguraikannya menjadi komponen makanan yang ditinjau pengguna, lalu mencatatnya lewat jalur buku harian yang sama dengan makanan lain.

### Modified Capabilities

Tidak ada. `image-ai-access` dari change 010 menetapkan aturan untuk gambar; change ini menetapkan aturan setara untuk audio dan teks ucapan, karena jenis datanya berbeda dan persetujuan serta retensinya pun berbeda. Antarmuka penyedia, proksi inferensi, dan batas biayanya dipakai ulang apa adanya.

## Impact

- **Repo `mealora-apps/mealora-mobile`**: perekam suara beserta izin mikrofon, pengenalan ucapan di perangkat, klien penguraian kalimat di atas antarmuka penyedia change 010, layar rekam suara dan tinjau transkrip, serta penyambungan ke peninjauan komponen change 011.
- **Repo `mealora-plans`**: rancangan tiga layar baru, dan himpunan uji kalimat pencatatan berbahasa Indonesia beserta hasil evaluasi penguraian.
- **Bergantung pada** change 007 (katalog, buku harian), 010 (antarmuka penyedia, proksi, batas biaya), dan 011 (peninjauan dan koreksi komponen, pencatatan banyak komponen).
- **Biaya tambahan kecil**: penguraian bekerja pada teks, bukan audio. Teks adalah masukan termurah pada seluruh penyedia dan paling mungkin tercakup kuota gratis — berbeda jauh dari audio atau gambar.
- **Tidak memblokir apa pun**; ini jalur kelima yang berdiri di atas empat jalur sebelumnya.
