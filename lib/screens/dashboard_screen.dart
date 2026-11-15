import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';
import '../widgets/item_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.items,
    required this.onAdd,
    required this.onOpenItems,
    required this.onOpenDetail,
    this.onSelectCategory,
  });

  final List<ExpiryItem> items;
  final VoidCallback onAdd;
  final VoidCallback onOpenItems;
  final void Function(ExpiryItem) onOpenDetail;
  final void Function(String)? onSelectCategory;

  @override
  Widget build(BuildContext context) {
    final total = items.length;
    final safe =
        items.where((e) => e.status == 'Aman' || e.status == 'Safe').length;
    final soon = items
        .where((e) =>
            e.status == 'Segera Kedaluwarsa' ||
            e.status == 'Kedaluwarsa Hari Ini' ||
            e.status == 'Expiring Soon' ||
            e.status == 'Expires Today')
        .length;
    final expired = items
        .where((e) => e.status == 'Kedaluwarsa' || e.status == 'Expired')
        .length;

    // Urgent items: Segera kedaluwarsa atau kedaluwarsa hari ini
    final urgentItems = items
        .where((e) => e.daysLeft >= 0 && e.daysLeft <= 7)
        .toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    // Other upcoming safe items if urgent items list is short
    final upcomingSafe = items.where((e) => e.daysLeft > 7).toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));

    final displayItems = [...urgentItems, ...upcomingSafe];

    final todayDate = formatFriendlyDate(DateTime.now());
    final greeting = getGreetingMessage();

    final categories = [
      {'name': 'Makanan', 'emoji': '🥗', 'color': const Color(0xFFEBF6EA)},
      {'name': 'Minuman', 'emoji': '🧃', 'color': const Color(0xFFFFF4DE)},
      {'name': 'Obat-obatan', 'emoji': '💊', 'color': const Color(0xFFFFEEEE)},
      {
        'name': 'Perawatan Kulit',
        'emoji': '✨',
        'color': const Color(0xFFF4EEFC)
      },
      {
        'name': 'Perlengkapan Rumah',
        'emoji': '🏡',
        'color': const Color(0xFFEAF5F8)
      },
    ];

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        // A. Header Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Yuk, cek barang-barangmu!',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: kDarkGreen,
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: kSubText),
                    const SizedBox(width: 5),
                    Text(
                      todayDate,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kSubText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Cute Mascot Avatar in a layered pastel circle
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [kSoftGreen, kSoftYellow],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: kDarkGreen.withValues(alpha: 0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: kWhite,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🐻', style: TextStyle(fontSize: 26)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // B. Hero Section: Playful Mascot Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: kSoftGreen,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: kCardBorder, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: kDarkGreen.withValues(alpha: 0.09),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Subtle background bubble accents
              Positioned(
                right: -10,
                top: -15,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: kWhite.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Text(
                            '✨ ExpireMate',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: kDarkGreen,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Teman Pintar Pengingat Kedaluwarsa',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF224326),
                            height: 1.2,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Pengingat kecil hari ini,\nkurangi pemborosan esok hari 🌱',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E5434),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Mascot with Shopping Basket Illustration
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: kWhite,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kDarkGreen.withValues(alpha: 0.15),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🧺', style: TextStyle(fontSize: 42)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),

        // C. Expiry Overview: 4 Dynamic Stat Cards
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                title: 'Total Barang',
                value: '$total',
                color: const Color(0xFFEBF6EA),
                textColor: kDarkGreen,
                icon: Icons.inventory_2_rounded,
                badgeEmoji: '📦',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewCard(
                title: 'Aman',
                value: '$safe',
                color: kSoftGreen,
                textColor: const Color(0xFF234B26),
                icon: Icons.eco_rounded,
                badgeEmoji: '🌿',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _OverviewCard(
                title: 'Segera Kedaluwarsa',
                value: '$soon',
                color: kSoftYellow,
                textColor: const Color(0xFF7A5800),
                icon: Icons.schedule_rounded,
                badgeEmoji: '⏰',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _OverviewCard(
                title: 'Kedaluwarsa',
                value: '$expired',
                color: kSoftPink,
                textColor: const Color(0xFF8B2323),
                icon: Icons.warning_amber_rounded,
                badgeEmoji: '⚠️',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // E. Categories Quick Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kategori 🏷️',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: kDarkText,
                letterSpacing: -0.3,
              ),
            ),
            GestureDetector(
              onTap: onOpenItems,
              child: const Text(
                'Lihat Semua',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kDarkGreen,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 104,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final catName = cat['name'] as String;
              final catEmoji = cat['emoji'] as String;
              final catColor = cat['color'] as Color;
              final count = items.where((e) {
                if (catName == 'Makanan') {
                  return e.category == 'Makanan' || e.category == 'Food';
                }
                if (catName == 'Minuman') {
                  return e.category == 'Minuman' || e.category == 'Beverage';
                }
                if (catName == 'Obat-obatan') {
                  return e.category == 'Obat-obatan' ||
                      e.category == 'Medicine';
                }
                if (catName == 'Perawatan Kulit') {
                  return e.category == 'Perawatan Kulit' ||
                      e.category == 'Skincare';
                }
                if (catName == 'Perlengkapan Rumah') {
                  return e.category == 'Perlengkapan Rumah' ||
                      e.category == 'Household';
                }
                return e.category == catName;
              }).length;

              return InkWell(
                onTap: () {
                  if (onSelectCategory != null) {
                    onSelectCategory!(catName);
                  } else {
                    onOpenItems();
                  }
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 82,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kCardBorder, width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: catColor,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(catEmoji,
                              style: const TextStyle(fontSize: 18)),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        catName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: kDarkText,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$count barang',
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w500,
                          color: kSubText,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 24),

        // D. Expiring Soon / Barang Segera Kedaluwarsa Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  'Segera Kedaluwarsa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: kDarkText,
                    letterSpacing: -0.3,
                  ),
                ),
                if (urgentItems.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: kSoftYellow,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${urgentItems.length} Mendesak',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF7A5800),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            TextButton(
              onPressed: onOpenItems,
              child: const Row(
                children: [
                  Text(
                    'Lihat semua',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: kDarkGreen,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded,
                      size: 18, color: kDarkGreen),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        if (displayItems.isEmpty)
          const _EmptyDashboardHint()
        else
          ...displayItems.take(4).map(
                (item) => ItemCard(
                  item: item,
                  onTap: () => onOpenDetail(item),
                ),
              ),

        const SizedBox(height: 14),

        // F. Quick Action: Tambah Barang Baru Button
        OutlinedButton.icon(
          onPressed: onAdd,
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kDarkGreen, width: 1.6),
            foregroundColor: kDarkGreen,
            backgroundColor: kWhite,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 1,
            shadowColor: kDarkGreen.withValues(alpha: 0.1),
          ),
          icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
          label: const Text(
            'Tambah Barang Baru',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
          ),
        ),
      ],
    );
  }
}

class _OverviewCard extends StatelessWidget {
  const _OverviewCard({
    required this.title,
    required this.value,
    required this.color,
    required this.textColor,
    required this.icon,
    required this.badgeEmoji,
  });

  final String title;
  final String value;
  final Color color;
  final Color textColor;
  final IconData icon;
  final String badgeEmoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kCardBorder, width: 1.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: kWhite.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: textColor),
              ),
              Text(
                badgeEmoji,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor.withValues(alpha: 0.85),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _EmptyDashboardHint extends StatelessWidget {
  const _EmptyDashboardHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
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
      child: const Column(
        children: [
          Text('🐻🧺', style: TextStyle(fontSize: 48)),
          SizedBox(height: 10),
          Text(
            'Keranjangmu masih kosong!',
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 16,
              color: kDarkText,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tambahkan barang belanjaan atau obat-obatan untuk mulai memantau tanggal kedaluwarsa.',
            textAlign: TextAlign.center,
            style: TextStyle(color: kSubText, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
