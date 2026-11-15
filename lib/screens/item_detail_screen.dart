import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';

class ItemDetailScreen extends StatelessWidget {
  const ItemDetailScreen({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final ExpiryItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final statusBg = statusColor(item);
    final statusTxt = statusTextColor(item);
    final catBg = categoryBgColor(item.category);

    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: const Text(
          'Detail Barang',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        children: [
          // Dominant Product Hero Card
          Container(
            padding: const EdgeInsets.all(26),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: kCardBorder, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: kDarkGreen.withValues(alpha: 0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Concentric Ring Category Avatar
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: catBg.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      color: catBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: kCardBorder, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        categoryEmoji(item.category),
                        style: const TextStyle(fontSize: 46),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: kCream,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kCardBorder),
                  ),
                  child: Text(
                    item.category,
                    style: const TextStyle(
                      color: kDarkGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Status Pill Banner
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: statusTxt.withValues(alpha: 0.15),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        item.daysLeft < 0
                            ? Icons.warning_amber_rounded
                            : Icons.access_time_rounded,
                        size: 16,
                        color: statusTxt,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${item.status} • ${countdownText(item)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: statusTxt,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Metadata Details Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: kCardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.numbers_rounded,
                  label: 'Kuantitas',
                  value: '${item.quantity} barang',
                ),
                const Divider(height: 20, color: kCardBorder),
                _DetailRow(
                  icon: Icons.shopping_bag_outlined,
                  label: 'Tanggal Pembelian',
                  value: formatDate(item.purchaseDate),
                ),
                const Divider(height: 20, color: kCardBorder),
                _DetailRow(
                  icon: Icons.event_available_rounded,
                  label: 'Tanggal Kedaluwarsa',
                  value: formatDate(item.expiryDate),
                ),
                const Divider(height: 20, color: kCardBorder),
                _DetailRow(
                  icon: Icons.hourglass_bottom_rounded,
                  label: 'Hitung Mundur',
                  value: countdownText(item),
                  valueColor: statusTxt,
                ),
                const Divider(height: 20, color: kCardBorder),
                _DetailRow(
                  icon: Icons.note_alt_outlined,
                  label: 'Catatan Penyimpanan',
                  value: item.note.isEmpty ? 'Tidak ada catatan' : item.note,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action Buttons
          FilledButton.icon(
            onPressed: onEdit,
            style: FilledButton.styleFrom(
              backgroundColor: kDarkGreen,
              foregroundColor: kWhite,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 2,
              shadowColor: kDarkGreen.withValues(alpha: 0.25),
            ),
            icon: const Icon(Icons.edit_rounded, size: 19),
            label: const Text(
              'Edit Barang',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () => _confirmDelete(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD32F2F), width: 1.4),
              foregroundColor: const Color(0xFFD32F2F),
              backgroundColor: kWhite,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.delete_outline_rounded, size: 19),
            label: const Text(
              'Hapus Barang',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: kCream,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🗑️', style: TextStyle(fontSize: 24)),
            SizedBox(width: 8),
            Text(
              'Hapus Barang?',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
            ),
          ],
        ),
        content: Text(
          'Apakah kamu yakin ingin menghapus "${item.name}" dari pelacak? Tindakan ini tidak dapat dibatalkan.',
          style: const TextStyle(color: kDarkText, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Batal',
              style: TextStyle(color: kSubText, fontWeight: FontWeight.w600),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFD32F2F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Hapus',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: kCream,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: kDarkGreen),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: kSubText,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: valueColor ?? kDarkText,
            ),
          ),
        ),
      ],
    );
  }
}
