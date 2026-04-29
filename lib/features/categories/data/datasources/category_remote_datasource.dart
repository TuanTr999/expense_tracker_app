import 'package:dio/dio.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSource(this.dio);

  Future<List<CategoryModel>> getCategories() async {
    final res = await dio.get('/categories');

    return (res.data as List).map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<List<CategoryModel>> getCategoriesByType(String type) async {
    final res = await dio.get('/categories', queryParameters: {'type': type});

    return (res.data as List).map((e) => CategoryModel.fromMap(e)).toList();
  }

  Future<void> addCategory(CategoryModel category) async {
    await dio.post('/categories', data: category.toMap());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await dio.put('/categories/${category.id}', data: category.toMap());
  }

  Future<void> deleteCategory(int id) async {
    await dio.delete('/categories/$id');
  }

  Future<bool> hasTransaction(int categoryId) async {
    final res = await dio.get('/categories/$categoryId/has-transaction');

    return res.data['hasTransaction'] == true;
  }
  Future<void> resetCategories() async {
    await dio.post('/categories/reset');
  }
}
