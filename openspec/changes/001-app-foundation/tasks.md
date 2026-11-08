## 1. mealora-mobile — Kerangka proyek

- [ ] 1.1 Buat proyek Flutter di `mealora-apps/mealora-mobile` dengan platform Android dan web saja (tanpa iOS/desktop di checkout ini), application id dan nama aplikasi Mealora
- [ ] 1.2 Buat struktur folder `lib/app/`, `lib/core/`, `lib/database/`, `lib/domain/`, `lib/data/`, `lib/features/` sesuai assessment §10, masing-masing dengan berkas penanda agar tidak kosong
- [ ] 1.3 Tambahkan dependensi: Riverpod, Drift + sqlite3 (native dan web), pembangkit UUID, paket lokalisasi/format, serta dependensi uji (termasuk build runner Drift)
- [ ] 1.4 Konfigurasi analisis statis ketat: aktifkan lint set yang dipilih, larang `print`, larang impor lintas-lapisan terlarang (domain tidak boleh mengimpor Flutter/Drift/jaringan), larang nilai warna/ukuran font harfiah di luar berkas token
- [ ] 1.5 Tambahkan uji arsitektur yang memindai impor terlarang per lapisan sebagai jaring kedua atas aturan lint
- [ ] 1.6 Siapkan struktur test `test/unit/`, `test/widget/`, `test/database/` beserta satu uji sanity di tiap folder
- [ ] 1.7 Jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test` — semua harus bersih sebelum lanjut

## 2. mealora-mobile — Waktu, pengenal, dan kesalahan bertipe

- [ ] 2.1 Definisikan antarmuka `Clock` di `lib/core/` yang mengembalikan instan UTC, zona waktu IANA perangkat, dan tanggal lokal; sediakan implementasi sistem dan implementasi uji berwaktu tetap
- [ ] 2.2 Definisikan antarmuka pembangkit pengenal (UUID v7, cadangan v4) dengan implementasi sistem dan implementasi uji berurutan tetap; larang pemanggilan pembangkit acak langsung di tempat pemakaian lewat aturan lint pada langkah 1.4
- [ ] 2.3 Daftarkan `Clock` dan pembangkit pengenal sebagai provider Riverpod yang dapat ditimpa dalam uji
- [ ] 2.4 Definisikan tipe hasil/kegagalan bersama di `lib/core/errors/` (hasil berhasil vs kegagalan bertipe dengan kode alasan yang dapat dipetakan ke pesan pengguna); tanpa exception sebagai mekanisme alur
- [ ] 2.5 Uji: waktu dan pengenal deterministik saat sumbernya ditimpa; tanggal lokal tidak berubah ketika zona waktu perangkat berubah setelah pencatatan

## 3. mealora-mobile — Fondasi penyimpanan lokal

- [ ] 3.1 Buat `AppDatabase` Drift dengan `schemaVersion` 1 dan pembuka koneksi per platform: SQLite native untuk Android, `sqlite3.wasm` + worker untuk web, di balik satu titik masuk yang tidak diketahui lapisan fitur
- [ ] 3.2 Aktifkan foreign key pada setiap pembukaan koneksi dan verifikasi lewat uji
- [ ] 3.3 Buat mixin kolom record pengguna: `id` (teks UUID), `created_at`, `updated_at`, `deleted_at`, `sync_status` (selalu `local` di MVP 1), `revision`
- [ ] 3.4 Buat satu tabel harness internal yang memakai mixin tersebut, semata untuk membuktikan dan menguji konvensi — bukan tabel produk, dan tidak boleh dipakai fitur
- [ ] 3.5 Implementasikan akses data bersama yang menyaring `deleted_at IS NULL` secara default, dengan jalur eksplisit untuk membaca record terhapus
- [ ] 3.6 Implementasikan penaikan `revision` dan pembaruan `updated_at` otomatis pada setiap perubahan record, dengan `created_at` yang tidak berubah
- [ ] 3.7 Implementasikan validasi nilai: tolak nilai gizi negatif, jumlah/berat nol atau negatif, dan nilai bukan-angka; bedakan "belum diketahui" dari nol
- [ ] 3.8 Pastikan penulisan multi-record berjalan dalam satu transaksi dan membatalkan seluruhnya saat gagal
- [ ] 3.9 Uji database: persistensi lintas pembukaan ulang, soft delete tersaring dari pembacaan, revisi bertambah, nilai mustahil ditolak, rollback transaksi utuh, foreign key aktif
- [ ] 3.10 Jalankan `flutter test` untuk seluruh uji database terhadap SQLite nyata (bukan hanya in-memory browser)

## 4. mealora-mobile — Harness migrasi

- [ ] 4.1 Siapkan harness migrasi Drift beserta penulisan skema terverifikasi untuk versi 1
- [ ] 4.2 Buat fixture: database kosong, pembuatan langsung pada versi terkini, database berisi data harness, dan simulasi migrasi terputus
- [ ] 4.3 Implementasikan pemeriksaan pasca-migrasi: versi skema benar dan `PRAGMA foreign_key_check` bersih
- [ ] 4.4 Implementasikan keadaan kegagalan inisialisasi penyimpanan yang dapat dibaca pengguna (dipakai oleh splash pada langkah 7.3), tanpa merusak data yang ada
- [ ] 4.5 Uji: migrasi terputus tidak merusak data dan percobaan berikutnya berhasil; dokumentasikan bahwa downgrade tidak didukung
- [ ] 4.6 Dokumentasikan cara menambah migrasi untuk change berikutnya di README repo

## 5. mealora-mobile — Token desain dan tema

- [ ] 5.1 Baca nilai tipografi, jarak, dan radius langsung dari `docs/mealora.pen` (MCP pen.dev) — jangan menebak dari tangkapan layar
- [ ] 5.2 Definisikan token warna sebagai satu sumber: `background #F7FAF5`, `primary #258747`, `accent #F5D35C`, `peach #FF8A50`, `ink #203D2D`, `muted #687D70`, `soft-green #DEF3DE`, `line #DFE9DE`
- [ ] 5.3 Definisikan skala tipografi, jarak, radius, dan elevasi sebagai token; susun tema aplikasi yang membacanya
- [ ] 5.4 Uji kontras otomatis untuk setiap pasangan teks/latar yang dipakai, khususnya `muted` di atas `background`
- [ ] 5.5 Uji bahwa perubahan satu nilai token berlaku ke seluruh komponen yang memakainya

