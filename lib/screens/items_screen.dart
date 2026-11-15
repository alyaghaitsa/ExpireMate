import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
    this.initialCategory = 'Semua',
  });

  final List<ExpiryItem> items;
  final VoidCallback onAdd;
  final Future<void> Function(ExpiryItem?) onEdit;
  final void Function(ExpiryItem) onDelete;
  final String initialCategory;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  late String _category;
  String _status = 'Semua';

  final List<Map<String, String>> _categories = [
    {'name': 'Semua', 'emoji': '🌟'},
    {'name': 'Makanan', 'emoji': '🥗'},
    {'name': 'Minuman', 'emoji': '🧃'},
    {'name': 'Obat-obatan', 'emoji': '💊'},
    {'name': 'Perawatan Kulit', 'emoji': '✨'},
    {'name': 'Perlengkapan Rumah', 'emoji': '🏡'},
  ];

  final List<String> _statuses = [
    'Semua',
    'Aman',
    'Segera Kedaluwarsa',
    'Kedaluwarsa Hari Ini',
    'Kedaluwarsa',
  ];

  @override
  void initState() {
    super.initState();
    _category = _normalizeCategory(widget.initialCategory);
  }

  @override
  void didUpdateWidget(covariant ItemsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialCategory != widget.initialCategory) {
      _category = _normalizeCategory(widget.initialCategory);
    }
  }

  String _normalizeCategory(String cat) {
    if (cat == 'All') return 'Semua';
    if (cat == 'Food') return 'Makanan';
    if (cat == 'Beverage') return 'Minuman';
    if (cat == 'Medicine') return 'Obat-obatan';
    if (cat == 'Skincare') return 'Perawatan Kulit';
    if (cat == 'Household') return 'Perlengkapan Rumah';
    return cat;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _query = '';
      _category = 'Semua';
      _status = 'Semua';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.items.where((item) {
      final matchesName =
          item.name.toLowerCase().contains(_query.toLowerCase()) ||
              item.note.toLowerCase().contains(_query.toLowerCase());

      final matchesCategory = _category == 'Semua' ||
          item.category == _category ||
          (_category == 'Makanan' && item.category == 'Food') ||
          (_category == 'Minuman' && item.category == 'Beverage') ||
          (_category == 'Obat-obatan' && item.category == 'Medicine') ||
          (_category == 'Perawatan Kulit' && item.category == 'Skincare') ||
          (_category == 'Perlengkapan Rumah' && item.category == 'Household');

      final matchesStatus = _status == 'Semua' ||
          item.status == _status ||
          (_status == 'Aman' && item.status == 'Safe') ||
          (_status == 'Segera Kedaluwarsa' && item.status == 'Expiring Soon') ||
          (_status == 'Kedaluwarsa Hari Ini' &&
              item.status == 'Expires Today') ||
          (_status == 'Kedaluwarsa' && item.status == 'Expired');

      return matchesName && matchesCategory && matchesStatus;
    }).toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        // Page Title & Subtitle
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barang Saya 📦',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Kelola inventarismu agar tetap segar dan tertata',
                  style: TextStyle(fontSize: 13, color: kSubText),
                ),
              ],
            ),
            IconButton.filledTonal(
              icon: const Icon(Icons.refresh_rounded, color: kDarkGreen),
              style: IconButton.styleFrom(backgroundColor: kCream),
              tooltip: 'Reset Filter',
              onPressed: _resetFilters,
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Modern Pill Search Field
        Container(
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: kCardBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (v) => setState(() => _query = v.trim()),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.search_rounded, color: kDarkGreen, size: 22),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded,
                          size: 18, color: kSubText),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              hintText: 'Cari barang berdasarkan nama atau catatan...',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Horizontal Category Filter Chips
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final catName = cat['name']!;
              final catEmoji = cat['emoji']!;
              final isSelected = _category == catName;

              return InkWell(
                onTap: () => setState(() => _category = catName),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? kDarkGreen : kWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? kDarkGreen : kCardBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: kDarkGreen.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Text(catEmoji, style: const TextStyle(fontSize: 13)),
                      const SizedBox(width: 6),
                      Text(
                        catName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                          color: isSelected ? kWhite : kDarkText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),

        // Status Filter Chips
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _statuses.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final st = _statuses[index];
              final isSelected = _status == st;

              return InkWell(
                onTap: () => setState(() => _status = st),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? kSoftGreen : kWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF86B984) : kCardBorder,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    st,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? const Color(0xFF224525) : kSubText,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 18),

        // Results Summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Menampilkan ${filtered.length} dari ${widget.items.length} barang',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                color: kDarkText,
              ),
            ),
            if (_query.isNotEmpty || _category != 'Semua' || _status != 'Semua')
              GestureDetector(
                onTap: _resetFilters,
                child: const Text(
                  'Hapus filter',
                  style: TextStyle(
                    fontSize: 12,
                    color: kDarkGreen,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        // Items List or Empty View
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const Text('🔍🌼', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 12),
                const Text(
                  'Tidak ada barang yang ditemukan',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: kDarkText,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Coba ubah kata kunci pencarian atau filter yang dipilih.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kSubText, fontSize: 13),
                ),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: _resetFilters,
                  style: FilledButton.styleFrom(
                    backgroundColor: kSoftGreen,
                    foregroundColor: const Color(0xFF224525),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Reset Semua Filter',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ],
            ),
          )
        else
          ...filtered.map(
            (item) => ItemCard(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailScreen(
                    item: item,
                    onEdit: () {
                      Navigator.pop(context);
                      widget.onEdit(item);
                    },
                    onDelete: () {
                      Navigator.pop(context);
                      widget.onDelete(item);
                    },
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
