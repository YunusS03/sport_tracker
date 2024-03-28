import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  List<Activity> _activities = [];

  List<Activity> get activities => _activities;

  Map<String, List<Activity>> get activitiesByWeek {
    final now = DateTime.now();
    final filteredActivities = _activities.where((activity) =>
    activity.date.isAfter(now.subtract(Duration(days: 7))) && activity.date.isBefore(now));
    return _groupActivities(filteredActivities);
  }

  Map<String, List<Activity>> get activitiesByMonth {
    final now = DateTime.now();
    final filteredActivities = _activities.where((activity) => activity.date.year == now.year && activity.date.month == now.month);
    return _groupActivities(filteredActivities);
  }

  Map<String, List<Activity>> get activitiesByYear {
    final now = DateTime.now();
    final filteredActivities = _activities.where((activity) => activity.date.year == now.year);
    return _groupActivities(filteredActivities);
  }

  void addActivity(Activity activity) {
    _activities.add(activity);
    notifyListeners();
  }

  void removeActivity(Activity activity) {
    _activities.remove(activity);
    notifyListeners();
  }

  Map<String, List<Activity>> _groupActivities(Iterable<Activity> activities) {
    Map<String, List<Activity>> groupedActivities = {};
    activities.forEach((activity) {
      final key = '${DateFormat('yyyy-MM-dd').format(activity.date)}_${activity.type}';
      if (groupedActivities.containsKey(key)) {
        groupedActivities[key]!.add(activity);
      } else {
        groupedActivities[key] = [activity];
      }
    });
    return groupedActivities;
  }
}
