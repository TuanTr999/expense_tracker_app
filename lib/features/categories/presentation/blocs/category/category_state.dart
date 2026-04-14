import '../../../data/models/category_model.dart';

class CategoryState {
  final List<CategoryModel> categories;
  final String? selectedType;
  final bool isLoading;

  CategoryState({
    required this.categories,
    this.selectedType,
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<CategoryModel>? categories,
    String? selectedType,
    bool? isLoading,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      selectedType: selectedType ?? this.selectedType,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}