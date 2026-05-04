import 'package:expense_tracker_app/core/enums/app_type.dart';

import '../../../data/models/category_model.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final AppType? selectedType;
  final bool isLoading;
  final bool isDeleted;

  CategoryState({
    required this.categories,
    this.selectedType,
    this.isLoading = false,
    this.isDeleted = false,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    AppType? selectedType,
    bool? isLoading,
    bool? isDeleted,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedType: selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
      isDeleted: isDeleted ?? this.isDeleted,
    );
  }
}