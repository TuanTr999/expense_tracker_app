import 'package:expense_tracker_app/core/enums/app_type.dart';

import '../repositories/category_repository.dart';
import '../datasources/category_local_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<void> insertCategory(CategoryModel category) {
    return localDataSource.insertCategory(category);
  }

  @override
  Future<List<CategoryModel>> getCategories() {
    return localDataSource.getCategories();
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType(AppType type) {
    return localDataSource.getCategoriesByType(type.name);
  }


  @override
  Future<void> updateCategory(CategoryModel category) {
    return localDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(int id) {
    return localDataSource.deleteCategory(id);
  }

  @override
  Future<void> resetCategory(){
    return localDataSource.resetCategories();
  }
}