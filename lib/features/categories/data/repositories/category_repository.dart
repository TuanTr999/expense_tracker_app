import 'package:expense_tracker_app/core/enums/app_type.dart';

import '../models/category_model.dart';

abstract class CategoryRepository {
  Future<void> insertCategory(CategoryModel category);

  Future<List<CategoryModel>> getCategories();

  Future<List<CategoryModel>> getCategoriesByType(AppType type);

  Future<void> updateCategory(CategoryModel category);

  Future<void> deleteCategory(int id);

  Future<void> resetCategory();
}