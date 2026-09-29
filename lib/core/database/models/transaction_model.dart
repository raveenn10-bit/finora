class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type; // 'income' | 'expense'
  final int categoryId;
  final DateTime timestamp;
  final String? note;

  const TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.categoryId,
    required this.timestamp,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'amount': amount,
        'type': type,
        'categoryId': categoryId,
        'timestamp': timestamp.millisecondsSinceEpoch,
        'note': note,
      };

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'] as int?,
        title: map['title'] as String,
        amount: (map['amount'] as num).toDouble(),
        type: map['type'] as String,
        categoryId: map['categoryId'] as int,
        timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
        note: map['note'] as String?,
      );
}
