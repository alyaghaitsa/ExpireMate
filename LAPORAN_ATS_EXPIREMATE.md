# LAPORAN ASESMEN TENGAH SEMESTER (ATS)
## PRAKTIKUM PEMROGRAMAN PERANGKAT BERGERAK (RPL317)

---

**Nama Aplikasi**: ExpireMate  
**Tagline**: *Your Smart Expiry Companion — Never Miss an Expiry Date!*  
**Penyusun**: Alya Ghaitsa Salsabila  
**NIM**: 4342501051  
**Program Studi**: D4 Rekayasa Perangkat Lunak  
**Mata Kuliah**: Praktikum Pemrograman Perangkat Bergerak (RPL317)  
**Tahun Akademik**: 2026/2027  

---

## TAUTAN PENGUMPULAN & REPOSITORI
- **Link Repositori GitHub**: `[Tempelkan Link GitHub Anda di Sini]` *(contoh: https://github.com/alyaghaitsa/ExpireMate)*
- **Link Video Demonstrasi Aplikasi**: `[Tempelkan Link Video Demo YouTube / Google Drive di Sini]`

---

## 1. DESKRIPSI APLIKASI
**ExpireMate** adalah aplikasi mobile berbasis Flutter yang dirancang untuk membantu pengguna mencatat, memantau, dan mengelola tanggal kedaluwarsa berbagai kebutuhan sehari-hari, seperti makanan segar, minuman kemasan, obat-obatan, produk perawatan kulit (*skincare*), hingga perlengkapan rumah tangga (*household*).

Aplikasi ini mengusung pendekatan visual yang **Cute, Playful, Illustrative, Modern, Fresh, dan Aesthetic** dengan maskot beruang kecil pembawa keranjang belanja (🐻🧺) serta palet warna pastel yang lembut:
- **Soft Green** (`#B7DDB5`): Memberikan kesan kesegaran dan keberlanjutan lingkungan.
- **Dark Green** (`#527C55`): Warna aksen utama yang elegan, ramah, dan berorientasi alam.
- **Cream** (`#FFF8E9`): Warna dasar latar belakang (*scaffold*) yang hangat dan nyaman di mata.
- **Soft Yellow** (`#FFE7A8`): Indikator peringatan barang yang segera kedaluwarsa (*Expiring Soon*).
- **Soft Pink** (`#F8CACA`): Indikator peringatan barang yang telah melewati kedaluwarsa (*Expired*).
- **White** (`#FFFFFF`): Warna kartu dan kontainer elemen agar kontras dan mudah dibaca.

Dengan ExpireMate, pengguna dapat mengurangi pemborosan makanan (*food waste*), menghindari konsumsi obat/makanan berbahaya yang sudah kedaluwarsa, dan berbelanja lebih bijak.

---

## 2. ALASAN PEMILIHAN TOPIK
1. **Permasalahan Nyata di Kehidupan Sehari-hari (*Food & Product Waste*)**: Banyak keluarga dan anak kos sering kali lupa tanggal kedaluwarsa barang yang disimpan di dalam kulkas, lemari makanan, atau kotak obat. Akibatnya, barang terbuang sia-sia atau membahayakan kesehatan saat dikonsumsi tanpa sengaja.
2. **Kesesuaian dengan Kompetensi Mobile Programming**: Topik ini mencakup seluruh aspek penilaian ATS RPL317 secara komprehensif, meliputi manipulasi tanggal (*DateTime calculations*), penyimpanan persisten lokal (*SharedPreferences*), validasi input bertingkat, dynamic state management, navigasi multi-screen, dan desain UI/UX berbasis Material 3 yang menarik.
3. **Usability & Personalization**: Pengguna membutuhkan pencatatan yang cepat dan visualisasi instan, baik melalui ringkasan dashboard, filter kategori, maupun tampilan kalender bulanan.

---

## 3. TOOLS DAN TEKNOLOGI
- **Bahasa Pemrograman**: Dart (SDK 3.13.2 / 3.4.0+)
- **Framework**: Flutter 3.x (Material Design 3)
- **Target Platform**: Android Mobile & Web Chrome
- **State Management**: Stateful Architecture & State Lifting via Callbacks
- **Penyimpanan Data Lokal**: `shared_preferences` (v2.5.3+)
- **Editor / IDE**: VS Code / Google Antigravity Agentic IDE
- **Linter & Analyzer**: `flutter_lints` (v5.0.0), `dart format`, `flutter analyze`
- **Testing Engine**: `flutter_test` (Unit Test, Integration Test, & Widget Test)

---

## 4. ARSITEKTUR DAN STRUKTUR PROJECT
Project dibangun dengan arsitektur modular yang memisahkan tanggung jawab model, presentation (screens & widgets), service, dan helper utilities:

```
ExpiryCare/
├── android/                       # Konfigurasi platform Android (Gradle, Manifest, Kotlin)
│   ├── app/
│   │   ├── build.gradle.kts       # namespace & applicationId: com.example.expirycare
│   │   └── src/main/
│   │       ├── AndroidManifest.xml# android:label="ExpireMate"
│   │       └── kotlin/com/example/expirycare/MainActivity.kt
│   └── local.properties           # Path Android SDK & Flutter SDK
├── web/                           # Konfigurasi platform Web Chrome (PWA, Manifest, HTML)
│   ├── index.html                 # Title: ExpireMate - Your Smart Expiry Companion
│   └── manifest.json              # Web app metadata & theme colors
├── lib/
│   ├── main.dart                  # Entry point aplikasi, theme data, inisialisasi awal
│   ├── models/
│   │   └── item_model.dart        # Model ExpiryItem, logika status & kalkulasi hari
│   ├── screens/
│   │   ├── splash_screen.dart     # Halaman pembuka dengan animasi maskot & branding
│   │   ├── app_shell.dart         # Container navigasi bawah & pengelola state utama
│   │   ├── dashboard_screen.dart  # Redesign kreatif: Header, Hero, Overview, Categories, Urgent
│   │   ├── items_screen.dart      # Daftar My Items, search pill modern, filter kategori chips
│   │   ├── item_detail_screen.dart# Visual produk dominan, tabel info, countdown, dialog hapus
│   │   ├── add_item_screen.dart   # Form modern, visual category selector, validasi tanggal
│   │   ├── calendar_screen.dart   # Kalender colorful, status dots, filter per tanggal
│   │   └── history_screen.dart    # Arsip riwayat barang kedaluwarsa & empty state cute
│   ├── services/
│   │   └── storage_service.dart   # Abstraksi SharedPreferences & penyedia dummy data
│   ├── utils/
│   │   └── helpers.dart           # Palet warna, format tanggal, greeting, pemetaan emoji
│   └── widgets/
│       └── item_card.dart         # Komponen kartu barang cute berbayang lembut & rounded
├── test/
│   └── expiremate_test.dart       # Pengujian otomatis (14 skenario pengujian 100% lolos)
├── pubspec.yaml                   # Definisi paket, dependensi, dan metadata
└── README.md                      # Dokumentasi repositori project
```

---

## 5. PENJELASAN REDESIGN SETIAP HALAMAN (7 SCREENS)

### 1. Splash Screen (`screens/splash_screen.dart`)
- **Konsep**: Sambutan hangat dan *memorable* dengan identitas brand ExpireMate.
- **Elemen Visual**:
  - Animasi kurva scale-in maskot beruang dan keranjang belanja (🐻🧺) berlingkar gradien Soft Green & Soft Yellow.
  - Percikan bintang (*sparkles*) (✨).
  - Judul brand **ExpireMate** tebal bergradasi alam, tagline *"Teman Pintar Pengingat Kedaluwarsa"*, dan sub-tagline *"Jangan Lewatkan Tanggal Kedaluwarsa! 🌱"*.
  - Tombol aksi *"Mulai Sekarang"* dengan sudut membulat modern (22px) dan bayangan lembut.
  - Timer navigasi otomatis 2,5 detik atau langsung masuk saat layar disentuh.

### 2. Dashboard Screen (`screens/dashboard_screen.dart`) — *Fokus Redesign Utama*
- **A. Header Dinamis**:
  - Sapaan cerdas otomatis (*Selamat Pagi! ☀️*, *Selamat Siang! 🌤️*, atau *Selamat Malam! 🌙*) menyesuaikan waktu perangkat pengguna.
  - Subtitle ramah: *"Yuk, cek barang-barangmu!"*.
  - Tanggal hari ini dalam format ramah Bahasa Indonesia (*e.g. Minggu, 15 Nov 2026*).
  - Avatar lingkaran berlapis maskot beruang kecil dengan cincin pastel.
- **B. Hero Banner Section**:
  - Kartu Soft Green `#B7DDB5` berpola gelembung pastel dengan badge *"✨ ExpireMate"*.
  - Headline inspiratif: *"Teman Pintar Pengingat Kedaluwarsa — Catat hari ini, kurangi sampah esok hari 🌱"*.
  - Maskot ilustrasi keranjang belanja 🧺 berlingkar putih dengan drop-shadow lembut.
- **C. Ringkasan Kedaluwarsa (4 Kartu Statistik Dinamis)**:
  - **Total Barang**: Kartu Soft Sage `#EBF6EA` dengan ikon inventaris dan emoji 📦.
  - **Aman**: Kartu Soft Green `#B7DDB5` dengan ikon daun ramah lingkungan dan emoji 🌿.
  - **Segera Kedaluwarsa**: Kartu Soft Yellow `#FFE7A8` dengan ikon jam dan emoji ⏰.
  - **Kedaluwarsa**: Kartu Soft Pink `#F8CACA` dengan ikon peringatan dan emoji ⚠️.
  - Seluruh angka statistik terhubung langsung ke data riil inventaris.
- **D. Kategori Cepat (Categories Quick Bar)**:
  - Baris kategori horizontal berbentuk kartu rounded berlingkar ikon: Makanan 🥗, Minuman 🧃, Obat-obatan 💊, Perawatan Kulit ✨, dan Perlengkapan Rumah 🏡.
  - Dilengkapi indikator jumlah barang di tiap kategori.
  - **Navigasi Interaktif**: Menekan salah satu kategori langsung membuka halaman *Barang Saya* dengan filter kategori tersebut telah aktif.
- **E. Segera Kedaluwarsa (Bagian Barang Mendesak)**:
  - Menyajikan daftar barang yang kedaluwarsa hari ini atau dalam waktu ≤ 7 hari.
  - Dilengkapi badge urgensi *"X Mendesak"*, countdown sisa hari (*e.g. "Sisa 3 hari lagi"*, *"Kedaluwarsa hari ini!"*), dan kartu interaktif yang langsung membuka detail barang saat diklik.
- **F. Quick Action**:
  - Tombol *"Tambah Barang Baru"* berdesain outline hijau tua elegan di bawah daftar, ditambah Floating Action Button (FAB) melayang di sudut bawah.

### 3. My Items Screen (`screens/items_screen.dart`) — *Barang Saya*
- **Pencarian Modern**: Input pencarian berbentuk *pill* membulat bersih dengan teks petunjuk *"Cari barang berdasarkan nama atau catatan..."* dan tombol *clear* cepat.
- **Filter Kategori Chips**: Tab filter horizontal (*Semua, Makanan, Minuman, Obat-obatan, Perawatan Kulit, Perlengkapan Rumah*) dengan status aktif berwarna hijau tua berkilau (*elevation shadow*).
- **Filter Status Chips**: Filter status bertingkat (*Semua, Aman, Segera Kedaluwarsa, Kedaluwarsa Hari Ini, Kedaluwarsa*) dengan warna Soft Green membulat.
- **Ringkasan & Reset**: Menampilkan jumlah hasil pencarian (*Menampilkan X dari Y barang*) dan tombol *"Reset Semua Filter"* jika filter aktif.

### 4. Item Detail Screen (`screens/item_detail_screen.dart`) — *Detail Barang*
- **Visual Produk Dominan**: Avatar kategori besar di dalam lingkaran konsentris lembut berdiameter 86px.
- **Banner Status Kontras**: Banner horizontal melengkung yang menampilkan status barang dan countdown sisa hari secara tegas dalam Bahasa Indonesia.
- **Spesifikasi Kartu Rapi**: Kartu informasi berbaris rapi (Kuantitas, Tanggal Pembelian, Tanggal Kedaluwarsa, Hitung Mundur, Catatan Penyimpanan) dengan ikon khas pada setiap baris.
- **Aksi Cepat & Dialog Konfirmasi**: Tombol *"Edit Barang"* berwarna Dark Green solid dan tombol *"Hapus Barang"* merah berbingkai dengan dialog konfirmasi modal (*"Hapus Barang?"*, *"Batal"*, *"Hapus"*) sebelum penghapusan data.

### 5. Add / Edit Item Screen (`screens/add_item_screen.dart`) — *Tambah / Edit Barang*
- **Form Card Modern**: Input dibungkus dalam kartu putih bersih berborder halus `#ECE7D8`.
- **Visual Category Selector**: Pilihan kategori menggunakan *chips* visual Bahasa Indonesia (*Makanan, Minuman, Obat-obatan, Perawatan Kulit, Perlengkapan Rumah, Lainnya*) dengan emoji.
- **Tombol Pemilih Tanggal Ramah**: Tombol input decorator dengan kalender interaktif bertema Dark Green dan Soft Cream berformat tanggal Indonesia.
- **Validasi Visual Real-Time**: Nama wajib diisi (*"Nama barang wajib diisi"*), kuantitas wajib angka > 0 (*"Kuantitas harus berupa angka lebih dari 0"*), dan tanggal kedaluwarsa dilarang sebelum tanggal pembelian (*"Tanggal kedaluwarsa tidak boleh sebelum tanggal pembelian."*).

### 6. Expiry Calendar Screen (`screens/calendar_screen.dart`) — *Kalender Kedaluwarsa*
- **Kalender Bulanan Colorful**: Grid kalender elegan dengan tajuk hari berbahasa Indonesia (*Min, Sen, Sel, Rab, Kam, Jum, Sab*) dan nama bulan Indonesia (*Januari - Desember*).
- **Indikator Titik Status (Status Dots)**:
  - Tanggal dengan barang Aman ditandai Soft Green.
  - Tanggal dengan barang Segera Kedaluwarsa ditandai Soft Yellow.
  - Tanggal dengan barang Kedaluwarsa ditandai Soft Pink.
  - Tanggal yang dipilih pengguna disorot warna Dark Green dengan angka putih tebal.
- **Daftar Hari Terpilih**: Menampilkan daftar kartu barang yang jatuh tempo pada tanggal yang diklik.

### 7. History Screen (`screens/history_screen.dart`) — *Riwayat Kedaluwarsa*
- **Rekam Jejak Kronologis**: Menampilkan barang-barang yang telah melewati masa kedaluwarsa secara terurut.
- **Aesthetic Empty State**: Menampilkan ilustrasi bunga dan bintang (*🌷✨*), pesan apresiasi *"Tidak Ada Barang Kedaluwarsa!"*, dan pesan motivasi untuk terus menjaga kesegaran persediaan.

---

## 6. PENJELASAN FITUR UTAMA DINAMIS

1. **CRUD Barang Lengkap (Create, Read, Update, Delete)**:
   - Tambah barang baru melalui tombol form atau FAB.
   - Update data barang (nama, kategori, kuantitas, tanggal, catatan) langsung tersimpan dan tercermin di seluruh layar.
   - Hapus barang dengan modal dialog konfirmasi dan snackbar feedback.
2. **Pencarian Real-Time**:
   - Filter query teks mencari secara instan pada atribut `name` dan `note` tanpa delay.
3. **Filter Multi-Kriteria (Kategori & Status)**:
   - Kombinasi filter kategori dan status dapat digunakan secara bersamaan.
4. **Kalkulasi Countdown Tanggal Otomatis**:
   - Model `ExpiryItem` menghitung selisih hari (`difference.inDays`) yang dinormalisasi pada awal hari (jam 00:00:00).
5. **Klasifikasi 4 Status Otomatis (Bahasa Indonesia)**:
   - `Aman` (*Safe*): Sisa hari > 7 hari.
   - `Segera Kedaluwarsa` (*Expiring Soon*): Sisa hari 1 s.d. 7 hari.
   - `Kedaluwarsa Hari Ini` (*Expires Today*): Sisa hari = 0 (hari ini).
   - `Kedaluwarsa` (*Expired*): Sisa hari < 0 (sudah lewat).
6. **Kalender Kedaluwarsa Interaktif**:
   - Pengguna dapat melihat beban kedaluwarsa pada grid bulanan dan memeriksa barang apa saja yang jatuh tempo di tanggal tertentu.
7. **Statistik Dashboard Dinamis**:
   - Angka statistik ringkasan di dashboard secara reaktif menghitung ulang nilai saat terjadi aksi tambah, edit, atau hapus barang.

---

## 7. IMPLEMENTASI STATE MANAGEMENT DAN LIFECYCLE

### A. State Management
- Pola **State Lifting** terpusat pada widget `AppShell` (`StatefulWidget`).
- Data list `_items` disimpan sebagai state utama di `_AppShellState`.
- Operasi mutasi data (`_addOrEdit` dan `_delete`) didefinisikan di `AppShell` dan dioperkan ke *child screen* melalui *typed callback functions*.
- Saat terjadi mutasi, `setState()` dipanggil untuk memicu re-render sinkron pada seluruh tab (Dashboard, My Items, Calendar, History), kemudian dilanjutkan dengan pemanggilan *asynchronous* `StorageService.saveItems(_items)` agar data persisten.
- Menggunakan `IndexedStack` pada navigasi bawah untuk mempertahankan state halaman dan posisi scroll saat berpindah tab.

### B. Widget Lifecycle
- **`initState()`**:
  - Di `AppShell`: Menginisialisasi list `_items` dari `widget.initialItems`.
  - Di `SplashScreen`: Menginisialisasi `AnimationController` dan `Timer`.
  - Di `AddItemScreen`: Mempersiapkan nilai awal pada `TextEditingController` jika dalam mode *edit*.
  - Di `CalendarScreen`: Mengatur default tanggal terpilih ke tanggal hari ini.
- **`dispose()`**:
  - Seluruh `TextEditingController`, `AnimationController`, dan `Timer` di-dispose dengan disiplin untuk mencegah kebocoran memori (*memory leak*).
- **`mounted` Check**:
  - Setiap pemanggilan `Navigator` atau `ScaffoldMessenger` setelah operasi `await` selalu memeriksa `if (!mounted) return;` untuk memastikan widget masih aktif dalam pohon widget.

---

## 8. VALIDASI DAN EXCEPTION HANDLING

1. **Validasi Input Form**:
   - **Nama Barang**: Wajib diisi dan minimal 2 karakter (mencegah whitespace kosong dengan `.trim()`).
   - **Kategori**: Wajib memilih salah satu opsi dari daftar yang valid.
   - **Kuantitas**: Dicek dengan `int.tryParse(v)`. Menolak angka <= 0, nilai kosong, atau karakter non-numerik.
   - **Relasi Tanggal**: Tanggal kedaluwarsa divalidasi tidak boleh mendahului tanggal pembelian (`_expiryDate.isBefore(_purchaseDate)`). Jika terjadi, form memunculkan pesan kesalahan visual dan snackbar peringatan.
2. **Exception Handling & Keamanan Data**:
   - `StorageService.loadItems()` dibungkus dalam blok `try-catch`. Jika file penyimpanan korup atau gagal didecode, aplikasi tidak akan crash melainkan otomatis kembali ke data bawaan (*fallback sample data*).
   - Dukungan *backward compatibility* pada key penyimpanan SharedPreferences (`expiremate_items_v1` dan `expirycare_items_v1`).

---

## 9. HASIL PENGUJIAN AKTUAL

### A. Pengujian Analisis Kode (`flutter analyze`)
```
Command: flutter analyze
Status: Exited with code 0
Output:
Analyzing ExpiryCare...
No issues found! (ran in 1.6s)
```

### B. Pengujian Test Suite (`flutter test`)
```
Command: flutter test
Status: Exited with code 0
Output:
00:00 +0: A. Model & Helper Business Logic Tests Calculates daysLeft and status accurately
00:00 +1: A. Model & Helper Business Logic Tests Serializes to and from Map accurately
00:00 +2: A. Model & Helper Business Logic Tests Category icons and emojis return valid mappings
00:00 +3: B. StorageService Integration Tests Loads initial sample items when preferences is empty
00:00 +4: B. StorageService Integration Tests Saves and reloads items accurately
00:00 +5: C. Screen & Navigation Widget Tests 1. Splash Screen renders title, mascot and navigates
00:01 +6: C. Screen & Navigation Widget Tests 2. Dashboard Screen shows stats and handles navigation
00:02 +7: C. Screen & Navigation Widget Tests 3. My Items Screen supports real-time search & filters
00:02 +8: C. Screen & Navigation Widget Tests 4. Item Detail Screen displays info and delete confirmation
00:03 +9: C. Screen & Navigation Widget Tests 5. Add/Edit Screen validates input constraints
00:03 +10: C. Screen & Navigation Widget Tests 6. Calendar Screen shows month grid and items on selected date
00:03 +11: C. Screen & Navigation Widget Tests 7. History Screen displays expired items
00:03 +12: C. Screen & Navigation Widget Tests 8. Full App navigation via BottomNavigationBar
00:05 +13: C. Screen & Navigation Widget Tests 9. Complete CRUD lifecycle updates state & storage
00:07 +14: All tests passed!
```

### C. Kompilasi Web Chrome (`flutter build web`)
```
Command: flutter build web
Output:
Compiling lib\main.dart for the Web...
√ Built build\web (53.8s)
```

---

## 10. CUPLIKAN SOURCE CODE INTI FUNGSIONALITAS

### A. Model & Kalkulasi Otomatis Status Kedaluwarsa (`lib/models/item_model.dart`)
```dart
int get daysLeft {
  final today = DateTime.now();
  final a = DateTime(today.year, today.month, today.day);
  final b = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
  return b.difference(a).inDays;
}

String get status {
  if (daysLeft < 0) return 'Kedaluwarsa';
  if (daysLeft == 0) return 'Kedaluwarsa Hari Ini';
  if (daysLeft <= 7) return 'Segera Kedaluwarsa';
  return 'Aman';
}
```

### B. Header Dinamis & Kategorisasi Interaktif Dashboard (`lib/screens/dashboard_screen.dart`)
```dart
// Sapaan otomatis sesuai waktu perangkat
final greeting = getGreetingMessage();
final todayDate = formatFriendlyDate(DateTime.now());

// Navigasi instan kategori ke layar My Items
InkWell(
  onTap: () {
    if (onSelectCategory != null) {
      onSelectCategory!(catName);
    } else {
      onOpenItems();
    }
  },
  borderRadius: BorderRadius.circular(20),
  child: ...
)
```

### C. Validasi Hubungan Tanggal (`lib/screens/add_item_screen.dart`)
```dart
void _submit() {
  setState(() {
    if (_expiryDate.isBefore(_purchaseDate)) {
      _dateError = 'Tanggal kedaluwarsa tidak boleh sebelum tanggal pembelian.';
    } else {
      _dateError = null;
    }
  });

  if (!_formKey.currentState!.validate()) return;
  if (_dateError != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_dateError!),
        backgroundColor: const Color(0xFFC2410C),
      ),
    );
    return;
  }
  // Pembentukan objek ExpiryItem
  final item = ExpiryItem(
    id: widget.existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
    name: _name.text.trim(),
    category: _category,
    quantity: int.parse(_quantity.text.trim()),
    purchaseDate: _purchaseDate,
    expiryDate: _expiryDate,
    note: _note.text.trim(),
  );
  Navigator.pop(context, item);
}
```

---

## 11. TABEL DAFTAR FILE YANG DIUBAH / DISEMPURNAKAN

| No | Path File | Status | Keterangan Redesign & Penyempurnaan |
|---|---|---|---|
| 1 | `lib/screens/dashboard_screen.dart` | **Redesign Penuh** | Header sapaan waktu & tanggal, Hero banner maskot 🐻🧺, 4 kartu overview pastel berbayang lembut, Categories bar interaktif, dan section Expiring Soon. |
| 2 | `lib/screens/items_screen.dart` | **Redesign Penuh** | Search pill modern, filter kategori chips horizontal, status chips, dan integrasi filter langsung dari Dashboard. |
| 3 | `lib/screens/item_detail_screen.dart` | **Redesign Penuh** | Avatar konsentris 86px, banner status kontras, spesifikasi kartu rapi berikon, dan tombol aksi modern. |
| 4 | `lib/screens/add_item_screen.dart` | **Redesign Penuh** | Form modern, visual selector chips kategori, tombol date picker berikon, dan validasi tanggal dinamis. |
| 5 | `lib/screens/calendar_screen.dart` | **Redesign Penuh** | Kalender bulanan colorful, status dots (hijau/kuning/merah muda), sorotan tanggal aktif, dan rincian per tanggal. |
| 6 | `lib/screens/history_screen.dart` | **Redesign Penuh** | Arsip barang kedaluwarsa kronologis, kartu riwayat interaktif, dan empty state estetik dengan pesan apresiasi. |
| 7 | `lib/screens/splash_screen.dart` | **Redesign Penuh** | Animasi ganda scale & fade-in, maskot cincin gradien, branding kuat ExpireMate, dan CTA button *"Get Started"*. |
| 8 | `lib/screens/app_shell.dart` | **Penyempurnaan** | Integrasi parameter `_selectedCategory`, floating action button modern, dan bar navigasi bawah Material 3. |
| 9 | `lib/widgets/item_card.dart` | **Redesign Penuh** | Squircle container berbayang lembut, badge kategori pastel, countdown pill berwarna status, dan ripple tap. |
| 10 | `lib/utils/helpers.dart` | **Penyempurnaan** | Fungsi `getGreetingMessage()`, `formatFriendlyDate()`, pemetaan warna pastel dan background kategori. |
| 11 | `lib/main.dart` | **Penyempurnaan** | Theme global Material 3, card theme, dialog theme, dan input decoration terpadu. |
| 12 | `web/index.html` & `web/manifest.json` | **Penyempurnaan** | Branding web: ExpireMate - Your Smart Expiry Companion dengan tema `#527C55` dan `#FFF8E9`. |
| 13 | `test/expiremate_test.dart` | **Diverifikasi** | 14 skenario pengujian unit & widget testing seluruh alur aplikasi 100% lulus. |
| 14 | `README.md` & `LAPORAN_ATS_EXPIREMATE.md` | **Diperbarui** | Dokumentasi lengkap project dan laporan resmi ATS RPL317. |

---
**Status Akhir**: SELESAI (100% Fitur Berfungsi Sempurna, UI/UX Menarik & Profesional, 0 Error / Warning, 14/14 Pengujian Lulus, Build Web Chrome Berhasil).
