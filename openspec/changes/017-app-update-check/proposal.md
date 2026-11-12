## Why

Saat ini pengguna tidak punya cara untuk tahu bahwa versi baru Mealora sudah tersedia. Akibatnya mereka bisa lama bertahan di versi lama yang masih mengandung bug, dan saat nanti ada perubahan yang tidak kompatibel (misalnya kontrak proksi model berubah), tim tidak bisa mewajibkan update. MVP 1 belum punya backend selain `mealora-model-proxy`, jadi mekanisme ini perlu menumpang di proksi dan tetap gampang dipindah ke Supabase nanti.

## What Changes

- `mealora-model-proxy` mendapat endpoint publik read-only yang mengembalikan konfigurasi versi app: versi terbaru, versi minimum yang masih didukung, catatan rilis, dan tautan toko per platform.
- `mealora-mobile` mengecek konfigurasi itu saat app dibuka dan saat kembali dari background (dengan batas frekuensi), lalu membandingkannya dengan versi yang terpasang:
  - Versi terpasang di bawah versi minimum: tampil layar **wajib update** yang memblokir app.
  - Versi terpasang di bawah versi terbaru: tampil dialog **update tersedia** (Update / Nanti), paling banyak sekali per versi.
- Pengecekan bersifat **fail-open**: kalau jaringan gagal, timeout, atau respons tidak valid, app tetap berjalan normal.
- Konfigurasi terakhir yang valid disimpan di lokal supaya status wajib update tidak bisa dilewati hanya dengan mematikan jaringan.
- Sumber konfigurasi di app dipisah lewat abstraksi supaya migrasi ke Supabase cukup mengganti implementasinya.

## Capabilities

### New Capabilities
- `app-update-check`: pemberitahuan dan pemaksaan update versi app berdasarkan konfigurasi versi dari server, termasuk perilaku saat gagal.

### Modified Capabilities

## Impact

- **mealora-model-proxy**: route baru `GET /app-config`, config versi lewat env var, dan README.
- **mealora-mobile**: modul cek update (sumber konfigurasi, pembanding versi, penyimpanan lokal di `ui_preferences`), gerbang wajib update di bootstrap, dialog update tersedia, teks `AppText`, dan dependency baru `url_launcher` untuk membuka toko.
- **Proses rilis**: setiap bump versi app juga memperbarui `latest_version` dan `release_notes` di proksi (aturan sudah dicatat di `CLAUDE.md` workspace). `min_supported_version` hanya diubah secara sengaja.
- Tidak ada data pengguna yang dikirim. Request hanya mengambil konfigurasi publik.
