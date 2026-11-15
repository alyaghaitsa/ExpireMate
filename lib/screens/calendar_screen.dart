import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';
import '../widgets/item_card.dart';
import 'item_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<ExpiryItem> items;
  final Future<void> Function(ExpiryItem?) onEdit;
  final void Function(ExpiryItem) onDelete;

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _selected;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selected = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final dayItems = widget.items.where((e) {
      return e.expiryDate.year == _selected.year &&
          e.expiryDate.month == _selected.month &&
          e.expiryDate.day == _selected.day;
    }).toList();

    final firstDayOfMonth = DateTime(_selected.year, _selected.month, 1);
    final daysInMonth = DateTime(_selected.year, _selected.month + 1, 0).day;
    final leadingOffset = firstDayOfMonth.weekday % 7; // Sunday = 0

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        // Title & Description
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kalender Kedaluwarsa 📅',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: kDarkText,
                letterSpacing: -0.4,
              ),
            ),
            SizedBox(height: 3),
            Text(
              'Pantau jadwal kedaluwarsa barangmu secara sekilas',
              style: TextStyle(fontSize: 13, color: kSubText),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Aesthetic Calendar Card
        Container(
          padding: const EdgeInsets.all(18),
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
              // Month & Year Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        _selected =
                            DateTime(_selected.year, _selected.month - 1, 1);
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: kCream,
                      foregroundColor: kDarkGreen,
                    ),
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  Text(
                    '${_monthName(_selected.month)} ${_selected.year}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      color: kDarkText,
                      letterSpacing: -0.2,
                    ),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {
                      setState(() {
                        _selected =
                            DateTime(_selected.year, _selected.month + 1, 1);
                      });
                    },
                    style: IconButton.styleFrom(
                      backgroundColor: kCream,
                      foregroundColor: kDarkGreen,
                    ),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Day of Week Header
              Row(
                children: const [
                  'Min',
                  'Sen',
                  'Sel',
                  'Rab',
                  'Kam',
                  'Jum',
                  'Sab',
                ]
                    .map(
                      (d) => Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            child: Text(
                              d,
                              style: const TextStyle(
                                color: kSubText,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 8),

              // Days Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: leadingOffset + daysInMonth,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  if (index < leadingOffset) return const SizedBox();
                  final day = index - leadingOffset + 1;
                  final date = DateTime(_selected.year, _selected.month, day);
                  final matchingItems = widget.items.where((e) {
                    return e.expiryDate.year == date.year &&
                        e.expiryDate.month == date.month &&
                        e.expiryDate.day == date.day;
                  }).toList();

                  final hasItems = matchingItems.isNotEmpty;
                  final isSelected = _selected.year == date.year &&
                      _selected.month == date.month &&
                      _selected.day == date.day;

                  Color cellColor = Colors.transparent;
                  Color cellTextColor = kDarkText;
                  FontWeight cellWeight = FontWeight.w600;

                  if (isSelected) {
                    cellColor = kDarkGreen;
                    cellTextColor = kWhite;
                    cellWeight = FontWeight.w900;
                  } else if (hasItems) {
                    final hasExpired = matchingItems.any((e) =>
                        e.status == 'Kedaluwarsa' || e.status == 'Expired');
                    final hasSoon = matchingItems.any((e) =>
                        e.status == 'Segera Kedaluwarsa' ||
                        e.status == 'Kedaluwarsa Hari Ini' ||
                        e.status == 'Expiring Soon' ||
                        e.status == 'Expires Today');

                    if (hasExpired) {
                      cellColor = kSoftPink;
                      cellTextColor = const Color(0xFF8B2323);
                    } else if (hasSoon) {
                      cellColor = kSoftYellow;
                      cellTextColor = const Color(0xFF7A5800);
                    } else {
                      cellColor = kSoftGreen;
                      cellTextColor = const Color(0xFF224525);
                    }
                    cellWeight = FontWeight.w800;
                  }

                  return InkWell(
                    onTap: () => setState(() => _selected = date),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(14),
                        border: isSelected
                            ? null
                            : (hasItems
                                ? Border.all(color: kCardBorder, width: 1)
                                : null),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$day',
                            style: TextStyle(
                              fontWeight: cellWeight,
                              color: cellTextColor,
                              fontSize: 13,
                            ),
                          ),
                          if (hasItems && !isSelected)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                color: cellTextColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // Selected Date Items Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Barang pada ${formatDate(_selected)}',
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: kDarkText,
                letterSpacing: -0.2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: dayItems.isEmpty ? kCream : kSoftGreen,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kCardBorder),
              ),
              child: Text(
                '${dayItems.length} barang',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: kDarkGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (dayItems.isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: kCardBorder),
            ),
            child: const Row(
              children: [
                Text('🌼', style: TextStyle(fontSize: 32)),
                SizedBox(width: 14),
                Expanded(
                  child: Text(
                    'Tidak ada barang yang kedaluwarsa pada tanggal ini! Waktunya bersantai.',
                    style: TextStyle(
                      color: kSubText,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          ...dayItems.map(
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

  String _monthName(int m) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return months[m - 1];
  }
}
