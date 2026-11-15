import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:expiremate/models/item_model.dart';
import 'package:expiremate/screens/add_item_screen.dart';
import 'package:expiremate/screens/app_shell.dart';
import 'package:expiremate/screens/calendar_screen.dart';
import 'package:expiremate/screens/dashboard_screen.dart';
import 'package:expiremate/screens/history_screen.dart';
import 'package:expiremate/screens/item_detail_screen.dart';
import 'package:expiremate/screens/items_screen.dart';
import 'package:expiremate/screens/splash_screen.dart';
import 'package:expiremate/services/storage_service.dart';
import 'package:expiremate/utils/helpers.dart';
import 'package:expiremate/widgets/item_card.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('A. Model & Helper Business Logic Tests', () {
    test('Calculates daysLeft and status accurately', () {
      final now = DateTime.now();
      DateTime day(int offset) =>
          DateTime(now.year, now.month, now.day + offset);

      final safeItem = ExpiryItem(
        id: '1',
        name: 'Sereal Jagung',
        category: 'Makanan',
        quantity: 2,
        purchaseDate: day(-5),
        expiryDate: day(10),
      );
      expect(safeItem.daysLeft, 10);
      expect(safeItem.status, 'Aman');
      expect(countdownText(safeItem), 'Sisa 10 hari lagi');

      final soonItem = ExpiryItem(
        id: '2',
        name: 'Susu Segar',
        category: 'Minuman',
        quantity: 1,
        purchaseDate: day(-2),
        expiryDate: day(3),
      );
      expect(soonItem.daysLeft, 3);
      expect(soonItem.status, 'Segera Kedaluwarsa');
      expect(countdownText(soonItem), 'Sisa 3 hari lagi');

      final tomorrowItem = ExpiryItem(
        id: '2b',
        name: 'Roti Tawar',
        category: 'Makanan',
        quantity: 1,
        purchaseDate: day(-1),
        expiryDate: day(1),
      );
      expect(tomorrowItem.daysLeft, 1);
      expect(tomorrowItem.status, 'Segera Kedaluwarsa');
      expect(countdownText(tomorrowItem), 'Kedaluwarsa besok');

      final todayItem = ExpiryItem(
        id: '3',
        name: 'Sandwich Telur',
        category: 'Makanan',
        quantity: 1,
        purchaseDate: day(-1),
        expiryDate: day(0),
      );
      expect(todayItem.daysLeft, 0);
      expect(todayItem.status, 'Kedaluwarsa Hari Ini');
      expect(countdownText(todayItem), 'Kedaluwarsa hari ini!');

      final expiredItem = ExpiryItem(
        id: '4',
        name: 'Yogurt Rasa Buah',
        category: 'Makanan',
        quantity: 1,
        purchaseDate: day(-10),
        expiryDate: day(-3),
      );
      expect(expiredItem.daysLeft, -3);
      expect(expiredItem.status, 'Kedaluwarsa');
      expect(countdownText(expiredItem), 'Kedaluwarsa 3 hari yang lalu');
    });

    test('Serializes to and from Map accurately', () {
      final now = DateTime(2026, 11, 15);
      final item = ExpiryItem(
        id: 'test-123',
        name: 'Teh Hijau',
        category: 'Minuman',
        quantity: 5,
        purchaseDate: now,
        expiryDate: now.add(const Duration(days: 30)),
        note: 'Disimpan di lemari',
      );

      final map = item.toMap();
      final reconstructed = ExpiryItem.fromMap(map);

      expect(reconstructed.id, item.id);
      expect(reconstructed.name, item.name);
      expect(reconstructed.category, item.category);
      expect(reconstructed.quantity, item.quantity);
      expect(reconstructed.note, item.note);
      expect(reconstructed.purchaseDate, item.purchaseDate);
      expect(reconstructed.expiryDate, item.expiryDate);
    });

    test('Category icons and emojis return valid mappings', () {
      expect(categoryEmoji('Makanan'), '🥗');
      expect(categoryEmoji('Minuman'), '🧃');
      expect(categoryEmoji('Obat-obatan'), '💊');
      expect(categoryEmoji('Perawatan Kulit'), '✨');
      expect(categoryEmoji('Perlengkapan Rumah'), '🏡');
      expect(categoryEmoji('Lainnya'), '📦');

      expect(categoryIcon('Makanan'), Icons.restaurant_rounded);
      expect(categoryIcon('Obat-obatan'), Icons.medication_rounded);
    });
  });

  group('B. StorageService Integration Tests', () {
    test('Loads initial sample items when preferences is empty', () async {
      SharedPreferences.setMockInitialValues({});
      final items = await StorageService.loadItems();
      expect(items.isNotEmpty, isTrue);
      expect(items.any((e) => e.status == 'Aman'), isTrue);
      expect(items.any((e) => e.status == 'Segera Kedaluwarsa'), isTrue);
      expect(items.any((e) => e.status == 'Kedaluwarsa Hari Ini'), isTrue);
      expect(items.any((e) => e.status == 'Kedaluwarsa'), isTrue);
    });

    test('Saves and reloads items accurately', () async {
      SharedPreferences.setMockInitialValues({});
      final testItems = [
        ExpiryItem(
          id: 'custom-1',
          name: 'Vitamin D3',
          category: 'Obat-obatan',
          quantity: 2,
          purchaseDate: DateTime(2026, 1, 1),
          expiryDate: DateTime(2026, 12, 31),
          note: 'Catatan sampel',
        ),
      ];

      await StorageService.saveItems(testItems);
      final reloaded = await StorageService.loadItems();
      expect(reloaded.length, 1);
      expect(reloaded.first.name, 'Vitamin D3');
    });
  });

  group('C. Screen & Navigation Widget Tests', () {
    final now = DateTime.now();
    DateTime day(int offset) => DateTime(now.year, now.month, now.day + offset);

    final dummyItems = [
      ExpiryItem(
        id: 'item-safe',
        name: 'Oatmeal',
        category: 'Makanan',
        quantity: 2,
        purchaseDate: day(-5),
        expiryDate: day(20),
      ),
      ExpiryItem(
        id: 'item-soon',
        name: 'Susu Murni',
        category: 'Minuman',
        quantity: 1,
        purchaseDate: day(-2),
        expiryDate: day(2),
      ),
      ExpiryItem(
        id: 'item-today',
        name: 'Donat Cokelat',
        category: 'Makanan',
        quantity: 1,
        purchaseDate: day(-1),
        expiryDate: day(0),
      ),
      ExpiryItem(
        id: 'item-expired',
        name: 'Salad Sayur',
        category: 'Makanan',
        quantity: 1,
        purchaseDate: day(-10),
        expiryDate: day(-2),
      ),
    ];

    testWidgets('1. Splash Screen renders title, mascot and navigates',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: SplashScreen(initialItems: dummyItems),
        ),
      );

      expect(find.text('ExpireMate'), findsOneWidget);
      expect(find.text('Teman Pintar Pengingat Kedaluwarsa'), findsOneWidget);
      expect(find.text('Mulai Sekarang'), findsOneWidget);

      await tester.tap(find.text('Mulai Sekarang'));
      await tester.pumpAndSettle();

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.text('Yuk, cek barang-barangmu!'), findsOneWidget);
    });

    testWidgets('2. Dashboard Screen shows stats and handles navigation',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool addTapped = false;
      bool openItemsTapped = false;
      ExpiryItem? detailItem;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DashboardScreen(
              items: dummyItems,
              onAdd: () => addTapped = true,
              onOpenItems: () => openItemsTapped = true,
              onOpenDetail: (item) => detailItem = item,
            ),
          ),
        ),
      );

      expect(find.textContaining('ExpireMate'), findsOneWidget);
      expect(find.text('Total Barang'), findsOneWidget);
      expect(find.text('4'), findsOneWidget);
      expect(find.text('Aman'), findsWidgets);
      expect(find.text('Segera Kedaluwarsa'), findsWidgets);
      expect(find.text('Kedaluwarsa'), findsWidgets);

      await tester.tap(find.text('Tambah Barang Baru'));
      expect(addTapped, isTrue);

      await tester.tap(find.text('Lihat semua'));
      expect(openItemsTapped, isTrue);

      await tester.tap(find.text('Susu Murni'));
      expect(detailItem?.name, 'Susu Murni');
    });

    testWidgets('3. My Items Screen supports real-time search & filters',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ItemsScreen(
              items: dummyItems,
              onAdd: () {},
              onEdit: (_) async {},
              onDelete: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Barang Saya 📦'), findsOneWidget);
      expect(find.text('Menampilkan 4 dari 4 barang'), findsOneWidget);

      // Filter by Search Query
      await tester.enterText(find.byType(TextField), 'Oatmeal');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ItemCard, 'Oatmeal'), findsOneWidget);
      expect(find.widgetWithText(ItemCard, 'Susu Murni'), findsNothing);
      expect(find.text('Menampilkan 1 dari 4 barang'), findsOneWidget);

      // Clear search
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ItemCard, 'Susu Murni'), findsOneWidget);

      // Search with no matches
      await tester.enterText(find.byType(TextField), 'NonExistentItemXYZ');
      await tester.pumpAndSettle();
      expect(find.text('Tidak ada barang yang ditemukan'), findsOneWidget);
    });

    testWidgets('4. Item Detail Screen displays info and delete confirmation',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      bool editCalled = false;
      bool deleteCalled = false;

      final testItem = dummyItems[1]; // Susu Murni

      await tester.pumpWidget(
        MaterialApp(
          home: ItemDetailScreen(
            item: testItem,
            onEdit: () => editCalled = true,
            onDelete: () => deleteCalled = true,
          ),
        ),
      );

      expect(find.text('Susu Murni'), findsOneWidget);
      expect(find.text('Minuman'), findsOneWidget);
      expect(find.text('Edit Barang'), findsOneWidget);
      expect(find.text('Hapus Barang'), findsOneWidget);

      // Tap Edit
      await tester.tap(find.text('Edit Barang'));
      expect(editCalled, isTrue);

      // Tap Delete to open confirmation dialog
      await tester.tap(find.text('Hapus Barang'));
      await tester.pumpAndSettle();

      expect(find.text('Hapus Barang?'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Hapus'), findsOneWidget);

      // Confirm delete
      await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
      await tester.pumpAndSettle();
      expect(deleteCalled, isTrue);
    });

    testWidgets('5. Add/Edit Screen validates input constraints',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(
          home: AddItemScreen(),
        ),
      );

      expect(find.text('Tambah Barang Baru'), findsOneWidget);

      // Try submitting empty form
      await tester.tap(find.text('Simpan Barang ke Pelacak'));
      await tester.pumpAndSettle();

      // Check validation error
      expect(find.text('Nama barang wajib diisi'), findsOneWidget);

      // Enter valid name
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Barang *'),
        'Alpukat Mentega',
      );

      // Enter invalid quantity (0)
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Kuantitas *'),
        '0',
      );
      await tester.tap(find.text('Simpan Barang ke Pelacak'));
      await tester.pumpAndSettle();

      expect(
        find.text('Kuantitas harus berupa angka lebih dari 0'),
        findsOneWidget,
      );
    });

    testWidgets(
        '6. Calendar Screen shows month grid and items on selected date',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CalendarScreen(
              items: dummyItems,
              onEdit: (_) async {},
              onDelete: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Kalender Kedaluwarsa 📅'), findsOneWidget);
      expect(find.text('Min'), findsOneWidget);
      expect(find.text('Sen'), findsOneWidget);

      // Today is selected by default; dummyItems[2] 'Donat Cokelat' expires today
      expect(find.text('Donat Cokelat'), findsOneWidget);
    });

    testWidgets('7. History Screen displays expired items', (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HistoryScreen(
              items: dummyItems,
              onEdit: (_) async {},
              onDelete: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Riwayat Kedaluwarsa 📜'), findsOneWidget);
      expect(find.text('1 kedaluwarsa'), findsOneWidget);
      expect(find.text('Salad Sayur'), findsOneWidget);
      expect(find.text('Susu Murni'), findsNothing);
    });

    testWidgets('8. Full App navigation via BottomNavigationBar',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(initialItems: dummyItems),
        ),
      );

      // Check initial Home/Dashboard
      expect(find.text('Total Barang'), findsOneWidget);

      // Navigate to Barang Saya tab
      await tester.tap(find.text('Barang Saya'));
      await tester.pumpAndSettle();
      expect(find.text('Barang Saya 📦'), findsOneWidget);

      // Navigate to Kalender tab
      await tester.tap(find.text('Kalender'));
      await tester.pumpAndSettle();
      expect(find.text('Kalender Kedaluwarsa 📅'), findsOneWidget);

      // Navigate to Riwayat tab
      await tester.tap(find.text('Riwayat'));
      await tester.pumpAndSettle();
      expect(find.text('Riwayat Kedaluwarsa 📜'), findsOneWidget);

      // Navigate back to Beranda
      await tester.tap(find.text('Beranda'));
      await tester.pumpAndSettle();
      expect(find.text('Total Barang'), findsOneWidget);
    });

    testWidgets('9. Complete CRUD lifecycle updates state & storage',
        (tester) async {
      tester.view.physicalSize = const Size(1080, 1920);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final liveItems = List<ExpiryItem>.of(dummyItems);

      await tester.pumpWidget(
        MaterialApp(
          home: AppShell(initialItems: liveItems),
        ),
      );

      // Initial count on Dashboard
      expect(find.text('4'), findsOneWidget);

      // 1. CREATE: Tap FloatingActionButton to Add Item
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();
      expect(find.text('Tambah Barang Baru'), findsOneWidget);

      // Fill in details
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Barang *'),
        'Madu Alami',
      );
      await tester.tap(find.text('Simpan Barang ke Pelacak'));
      await tester.pumpAndSettle();

      // Should be back to AppShell and count increased to 5
      expect(find.text('5'), findsOneWidget);

      // 2. READ: Go to Barang Saya and verify 'Madu Alami' is listed
      await tester.tap(find.text('Barang Saya'));
      await tester.pumpAndSettle();
      expect(find.widgetWithText(ItemCard, 'Madu Alami'), findsOneWidget);

      // 3. UPDATE: Open Item Details and Edit
      await tester.tap(find.widgetWithText(ItemCard, 'Madu Alami'));
      await tester.pumpAndSettle();
      expect(find.text('Detail Barang'), findsOneWidget);
      expect(find.text('Madu Alami'), findsOneWidget);

      // Tap Edit Barang
      await tester.tap(find.text('Edit Barang'));
      await tester.pumpAndSettle();
      expect(find.text('Edit Barang'), findsOneWidget);

      // Change name to 'Madu Hutan Liar'
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nama Barang *'),
        'Madu Hutan Liar',
      );
      await tester.tap(find.text('Simpan Perubahan'));
      await tester.pumpAndSettle();

      // Back in Barang Saya, verify updated name
      expect(find.widgetWithText(ItemCard, 'Madu Hutan Liar'), findsOneWidget);

      // 4. DELETE: Open detail and delete
      await tester.tap(find.widgetWithText(ItemCard, 'Madu Hutan Liar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hapus Barang'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Hapus'));
      await tester.pumpAndSettle();

      // Verify item removed from Barang Saya list
      expect(find.widgetWithText(ItemCard, 'Madu Hutan Liar'), findsNothing);
    });
  });
}
