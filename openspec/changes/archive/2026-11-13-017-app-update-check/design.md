## Context

- `mealora-model-proxy` (Express, `src/server.js`) saat ini adalah satu-satunya backend. Route inference di sana dilindungi `x-proxy-token` opsional, dan config dibaca dari env lewat `src/config.js`.
- `mealora-mobile` bersifat offline-first (Drift). Alamat proksi dibaca dari `--dart-define=MEALORA_VISION_PROXY_BASE_URL` (`VisionProxyConfig.fromEnvironment`). `package_info_plus` sudah terpasang (dipakai `about_screen.dart`). Preferensi kecil disimpan lewat `UiPreferenceDao` (key/value). Gerbang peluncuran ada di `lib/app/bootstrap.dart` (`MealoraBootstrap` → `_OnboardingGate`).
- `url_launcher` belum ada.
- Supabase direncanakan menggantikan proksi sebagai backend nanti.

## Goals / Non-Goals

**Goals:**
- Kontrak `/app-config` yang stabil, sehingga app tidak perlu berubah saat sumbernya pindah ke Supabase.
- Kegagalan apa pun di jalur cek update tidak boleh merusak peluncuran app.

**Non-Goals:**
- Google Play In-App Updates (update di dalam app). Ditunda supaya MVP tetap kecil. Bisa ditambahkan nanti tanpa mengubah spec, karena tombol "Update" tetap bermuara ke toko.
- Menampilkan "Apa yang baru" setelah update terpasang.
- Otomasi CI untuk sinkronisasi versi. Untuk sementara manual, mengikuti aturan di `CLAUDE.md`.
- Konfigurasi versi per platform yang berbeda (Android dan iOS memakai angka versi yang sama).

## Decisions

**D1. Endpoint di proksi, nilai dari env var.**
`GET /app-config` tanpa `checkSharedToken` dan tanpa rate limiter model. Nilainya dari env: `APP_LATEST_VERSION`, `APP_MIN_SUPPORTED_VERSION`, `APP_RELEASE_NOTES`, `APP_STORE_URL_ANDROID`, `APP_STORE_URL_IOS`. Validasi saat start (format `x.y.z`, min ≤ latest) dan fail-fast seperti `requireEnv`. Respons dibentuk dari whitelist field, bukan dengan menyebarkan objek config. Tambahkan `Cache-Control: public, max-age=300`.
Kalau env versi tidak diisi sama sekali, endpoint mengembalikan 404 `APP_CONFIG_UNSET` dan app memperlakukannya sebagai gagal (fail-open), supaya proksi lokal developer tidak wajib mengisinya.
*Alternatif:* file JSON di repo proksi (perlu deploy ulang juga, tanpa keuntungan berarti); Firebase Remote Config (dependency baru yang akan dibuang saat pindah ke Supabase); JSON statis di hosting (satu tempat lagi yang harus dikelola).

**D2. Bentuk respons (kontrak lintas-repo).**
```json
{
  "latestVersion": "1.2.0",
  "minSupportedVersion": "1.0.0",
  "releaseNotes": "…",
  "storeUrl": { "android": "https://play.google.com/…", "ios": "https://apps.apple.com/…" }
}
```
Penamaan camelCase mengikuti respons proksi yang sudah ada. `releaseNotes` boleh string kosong. `storeUrl.<platform>` boleh kosong, misalnya iOS yang belum terbit. Dalam kasus itu app di platform tersebut tidak menampilkan UI update (fail-open), karena tanpa tautan pengguna tidak punya jalan keluar.

**D3. Abstraksi sumber di app.**
`AppConfigSource` (domain) memiliki `Future<AppVersionConfig?> fetch()`, dengan implementasi `ProxyAppConfigSource` (`lib/data/remote/`) yang memakai `http` dan timeout 3 detik. Jika `baseUrl` kosong, fungsi langsung mengembalikan null. Saat migrasi ke Supabase, cukup tambahkan `SupabaseAppConfigSource` dengan bentuk data yang sama.

**D4. Logika keputusan sebagai fungsi murni.**
`evaluateUpdate(installed, fresh, cached, dismissedVersion)` menghasilkan `none | optional(version) | forced`. Fungsi ini mudah diuji tanpa UI. Pembanding versi: parse `x.y.z`, buang `+build` dan suffix `-pre`, lalu bandingkan per segmen sebagai integer.

**D5. Penyimpanan di `ui_preferences`.**
Kunci baru `app_config_cache` (JSON dari konfigurasi valid terakhir), `app_update_dismissed_version`, dan `app_config_last_success_at`. Tidak perlu migrasi skema karena tabel key/value sudah ada. Kolom `value` dibatasi 256 karakter, jadi saat disimpan ke cache catatan rilis dipotong (diakhiri "…") supaya muat. Versi dan tautan toko, yang menentukan wajib update saat offline, selalu disimpan utuh. Kalau versi dan tautan itu sendiri sudah melebihi batas, cache tidak ditulis (fail-open). Kegagalan menyimpan juga tidak membatalkan status dari konfigurasi yang baru diambil.

**D6. Penempatan UI.**
Provider Riverpod `appUpdateStatusProvider` dipanggil setelah storage siap (di `_OnboardingGate`/bootstrap, berlaku juga selama onboarding). Status `forced` mengganti seluruh child dengan `ForceUpdateScreen` (`PopScope(canPop: false)`). Status `optional` menampilkan dialog sekali setelah frame pertama. Pemicu resume memakai `AppLifecycleListener` dengan throttle 1 jam dari `app_config_last_success_at`.
Cek pertama tidak menahan splash: layar normal tampil dulu, lalu gerbang wajib update menimpanya begitu hasil keluar. Status `forced` dari cache bisa langsung diterapkan karena cache dibaca dari lokal.

**D7. Membuka toko.**
Tambahkan `url_launcher` dengan `LaunchMode.externalApplication`. Hanya URL `https` yang diterima. Jika gagal dibuka, tampilkan snackbar, dan layar wajib update tetap tampil.

## Risks / Trade-offs

- [Proksi down membuat pengguna tidak tahu ada update] → Ini konsekuensi yang memang diterima dari pilihan fail-open. Wajib update tetap berlaku lewat cache.
- [Salah isi `APP_MIN_SUPPORTED_VERSION` memblokir semua pengguna] → Validasi min ≤ latest saat start, nilai ini hanya diubah secara sengaja (aturan `CLAUDE.md`), dan rollback cukup dengan mengubah env lalu redeploy. App akan membuka blokir pada pengambilan berhasil berikutnya, saat dibuka ulang atau resume setelah throttle.
- [Lupa memperbarui `APP_LATEST_VERSION` saat rilis] → Dampaknya hanya dialog tidak muncul, dan aturan sinkronisasi di `CLAUDE.md` mencegahnya.
- [Versi baru sudah dikonfigurasi tetapi belum lolos review store] → Ubah `latestVersion` hanya setelah build tersedia di toko (dicatat di README proksi).
- [Proksi kini memegang tanggung jawab di luar inference] → Ini tech debt yang memang diterima, dan endpoint akan dipindah ke Supabase sesuai D3.

## Migration Plan

1. Deploy proksi dengan env versi diisi sesuai versi yang sedang live, dengan `min = latest = versi live`.
2. Rilis app yang memuat fitur ini. Versi lama yang belum punya fitur ini tidak terpengaruh, dan baru bisa dipaksa update mulai rilis ini.
3. Rollback: kosongkan env versi sehingga endpoint mengembalikan 404 dan app kembali fail-open tanpa dialog.
