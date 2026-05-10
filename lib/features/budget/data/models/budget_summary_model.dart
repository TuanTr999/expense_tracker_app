class BudgetSummaryModel {
  final int budgetId;
  final double budgetAmount;

  final int? month;
  final int? year;

  final String categoryName;
  final String categoryIcon;

  final double spentAmount;
  final double remaining;

  BudgetSummaryModel({
    required this.budgetId,
    required this.budgetAmount,
    this.month,
    this.year,
    required this.categoryName,
    required this.categoryIcon,
    required this.spentAmount,
    required this.remaining,
  });

  factory BudgetSummaryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BudgetSummaryModel(
      budgetId: json['budgetId'] ?? 0,

      budgetAmount:
      (json['budgetAmount'] ?? 0).toDouble(),

      month: json['month'],

      year: json['year'],

      categoryName:
      json['categoryName'] ?? '',

      categoryIcon:
      json['categoryIcon'] ?? '',

      spentAmount:
      (json['spentAmount'] ?? 0).toDouble(),

      remaining:
      (json['remaining'] ?? 0).toDouble(),
    );
  }
}