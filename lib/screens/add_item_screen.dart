import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../utils/helpers.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key, this.existing});
  final ExpiryItem? existing;

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _quantity = TextEditingController(text: '1');
  final _note = TextEditingController();
  String _category = 'Makanan';
  late DateTime _purchaseDate;
  late DateTime _expiryDate;
  String? _dateError;

  final List<Map<String, String>> _categories = [
    {'name': 'Makanan', 'emoji': '🥗'},
    {'name': 'Minuman', 'emoji': '🧃'},
    {'name': 'Obat-obatan', 'emoji': '💊'},
    {'name': 'Perawatan Kulit', 'emoji': '✨'},
    {'name': 'Perlengkapan Rumah', 'emoji': '🏡'},
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.existing;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    if (item != null) {
      _name.text = item.name;
      _quantity.text = item.quantity.toString();
      _note.text = item.note;
      _category = _normalizeCat(item.category);
      _purchaseDate = item.purchaseDate;
      _expiryDate = item.expiryDate;
    } else {
      _purchaseDate = today;
      _expiryDate = today.add(const Duration(days: 7));
    }
  }

  String _normalizeCat(String c) {
    if (c == 'Food') return 'Makanan';
    if (c == 'Beverage') return 'Minuman';
    if (c == 'Medicine') return 'Obat-obatan';
    if (c == 'Skincare') return 'Perawatan Kulit';
    if (c == 'Household') return 'Perlengkapan Rumah';
    return c;
  }

  @override
  void dispose() {
    _name.dispose();
    _quantity.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isPurchase) async {
    final initial = isPurchase ? _purchaseDate : _expiryDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kDarkGreen,
              onPrimary: kWhite,
              surface: kCream,
              onSurface: kDarkText,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isPurchase) {
          _purchaseDate = DateTime(picked.year, picked.month, picked.day);
        } else {
          _expiryDate = DateTime(picked.year, picked.month, picked.day);
        }
        if (_expiryDate.isBefore(_purchaseDate)) {
          _dateError =
              'Tanggal kedaluwarsa tidak boleh sebelum tanggal pembelian.';
        } else {
          _dateError = null;
        }
      });
    }
  }

  void _submit() {
    setState(() {
      if (_expiryDate.isBefore(_purchaseDate)) {
        _dateError =
            'Tanggal kedaluwarsa tidak boleh sebelum tanggal pembelian.';
      } else {
        _dateError = null;
      }
    });

    if (!_formKey.currentState!.validate()) return;
    if (_dateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_dateError!),
          backgroundColor: const Color(0xFFC2410C),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    final old = widget.existing;
    final item = ExpiryItem(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      category: _category,
      quantity: int.parse(_quantity.text.trim()),
      purchaseDate: _purchaseDate,
      expiryDate: _expiryDate,
      note: _note.text.trim(),
    );
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Scaffold(
      backgroundColor: kCream,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Barang' : 'Tambah Barang Baru',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          children: [
            // Decorative Mascot Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: kSoftGreen,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: kCardBorder),
                boxShadow: [
                  BoxShadow(
                    color: kDarkGreen.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: kWhite,
                      shape: BoxShape.circle,
                    ),
                    child: const Text('🍓🧺', style: TextStyle(fontSize: 26)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      isEditing
                          ? 'Perbarui rincian untuk barang ini'
                          : 'Yuk, simpan barang ini sebelum kedaluwarsa!',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: Color(0xFF244728),
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Form Section Card
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item Name Field
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Nama Barang *',
                      hintText: 'misal: Susu Segar Organik',
                      prefixIcon: Icon(Icons.drive_file_rename_outline,
                          color: kDarkGreen),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama barang wajib diisi';
                      }
                      if (v.trim().length < 2) {
                        return 'Nama barang minimal 2 karakter';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Visual Category Chips Selector
                  const Text(
                    'Kategori *',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: kDarkText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _categories.map((cat) {
                      final catName = cat['name']!;
                      final catEmoji = cat['emoji']!;
                      final isSelected = _category == catName;

                      return InkWell(
                        onTap: () => setState(() => _category = catName),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 7),
                          decoration: BoxDecoration(
                            color: isSelected ? kDarkGreen : kCream,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? kDarkGreen : kCardBorder,
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(catEmoji,
                                  style: const TextStyle(fontSize: 14)),
                              const SizedBox(width: 6),
                              Text(
                                catName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: isSelected ? kWhite : kDarkText,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Quantity Field
                  TextFormField(
                    controller: _quantity,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Kuantitas *',
                      prefixIcon:
                          Icon(Icons.numbers_rounded, color: kDarkGreen),
                      hintText: '1',
                    ),
                    validator: (v) {
                      final n = int.tryParse(v?.trim() ?? '');
                      if (n == null || n <= 0) {
                        return 'Kuantitas harus berupa angka lebih dari 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Date Buttons
                  _DateButton(
                    label: 'Tanggal Pembelian',
                    value: formatDate(_purchaseDate),
                    icon: Icons.calendar_today_rounded,
                    onTap: () => _pickDate(true),
                  ),
                  const SizedBox(height: 12),
                  _DateButton(
                    label: 'Tanggal Kedaluwarsa',
                    value: formatDate(_expiryDate),
                    icon: Icons.event_busy_rounded,
                    onTap: () => _pickDate(false),
                  ),
                  if (_dateError != null) ...[
                    const SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        _dateError!,
                        style: const TextStyle(
                          color: Color(0xFFC2410C),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Note Field
                  TextFormField(
                    controller: _note,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Catatan (Opsional)',
                      hintText:
                          'misal: Simpan di kulkas, habiskan dalam 3 hari...',
                      prefixIcon:
                          Icon(Icons.edit_note_rounded, color: kDarkGreen),
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            FilledButton.icon(
              onPressed: _submit,
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
              icon: Icon(
                isEditing ? Icons.check_circle_outline : Icons.add_rounded,
                size: 20,
              ),
              label: Text(
                isEditing ? 'Simpan Perubahan' : 'Simpan Barang ke Pelacak',
                style:
                    const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _DateButton extends StatelessWidget {
  const _DateButton({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kCardBorder, width: 1.2),
        ),
        child: Row(
          children: [
            Icon(icon, color: kDarkGreen, size: 20),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 11, color: kSubText),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: kDarkText,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.edit_calendar_rounded,
                size: 20, color: kDarkGreen),
          ],
        ),
      ),
    );
  }
}