## 6. mealora-mobile — Lokalisasi dan komponen dasar

- [ ] 6.1 Siapkan lapisan lokalisasi dengan locale `id-ID` sebagai satu-satunya locale; semua string pengguna berasal dari sini
- [ ] 6.2 Implementasikan format angka Indonesia (titik ribuan, koma desimal) dan format tanggal Indonesia; sediakan pembantu satuan metrik (kg, cm, kkal, g)
- [ ] 6.3 Uji format: "2.100 kkal" dan "68,4 kg" tampil sesuai konvensi Indonesia
- [ ] 6.4 Bangun komponen dasar dari token: tombol primer, chip, kartu, kolom isian, keadaan kosong, keadaan kesalahan — semuanya dengan target sentuh memadai dan label pembaca layar
- [ ] 6.5 Uji widget untuk tiap komponen dasar pada ukuran teks normal dan ukuran teks besar

## 7. mealora-mobile — Splash dan kerangka navigasi

- [ ] 7.1 Salin aset merek yang diperlukan dari `docs/brand-assets/` ke repo aplikasi (ikon aplikasi, adaptif Android, monokrom, logo splash)
- [ ] 7.2 Bangun layar splash sesuai `06 · Splash Mealora`: simbol dan wordmark, tagline, janji penyimpanan lokal, perpindahan otomatis ke ruang utama tanpa interaksi
- [ ] 7.3 Tangani kegagalan inisialisasi penyimpanan di splash: tampilkan keadaan kesalahan yang dapat dibaca beserta tindakan lanjutan, bukan splash menggantung
- [ ] 7.4 Bangun navigasi kapsul mengambang empat ruang (Hari ini, Program, Riwayat, Profil) mengikuti `Component · floating navigation`, dengan penanda aktif yang tidak bergantung pada warna saja
- [ ] 7.5 Bangun empat layar kerangka berkeadaan "belum ada data" yang menjelaskan isi dan tindakan tersedia, tanpa angka nol yang menyerupai hasil pengukuran
- [ ] 7.6 Implementasikan penyimpanan dan pemulihan ruang terpilih saat aplikasi dibuka kembali
- [ ] 7.7 Implementasikan keadaan rute tidak dikenal dengan jalan kembali ke ruang utama
- [ ] 7.8 Uji widget: perpindahan antar empat ruang, penanda aktif, keadaan kosong, rute tidak dikenal, dan pemulihan ruang terpilih

## 8. mealora-mobile — Aksesibilitas dan verifikasi preview web

- [ ] 8.1 Tambahkan label pembaca layar yang bermakna pada setiap tujuan navigasi, kontrol, dan ikon bermakna, termasuk keadaan terpilih
- [ ] 8.2 Uji seluruh layar pada skala teks besar: tidak ada teks terpotong, tertindih, atau kontrol yang tidak terjangkau
- [ ] 8.3 Jalankan `flutter run -d chrome` dan verifikasi kelima layar pada viewport 390×844; bandingkan dengan `docs/mealora.pen`
- [ ] 8.4 Verifikasi tidak ada permintaan jaringan yang keluar selama peluncuran dan navigasi
- [ ] 8.5 Catat langkah menjalankan, menguji, dan preview debug di README repo, termasuk cara menghubungkan debugger editor

## 9. mealora-mobile — Verifikasi Android dan gate penutup

- [ ] 9.1 Siapkan emulator atau perangkat Android (timebox satu hari; bila penyiapan emulator gagal, gunakan perangkat fisik) dan pastikan `adb` terjangkau
- [ ] 9.2 Pasang dan jalankan build debug di Android; verifikasi splash, navigasi, dan keadaan kosong tampil sesuai rancangan
- [ ] 9.3 Verifikasi alur mode pesawat di Android: buka aplikasi, jelajahi empat ruang, tutup sepenuhnya, buka kembali — ruang terpilih dan data lokal bertahan
- [ ] 9.4 Verifikasi database SQLite benar-benar terbentuk di perangkat dan bertahan setelah perangkat dimatikan dan dinyalakan kembali
- [ ] 9.5 Gate verifikasi repo: jalankan `flutter analyze`, `dart format --set-exit-if-changed .`, dan `flutter test` — seluruhnya harus hijau, lalu laporkan hasil beserta risiko yang tersisa
