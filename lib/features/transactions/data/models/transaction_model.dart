import '../../../../core/enums/app_type.dart';
import '../../../../core/enums/wallet_type.dart';

class TransactionModel {
  final String id;
  final int categoryId;
  final int walletId;
  final String title;
  final double amount;
  final DateTime date;
  final AppType type;
  final String? categoryIcon;

  final String? walletName;
  final String? walletIcon;
  final WalletType? walletType;

  TransactionModel({
    required this.id,
    required this.categoryId,
    required this.walletId,
    required this.title,
    required this.amount,
    required this.date,
    required this.type,
    this.categoryIcon,
    this.walletName,
    this.walletIcon,
    this.walletType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'wallet_id': walletId,
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
      walletId: map['wallet_id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']).toLocal(),
      type: AppType.values.firstWhere(
            (e) => e.name == map['type'],
      ),
      categoryIcon: map['category_icon'],
      walletName: map['wallet_name'],
      walletIcon: map['wallet_icon'],
      walletType: map['wallet_type'] == null
          ? null
          : WalletType.values.firstWhere(
            (e) => e.name == map['wallet_type'],
      ),
    );
  }
}