# 020 · Isi gizi dari teks atau foto info gizi

## Why

Tester melaporkan bahwa input makanan buatan sendiri masih lambat. Pengguna sering sudah menemukan info gizinya di internet, misalnya jawaban Google atau artikel ("nutrisi steak daging sapi") di HP atau laptop, tapi tetap harus mengetik ulang setiap angka ke form Buat makanan (change 007/016).

Sementara itu, "Foto Info Gizi" (change 010) hanya memahami panel label kemasan. Foto layar laptop atau artikel tidak bisa dibaca.

Info gizi di internet formatnya bebas:

- angka berupa rentang ("214 – 252 kkal") atau perkiraan ("~15 gram");
- basis porsinya ada di kalimat ("per 100 gram daging sapi matang");
- isinya bercampur dengan mikronutrien, penjelasan, dan tautan.

## What Changes

- **Tempel teks** di form Buat makanan (mode isi manual):
  - Layar tempel diisi dari clipboard, teksnya bisa disunting, maksimal 4000 karakter.
  - Tersedia tombol **Tempel ulang** dan **Foto**. Tombol Foto membuka layar Foto info gizi.
- **Foto info gizi jadi satu layar** untuk label kemasan, layar laptop, dan artikel:
  - judul dan penjelasannya diperkaya;
  - izin unggah tetap ada;
  - ada ikon galeri kecil untuk gambar yang sudah tersimpan.
- **Pembacaan foto bertingkat**:
  1. **AI vision**, bila izin unggah diberikan.
  2. Bila izin tidak diberikan, atau AI vision gagal, timeout, atau kuotanya habis: **OCR di HP**, lalu **hanya teksnya** dibaca AI.
  3. Bila itu juga gagal atau perangkat offline: **OCR + pembaca lokal** di HP, dan hasilnya ditandai "perlu dicek".
- **Menu "Scan barcode" menjadi "Scan barcode / info gizi"**. Subjudul "Foto Info Gizi" di layar pindai juga diperbarui.
- **Satu format hasil dan satu layar tinjau** untuk teks maupun foto:
  - **Rentang** diisi nilai tengahnya dan diberi label "Nilai tengah". Angka asli tetap ditampilkan.
  - **Nilai yang tidak terbaca** tetap kosong, tidak diisi nol atau tebakan.
  - **Basis porsi** menjadi ukuran sajian.
  - **Mikronutrien** yang belum didukung ditampilkan sebagai "diabaikan".
- **Tujuan hasil mengikuti isi dan konteks**:
  - Dibuka dari form Buat makanan: form itu yang diisi.
  - Dibuka dari "Barcode tidak ditemukan": jadi produk kemasan, seperti alur lama.
  - Dari menu scan tanpa barcode: label kemasan masuk ke tinjau label lalu jadi produk kemasan (alur lama). Layar atau artikel membuka form Buat makanan yang sudah terisi.
- **Tidak ada yang tersimpan otomatis.** Pengguna selalu menekan Simpan sendiri.
- **Proxy mendapat dua endpoint baru** yang formatnya seragam: `POST /parse-nutrition-text` (teks) dan `POST /read-nutrition-image` (gambar).
  - Keduanya memakai token, batas harian, dan pemetaan error yang sama dengan route yang sudah ada.
  - Isi permintaan dan hasilnya tidak dicatat di log.
  - `/extract-label` **tidak diubah** dan tetap melayani app versi lama.

## Capabilities

### New Capabilities

- `nutrition-text-import`: membaca nilai gizi dari teks yang ditempel, atau dari foto/gambar, secara bertingkat (AI vision → teks hasil OCR → OCR offline). Cakupannya: aturan rentang, basis, nilai tidak terbaca, dan nutrien diabaikan, peninjauan oleh pengguna, serta penentuan tujuan hasil (form Buat makanan atau produk kemasan) tanpa menyimpan otomatis.

### Modified Capabilities

(tidak ada)

Main spec belum ada di store; spec 007/010 masih berada di change masing-masing. Perilaku yang menyentuhnya dinyatakan sebagai requirement baru di `nutrition-text-import`:

- Penyimpanan makanan buatan sendiri tetap "diisi manual".
- Tinjau dan simpan produk kemasan tetap memakai alur 010.
- Layar foto sekarang memanggil endpoint gambar yang baru, menggantikan `/extract-label` untuk app versi ini. Alur tinjau dan penyimpanan produk kemasan tidak berubah.

## Impact

- **mealora-model-proxy**:
  - Prompt dan skema hasil bersama.
  - Route teks dan route gambar baru, dengan batas karakter, batas body, dan tag data terpisah.
  - Test dan README.
- **mealora-mobile**:
  - Tombol di `custom_food_screen.dart` (mode manual), dengan `prefill` opsional.
  - Layar tempel, layar tinjau, dan layar gagal baru.
  - `nutrition_label_photo_screen.dart` menjadi layar Foto info gizi tunggal dengan alur bertingkat dan ikon galeri.
  - Klien proxy untuk teks dan gambar.
  - Fungsi murni untuk validasi, nilai tengah, dan pemetaan ke `LabelExtraction` untuk jalur produk kemasan.
  - OCR memakai ulang `google_mlkit_text_recognition`, dan pembaca offline memakai ulang `LabelTextParser`.
  - **Dependency baru**: `image_picker` untuk ikon galeri.
  - Teks menu dan string l10n.
- **Desain**: `mealora-plans/docs/mealora-v2.pen`, section 13, layar 82–89.
- **Rollout**:
  - Diuji dengan proxy lokal (emulator lewat `10.0.2.2`).
  - Deploy proxy ke server Koorva setelah lolos uji, dengan konfirmasi eksplisit.
  - Proxy harus live lebih dulu sebelum app versi ini dirilis.
- **Biaya model**: permintaan gambar lebih mahal dari teks. Pemakaian keduanya masuk ke batas permintaan dan biaya harian proxy yang sudah ada.
- **Regresi**: alur barcode dan foto label kemasan (010) wajib diuji ulang.
- **Ketergantungan**: dibangun di atas form dari change 007/016 dan alur foto label dari change 010.
