EXPIRYCARE - STARTER FILES

Cara memasang:
1. Pastikan project Flutter sudah dibuat di C:\ExpiryCare.
2. Ekstrak folder `lib` dan file `pubspec.yaml` dari ZIP ini.
3. Salin ke dalam C:\ExpiryCare.
4. Jika Windows meminta konfirmasi penggantian file, pilih Replace untuk file yang memang sama.
5. Buka terminal pada folder C:\ExpiryCare, lalu jalankan:
      flutter pub get
      flutter analyze
      flutter run

PENTING:
- File ini adalah starter implementasi dengan Dashboard, My Items, Detail, Add/Edit, Calendar, History.
- Data disimpan lokal memakai SharedPreferences.
- Ada dummy data awal.
- Riwayat saat ini menampilkan item yang sudah melewati tanggal kedaluwarsa; item yang dihapus belum diarsipkan.
- Setelah file disalin, minta Antigravity memeriksa, memperbaiki error, dan menyempurnakan UI/UX tanpa menghapus fitur yang sudah berfungsi.

PROMPT UNTUK ANTIGRAVITY:
"Periksa seluruh file starter ExpiryCare yang sudah ada di project ini. Jangan membuat ulang project dan jangan menghapus fitur yang sudah berjalan. Jalankan flutter pub get dan flutter analyze, perbaiki semua error/warning penting, lalu jalankan aplikasi. Pastikan CRUD, pencarian, filter kategori/status, countdown, kalender, dan penyimpanan SharedPreferences berfungsi. Sempurnakan UI menjadi cute, playful, illustrative, modern, dan konsisten dengan palet warna di kode. Laporkan file yang diubah dan hasil pengujian."
