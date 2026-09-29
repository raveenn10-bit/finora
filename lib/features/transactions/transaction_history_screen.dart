// ─────────────────────────────────────────────────────────
//  features/transactions/transaction_history_screen.dart
//  Full-screen list of ALL transactions with swipe-to-delete.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/database/models/category_model.dart';
import '../../core/database/models/transaction_model.dart';
import '../../core/providers/category_provider.dart';
import '../../core/providers/transaction_provider.dart';
import '../../core/theme/colors.dart';

class TransactionHistoryScreen extends ConsumerWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return Scaffold(
      backgroundColor: kNavy,
      appBar: AppBar(
        backgroundColor: kNavy2,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: kText, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Transaction History',
          style: GoogleFonts.plusJakartaSans(
            color: kText,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: txAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: kMint)),
        error: (e, _) => Center(
          child: Text('Error: $e',
              style: GoogleFonts.plusJakartaSans(color: kError)),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      color: kMuted, size: 64),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: GoogleFonts.plusJakartaSans(
                        color: kMuted, fontSize: 16),
                  ),
                ],
              ),
            );
          }

          return categoriesAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator(color: kMint)),
            error: (_, __) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _TxTile(
                tx: transactions[i],
                category: null,
                onDelete: (id) => _deleteWithSnackbar(context, ref, id),
              ),
            ),
            data: (categories) {
              final catMap = {for (final c in categories) c.id: c};
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final tx = transactions[i];
                  final cat = catMap[tx.categoryId];
                  return _TxTile(
                    tx: tx,
                    category: cat,
                    onDelete: (id) => _deleteWithSnackbar(context, ref, id),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _deleteWithSnackbar(
      BuildContext context, WidgetRef ref, int id) async {
    await ref.read(transactionListProvider.notifier).deleteTransaction(id);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transaction deleted',
            style: GoogleFonts.plusJakartaSans(color: kText),
          ),
          backgroundColor: kNavy2,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ── Transaction tile ──────────────────────────────────────

class _TxTile extends StatelessWidget {
  final TransactionModel tx;
  final CategoryModel? category;
  final void Function(int id) onDelete;

  const _TxTile({
    required this.tx,
    required this.category,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = tx.type == 'income';
    final amountColor = isIncome ? kMint : kError;
    final amountPrefix = isIncome ? '+' : '-';
    final catColor = category != null ? Color(category!.color) : kMuted;
    final catIcon = category?.icon ?? '📦';
    final dateStr = DateFormat('d MMM').format(tx.timestamp);

    return Dismissible(
      key: ValueKey(tx.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(tx.id!),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: kError.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: kError),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: kNavy2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            // Category icon circle
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: catColor.withOpacity(0.15),
              ),
              child: Center(
                child: Text(catIcon, style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            // Title + date
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.title,
                    style: GoogleFonts.plusJakartaSans(
                      color: kText,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dateStr,
                    style: GoogleFonts.plusJakartaSans(
                      color: kMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '$amountPrefix₹${tx.amount.toStringAsFixed(2)}',
              style: GoogleFonts.plusJakartaSans(
                color: amountColor,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
