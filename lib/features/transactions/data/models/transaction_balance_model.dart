class BalanceModel {
  final String type;

  final int? month;
  final int year;

  final int? previousMonth;
  final int? previousYear;

  final double currentBalance;
  final double previousBalance;
  final double totalBalance;

  BalanceModel({
    required this.type,
    this.month,
    required this.year,
    this.previousMonth,
    this.previousYear,
    required this.currentBalance,
    required this.previousBalance,
    required this.totalBalance,
  });

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      type: json['type'] ?? '',
      month: json['month'],
      year: json['year'] ?? 0,
      previousMonth: json['previousMonth'],
      previousYear: json['previousYear'],
      currentBalance: double.tryParse(json['currentBalance'].toString()) ?? 0,
      previousBalance: double.tryParse(json['previousBalance'].toString()) ?? 0,
      totalBalance: double.tryParse(json['totalBalance'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'month': month,
      'year': year,
      'previousMonth': previousMonth,
      'previousYear': previousYear,
      'currentBalance': currentBalance,
      'previousBalance': previousBalance,
      'totalBalance': totalBalance,
    };
  }
}