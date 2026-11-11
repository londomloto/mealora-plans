# Proksi Inferensi — Rancangan

Dokumen ini adalah artifact task 2.1–2.4 dari
`openspec/changes/010-nutrition-label-extraction`. Lihat `design.md` D2 di
change itu untuk alasan keputusan; dokumen ini menetapkan rancangan
operasionalnya.

## 1. Cakupan (task 2.1)

Proksi inferensi adalah satu-satunya komponen sisi server di MVP 1. Cakupannya
dibatasi keras:

- Menerima satu foto label per permintaan.
- Meneruskan foto itu ke penyedia model vision (Gemini) dengan kredensial yang
  disimpan di server.
- Mengembalikan hasil terstruktur (JSON) ke aplikasi.

**Yang secara tegas TIDAK disimpan oleh proksi:**

- Gambar yang dikirim — diproses di memori, dibuang setelah permintaan selesai.
- Hasil ekstraksi — tidak ditulis ke disk maupun basis data mana pun.
- Data pengguna apa pun — proksi tidak mengenal konsep "pengguna"; tidak ada
  akun, sesi, maupun pengenal yang bertahan antar permintaan.
- Log operasional (waktu, status HTTP, durasi) boleh dicatat untuk pemantauan,
  tetapi **tidak pernah memuat isi gambar atau nilai gizi hasil bacaan**.

Implementasi referensi: `mealora-apps/mealora-vision-proxy` (Node.js +
Express, lihat README repo itu untuk detail endpoint).

## 2. Batas permintaan dan biaya (task 2.2)

Proksi menetapkan dua batas eksplisit per hari (reset tengah malam waktu
server):

- **Batas jumlah permintaan** — `MAX_REQUESTS_PER_DAY`, bawaan 300/hari.
- **Batas estimasi biaya** — `MAX_ESTIMATED_COST_USD_PER_DAY`, bawaan USD 5/hari,
  dihitung dari `ESTIMATED_COST_USD_PER_REQUEST` × jumlah permintaan yang
  disetujui. Ini estimasi kasar untuk pengereman dini, bukan rekonsiliasi
  tagihan sebenarnya dari penyedia.

Ketika salah satu batas terlampaui, permintaan ditolak dengan `429
{"error":"LIMIT_EXCEEDED"}`. Aplikasi mobile WAJIB menerjemahkan ini menjadi
pernyataan "layanan sedang tidak tersedia" dalam bahasa yang dapat dimengerti
pengguna, lalu mengarahkan ke jalur isi manual — tidak pernah menampilkan kode
error atau istilah teknis (lihat `specs/image-ai-access/spec.md`, requirement
"Batas biaya dan permintaan ditetapkan").

Batas ini dikonfigurasi lewat environment variable di server, bukan di kode
aplikasi, sehingga dapat disesuaikan tanpa merilis ulang aplikasi.

Batas waktu tunggu (`PROVIDER_TIMEOUT_MS`, bawaan 20 detik) dan batas ukuran
gambar (`MAX_IMAGE_BYTES`, bawaan 8 MB) ditetapkan serupa, untuk mencegah satu
permintaan menggantung atau menghabiskan sumber daya server.

## 3. Tanpa akun, bukan sumber kebenaran (task 2.3)

Proksi SHALL TIDAK mewajibkan pembuatan akun maupun autentikasi pengguna.
Satu-satunya "autentikasi" yang ada adalah token statis level-aplikasi
(`PROXY_SHARED_TOKEN`, header `X-Proxy-Token`) yang bersifat opsional — ini
bukan kredensial pengguna, hanya penangkal lalu lintas acak dari internet
publik ke endpoint yang terbuka.

Seluruh data yang diterima dari proksi (hasil ekstraksi) disimpan di
perangkat pengguna lewat SQLite lokal (tabel produk change 009), persis
seperti data lain di Mealora. Proksi tidak pernah menjadi sumber kebenaran:
bila proksi hilang, dimatikan, atau diganti dengan server lain, seluruh data
yang sudah tersimpan di perangkat tetap utuh dan tidak bergantung padanya.

## 4. Penanganan kredensial penyedia (task 2.4)

- API key Gemini disimpan sebagai environment variable di server
  (`GEMINI_API_KEY`), dibaca sekali saat proses start, tidak pernah dikirim
  balik ke klien dalam bentuk apa pun.
- API key SHALL TIDAK pernah disertakan dalam kode, aset, maupun konfigurasi
  aplikasi mobile yang didistribusikan. Task 9.4 memeriksa ini secara eksplisit
  pada paket aplikasi yang dirilis.
- Rotasi key dilakukan di server (ubah environment variable, restart
  container) tanpa perlu merilis ulang aplikasi mobile.
- Token aplikasi (`PROXY_SHARED_TOKEN`) adalah penangkal, bukan batas
  keamanan — nilainya boleh ada di aplikasi karena bukan kredensial penyedia
  model; yang dilindungi secara keras hanyalah `GEMINI_API_KEY`.

## 5. Penyedia model dan evaluasi

Implementasi awal memanggil Gemini (`gemini-2.0-flash` atau versi vision
terbaru yang tersedia saat deploy) untuk mulai pengembangan klien dan layar
tanpa menunggu evaluasi selesai, sesuai catatan dependensi di `workorder.md`
("paket 3 ... tidak memblokir paket 5 sampai 14"). Ini **bukan** keputusan
rilis final — pemilihan penyedia untuk rilis tetap menunggu evaluasi
terdokumentasi pada task 1.1–1.6 dengan himpunan uji label Indonesia berizin,
sesuai D8 di `design.md`. Antarmuka penyedia di sisi mobile (task 3.1) dibuat
agar penggantian penyedia, termasuk hasil evaluasi nanti, tidak menyentuh
layar maupun proksi ini — hanya implementasi klien di baliknya.

## 6. Deploy

**Catatan migrasi masa depan:** bila MVP 2 memang pindah ke Supabase (sudah
jadi kandidat terdokumentasi untuk MVP 2, §19 assessment), proksi ini pindah
ke **Supabase Edge Function**, bukan digabung ke dalam monolith Go/PostgreSQL
MVP 2. Alasannya tetap D2: cakupannya murni inferensi, terpisah dari data
pengguna. Catatan teknis untuk migrasi itu: batas permintaan/biaya
(`rateLimiter.js`) di sini memakai counter in-memory yang valid karena proses
Node berjalan terus-menerus di droplet; Edge Function bersifat
scale-to-zero dan TIDAK menjamin memori bertahan antar panggilan, sehingga
counter itu harus dipindah ke penyimpanan bersama (mis. tabel Postgres kecil
atau KV) saat migrasi — bukan port langsung.

Dideploy sebagai container Docker di server yang sudah ada (DigitalOcean
droplet milik tim), di belakang reverse proxy (nginx/Caddy) yang sudah
berjalan di server itu, atau lewat port langsung — lihat README
`mealora-apps/mealora-vision-proxy` untuk langkah deploy. Tidak ada
infrastruktur baru (tidak ada Supabase, tidak ada layanan terkelola
tambahan) — sejalan dengan keputusan §19 `mealora_product_assessment_v1.1.md`
yang menunda Supabase/backend ke MVP 2.
