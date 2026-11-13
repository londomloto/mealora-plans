## MODIFIED Requirements

### Requirement: Pengguna dapat membuat makanan sendiri

Sistem SHALL memungkinkan pengguna membuat makanan yang tidak ada di katalog, dengan masukan sekurang-kurangnya: nama, ukuran sajian, energi, protein, karbohidrat, dan lemak.

Sistem SHALL menyediakan dua cara mengisi nilai gizi: **isi manual**, yang menjadi cara bawaan, dan **hitung dari bahan** (lihat kapabilitas `custom-food-recipe`). Pengguna SHALL dapat memilih isi manual tanpa harus memasukkan bahan apa pun.

Sistem SHALL menyatakan bahwa nilai sebaiknya disalin dari sumber yang dipercaya pengguna, dan SHALL menyatakan bahwa nilai yang belum diketahui jangan diisi nol. Nilai yang dikosongkan SHALL disimpan sebagai belum diketahui.

Makanan buatan pengguna SHALL ditandai berbeda dari makanan katalog bawaan, SHALL mencatat apakah nilai gizinya diisi manual atau dihitung dari bahan, dan SHALL dapat dicari serta dicatat seperti makanan lain.

#### Scenario: Membuat makanan sendiri

- **WHEN** pengguna menyimpan makanan buatan sendiri dengan nama, ukuran sajian, dan nilai gizi
- **THEN** makanan itu tersedia pada pencarian berikutnya dan ditandai sebagai makanan buatan pengguna

#### Scenario: Isi manual tetap tersedia

- **WHEN** pengguna membuka layar buat makanan sendiri dan sudah mengetahui nilai gizinya
- **THEN** pengguna dapat langsung mengisi nilai gizi secara manual dan menyimpan tanpa menambahkan bahan

#### Scenario: Nilai gizi dikosongkan

- **WHEN** pengguna mengosongkan nilai lemak karena tidak mengetahuinya
- **THEN** nilai itu tersimpan sebagai belum diketahui dan tidak diubah menjadi nol

#### Scenario: Nilai tidak masuk akal

- **WHEN** pengguna memasukkan nilai gizi negatif atau ukuran sajian nol
- **THEN** sistem menolak dengan penjelasan dan tidak menyimpan makanan itu
