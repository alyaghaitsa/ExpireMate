import 'package:flutter/material.dart';
import '../models/item_model.dart';

// Brand Identity Color Palette
const Color kSoftGreen = Color(0xFFB7DDB5);
const Color kDarkGreen = Color(0xFF527C55);
const Color kCream = Color(0xFFFFF8E9);
const Color kSoftYellow = Color(0xFFFFE7A8);
const Color kSoftPink = Color(0xFFF8CACA);
const Color kWhite = Color(0xFFFFFFFF);

// Harmonious Aesthetic Accents
const Color kDarkText = Color(0xFF26332A);
const Color kSubText = Color(0xFF6E7870);
const Color kCardBorder = Color(0xFFECE7D8);
const Color kSoftOrange = Color(0xFFFFD199);
const Color kSageCard = Color(0xFFEAF5E9);
const Color kPeachCard = Color(0xFFFFF3DE);
const Color kLavenderCard = Color(0xFFF4EEFC);

String formatDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

String formatFriendlyDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des'
  ];
  const weekdays = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu'
  ];
  final weekday = weekdays[date.weekday - 1];
  return '$weekday, ${date.day} ${months[date.month - 1]} ${date.year}';
}

String getGreetingMessage() {
  final hour = DateTime.now().hour;
  if (hour >= 4 && hour < 12) {
    return 'Selamat Pagi! ☀️';
  } else if (hour >= 12 && hour < 17) {
    return 'Selamat Siang! 🌤️';
  } else {
    return 'Selamat Malam! 🌙';
  }
}

Color statusColor(ExpiryItem item) {
  switch (item.status) {
    case 'Kedaluwarsa':
    case 'Expired':
      return kSoftPink;
    case 'Kedaluwarsa Hari Ini':
    case 'Expires Today':
      return kSoftOrange;
    case 'Segera Kedaluwarsa':
    case 'Expiring Soon':
      return kSoftYellow;
    default:
      return kSoftGreen;
  }
}

Color statusTextColor(ExpiryItem item) {
  switch (item.status) {
    case 'Kedaluwarsa':
    case 'Expired':
      return const Color(0xFF8B2323);
    case 'Kedaluwarsa Hari Ini':
    case 'Expires Today':
      return const Color(0xFF854300);
    case 'Segera Kedaluwarsa':
    case 'Expiring Soon':
      return const Color(0xFF7A5800);
    default:
      return const Color(0xFF2B5C2F);
  }
}

IconData categoryIcon(String category) {
  switch (category) {
    case 'Makanan':
    case 'Food':
      return Icons.restaurant_rounded;
    case 'Minuman':
    case 'Beverage':
      return Icons.local_cafe_rounded;
    case 'Obat-obatan':
    case 'Medicine':
      return Icons.medication_rounded;
    case 'Perawatan Kulit':
    case 'Skincare':
      return Icons.spa_rounded;
    case 'Perlengkapan Rumah':
    case 'Household':
      return Icons.cleaning_services_rounded;
    default:
      return Icons.inventory_2_rounded;
  }
}

String categoryEmoji(String category) {
  switch (category) {
    case 'Makanan':
    case 'Food':
      return '🥗';
    case 'Minuman':
    case 'Beverage':
      return '🧃';
    case 'Obat-obatan':
    case 'Medicine':
      return '💊';
    case 'Perawatan Kulit':
    case 'Skincare':
      return '✨';
    case 'Perlengkapan Rumah':
    case 'Household':
      return '🏡';
    default:
      return '📦';
  }
}

Color categoryBgColor(String category) {
  switch (category) {
    case 'Makanan':
    case 'Food':
      return const Color(0xFFEBF6EA);
    case 'Minuman':
    case 'Beverage':
      return const Color(0xFFFFF4DE);
    case 'Obat-obatan':
    case 'Medicine':
      return const Color(0xFFFFEEEE);
    case 'Perawatan Kulit':
    case 'Skincare':
      return const Color(0xFFF4EEFC);
    case 'Perlengkapan Rumah':
    case 'Household':
      return const Color(0xFFEAF5F8);
    default:
      return kCream;
  }
}

String countdownText(ExpiryItem item) {
  if (item.daysLeft < 0) {
    final days = item.daysLeft.abs();
    return days == 1
        ? 'Kedaluwarsa kemarin'
        : 'Kedaluwarsa $days hari yang lalu';
  }
  if (item.daysLeft == 0) return 'Kedaluwarsa hari ini!';
  if (item.daysLeft == 1) return 'Kedaluwarsa besok';
  return 'Sisa ${item.daysLeft} hari lagi';
}
