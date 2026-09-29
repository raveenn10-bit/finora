// ─────────────────────────────────────────────────────────
//  core/providers/category_provider.dart
//  Riverpod provider that loads categories from SQLite.
// ─────────────────────────────────────────────────────────
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/database_helper.dart';
import '../database/models/category_model.dart';

final categoryListProvider = FutureProvider<List<CategoryModel>>((ref) async {
  return DatabaseHelper.instance.getCategories();
});
