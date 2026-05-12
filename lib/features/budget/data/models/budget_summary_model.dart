class BudgetSummaryModel {
  final int categoryId;

  final int budgetId;
  final double budgetAmount;

  final int? month;
  final int? year;

  final String categoryName;
  final String categoryIcon;

  final double spentAmount;
  final double remaining;

  BudgetSummaryModel({
    required this.categoryId,
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
      categoryId: int.tryParse(
        json['categoryId'].toString(),
      ) ??
          0,

      budgetId: int.tryParse(
        json['budgetId'].toString(),
      ) ??
          0,

      budgetAmount: double.tryParse(
        json['budgetAmount'].toString(),
      ) ??
          0,

      month: json['month'] == null
          ? null
          : int.tryParse(json['month'].toString()),

      year: json['year'] == null
          ? null
          : int.tryParse(json['year'].toString()),

      categoryName: json['categoryName'] ?? '',

      categoryIcon: json['categoryIcon'] ?? '',

      spentAmount: double.tryParse(
        json['spentAmount'].toString(),
      ) ??
          0,

      remaining: double.tryParse(
        json['remaining'].toString(),
      ) ??
          0,
    );
  }
}