class BudgetSummaryModel {
  final int budgetId;
  final double budgetAmount;
  final int month;
  final int year;
  final String categoryName;
  final String categoryIcon;
  final double spentAmount;
  final double remaining;

  BudgetSummaryModel({
    required this.budgetId,
    required this.budgetAmount,
    required this.month,
    required this.year,
    required this.categoryName,
    required this.categoryIcon,
    required this.spentAmount,
    required this.remaining,
  });

  factory BudgetSummaryModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return BudgetSummaryModel(
      budgetId: json['budgetId'],
      budgetAmount: json['budgetAmount'].toDouble(),
      month: json['month'],
      year: json['year'],
      categoryName: json['categoryName'],
      categoryIcon: json['categoryIcon'],
      spentAmount: json['spentAmount'].toDouble(),
      remaining: json['remaining'].toDouble(),
    );
  }
}