// ─────────────────────────────────────────────────────────
//  features/transactions/add_transaction_sheet.dart
//  Modal bottom sheet for adding income / expense entries.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/database/models/transaction_model.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/transaction_provider.dart';
import '../../core/theme/colors.dart';

class AddTransactionSheet extends ConsumerStatefulWidget {
  /// Pass 'income' or 'expense' (defaults to 'expense').
  final String initialType;

  const AddTransactionSheet({super.key, this.initialType = 'expense'});

  @override
  ConsumerState<AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet> {
  late String _type;
  String _amountStr = '0';
  int? _selectedCategoryId;
  final TextEditingController _noteCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  // ── Numpad logic ─────────────────────────────────────────

  void _onNumpad(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amountStr.length > 1) {
          _amountStr = _amountStr.substring(0, _amountStr.length - 1);
        } else {
          _amountStr = '0';
        }
      } else if (key == '.') {
        if (!_amountStr.contains('.')) _amountStr += '.';
      } else {
        if (_amountStr == '0') {
          _amountStr = key;
        } else {
          // Limit to 2 decimal places
          final dotIndex = _amountStr.indexOf('.');
          if (dotIndex == -1 || _amountStr.length - dotIndex <= 2) {
            _amountStr += key;
          }
        }
      }
    });
  }

  double get _amount => double.tryParse(_amountStr) ?? 0;

  // ── Date picker ──────────────────────────────────────────

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: kMint,
            onPrimary: kNavy,
            surface: kNavy2,
            onSurface: kText,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _date = picked);
  }

  // ── Save ─────────────────────────────────────────────────

  Future<void> _save(String categoryName) async {
    if (_amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an amount greater than 0')),
      );
      return;
    }
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() => _saving = true);

    final title = '$categoryName ${_type == 'income' ? 'Income' : 'Expense'}';
    final tx = TransactionModel(
      title: title,
      amount: _amount,
      type: _type,
      categoryId: _selectedCategoryId!,
      timestamp: _date,
      note: _noteCtrl.text.trim().isEmpty ? null : _noteCtrl.text.trim(),
    );

    await ref.read(transactionListProvider.notifier).addTransaction(tx);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  // ── Build ────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: kNavy2,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: kBorder,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),

            // ── Type toggle ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: kNavy,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorder),
                ),
                child: Row(
                  children: [
                    _TypeButton(
                      label: 'Expense',
                      selected: _type == 'expense',
                      selectedColor: kError,
                      onTap: () => setState(() => _type = 'expense'),
                    ),
                    _TypeButton(
                      label: 'Income',
                      selected: _type == 'income',
                      selectedColor: kMint,
                      onTap: () => setState(() => _type = 'income'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Amount display ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '₹',
                    style: GoogleFonts.plusJakartaSans(
                      color: kText.withOpacity(0.6),
                      fontSize: 28,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      _amountStr,
                      style: GoogleFonts.plusJakartaSans(
                        color: kText,
                        fontSize: 56,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Category chips ──────────────────────────────
            categoriesAsync.when(
              loading: () => const SizedBox(
                height: 48,
                child: Center(
                    child: CircularProgressIndicator(
                        color: kMint, strokeWidth: 2)),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text('Error loading categories',
                    style: GoogleFonts.plusJakartaSans(color: kError)),
              ),
              data: (categories) => SizedBox(
                height: 56,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final isSelected = _selectedCategoryId == cat.id;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryId = cat.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? kMint.withOpacity(0.12) : kNavy,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? kMint : kBorder,
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(cat.icon,
                                style: const TextStyle(fontSize: 16)),
                            const SizedBox(width: 6),
                            Text(
                              cat.name,
                              style: GoogleFonts.plusJakartaSans(
                                color: isSelected ? kMint : kText,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Note TextField ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: _noteCtrl,
                style: GoogleFonts.plusJakartaSans(color: kText, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Add a note (optional)',
                  hintStyle:
                      GoogleFonts.plusJakartaSans(color: kMuted, fontSize: 14),
                  filled: true,
                  fillColor: kNavy,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kMint, width: 1.5),
                  ),
                  prefixIcon:
                      const Icon(Icons.notes_rounded, color: kMuted, size: 18),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Date row ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: _pickDate,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: kNavy,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          color: kMuted, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        '${_date.day} ${_monthName(_date.month)} ${_date.year}',
                        style: GoogleFonts.plusJakartaSans(
                          color: kText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: kMuted, size: 20),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── Numpad ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _Numpad(onKey: _onNumpad),
            ),
            const SizedBox(height: 16),

            // ── Save button ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: categoriesAsync.when(
                data: (categories) {
                  final selectedCat = categories
                      .where((c) => c.id == _selectedCategoryId)
                      .toList();
                  final catName =
                      selectedCat.isNotEmpty ? selectedCat.first.name : '';
                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _saving ? null : () => _save(catName),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kMint,
                        disabledBackgroundColor: kMint.withOpacity(0.5),
                        foregroundColor: kNavy,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  color: kNavy, strokeWidth: 2),
                            )
                          : Text(
                              'SAVE TRANSACTION',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}

// ── Type toggle button ────────────────────────────────────

class _TypeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color selectedColor;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.all(4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color:
                selected ? selectedColor.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: selected
                ? Border.all(color: selectedColor.withOpacity(0.5))
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: selected ? selectedColor : kMuted,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Numpad widget ─────────────────────────────────────────

class _Numpad extends StatelessWidget {
  final void Function(String key) onKey;

  const _Numpad({required this.onKey});

  static const _keys = [
    ['7', '8', '9'],
    ['4', '5', '6'],
    ['1', '2', '3'],
    ['.', '0', '⌫'],
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _keys.map((row) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: row.map((key) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _NumpadButton(label: key, onTap: () => onKey(key)),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}

class _NumpadButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _NumpadButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBackspace = label == '⌫';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: kNavy,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kBorder),
        ),
        child: Center(
          child: isBackspace
              ? const Icon(Icons.backspace_outlined, color: kText, size: 20)
              : Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    color: kText,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
