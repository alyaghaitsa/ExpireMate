import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../services/storage_service.dart';
import '../utils/helpers.dart';
import 'dashboard_screen.dart';
import 'items_screen.dart';
import 'calendar_screen.dart';
import 'history_screen.dart';
import 'add_item_screen.dart';
import 'item_detail_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.initialItems});
  final List<ExpiryItem> initialItems;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late List<ExpiryItem> _items;
  int _selectedIndex = 0;
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _items = List.of(widget.initialItems);
  }

  Future<void> _save() async {
    await StorageService.saveItems(_items);
  }

  Future<void> _addOrEdit(ExpiryItem? existing) async {
    final result = await Navigator.push<ExpiryItem>(
      context,
      MaterialPageRoute(
        builder: (_) => AddItemScreen(existing: existing),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      final index = _items.indexWhere((e) => e.id == result.id);
      if (index >= 0) {
        _items[index] = result;
      } else {
        _items.add(result);
      }
    });

    await _save();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          existing == null
              ? '✨ "${result.name}" berhasil ditambahkan ke pelacak!'
              : '✅ "${result.name}" berhasil diperbarui!',
        ),
        backgroundColor: kDarkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _delete(ExpiryItem item) {
    setState(() {
      _items.removeWhere((e) => e.id == item.id);
    });
    _save();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🗑️ "${item.name}" telah dihapus.'),
        backgroundColor: const Color(0xFF4B4F4C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  void _openDetail(ExpiryItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemDetailScreen(
          item: item,
          onEdit: () {
            Navigator.pop(context);
            _addOrEdit(item);
          },
          onDelete: () {
            Navigator.pop(context);
            _delete(item);
          },
        ),
      ),
    );
  }

  void _handleSelectCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedIndex = 1; // Pindah ke tab Barang Saya
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(
        items: _items,
        onAdd: () => _addOrEdit(null),
        onOpenItems: () => setState(() {
          _selectedCategory = 'Semua';
          _selectedIndex = 1;
        }),
        onOpenDetail: _openDetail,
        onSelectCategory: _handleSelectCategory,
      ),
      ItemsScreen(
        items: _items,
        initialCategory: _selectedCategory,
        onAdd: () => _addOrEdit(null),
        onEdit: _addOrEdit,
        onDelete: _delete,
      ),
      CalendarScreen(
        items: _items,
        onEdit: _addOrEdit,
        onDelete: _delete,
      ),
      HistoryScreen(
        items: _items,
        onEdit: _addOrEdit,
        onDelete: _delete,
      ),
    ];

    return Scaffold(
      backgroundColor: kCream,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: pages,
        ),
      ),
      floatingActionButton: (_selectedIndex == 0 || _selectedIndex == 1)
          ? FloatingActionButton.extended(
              onPressed: () => _addOrEdit(null),
              backgroundColor: kDarkGreen,
              foregroundColor: kWhite,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              icon: const Icon(Icons.add_rounded, size: 22),
              label: const Text(
                'Tambah Barang',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
              ),
            )
          : null,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: kWhite,
          border: Border(
            top: BorderSide(color: kCardBorder, width: 1.2),
          ),
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: (i) => setState(() => _selectedIndex = i),
          backgroundColor: kWhite,
          indicatorColor: kSoftGreen,
          elevation: 0,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home_rounded, color: kDarkGreen),
              label: 'Beranda',
            ),
            NavigationDestination(
              icon: Icon(Icons.inventory_2_outlined),
              selectedIcon: Icon(Icons.inventory_2_rounded, color: kDarkGreen),
              label: 'Barang Saya',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined),
              selectedIcon:
                  Icon(Icons.calendar_month_rounded, color: kDarkGreen),
              label: 'Kalender',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_rounded),
              selectedIcon: Icon(Icons.history_rounded, color: kDarkGreen),
              label: 'Riwayat',
            ),
          ],
        ),
      ),
    );
  }
}
