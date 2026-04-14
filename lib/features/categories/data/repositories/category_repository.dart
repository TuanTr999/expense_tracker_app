import '../models/category_model.dart';

abstract class CategoryRepository {
  Future<void> insertCategory(CategoryModel category);

  Future<List<CategoryModel>> getCategories();

  Future<List<CategoryModel>> getCategoriesByType(String type);

  Future<void> updateCategory(CategoryModel category);

  Future<void> deleteCategory(String id);
}