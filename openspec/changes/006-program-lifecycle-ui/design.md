# Design — 006 · Mengelola program yang berjalan

## Context

Lihat `proposal.md` — Why. Keadaan saat ini: change 003 menyediakan perintah siklus hidup yang teruji, change 004 menyediakan penyimpanan beserta riwayat dan potret kemajuan, change 005 menyediakan profil, pratinjau target, dan aktivasi. Ruang Program masih berupa keadaan kosong dari change 001.

Rancangan tersedia di `docs/mealora-v2.pen`: `05 · Program saya`, `27 · Program dijeda`, `28 · Pratinjau ganti program`, `29 · Riwayat program`, `30 · Detail program selesai`, `34 · Ubah profil & target`, dan `39 · Selesaikan program`. Satu layar yang diwajibkan §45 belum ada: rincian "Bagaimana dihitung" untuk program yang sedang berjalan.

## Goals / Non-Goals

**Goals**

- Pengguna dapat melihat keadaan programnya dan mengubahnya tanpa menebak-nebak akibatnya.
- Setiap angka yang tampil punya penjelasan yang bisa dibuka — termasuk peringatan yang menyertainya.
- Setiap tindakan yang memindahkan program ke riwayat ditinjau lebih dulu dan bisa dibatalkan tanpa akibat.
- Data yang belum ada tampak sebagai belum ada, di setiap layar tanpa kecuali.

**Non-Goals**

- Tidak ada pencatatan makanan, berat badan, atau riwayat harian — angka kemajuan dari buku harian tetap "belum diketahui" sampai change berikutnya.
- Tidak ada perubahan aturan siklus hidup, kebijakan, atau skema basis data.
- Tidak ada pengaturan satuan, bahasa, atau privasi; hanya butir Program saya dan Riwayat program pada ruang Profil yang disambungkan.
- Tidak ada notifikasi, pengingat, atau saran otomatis terkait program.

## Decisions

### D1 — Ruang Program sebagai satu layar yang berubah menurut keadaan

Program aktif (`05`) dan program dijeda (`27`) adalah satu layar dengan susunan yang sama dan isi yang berbeda, bukan dua layar terpisah. Keduanya menampilkan program, target, kemajuan, berat terbaru, dan kendali; yang berbeda adalah penanda keadaan dan kendali mana yang tersedia.

Alasannya bukan penghematan kode: dua layar terpisah cenderung berbeda diam-diam seiring waktu, dan perbedaan yang paling mudah menyelinap adalah bagian "kemajuan" — tempat aturan hari jeda tidak boleh salah.

### D2 — Layar baru: "Bagaimana dihitung" untuk program berjalan

§45 mewajibkan tanggal perhitungan terakhir dan rincian penjelasan pada ruang Program, tetapi rancangan baru menyediakan padanannya untuk program yang sudah selesai (`30`).

Rancangan yang dipilih: layar rincian yang strukturnya mengikuti `30 · Detail program selesai`, dengan bagian yang sama — target yang berlaku, masukan yang dipakai, asumsi, peringatan, tanggal perhitungan terakhir, dan kedua versi. Yang berbeda hanya bingkainya: program ini masih berjalan, sehingga rinciannya dibuka dari ruang Program dan bukan dari riwayat.

Memakai struktur yang sama bukan kemalasan — pengguna yang pernah membaca detail program lamanya akan menemukan hal yang sama persis di tempat yang sama, dan itu yang membuat keterjelasan terasa dapat dipercaya.

**Peringatan ikut ditampilkan di sini, bukan hanya saat pratinjau.** Ini keputusan yang disengaja: peringatan seperti "batas bawah energi menaikkan target Anda" muncul sekali saat onboarding lalu hilang selamanya kalau tidak disimpan di tempat yang bisa dibuka lagi. Padahal justru peringatan itu yang menjelaskan mengapa angkanya tidak seperti yang pengguna harapkan.

### D3 — Setiap tindakan yang memindahkan program ke riwayat ditinjau lebih dulu

Ganti (`28`) dan selesaikan (`39`) sama-sama memakai pola: tampilkan akibatnya, tegaskan apa yang tidak berubah, sediakan jalan batal yang tidak berakibat apa-apa.

Pada pergantian, yang ditegaskan adalah program lama pindah ke riwayat dan catatan makanan serta berat tetap utuh. Pada penyelesaian, yang ditegaskan adalah ringkasan akhir disimpan dan program selesai tidak dapat dilanjutkan.

Keduanya tidak memakai dialog konfirmasi singkat. Dialog "Yakin?" tidak memberi informasi apa pun — yang dibutuhkan pengguna adalah tahu apa yang akan terjadi, bukan ditanya dua kali.

### D4 — Pergantian memakai ulang alur pratinjau dan aktivasi dari change 005

Pratinjau pengganti pada `28` menampilkan ringkasan, lalu meneruskan ke alur pratinjau target yang sudah ada. Aktivasi memakai perintah yang sama, termasuk verifikasi ulang fakta dan layar "masukan berubah sejak pratinjau".

