import 'dart:developer';

import 'package:dicoding_submission_restaurant/data/models/response/restaurant.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteService {
  static const _databaseName = 'sds.db';
  static const _databaseVersion = 1;
  static const _tableName = 'restaurant';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnDescription = 'description';
  static const columnImageId = 'pictureId';
  static const columnCity = 'city';
  static const columnRating = 'rating';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);

    var db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (Database db, int version) async {
        await createTables(db, version);
      },
    );

    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$_tableName'");

    if (result.isEmpty) {
      await createTables(db, _databaseVersion);
    }

    return db;
  }

  Future<void> createTables(Database database, int version) async {
    await database.execute(
      """CREATE TABLE IF NOT EXISTS $_tableName(
    $columnId TEXT PRIMARY KEY NOT NULL,
    $columnName TEXT,
    $columnDescription TEXT,
    $columnImageId TEXT,
    $columnCity TEXT,
    $columnRating REAL
   )
   """,
    );
  }

  Future<int> insertItem(Restaurant restaurant) async {
    log('Execute insertItem');
    final db = await database;

    final data = {
      columnId: restaurant.id,
      columnName: restaurant.name,
      columnDescription: restaurant.description,
      columnImageId: restaurant.pictureId,
      columnCity: restaurant.city,
      columnRating: restaurant.rating.toDouble(),
    };

    final id = await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id;
  }

  Future<List<Restaurant>> getAllItems() async {
    final db = await database;
    final results = await db.query(_tableName, orderBy: "id");
    log("Execute getAllItems" + results.toString());

    return results.map((result) {
      return Restaurant.fromJson(result);
    }).toList();
  }

  Future<int> removeItem(String id) async {
    final db = await database;

    final result =
        await db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return result;
  }

  Future<void> clearDatabase() async {
    var dbPath = await getDatabasesPath();
    var path = join(dbPath, _databaseName);
    await deleteDatabase(path);
  }
}
