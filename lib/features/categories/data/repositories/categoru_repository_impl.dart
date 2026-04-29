import 'package:expense_tracker_app/core/enums/app_type.dart';
import 'package:expense_tracker_app/features/categories/data/datasources/category_remote_datasource.dart';

import '../repositories/category_repository.dart';
import '../datasources/category_local_datasource.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> insertCategory(CategoryModel category) {
    return remoteDataSource.addCategory(category);
  }

  @override
  Future<List<CategoryModel>> getCategories() {
    return remoteDataSource.getCategories();
  }

  @override
  Future<List<CategoryModel>> getCategoriesByType(AppType type) {
    return remoteDataSource.getCategoriesByType(type.name);
  }


  @override
  Future<void> updateCategory(CategoryModel category) {
    return remoteDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(int id) {
    return remoteDataSource.deleteCategory(id);
  }

  @override
  Future<void> resetCategory(){
    return remoteDataSource.resetCategories();
  }
}