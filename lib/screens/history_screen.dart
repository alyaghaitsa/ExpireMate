import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ExpiryItem> items;
  final Future<void> Function(ExpiryItem?) onEdit;
  final void Function(ExpiryItem) onDelete;

  @override
  Widget build(BuildContext context) {
    final history = items.where((e) => e.daysLeft < 0).toList()
      ..sort((a, b) => b.expiryDate.compareTo(a.expiryDate));

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        // Title & Description
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Kedaluwarsa 📜',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Daftar barang yang telah melewati batas tanggal kedaluwarsa',
                  style: TextStyle(fontSize: 13, color: kSubText),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: kSoftPink,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kCardBorder),
              ),
              child: Text(
                '${history.length} kedaluwarsa',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF8B2323),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        if (history.isEmpty)
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: kCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text('🌷✨', style: TextStyle(fontSize: 52)),
                SizedBox(height: 14),
                Text(
                  'Tidak Ada Barang Kedaluwarsa!',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 17,
                    color: kDarkText,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kerja bagus! Kamu telah menggunakan semua barangmu sebelum kedaluwarsa.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kSubText,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          )
        else
          ...history.map(
            (item) => ItemCard(
              item: item,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ItemDetailScreen(
                    item: item,
                    onEdit: () {
                      Navigator.pop(context);
                      onEdit(item);
                    },
                    onDelete: () {
                      Navigator.pop(context);
                      onDelete(item);
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
