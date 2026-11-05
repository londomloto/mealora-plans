# AGENTS.md — <nama-store> (OpenSpec Store)

<!-- CUSTOMIZE: ganti judul di atas dengan id store ini (mis. "bizcare-plans"),
     dan baris di bawah dengan nama project/perusahaan sebenarnya. -->

Repo ini adalah **store OpenSpec**: rumah perencanaan lintas-repo untuk
`<nama-project>`. Tidak ada kode aplikasi di sini. Kode tinggal di repo-repo
terpisah yang di-clone berdampingan dengan store ini (lihat bagian 4).

## 1. Konvensi penomoran dan tipe change

Setiap change diberi nomor urut tiga digit diikuti slug kebab-case, opsional dengan tag tipe tepat setelah nomor:

```
001-foo
002-fix-bar
003-perf-baz
004-workaround-qux
```

Tag tipe (opsional):

| Tag | Untuk change yang... |
|---|---|
| `fix` | memperbaiki perilaku yang sudah ada dan salah/rusak |
| `perf` | soal kecepatan/efisiensi perilaku yang sudah ada, perilaku tidak berubah |
| `workaround` | solusi sementara/stopgap, root cause sengaja belum dibereskan |
| *(tanpa tag)* | feature/kapabilitas baru — **default store ini**, kasus paling umum |

Klasifikasi ini **best effort**, bukan aturan kaku: kalau ambigu, defaultnya tanpa tag (feature). Salah tag tinggal rename manual folder change-nya — tidak ada konsekuensi lain (bukan sesuatu yang dibaca tooling OpenSpec).

OpenSpec **tidak** menomori atau mengklasifikasi otomatis. Jangan menebak nomor manual — hitung dengan script:

```bash
./scripts/next-change.sh foo-slug                          # Linux / macOS -> 001-foo-slug
./scripts/next-change.sh bar-slug --type fix                # -> 002-fix-bar-slug
powershell -File ./scripts/next-change.ps1 -Slug baz-slug -Type perf # Windows -> 003-perf-baz-slug
```

Script memindai change aktif **dan** folder arsip. Pemindaian arsip itu penting karena `openspec archive` menambahkan prefix tanggal, sehingga `001-foo` menjadi `2026-08-18-001-foo`. Tanpa memindai arsip, nomor yang sudah terpakai bisa terpakai ulang.

Untuk langsung membuat change-nya:

```bash
./scripts/next-change.sh foo-slug --create
./scripts/next-change.sh bar-slug --type fix --create
powershell -File ./scripts/next-change.ps1 -Slug foo-slug -Create
```

**`/opsx:propose` (dan `/openspec-propose` untuk agent non-Claude) sudah mengklasifikasikan tipe dan menghitung nomor ini secara otomatis** — skill-nya di-patch oleh `scripts/patch-propose-skill.sh`/`.ps1` (dijalankan otomatis oleh `setup-lead`) supaya memanggil `next-change` dengan `--type` yang sesuai sebelum membuat folder change. Tidak perlu menjalankan `next-change` manual sebelum `/opsx:propose`, kecuali kamu memang mau tahu nomor/tag-nya lebih dulu.

## 2. Schema `<schema>`

<!-- CUSTOMIZE: ganti "<schema>" di atas dan di tabel bawah dengan nama schema
     yang dibuat setup-lead.ps1/.sh (default: "kct-spec-driven" - konvensi
     standar KCT, sama di semua store dari template ini, kecuali di-override
     lewat --schema-name/-SchemaName). Detail instruction tiap artifact ada di
     openspec/schemas/<schema>/schema.yaml — cari komentar "# CUSTOMIZE"
     di sana dan sesuaikan dengan domain project ini sebelum dipakai tim. -->

Change memakai schema `<schema>` (default store ini), dengan enam artifact berurutan:

| # | Artifact | File | Untuk siapa |
|---|---|---|---|
| 1 | proposal | `proposal.md` | tim internal — kenapa dan apa |
| 2 | specs | `specs/**/*.md` | kontrak perilaku normatif (delta) |
| 3 | design | `design.md` | engineer — keputusan teknis |
| 4 | frs | `frs.md` | **client** — bahasa fungsional, non-teknis |
| 5 | workorder | `workorder.md` | PM/tim — WBS, effort, urutan rilis |
| 6 | tasks | `tasks.md` | eksekusi — checklist per repository |

Dua aturan yang paling sering dilanggar:

