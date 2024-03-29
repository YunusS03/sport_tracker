import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../providers/activityProvider.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._();
  static Database? _database;

  DatabaseHelper._();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String path = join(await getDatabasesPath(), 'activities.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE activities(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date TEXT,
        type TEXT,
        duration INTEGER,
        intensity INTEGER
      )
    ''');
  }

  Future<int> insertActivity(Activity activity) async {
    final Database db = await database;
    return await db.insert('activities', activity.toMap());
  }

  Future<List<Activity>> getActivities() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('activities');
    return List.generate(maps.length, (i) {
      return Activity(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
        duration: Duration(minutes: maps[i]['duration']),
        intensity: maps[i]['intensity'],
      );
    });
  }

  Future<int> deleteActivity(int id) async {
    final Database db = await database;
    return await db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }
}
