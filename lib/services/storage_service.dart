import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/item_model.dart';

class StorageService {
  static const _key = 'expiremate_items_v1';
  static const _legacyKey = 'expirycare_items_v1';

  static Future<List<ExpiryItem>> loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    var raw = prefs.getString(_key);
    raw ??= prefs.getString(_legacyKey);
    if (raw == null) return _sampleItems();
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final list = decoded
          .map((e) => ExpiryItem.fromMap(Map<String, dynamic>.from(e as Map)))
          .toList();
      return list.isEmpty ? _sampleItems() : list;
    } catch (_) {
      return _sampleItems();
    }
  }

  static Future<void> saveItems(List<ExpiryItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((item) => item.toMap()).toList());
    await prefs.setString(_key, encoded);
    await prefs.setString(_legacyKey, encoded);
  }

  static List<ExpiryItem> _sampleItems() {
    final now = DateTime.now();
    DateTime day(int offset) => DateTime(now.year, now.month, now.day + offset);
    return [
      ExpiryItem(
        id: 'sample-1',
        name: 'Susu Segar Organik',
        category: 'Minuman',
        quantity: 2,
        purchaseDate: day(-3),
        expiryDate: day(1),
        note: 'Simpan di lemari es suhu dingin',
      ),
      ExpiryItem(
        id: 'sample-2',
        name: 'Yogurt Stroberi',
        category: 'Makanan',
        quantity: 3,
        purchaseDate: day(-5),
        expiryDate: day(4),
        note: 'Cocok untuk sarapan pagi',
      ),
      ExpiryItem(
        id: 'sample-3',
        name: 'Roti Gandum Utuh',
        category: 'Makanan',
        quantity: 1,
        purchaseDate: day(-2),
        expiryDate: day(0),
        note: 'Habiskan sebelum malam ini',
      ),
      ExpiryItem(
        id: 'sample-4',
        name: 'Vitamin C 500mg',
        category: 'Obat-obatan',
        quantity: 1,
        purchaseDate: day(-15),
        expiryDate: day(25),
        note: 'Minum 1 tablet setelah sarapan',
      ),
      ExpiryItem(
        id: 'sample-5',
        name: 'Tabir Surya SPF50',
        category: 'Perawatan Kulit',
        quantity: 1,
        purchaseDate: day(-30),
        expiryDate: day(60),
        note: 'Gunakan sebelum beraktivitas di luar',
      ),
      ExpiryItem(
        id: 'sample-6',
        name: 'Sari Apel Kemasan',
        category: 'Minuman',
        quantity: 1,
        purchaseDate: day(-10),
        expiryDate: day(-2),
        note: 'Segel botol sudah terbuka',
      ),
      ExpiryItem(
        id: 'sample-7',
        name: 'Tisu Basah Antibakteri',
        category: 'Perlengkapan Rumah',
        quantity: 4,
        purchaseDate: day(-12),
        expiryDate: day(14),
        note: 'Simpan di kotak meja tamu',
      ),
    ];
  }
}
