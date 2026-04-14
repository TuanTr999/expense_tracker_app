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
        // Category
        await db.execute('''
          CREATE TABLE categories(
            id TEXT PRIMARY KEY,
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
            categoryId TEXT,
            FOREIGN KEY (categoryId) REFERENCES categories(id)
          )
        ''');



        for (var item in defaultCategories) {
          await db.insert('categories', item);
        }
      },
    );
  }

  static List<Map<String, dynamic>>  defaultCategories = [
    {
      'id': '1',
      'name': 'Ăn uống',
      'icon': 'food.png',
      'type': 'expense',
    },
    {
      'id': '2',
      'name': 'Giải trí',
      'icon': 'entertainment.png',
      'type': 'expense',
    },
    {
      'id': '3',
      'name': 'Sức khỏe',
      'icon': 'healthcare.png',
      'type': 'expense',
    },
    {
      'id': '4',
      'name': 'Nhà ở',
      'icon': 'house.png',
      'type': 'expense',
    },
    {
      'id': '5',
      'name': 'Mua sắm',
      'icon': 'shopping-cart.png',
      'type': 'expense',
    },
    {
      'id': '6',
      'name': 'Di chuyển',
      'icon': 'transportation.png',
      'type': 'expense',
    },
    {
      'id': '7',
      'name': 'Giáo dục',
      'icon': 'education.png',
      'type': 'expense',
    },

    {
      'id': '8',
      'name': 'Lương',
      'icon': 'salary.png',
      'type': 'income',
    },
    {
      'id': '9',
      'name': 'Thưởng',
      'icon': 'bonus.png',
      'type': 'income',
    },
    {
      'id': '10',
      'name': 'Đầu tư',
      'icon': 'investment.png',
      'type': 'income',
    },
    {
      'id': '11',
      'name': 'Quà tặng',
      'icon': 'giftbox.png',
      'type': 'income',
    },
  ];
}