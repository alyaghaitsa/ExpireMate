class ExpiryItem {
  ExpiryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.purchaseDate,
    required this.expiryDate,
    this.note = '',
  });

  final String id;
  final String name;
  final String category;
  final int quantity;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String note;

  int get daysLeft {
    final today = DateTime.now();
    final a = DateTime(today.year, today.month, today.day);
    final b = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
    return b.difference(a).inDays;
  }

  String get status {
    if (daysLeft < 0) return 'Kedaluwarsa';
    if (daysLeft == 0) return 'Kedaluwarsa Hari Ini';
    if (daysLeft <= 7) return 'Segera Kedaluwarsa';
    return 'Aman';
  }

  ExpiryItem copyWith({
    String? name,
    String? category,
    int? quantity,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? note,
  }) {
    return ExpiryItem(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      note: note ?? this.note,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
        'purchaseDate': purchaseDate.toIso8601String(),
        'expiryDate': expiryDate.toIso8601String(),
        'note': note,
      };

  factory ExpiryItem.fromMap(Map<String, dynamic> map) => ExpiryItem(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String,
        quantity: map['quantity'] as int,
        purchaseDate: DateTime.parse(map['purchaseDate'] as String),
        expiryDate: DateTime.parse(map['expiryDate'] as String),
        note: (map['note'] ?? '') as String,
      );
}
