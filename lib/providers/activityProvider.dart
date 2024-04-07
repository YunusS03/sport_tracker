import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';
import '../models/user.dart';

class ActivityProvider extends ChangeNotifier {
  late Database _database;
  List<Activity> _activities = [];
  late User _user;

  ActivityProvider() {
    _initDatabase().then((_) {
      _loadActivities();
      _loadUser();
    });
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'activity_database.db'),
      onCreate: (db, version) async {
        // Create activities table
        await db.execute(
          'CREATE TABLE activities(id INTEGER PRIMARY KEY, date TEXT, type TEXT, duration INTEGER, intensity INTEGER, calories INTEGER)',
        );

        // Create user table
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL, height REAL)',
        );


        // Insert a default user
        await db.insert(
          'users',
          User(name: 'John Doe', age: 30, weight: 70.0, height: 170.0).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
      version: 2,
    );
  }

  Future<void> _loadUser() async {
    final List<Map<String, dynamic>> maps = await _database.query('users');
    if (maps.isNotEmpty) {
      _user = User(
        id: maps[0]['id'],
        name: maps[0]['name'],
        age: maps[0]['age'],
        weight: maps[0]['weight'],
        height: maps[0]['height'],
      );
    } else {
      // If no user found, initialize with default values
      _user = User(id: null, name: 'default user', age: 24, weight: 70, height: 172);
    }

    print('Loaded user from the database');
    notifyListeners(); // Notify listeners after loading user
  }


  Future<void> setUser(User user) async {
    final existingUser = await _database.query('users');
    if (existingUser.isNotEmpty) {
      await _database.update(
        'users',
        {
          'name': user.name,
          'age': user.age,
          'weight': user.weight,
          'height': user.height,
        },
        where: 'id = ?',
        whereArgs: [existingUser[0]['id']],
      );
    } else {
      await _database.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    _user = user; // Set the user in memory
    print('User updated in the database: $user');
    notifyListeners(); // Notify listeners after setting user
  }



  User getUser() {
    return _user;
  }


  Future<void> _loadActivities() async {
    final List<Map<String, dynamic>> maps = await _database.query('activities');
    _activities = List.generate(maps.length, (i) {
      return Activity(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
        duration: Duration(minutes: maps[i]['duration']),
        intensity: maps[i]['intensity'],
        calories: maps[i]['calories'], // Added calories field
      );
    });

    print('Loaded ${_activities.length} activities from the database');
    notifyListeners(); // Notify listeners after loading activities
  }

  Future<void> addActivity(Activity activity) async {
    await _database.insert(
      'activities',
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _loadActivities(); // Reload activities after adding a new one
  }


  Future<void> removeActivity(int id) async {
    await _database.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadActivities(); // Reload activities after removing one
  }

  List<Activity> getAllActivities() {
    return _activities;
  }

  // Group activities by week
  Map<String, List<Activity>> activitiesByWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));
    return _groupActivities(_getActivitiesByDate(startOfWeek, endOfWeek));
  }

  // Group activities by month
  Map<String, List<Activity>> activitiesByMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return _groupActivities(_getActivitiesByDate(startOfMonth, endOfMonth));
  }

  // Group activities by year
  Map<String, List<Activity>> activitiesByYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);
    return _groupActivities(_getActivitiesByDate(startOfYear, endOfYear));
  }

  List<Activity> _getActivitiesByDate(DateTime startDate, DateTime endDate) {
    return _activities.where((activity) =>
    activity.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        activity.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
  }

  Map<String, List<Activity>> _groupActivities(List<Activity> activities) {
    Map<String, List<Activity>> groupedActivities = {};
    for (var activity in activities) {
      final key = activity.type;
      if (groupedActivities.containsKey(key)) {
        groupedActivities[key]!.add(activity);
      } else {
        groupedActivities[key] = [activity];
      }
    }
    return groupedActivities;
  }

  Activity? getActivityByType(String type) {
    final activity = _activities.firstWhere((activity) => activity.type == type);
    return activity;
  }




  List<Activity> getActivitiesByType(String type) {
    return _activities.where((activity) => activity.type == type).toList();
  }
}
