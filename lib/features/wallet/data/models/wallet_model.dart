

import '../../../../core/enums/wallet_type.dart';

class WalletModel {
  final int? id;
  final String name;
  final WalletType type;
  final String? icon;
  final double balance;

  WalletModel({
    this.id,
    required this.name,
    required this.type,
    this.icon,
    required this.balance,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      name: json['name'],
      type: walletTypeFromString(json['type']),
      icon: json['icon'],
      balance: double.tryParse(json['balance'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type.name,
      'icon': icon,
      'balance': balance,
    };
  }
}