- **FRS adalah turunan, bukan sumber.** Ia ditulis setelah `specs` dan `design` selesai. Dilarang memperkenalkan requirement baru di FRS — kalau muncul kebutuhan baru saat menulis FRS, revisi `specs` dulu. Dilarang juga menyalin detail implementasi dari `design` (nama tabel, kolom, class, endpoint internal, library).
- **`tasks.md` dikelompokkan per repository.** OpenSpec tidak bisa merutekan task ke repo, jadi setiap heading `## N.` adalah satu repo dengan nama folder persis seperti di workspace, dan task terakhir tiap grup adalah gate verifikasi repo tersebut.

Bila project ini tidak butuh keenam artifact ini (mis. tim kecil, tidak ada
dokumen client-facing terpisah), edit `openspec/schemas/<schema>/schema.yaml`
untuk memangkas artifact yang tidak perlu — jangan biarkan tim menulis
dokumen yang tidak pernah dibaca siapa pun.

## 3. Alur kerja

```bash
/opsx:propose    # buat change + seluruh artifact (planning saja, tidak menyentuh kode)
/opsx:apply      # implementasi, dijalankan DARI repo kode yang bersangkutan
/opsx:archive    # setelah selesai; delta specs ter-merge ke openspec/specs/
```

Perintah lain yang sering dipakai:

```bash
openspec list                       # change aktif
openspec list --specs               # kapabilitas yang sudah ada
openspec status --change <nama>     # progres artifact
openspec validate <nama> --strict
openspec view                       # dashboard
```

Perintah di atas bisa dijalankan dari dalam repo kode mana pun tanpa `--store`, karena pointer di root workspace (lihat bagian 4). Repo kode itu sendiri tidak memuat file OpenSpec apa pun. Bila dijalankan dari luar pohon workspace, tambahkan `--store <id-store>`.

## 4. Setup

### 4.1 Sekali per store (baru pertama kali dibuat)

Bila store ini baru disalin dari repo template dan belum pernah di-`openspec init`, jalankan dulu (lihat juga `README.md`):

```bash
./scripts/setup-lead.sh --id <id-store> --remote <url-git-store-ini>        # Linux / macOS
powershell -File ./scripts/setup-lead.ps1 -Id <id-store> -Remote <url-git-store-ini>    # Windows
```

Ini membuat struktur `openspec/`, memasang schema dari `scripts/schema-template/`, dan mendaftarkan store secara lokal. Detail lihat komentar di kepala tiap script.

### 4.2 Sekali per mesin (dilakukan setiap orang yang clone store)

Clone store ini **berdampingan dengan repo kode project**, lalu jalankan script setup:

```bash
./scripts/setup.sh        # Linux / macOS
powershell -File ./scripts/setup.ps1  # Windows
```

Kedua versi berperilaku sama dan menghasilkan pointer yang byte-identik, sehingga tim campuran Windows dan Linux tidak saling menimpa pekerjaan satu sama lain.

### Konvensi layout folder

Hanya ada **satu** syarat: repo kode berada di bawah satu folder induk bersama, dan folder itulah yang ditunjuk sebagai workspace. Selebihnya bebas.

Yang **tidak** disyaratkan:

- Nama folder. Script tidak peduli folder induknya bernama apa.
- Kedalaman. Repo boleh langsung di bawah workspace, dikelompokkan satu tingkat (`<workspace>/services/<repo>`), atau lebih dalam lagi.
- Pengelompokan. Layout datar maupun berkelompok sama-sama bekerja.
- Lokasi store. Store boleh berada di dalam workspace, boleh di luar.

Contoh layout (bukan keharusan):

```
<workspace>/
├── <id-store>/           <- store (repo ini)
├── <repo-kode-1>/
├── <repo-kode-2>/
└── ...
```

Bila layout Anda berbeda:

- **Store di-clone terpisah dari repo kode** → tunjuk foldernya: `./scripts/setup.sh --workspace-root /path/ke/folder-repo` atau `powershell -File ./scripts/setup.ps1 -WorkspaceRoot D:\path\ke\folder-repo`
- **Repo tersebar di beberapa folder induk** → satu pointer tidak dapat menaungi semuanya; jalankan script sekali per folder induk. Registrasi store dilewati otomatis pada run berikutnya, jadi yang bertambah hanya pointer.

Script menghitung berapa repo Git yang benar-benar ternaungi dan menampilkannya di awal. Penelusuran berhenti di batas tiap repo, sehingga isi repo — termasuk `node_modules` yang kadang memuat `.git` sendiri — tidak ikut terhitung. Bila hasilnya nol, script memperingatkan bahwa pointer kemungkinan ditulis di tempat yang salah. **Perhatikan angka itu**, karena pointer di folder keliru tetap terbuat dan terlihat seperti berhasil.

