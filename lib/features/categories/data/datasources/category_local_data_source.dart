import 'package:sqflite/sqflite.dart';
import '../../../../core/database/app_database.dart';
import '../models/category_model.dart';

class CategoryLocalDataSource {
  Future<Database> get database async => await AppDatabase.database;


  Future<void> insertCategory(CategoryModel category) async {
    final db = await database;
    await db.insert(
      'categories',
      category.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }


  Future<List<CategoryModel>> getCategories() async {
    final db = await database;
    final maps = await db.query('categories');

    return maps.map((e) => CategoryModel.fromMap(e)).toList();
  }


  Future<void> updateCategory(CategoryModel category) async {
    final db = await database;
    await db.update(
      'categories',
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }


  Future<void> deleteCategory(String id) async {
    final db = await database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}