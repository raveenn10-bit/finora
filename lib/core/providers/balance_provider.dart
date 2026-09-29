// ─────────────────────────────────────────────────────────
//  core/providers/balance_provider.dart
//  Derived provider: computes total balance, income, expenses
//  from the transactionListProvider.
// ─────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'transaction_provider.dart';

/// Returns a map with keys: 'total', 'income', 'expenses'.
/// Values are doubles (0.0 while loading).
final balanceProvider = Provider<Map<String, double>>((ref) {
  final txAsync = ref.watch(transactionListProvider);

  return txAsync.when(
    data: (transactions) {
      double income = 0;
      double expenses = 0;
      for (final tx in transactions) {
        if (tx.type == 'income') {
          income += tx.amount;
        } else {
          expenses += tx.amount;
        }
      }
      return {
        'total': income - expenses,
        'income': income,
        'expenses': expenses,
      };
    },
    loading: () => {'total': 0.0, 'income': 0.0, 'expenses': 0.0},
    error: (_, __) => {'total': 0.0, 'income': 0.0, 'expenses': 0.0},
  );
});