Script bersifat idempoten: registrasi yang sudah ada dilewati, pointer dan asset yang isinya sudah sesuai dilewati. Menimpa isi yang berbeda butuh `--force` / `-Force` eksplisit, sehingga penyesuaian lokal Anda tidak hilang diam-diam.

Setelah upgrade versi OpenSpec, jalankan `openspec init . --tools claude,agents` di store lalu jalankan ulang script setup dengan `--force` / `-Force` untuk menyegarkan asset user-level. **`openspec init` menimpa balik skill `openspec-propose` ke versi vendor default**, menghapus patch nomor urut change — jalankan `./scripts/patch-propose-skill.sh` (atau `powershell -File ./scripts/patch-propose-skill.ps1`) sesudahnya untuk menerapkannya lagi. Script ini berdiri sendiri, idempoten, dan tidak menyentuh schema atau registrasi store.

**Gap yang diketahui:** script setup di atas hanya memasang `.claude/commands` dan `.claude/skills` ke `~/.claude` (user-level), supaya `/opsx:*` bisa dipanggil dari repo kode mana pun tanpa `--store`. `.agents/skills/` (dihasilkan `--tools ...,agents` untuk dukungan agent non-Claude) **belum** punya propagasi setara — belum ada mekanisme yang membuatnya terjangkau dari luar checkout store ini. Belum dikerjakan karena mekanisme discovery tiap agent non-Claude berbeda-beda (sebagian auto-discover langsung dari cwd/ancestor tanpa perlu instalasi user-level, mirip cara `AGENTS.md` ditemukan; sebagian mungkin butuh sesuatu seperti pointer/instalasi seperti `.claude`). Sebelum mengimplementasikan ini di suatu project, tentukan dulu agent non-Claude mana yang jadi target dan bagaimana ia menemukan skill-nya.

Seluruh script di `scripts/` tersedia dalam dua versi — `.sh` untuk Linux dan macOS, `.ps1` untuk Windows — dan tidak terikat pada proyek ini. Script setup membaca id store dari `.openspec-store/store.yaml` dan nama schema dari `openspec/config.yaml`, sedangkan script penomoran murni bekerja berdasarkan lokasi folder. Keduanya dapat disalin apa adanya ke store OpenSpec lain.

## 5. Dokumen client-facing kumulatif (opsional)

<!-- CUSTOMIZE atau HAPUS bagian ini bila project tidak punya dokumen
     client-facing terpisah dari FRS per-change. Pola ini berguna kalau ada
     pihak eksternal (client) yang perlu melihat kondisi TERKINI satu
     kapabilitas, bukan sejarah tiap change yang membentuknya. -->

`frs.md` di dalam sebuah change bersifat **per-change**: ia ikut terarsip bersama change-nya dan hanya memuat apa yang berubah pada pengiriman itu. Saat archive, hanya delta `specs/` yang di-merge ke `openspec/specs/`.

Untuk dokumen client-facing yang mencerminkan **kondisi terkini** sebuah kapabilitas, tempatnya di `docs/frs/<kapabilitas>.md`. Dikurasi manual, diturunkan dari `openspec/specs/<kapabilitas>/spec.md`, dan diperbarui setelah change yang menyentuh kapabilitas itu diarsipkan.

Aturan yang tidak boleh dilanggar: **specs normatif, FRS penyajian ulang.** Dilarang memperkenalkan requirement baru di FRS — kalau muncul kebutuhan baru, revisi specs dulu lewat change. Bila keduanya bertentangan, FRS-nya yang usang.

## 6. Sumber kebenaran

<!-- CUSTOMIZE: sesuaikan dengan sumber dokumen historis project ini, bila
     ada (repo lama, arsip BRD/FRS, dsb). Hapus bagian ini bila project baru
     tidak punya riwayat dokumen sebelum OpenSpec. -->

- **As-built** ada di `openspec/specs/`. Itu yang berlaku.
- Bila ada dokumen historis dari sebelum store ini dipakai (BRD, FRS draft lama, WBS, dsb), sebutkan di sini lokasinya dan tegaskan statusnya: dokumen historis **bukan** sumber kebenaran, `openspec/specs/` yang menang bila bertentangan.
- Bila sumber bertentangan dan tidak ada keputusan terbaru yang terdokumentasi, hentikan keputusan arsitektural tersebut dan minta klarifikasi.

## 7. Batasan

- Jangan commit atau push kecuali user memintanya.
- Store ini tidak pernah disinkronkan otomatis oleh OpenSpec — pull dan push manual seperti repo biasa.
- Jangan mengedit artefak `.pdf`, `.docx`, atau `.xlsx` sebagai efek samping.
