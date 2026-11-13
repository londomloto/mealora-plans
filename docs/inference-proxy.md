# Proksi Inferensi — Rancangan

Dokumen ini adalah artifact task 2.1–2.4 dari
`openspec/changes/010-nutrition-label-extraction`. Lihat `design.md` D2 di
change itu untuk alasan keputusan; dokumen ini menetapkan rancangan
operasionalnya.

## 1. Cakupan (task 2.1)

Proksi inferensi adalah satu-satunya komponen sisi server di MVP 1. Cakupannya
dibatasi keras:

- Menerima satu gambar (label gizi, foto makanan, gambar nutrisi) atau satu
  teks pendek per permintaan.
- Meneruskannya ke penyedia model lewat rantai penyedia berurutan (lihat §5),
  dengan kredensial yang disimpan di server.
- Mengembalikan hasil terstruktur (JSON) ke aplikasi, setelah divalidasi
  terhadap skema keluaran.

**Yang secara tegas TIDAK disimpan oleh proksi:**

- Gambar yang dikirim — diproses di memori, dibuang setelah permintaan selesai.
- Hasil ekstraksi — tidak ditulis ke disk maupun basis data mana pun.
- Data pengguna apa pun — proksi tidak mengenal konsep "pengguna"; tidak ada
  akun, sesi, maupun pengenal yang bertahan antar permintaan.
- Log operasional (waktu, status HTTP, durasi, jumlah token, penyedia yang
  menjawab, dan alasan fallback) boleh dicatat untuk pemantauan, tetapi **tidak
  pernah memuat isi gambar, teks masukan, atau nilai gizi hasil bacaan**.

Implementasi referensi: `mealora-apps/mealora-model-proxy` (Node.js +
Express; dulu bernama `mealora-vision-proxy`). Lihat README repo itu untuk
detail endpoint dan variabel lingkungan.

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

Batas jumlah dan biaya dihitung satu kali per permintaan dari aplikasi, bukan
per percobaan ke penyedia. Saat sering terjadi fallback (§5), estimasi biaya
harian dapat sedikit meleset dari biaya sebenarnya.

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

- API key setiap penyedia (`GEMINI_API_KEY`, `GROQ_API_KEY`, `GLM_API_KEY`)
  disimpan sebagai environment variable di server, dibaca sekali saat proses
  start, dan tidak pernah dikirim balik ke klien dalam bentuk apa pun. Hanya key
  penyedia yang tercantum di rantai yang wajib diisi.
- API key SHALL TIDAK pernah disertakan dalam kode, aset, maupun konfigurasi
  aplikasi mobile yang didistribusikan. Task 9.4 memeriksa ini secara eksplisit
  pada paket aplikasi yang dirilis.
- Rotasi key dilakukan di server (ubah environment variable, restart
  container) tanpa perlu merilis ulang aplikasi mobile.
- Token aplikasi (`PROXY_SHARED_TOKEN`) adalah penangkal, bukan batas
  keamanan — nilainya boleh ada di aplikasi karena bukan kredensial penyedia
  model; yang dilindungi secara keras hanyalah API key penyedia.

## 5. Penyedia model, rantai fallback, dan evaluasi

Implementasi awal hanya memanggil Gemini. Sejak 2026-11-13 proksi memakai
**rantai penyedia berurutan** per jenis rute (`src/providerChain.js`):

| Jenis rute | Variabel | Rantai production | Model |
|---|---|---|---|
| Teks (`/parse-food-text`, `/parse-nutrition-text`) | `TEXT_PROVIDERS` | `gemini,groq,glm` | Gemini Flash-Lite → Groq `gpt-oss-20b` → GLM `glm-4.5-flash` |
| Gambar (`/extract-label`, `/recognize-food-components`, `/read-nutrition-image`) | `IMAGE_PROVIDERS` | `gemini,groq,glm` | Gemini Flash-Lite → Groq `qwen3.8-27b` (preview) → GLM `glm-4.6v-flash` |

Aturan rantai:

- Penyedia berikutnya dicoba saat penyedia sebelumnya timeout, membalas 429,
  5xx, galat konfigurasi (4xx), atau keluaran yang bukan JSON atau tidak sesuai
  skema. Bila semuanya gagal, aplikasi menerima `502 PROVIDER_ERROR` atau
  `504 PROVIDER_TIMEOUT` seperti sebelumnya. **Kontrak ke aplikasi tidak
  berubah.**
- Seluruh rantai harus selesai di bawah batas waktu aplikasi (teks 20 detik,
  gambar 55 detik): `TEXT_DEADLINE_MS` 18 detik dan `IMAGE_DEADLINE_MS` 50 detik.
  Setiap percobaan kecuali yang terakhir dibatasi `*_ATTEMPT_TIMEOUT_MS`.
- Penyedia yang membalas 429 dilewati selama `PROVIDER_COOLDOWN_MS` (60 detik).
- Setiap keluaran divalidasi terhadap skema di `src/schema.js` sebelum dikirim
  ke aplikasi. Groq memakai `json_schema` strict. GLM memakai mode JSON dengan
  skema disisipkan ke perintah.

Catatan kualitas (uji 2026-11-13, foto nasi padang): Gemini mengenali seluruh
komponen dengan benar, sedangkan Groq dan GLM salah mengenali sebagian
komponen. Untuk gambar, penyedia cadangan hanya pengganti terakhir sebelum
jalur manual. Peninjauan pengguna tetap wajib, sesuai `image-ai-access`.

Pemilihan penyedia untuk rilis tetap mengikuti evaluasi terdokumentasi
(change 010 D8 dan change 011). Antarmuka penyedia di sisi mobile tidak
berubah: rantai sepenuhnya berada di proksi, sehingga mengganti atau menambah
penyedia tidak memerlukan rilis aplikasi.

### 5.1 Kebijakan data penyedia

Proksi tidak mengirim identitas pengguna. Permintaan hanya memuat gambar atau
teks yang disetujui pengguna. Isi label gizi dan foto makanan bukan data
pribadi, tetapi metadata pada berkas foto (lokasi, waktu, perangkat) adalah data
pribadi. Pembersihannya dirancang di change `022-privacy-handling`. Mealora
hanya melayani pengguna Indonesia, sehingga acuan regulasinya adalah UU PDP
(UU 27/2022).

| Penyedia | Tier yang dipakai | Pemakaian data |
|---|---|---|
| Gemini | Gratis | Masukan dan keluaran dipakai Google untuk pengembangan produk dan dapat dibaca peninjau manusia. Tier berbayar tidak memakainya. |
| Groq | Gratis | Belum ditinjau; periksa sebelum rilis publik. |
| GLM (Z.ai) | Gratis | Belum ditinjau; periksa sebelum rilis publik. |

Rekomendasi sebelum rilis publik: aktifkan tier berbayar untuk penyedia utama
(Gemini), lalu tinjau kebijakan data penyedia cadangan. Biaya Gemini Flash-Lite
berbayar diperkirakan sekitar USD 0,001–0,005 per permintaan.

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
`mealora-apps/mealora-model-proxy` untuk langkah deploy. Production saat ini
berjalan dengan Node + pm2 di belakang Nginx Proxy Manager. Tidak ada
infrastruktur baru (tidak ada Supabase, tidak ada layanan terkelola
tambahan) — sejalan dengan keputusan §19 `mealora_product_assessment_v1.1.md`
yang menunda Supabase/backend ke MVP 2.
