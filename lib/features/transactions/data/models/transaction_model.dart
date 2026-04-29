

import '../../../../core/enums/app_type.dart';

class TransactionModel {
  final String id;
  final int categoryId;
  final String title;
  final double amount;
  final DateTime date;
  final AppType type;
  final String? categoryIcon;

  TransactionModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.categoryIcon,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'].toString(),
      categoryId: map['category_id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']).toLocal(),
      type: AppType.values.firstWhere(
            (e) => e.name == map['type'],
      ),
      categoryIcon: map['category_icon'],
    );
  }
}