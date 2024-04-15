import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/activity.dart';
import '../models/user.dart';

class ActivityProvider extends ChangeNotifier {
  late Database _database; // Database object voor gegevensopslag
  List<Activity> _activities = []; // Lijst met activiteiten
  late User _user; // Gebruikersobject

  ActivityProvider() {
    _initDatabase().then((_) {
      _loadActivities(); // Laad activiteiten bij het initialiseren
      _loadUser(); // Laad de gebruiker bij het initialiseren
    });
  }

  // Initialiseer de database
  Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'activity_database.db'), // Maak of open een database met de opgegeven naam
      onCreate: (db, version) async {
        // Maak tabel voor activiteiten
        await db.execute(
          'CREATE TABLE activities(id INTEGER PRIMARY KEY, date TEXT, type TEXT, duration INTEGER, intensity INTEGER, calories INTEGER)',
        );

        // Maak tabel voor gebruikers
        await db.execute(
          'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER, weight REAL, height REAL)',
        );

        // Voeg een standaardgebruiker toe
        await db.insert(
          'users',
          User(name: 'John Doe', age: 30, weight: 70.0, height: 170.0).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      },
      version: 2, // Databaseversie
    );
  }

  // Laad de gebruiker uit de database
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
      // Als geen gebruiker wordt gevonden, initialiseer met standaardwaarden
      _user = User(id: null, name: 'standaard gebruiker', age: 24, weight: 70, height: 172);
    }

    print('Gebruiker geladen uit de database');
    notifyListeners(); // Meld luisteraars na het laden van de gebruiker
  }

  // Stel de gebruiker in
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
    _user = user; // Stel de gebruiker in het geheugen in
    print('Gebruiker bijgewerkt in de database: $user');
    notifyListeners(); // Meld luisteraars na het instellen van de gebruiker
  }

  // Haal de huidige gebruiker op
  User? getUser() {
    return _user;
  }

  // Laad activiteiten uit de database
  Future<void> _loadActivities() async {
    final List<Map<String, dynamic>> maps = await _database.query('activities');
    _activities = List.generate(maps.length, (i) {
      return Activity(
        id: maps[i]['id'],
        date: DateTime.parse(maps[i]['date']),
        type: maps[i]['type'],
        duration: Duration(minutes: maps[i]['duration']),
        intensity: maps[i]['intensity'],
        calories: maps[i]['calories'], // Toegevoegd veld voor calorieën
      );
    });

    print('Geladen ${_activities.length} activiteiten uit de database');
    notifyListeners(); // Meld luisteraars na het laden van de activiteiten
  }

  // Voeg een nieuwe activiteit toe
  Future<void> addActivity(Activity activity) async {
    await _database.insert(
      'activities',
      activity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await _loadActivities(); // Herlaad activiteiten na toevoegen van een nieuwe
  }

  // Verwijder een activiteit
  Future<void> removeActivity(int id) async {
    await _database.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadActivities(); // Herlaad activiteiten na verwijderen van een
  }

  // Haal alle activiteiten op
  List<Activity> getAllActivities() {
    return _activities;
  }

  // Groepeer activiteiten per week
  Map<String, List<Activity>> activitiesByWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = now.add(Duration(days: 7 - now.weekday));
    return _groupActivities(_getActivitiesByDate(startOfWeek, endOfWeek));
  }

  // Groepeer activiteiten per maand
  Map<String, List<Activity>> activitiesByMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    return _groupActivities(_getActivitiesByDate(startOfMonth, endOfMonth));
  }

  // Groepeer activiteiten per jaar
  Map<String, List<Activity>> activitiesByYear() {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final endOfYear = DateTime(now.year, 12, 31);
    return _groupActivities(_getActivitiesByDate(startOfYear, endOfYear));
  }

  // Haal activiteiten op tussen een start- en einddatum
  List<Activity> _getActivitiesByDate(DateTime startDate, DateTime endDate) {
    return _activities.where((activity) =>
    activity.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
        activity.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
  }

  // Groepeer activiteiten
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

  // Haal een activiteit op op basis van het type
  Activity? getActivityByType(String type) {
    final activity = _activities.firstWhere((activity) => activity.type == type);
    return activity;
  }

  // Haal activiteiten op op basis van het type
  List<Activity> getActivitiesByType(String type) {
    return _activities.where((activity) => activity.type == type).toList();
  }
}
