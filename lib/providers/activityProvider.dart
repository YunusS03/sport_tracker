import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Activity {
  final int? id;
  final DateTime date;
  final String type;
  final Duration duration;
  final int intensity;

  Activity({
    this.id,
    required this.date,
    required this.type,
    required this.duration,
    required this.intensity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'duration': duration.inMinutes,
      'intensity': intensity,
    };
  }
}

class ActivityProvider extends ChangeNotifier {
  late Database _database;
  List<Activity> _activities = [];

  ActivityProvider() {
    _initDatabase().then((_) {
      _loadActivities();
    });
  }

  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'activity_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE activities(id INTEGER PRIMARY KEY, date TEXT, type TEXT, duration INTEGER, intensity INTEGER)',
        );
      },
      version: 1,
    );
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

  List<Activity> getActivitiesByType(String type) {
    return _activities.where((activity) => activity.type == type).toList();
  }
}
