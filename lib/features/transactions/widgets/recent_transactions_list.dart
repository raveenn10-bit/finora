// ─────────────────────────────────────────────────────────
//  features/transactions/widgets/recent_transactions_list.dart
//  Shows the 5 most recent transactions on the dashboard.
// ─────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/database/models/category_model.dart';
import '../../../core/database/models/transaction_model.dart';
import '../../../core/providers/category_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/theme/colors.dart';
import '../transaction_history_screen.dart';

class RecentTransactionsList extends ConsumerWidget {
  const RecentTransactionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(transactionListProvider);
    final categoriesAsync = ref.watch(categoryListProvider);

    return txAsync.when(
      loading: () =>
          const Center(child: CircularProgressIndicator(color: kMint)),
      error: (e, _) => Center(
        child: Text('Error loading transactions',
            style: GoogleFonts.plusJakartaSans(color: kError, fontSize: 13)),
      ),
      data: (allTx) {
        if (allTx.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_outlined,
                      color: kMuted, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No transactions yet',
                    style: GoogleFonts.plusJakartaSans(
                        color: kMuted, fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }

        final recent = allTx.take(5).toList();

        return categoriesAsync.when(
          loading: () =>
              const Center(child: CircularProgressIndicator(color: kMint)),
          error: (_, __) =>
              _buildList(context, ref, recent, <int?, CategoryModel>{}),
          data: (categories) {
            final catMap = <int?, CategoryModel>{
              for (final c in categories) c.id: c
            };
            return _buildList(context, ref, recent, catMap);
          },
        );
      },
    );
  }

  Widget _buildList(
    BuildContext context,
    WidgetRef ref,
    List<TransactionModel> transactions,
    Map<int?, CategoryModel> catMap,
  ) {
    return Column(
      children: [
        ...transactions.map((tx) {
          final cat = catMap[tx.categoryId];
          final isIncome = tx.type == 'income';
          final amountColor = isIncome ? kMint : kError;
          final amountPrefix = isIncome ? '+' : '-';
          final catColor = cat != null ? Color(cat.color) : kMuted;
          final catIcon = cat?.icon ?? '📦';
          final dateStr = DateFormat('d MMM').format(tx.timestamp);

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Dismissible(
              key: ValueKey(tx.id),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => ref
                  .read(transactionListProvider.notifier)
                  .deleteTransaction(tx.id!),
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        child:
                            Text(catIcon, style: const TextStyle(fontSize: 20)),
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
            ),
          );
        }),

        // ── See All button ──────────────────────────────
        TextButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const TransactionHistoryScreen(),
            ),
          ),
          style: TextButton.styleFrom(
            foregroundColor: kMint,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'See All Transactions',
                style: GoogleFonts.plusJakartaSans(
                  color: kMint,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_ios_rounded,
                  color: kMint, size: 12),
            ],
          ),
        ),
      ],
    );
  }
}
