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
  Future<List<CategoryModel>> getCategoriesByType(String type) {
    return localDataSource.getCategoriesByType(type);
  }


  @override
  Future<void> updateCategory(CategoryModel category) {
    return localDataSource.updateCategory(category);
  }

  @override
  Future<void> deleteCategory(String id) {
    return localDataSource.deleteCategory(id);
  }
}