Membangun jalur aktivasi kedua yang terpisah akan menghasilkan dua tempat yang harus sama-sama benar tentang hal yang paling berisiko di produk ini.

### D5 — Revisi target memakai pratinjau yang sama, dengan bingkai berbeda

Ubah profil (`34`) menyatakan bahwa target berjalan tidak langsung berubah, lalu menawarkan peninjauan. Peninjauan itu adalah layar pratinjau target yang sama dengan onboarding, dengan tambahan perbandingan terhadap target yang berlaku sekarang.

Perbandingan ditampilkan karena pengguna di sini punya titik acuan yang pengguna onboarding tidak punya: ia sudah hidup dengan satu angka, dan yang ingin ia ketahui adalah seberapa jauh angka barunya bergeser.

### D6 — Riwayat membaca nilai tersimpan apa adanya

Daftar riwayat (`29`) dan detail (`30`) tidak menghitung ulang apa pun. Keduanya membaca baris program pengguna dan potret kemajuan yang sudah tersimpan (change 004 D10).

Konsekuensi yang harus ditangani di tampilan: potret lama bisa punya nilai yang kosong. Layar wajib menampilkan "belum ada data di hari terakhir" apa adanya — seperti yang sudah dirancang di `30` — dan tidak boleh mengisi celah itu dengan nilai terakhir yang diketahui.

### D7 — Keadaan khusus dirancang, bukan ditemukan saat uji coba

Empat keadaan yang disebut §45 — belum ada program, profil belum lengkap, belum ada catatan berat, kebijakan tidak tersedia — ditangani sebagai bagian layar, bukan sebagai kasus tepi yang ditambal kemudian.

Tiga di antaranya memakai komponen keadaan kosong dari change 001; keadaan kebijakan tidak tersedia memakai kerangka penolakan dari change 005. Tidak ada komponen baru yang dibuat untuk ini.

### D8 — Tidak ada perubahan skema

Seluruh data yang ditampilkan change ini sudah tersedia dari change 004. Bila sebuah layar membutuhkan nilai yang belum ada di skema, itu pertanda layarnya menampilkan sesuatu yang tidak pernah disetujui — bukan pertanda skemanya kurang.

## Risks / Trade-offs

- **Kemajuan masih kosong karena buku harian belum ada** → ruang Program akan terasa setengah jadi saat diperlihatkan. Mitigasi: keadaan "belum diketahui" memang perilaku yang benar dan sudah dirancang; aturan hari jeda dan kelengkapan pencatatan tetap diuji dengan catatan tiruan, lalu diuji ulang dengan data sungguhan pada change buku harian.
- **Satu layar untuk dua keadaan (aktif dan dijeda)** bisa menjadi rumit bila kendali dan keterangan bertambah → mitigasi: perbedaan dibatasi pada penanda keadaan dan daftar kendali; bila melar melebihi itu, pisahkan dan catat alasannya.
- **Layar "Bagaimana dihitung" hasil rancangan sendiri** belum pernah diuji ke pengguna → mitigasi: strukturnya meniru `30` yang sudah matang, sehingga risikonya terbatas pada penempatan, bukan isi.
- **Perbandingan target lama dan baru pada revisi** bisa mendorong pengguna mengejar angka yang lebih agresif → mitigasi: perbandingan menampilkan selisih apa adanya tanpa penilaian, dan guardrail kebijakan tetap berlaku penuh.
- **Riwayat menampilkan nilai kosong** dapat dianggap bug oleh pengguna → mitigasi: kalimat eksplisit seperti pada rancangan `30` ("Belum ada data di hari terakhir"), bukan sel kosong tanpa keterangan.
- **Pengguna salah mengira "selesaikan" dapat dibatalkan** → mitigasi: pernyataan bahwa program selesai tidak dapat dilanjutkan tampil sebelum tindakan, bukan setelahnya.

## Migration Plan

Tidak ada perubahan skema dan tidak ada migrasi. Urutan penerapan:

1. Ruang Program untuk keadaan aktif dan dijeda, beserta keadaan khusus.
2. Rincian "Bagaimana dihitung" — dirancang di dokumen desain lebih dulu, lalu dibangun.
3. Kendali jeda, lanjutkan, dan selesaikan.
4. Pratinjau dan pelaksanaan pergantian, memakai ulang alur aktivasi.
5. Riwayat dan detail program.
6. Ubah profil dan peninjauan revisi target.
7. Penyambungan butir menu pada ruang Profil.

Rollback: murni penambahan lapisan tampilan; membuang commit mengembalikan ruang Program ke keadaan kosong tanpa memengaruhi data pengguna.

## Open Questions

Tidak ada pertanyaan yang ditunda. Satu hal yang akan ditinjau ulang pada change buku harian, bukan sekarang: ukuran kemajuan mana yang ditampilkan untuk program Makan Sehat di ruang Program. Rancangan `05` sudah menetapkan kelengkapan pencatatan mingguan sebagai bentuknya, dan itu cukup untuk dibangun; isian angkanya baru punya sumber setelah buku harian ada.
