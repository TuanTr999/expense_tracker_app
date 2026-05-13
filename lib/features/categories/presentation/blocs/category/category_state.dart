import 'package:expense_tracker_app/core/enums/app_status.dart';
import 'package:expense_tracker_app/core/enums/app_type.dart';

import '../../../data/models/category_model.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final AppType? selectedType;
  final AppStatus status;

  CategoryState({
    required this.categories,
    this.selectedType,
    this.status = AppStatus.initial,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    AppType? selectedType,
    AppStatus? status,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedType: selectedType ?? this.selectedType,
      status: status ?? this.status,
    );
  }
}