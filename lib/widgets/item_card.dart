import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({super.key, required this.item, this.onTap});
  final ExpiryItem item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bgColor = statusColor(item);
    final txtColor = statusTextColor(item);
    final catBg = categoryBgColor(item.category);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kCardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: kDarkGreen.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            child: Row(
              children: [
                // Category Icon with playful squircle container
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: catBg,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kCardBorder, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      categoryEmoji(item.category),
                      style: const TextStyle(fontSize: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: kDarkText,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kCream,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                color: kDarkGreen,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '•  Jumlah: ${item.quantity}',
                            style: const TextStyle(
                              color: kSubText,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Icon(
                            item.daysLeft < 0
                                ? Icons.warning_amber_rounded
                                : (item.daysLeft <= 3
                                    ? Icons.access_time_filled_rounded
                                    : Icons.eco_rounded),
                            size: 13,
                            color: txtColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            countdownText(item),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: txtColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Status Pill
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: txtColor.withValues(alpha: 0.15),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: txtColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: Color(0xFFBAC2B9),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
