// ─────────────────────────────────────────────────────────
//  core/providers/transaction_provider.dart
//  Riverpod provider for transaction CRUD via SQLite.
// ─────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../database/models/transaction_model.dart';

class TransactionNotifier extends AsyncNotifier<List<TransactionModel>> {
  @override
  Future<List<TransactionModel>> build() async {
    return DatabaseHelper.instance.getTransactions();
  }

  Future<void> addTransaction(TransactionModel tx) async {
    await DatabaseHelper.instance.insertTransaction(tx);
    state = AsyncData(await DatabaseHelper.instance.getTransactions());
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseHelper.instance.deleteTransaction(id);
    state = AsyncData(await DatabaseHelper.instance.getTransactions());
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = AsyncData(await DatabaseHelper.instance.getTransactions());
  }
}

final transactionListProvider =
    AsyncNotifierProvider<TransactionNotifier, List<TransactionModel>>(
  TransactionNotifier.new,
);
