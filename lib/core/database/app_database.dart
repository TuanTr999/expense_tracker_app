import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('PRAGMA foreign_keys = ON');

        // Category
        await db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            icon TEXT,
            type TEXT
          )
        ''');

        // Transaction
        await db.execute('''
          CREATE TABLE transactions(
            id TEXT PRIMARY KEY,
            title TEXT,
            amount REAL,
            date TEXT,
            type TEXT,
            categoryId INTEGER,
            FOREIGN KEY (categoryId) REFERENCES categories(id)
          )
        ''');

        for (var item in defaultCategories) {
          await db.insert('categories', item);
        }
      },
    );
  }

  static List<Map<String, dynamic>> defaultCategories = [
    {'name': 'Ăn uống', 'icon': 'food.png', 'type': 'expense'},
    {'name': 'Giải trí', 'icon': 'entertainment.png', 'type': 'expense'},
    {'name': 'Sức khỏe', 'icon': 'healthcare.png', 'type': 'expense'},
    {'name': 'Nhà ở', 'icon': 'house.png', 'type': 'expense'},
    {'name': 'Mua sắm', 'icon': 'shopping-cart.png', 'type': 'expense'},
    {'name': 'Di chuyển', 'icon': 'transportation.png', 'type': 'expense'},
    {'name': 'Giáo dục', 'icon': 'education.png', 'type': 'expense'},

    {'name': 'Lương', 'icon': 'salary.png', 'type': 'income'},
    {'name': 'Thưởng', 'icon': 'bonus.png', 'type': 'income'},
    {'name': 'Đầu tư', 'icon': 'investment.png', 'type': 'income'},
    {'name': 'Quà tặng', 'icon': 'giftbox.png', 'type': 'income'},
  ];
}
