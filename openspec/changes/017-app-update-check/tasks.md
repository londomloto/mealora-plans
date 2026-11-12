## 1. mealora-model-proxy — Endpoint konfigurasi versi

- [x] 1.1 Tambah `APP_LATEST_VERSION`, `APP_MIN_SUPPORTED_VERSION`, `APP_RELEASE_NOTES`, `APP_STORE_URL_ANDROID`, `APP_STORE_URL_IOS` di `src/config.js`; validasi format `x.y.z` dan min ≤ latest saat start (fail-fast). Bila kedua versi tidak diisi, fitur dianggap nonaktif
- [x] 1.2 Route `GET /app-config` di `src/server.js`: tanpa `checkSharedToken`, tanpa rate limiter model, respons dari whitelist field (design D2), `Cache-Control: public, max-age=300`; mengembalikan 404 `APP_CONFIG_UNSET` bila fitur nonaktif
- [x] 1.3 Test dengan `node:test` + script `npm test`: bentuk respons, tidak ada field rahasia, 404 saat nonaktif, start ditolak saat min > latest atau format tidak valid
- [x] 1.4 README: env baru, contoh `curl`, dan prosedur rilis (ubah `APP_LATEST_VERSION` hanya setelah build tersedia di toko; `APP_MIN_SUPPORTED_VERSION` hanya diubah secara sengaja)
- [x] 1.5 Gate verifikasi repo: `npm test`, jalankan lokal lalu `curl /app-config` tanpa token

## 2. mealora-mobile — Domain & data

- [x] 2.1 `lib/domain/app_update/`: model `AppVersionConfig`, parser/pembanding versi (`x.y.z`, buang `+build`/`-pre`), interface `AppConfigSource`, dan fungsi murni `evaluateUpdate` → `none | optional(version) | forced` (design D4), termasuk aturan tautan toko kosong
- [x] 2.2 Unit test: 1.9.0 < 1.10.0, nomor build diabaikan, versi tidak valid, forced dari cache saat fetch gagal, optional hanya dari fetch baru, versi yang sudah di-dismiss, tautan platform kosong
- [x] 2.3 `lib/data/remote/proxy_app_config_source.dart`: `GET {baseUrl}/app-config` memakai `http`, timeout 3 detik, null bila `baseUrl` kosong, non-200, atau JSON tidak valid; pakai `VisionProxyConfig.fromEnvironment`
- [x] 2.4 Kunci baru di `UiPreferenceKeys`: `app_config_cache`, `app_update_dismissed_version`, `app_config_last_success_at`; cache hanya ditimpa oleh konfigurasi yang valid
- [x] 2.5 Test data: source dengan `MockClient` (sukses, timeout, 500, JSON rusak) dan penyimpanan cache

## 3. mealora-mobile — UI

- [x] 3.1 Rancang layar wajib update dan dialog update tersedia di `docs/mealora-v2.pen`, lalu minta persetujuan pemilik produk
- [x] 3.2 Tambah dependency `url_launcher`; helper untuk membuka tautan toko (`https` saja, `externalApplication`, snackbar bila gagal)
- [x] 3.3 `appUpdateStatusProvider` + pemicu saat buka dan resume (`AppLifecycleListener`, throttle 1 jam); tidak menahan splash
- [x] 3.4 `ForceUpdateScreen` (`PopScope(canPop: false)`, catatan rilis, tombol ke toko) dipasang sebagai gerbang di `bootstrap.dart`, berlaku juga selama onboarding; hilang saat status berubah
- [x] 3.5 Dialog update tersedia (catatan rilis, "Update"/"Nanti"), tampil sekali per versi; "Nanti" menyimpan `app_update_dismissed_version`
- [x] 3.6 Teks UI baru di `AppText` (Bahasa Indonesia)

## 4. mealora-mobile — Verifikasi

- [x] 4.1 Widget test: layar wajib update tidak bisa ditutup dengan back, dialog muncul/tidak muncul sesuai versi dan dismiss, layar wajib update hilang setelah konfigurasi baru, fail-open tanpa konfigurasi
- [x] 4.2 Jalankan skenario uji FRS 1–9 di emulator Android (`flutter run -d emulator-5554`) dengan proksi lokal yang env versinya diatur per skenario
- [x] 4.3 Gate verifikasi repo: `flutter analyze`, `dart format --set-exit-if-changed .`, `flutter test`; laporkan hasil dan risiko tersisa

## 5. mealora-plans — Penutupan

- [ ] 5.1 Isi env versi proksi di lingkungan deploy sesuai versi live (`min = latest`) sebelum rilis app (minta konfirmasi sebelum deploy)
- [ ] 5.2 Arsipkan change setelah kedua repo rilis
