import 'package:path/path.dart';
import 'package:restaurants_project/data/model/restaurants.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal() {
    _instance = this;
  }

  factory DatabaseHelper() => _instance ?? DatabaseHelper._internal();

  static const String _tblFavoriteresto = 'favorite';

  Future<Database> _initializeDb() async {
    var path = await getDatabasesPath();
    var db = openDatabase(
      join(path, 'resto.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE $_tblFavoriteresto (
             id TEXT PRIMARY KEY,
             name TEXT,
             description TEXT,
             pictureId TEXT,
             city TEXT,
             rating NUMERIC
           )     
        ''');
      },
      version: 1,
    );

    return db;
  }

  Future<Database?> get database async {
    _database ??= await _initializeDb();

    return _database;
  }

  Future<void> insertData(Restaurants restaurant) async {
    final db = await database;
    await db!.insert(_tblFavoriteresto, restaurant.toJson());
  }

  Future<List<Restaurants>> getData() async {
    final db = await database;
    List<Map<String, dynamic>> results = await db!.query(_tblFavoriteresto);

    return results.map((res) => Restaurants.fromJson(res)).toList();
  }

  Future<void> removeData(String id) async {
    final db = await database;

    await db!.delete(
      _tblFavoriteresto,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Map> getDataById(String id) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db!.query(
      _tblFavoriteresto,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isNotEmpty) {
      return results.first;
    } else {
      return {};
    }
  }

  void complete(String testModuleName) {}
}
