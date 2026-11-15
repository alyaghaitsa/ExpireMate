# 🧺 ExpireMate — Teman Pintar Pengingat Kedaluwarsa

> **"Jangan Lewatkan Tanggal Kedaluwarsa!"**  
> *Catat hari ini, kurangi sampah esok hari 🌱*

ExpireMate adalah aplikasi pelacak tanggal kedaluwarsa barang yang dirancang dengan antarmuka yang ramah, imut (*cute*), ceria (*playful*), ilustratif, modern, segar (*fresh*), dan estetik. Aplikasi ini memudahkan Anda mencatat dan memantau persediaan makanan, minuman, obat-obatan, kosmetik (*skincare*), dan produk rumah tangga.

---

## 🎨 Palet Warna Identitas
- **Soft Green** (`#B7DDB5`)
- **Dark Green** (`#527C55`)
- **Cream** (`#FFF8E9`)
- **Soft Yellow** (`#FFE7A8`)
- **Soft Pink** (`#F8CACA`)
- **White** (`#FFFFFF`)

---

## ✨ Fitur & Antarmuka (UI/UX Design)
1. **Seluruh Antarmuka Berbahasa Indonesia**:
   - Seluruh teks, label, sapaan waktu, nama kategori, status kedaluwarsa, format tanggal, pesan konfirmasi, validasi formulir, dan notifikasi menggunakan Bahasa Indonesia yang ramah dan natural.
2. **Dashboard Kreatif & Modern**:
   - **Header Dinamis**: Sapaan waktu (*Selamat Pagi / Siang / Malam*), tanggal hari ini (*e.g. Minggu, 15 Nov 2026*), dan avatar maskot beruang kecil (🐻).
   - **Hero Section**: Kartu pastel beruang membawa keranjang belanja (🐻🧺) dengan tagline *"Teman Pintar Pengingat Kedaluwarsa"* dan pesan pengingat anti-pemborosan (*zero-waste*).
   - **Ringkasan Kedaluwarsa**: 4 kartu ringkasan dinamis (Total Barang 📦, Aman 🌿, Segera Kedaluwarsa ⏰, Kedaluwarsa ⚠️) dengan palet warna pastel dan bayangan lembut.
   - **Kategori Cepat**: Pilihan kategori melingkar (Makanan 🥗, Minuman 🧃, Obat-obatan 💊, Perawatan Kulit ✨, Perlengkapan Rumah 🏡) yang langsung memfilter layar *Barang Saya* saat diklik.
   - **Bagian Segera Kedaluwarsa**: Bagian khusus barang mendesak yang segera jatuh tempo dengan badge status dan navigasi langsung ke detail.
   - **Aksi Cepat**: Tombol *"Tambah Barang Baru"* berdesain elegan dan Floating Action Button (FAB) responsif.
3. **Layar Barang Saya (My Items)**:
   - Pencarian modern berbentuk *pill*, filter kategori chips horizontal, dan filter status bertingkat dengan reset instan.
4. **Layar Detail Barang (Item Detail)**:
   - Avatar kategori konsentris besar (86px), banner status & countdown kontras, tabel rincian berikon, tombol Edit dan Hapus dengan dialog konfirmasi modal.
5. **Layar Tambah / Edit Barang (Add / Edit Item)**:
   - Form modern berbingkai lembut, visual selector chips kategori, tombol date picker berikon, dan validasi tanggal dinamis (tanggal kedaluwarsa tidak boleh sebelum tanggal pembelian).
6. **Layar Kalender Kedaluwarsa (Expiry Calendar)**:
   - Kalender bulanan colorful dengan titik indikator status (hijau, kuning, merah muda), tajuk hari & bulan Indonesia, serta sorotan tanggal aktif.
7. **Layar Riwayat Kedaluwarsa (History)**:
   - Arsip barang kedaluwarsa secara kronologis dan tampilan *empty state* estetik bertema *"Tidak Ada Barang Kedaluwarsa!"*.
8. **Penyimpanan Persisten**:
   - Menggunakan `shared_preferences` dengan fallback error handling dan data awal realistis.

---

## 🚀 Cara Menjalankan Aplikasi

1. **Clone atau buka folder project**:
   ```bash
   cd C:\ExpiryCare
   ```

2. **Unduh dependensi**:
   ```bash
   flutter pub get
   ```

3. **Jalankan pengujian otomatis**:
   ```bash
   flutter test
   ```

4. **Periksa analisis kode**:
   ```bash
   flutter analyze
   ```

5. **Jalankan di Google Chrome (Web)**:
   ```bash
   flutter run -d chrome
   ```

6. **Jalankan di HP Android (USB Debugging)**:
   ```bash
   flutter run
   ```

---

## 🧪 Hasil Pengujian Terverifikasi
- **flutter analyze**: `No issues found! (ran in 1.6s)` (0 error, 0 warning).
- **flutter test**: `14 tests passed!` (100% lulus).
- **flutter build web**: `√ Built build\web (53.8s)` (Kompilasi Web Chrome Berhasil).
