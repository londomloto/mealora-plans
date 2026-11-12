# 015 · Kurasi katalog makanan: takaran sehari-hari & akurasi gizi

## Why

Dari uji coba aplikasi, hambatan terbesar pencatatan adalah takaran: seluruh 1.346 makanan katalog bawaan (TKPI via dataset Kaggle, change 007) hanya punya satu takaran, `100 g`. Padahal pengguna berpikir dalam gelas, sendok, centong, potong, dan piring. Akibatnya pengguna harus menebak gram sendiri, dan tebakan itu sumber galat terbesar.

Assessment katalog (2026-11-12) juga menemukan masalah akurasi yang sudah tercatat sebagai keterbatasan di `docs/food-data-sources.md`:
- 86 item energinya menyimpang >25% dari energi hasil hitung makronutrien (4·P + 4·K + 9·L).
- Ada nilai karbohidrat 0 yang kemungkinan hasil pengisian nilai kosong.
- Ada 3 nama duplikat.
- Bentuk bahannya ambigu. Contohnya `Teh` 132 kkal/100 g, yang kemungkinan daun kering, padahal pengguna mencatat teh seduh.
- Belum ada verifikasi item terhadap TKPI resmi.

Fondasi teknisnya sudah ada. Satu makanan bisa punya banyak takaran, catatan lama menyimpan salinan nilai, dan input suara mencocokkan satuan ucapan ke takaran. Jadi yang perlu dikerjakan sebagian besar adalah kurasi data ditambah sedikit penyesuaian perilaku.

## What Changes

- **Takaran sehari-hari** (gelas, sdm, centong, potong, buah, piring, dll.) ditambahkan untuk makanan katalog, masing-masing dengan padanan gram. Takaran bawaan diganti ke takaran sehari-hari yang paling lazim. Takaran `100 g` asal TKPI **tetap tersedia**.
- **Asal-usul per takaran** dibuat bertingkat: (1) sumber resmi atau penimbangan lapangan, (2) turunan matematis dari sumber terukur, (3) estimasi realistis yang ditandai "perkiraan". Estimasi hanya untuk **gram per takaran**, tidak pernah untuk nilai gizi per 100 g.
- **Koreksi nilai gizi terhadap TKPI 2017 resmi** (Kemenkes) untuk seluruh katalog, termasuk penanganan karbohidrat 0 yang meragukan (disimpan sebagai belum diketahui bila tidak terkonfirmasi).
- **Bentuk siap konsumsi dipisahkan dari bahan mentah atau kering.** Contohnya entri "Teh manis (seduh)" dipisah dari "Teh (daun kering)". Bahan yang jarang dicatat langsung tidak dimunculkan di urutan atas pencarian.
- **Duplikat dirapikan dan nama distandardisasi**, termasuk sinonim pencarian yang lazim ("mie" ↔ "mi", "telor" ↔ "telur").
- **Jumlah bebas dalam gram/ml.** Pengguna dapat mencatat berat langsung (mis. 150 g), tidak terbatas kelipatan 0,5 sajian.
- **Pemeriksaan mutu katalog otomatis** sebagai gerbang CI: konsistensi energi–makro, rentang gram per takaran, duplikat, dan kelengkapan asal-usul.
- Catatan makan lama **tidak berubah** (sudah dijamin requirement "Pembaruan katalog tidak mengubah catatan lama").

## Capabilities

### New Capabilities

- `food-catalog-quality`: aturan mutu data katalog bawaan yang dapat diperiksa otomatis sebelum rilis: konsistensi energi–makro, rentang wajar gram per takaran, tidak ada duplikat, asal-usul lengkap per takaran, dan nilai yang tidak diketahui tidak disimpan sebagai nol.

### Modified Capabilities

- `food-catalog`: requirement "Setiap makanan katalog memiliki asal-usul data" dan "Takaran saji yang bermakna" berubah (asal-usul bertingkat per takaran, penanda "perkiraan", takaran bawaan sehari-hari, takaran 100 g asal dipertahankan). Ditambah requirement baru: jumlah bebas dalam gram/ml, pemisahan bentuk siap konsumsi, dan sinonim pencarian.

## Impact

- **mealora-mobile**:
  - Migrasi skema kecil di tabel takaran saji (kolom asal-usul per takaran).
  - Seed katalog dibangkitkan ulang (versi seed naik).
  - Layar detail sajian dan ubah catatan diubah: input gram/ml dan penanda "perkiraan".
  - Pencarian ditambah sinonim dan pengurutan bentuk siap konsumsi.
  - Input suara ikut membaik karena satuan ucapan kini menemukan padanan takaran.
  - Draf foto makanan mencocokkan satuan hasil pengenalan ke takaran, tidak lagi selalu memakai takaran bawaan. Tanpa ini, "150 g" akan terbaca 150 × takaran bawaan begitu bawaan berubah dari 100 g.
- **mealora-plans**:
  - `docs/food-data-sources.md` diperbarui.
  - Dataset kurasi ditambahkan (sumber per takaran beserta halamannya), bersama skrip pembangkit seed dan pemeriksa mutu.
- **Ketergantungan**:
  - Change ini memodifikasi spec `food-catalog` dari change 007, jadi 007 harus diarsipkan lebih dulu.
  - Hak pakai TKPI masih menunggu izin Kemenkes (lihat `docs/surat-permohonan-izin-tkpi.md`). Risiko ini sudah diterima di change 007 dan tidak berubah di sini.
- **Data pengguna**:
  - Tidak ada catatan yang diubah atau dihapus.
  - Riwayat "terakhir dicatat" yang menunjuk takaran 100 g tetap valid.
