# starter-plans

Template generik untuk membuat store [OpenSpec](https://github.com/Fission-AI/OpenSpec) baru bagi project lain (workflow proposal → specs → design → FRS → work order → tasks, seperti yang dipakai di estabiz-plans).

## Pemakaian

1. Buat repo plan kosong di server (mis. `bizcare-plans`) lalu clone ke lokal, atau clone repo ini sebagai titik awal dan ganti remote-nya. Bila repo kodenya belum ada di server sama sekali, salin saja isi `scripts/` ke folder plan yang masih lokal-only.
2. Dari root store, jalankan sekali (oleh satu orang saja):

   ```bash
   ./scripts/setup-lead.sh --id bizcare-plans
   ```

   atau di PowerShell:

   ```powershell
   .\scripts\setup-lead.ps1 -Id bizcare-plans
   ```

   Ini menjalankan `openspec init`, mem-patch skill `openspec-propose` supaya `/opsx:propose` otomatis menghitung nomor urut change, memasang schema template di `openspec/schemas/kct-spec-driven/` (nama default, konvensi standar KCT — bisa diganti dengan `--schema-name`/`-SchemaName`), mengarahkan `openspec/config.yaml` ke schema itu, dan mendaftarkan store secara lokal. Remote git dibaca otomatis dari `origin` bila sudah ada; tambahkan `--remote <url>` / `-Remote <url>` hanya bila folder ini benar-benar belum punya remote.

3. Sesuaikan `openspec/schemas/<nama>/schema.yaml` dan `openspec/config.yaml` dengan domain project (cari komentar `# CUSTOMIZE`), lalu lakukan hal yang sama pada `AGENTS.md` (ganti placeholder `<nama-store>`, `<schema>`, dsb — cari komentar HTML `<!-- CUSTOMIZE -->`).
4. Commit dan push store ini. Setiap teammate lain yang meng-clone-nya cukup menjalankan `scripts/setup.ps1` / `scripts/setup.sh` (setup per mesin: registrasi lokal + pointer workspace + asset Claude Code) — **tidak perlu** `setup-lead`.

## Isi

- `AGENTS.md` — dokumen onboarding untuk tim/agent: konvensi penomoran change, schema, alur kerja `/opsx:*`, setup, dan sumber kebenaran. Salin ke store baru dan sesuaikan placeholder-nya.
- `scripts/setup-lead.ps1` / `.sh` — setup satu-kali per store (langkah 2 di atas).
- `scripts/setup.ps1` / `.sh` — setup per mesin (dijalankan siapa pun yang clone store).
- `scripts/next-change.ps1` / `.sh` — menghitung nomor urut change berikutnya (001, 002, ...).
- `scripts/patch-propose-skill.ps1` / `.sh` — mem-patch skill `openspec-propose` supaya otomatis memanggil `next-change`. Dipanggil otomatis oleh `setup-lead`; jalankan manual lagi setelah `openspec init ... --force` (mis. pasca-upgrade OpenSpec) karena itu menimpa balik skill ke versi vendor.
- `scripts/schema-template/` — schema OpenSpec generik yang disalin `setup-lead` ke store baru.
