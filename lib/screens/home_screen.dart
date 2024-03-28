import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/activiteitenprovider.dart';
import 'AddActivityScreen.dart'; // Replace with your actual import

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SportTracker'),
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, activityProvider, _) {
          final List<Activity> activities = activityProvider.activities;
          final Map<String, List<Activity>> activitiesByWeek = _groupActivitiesByWeek(activities);
          final Map<String, List<Activity>> activitiesByMonth = _groupActivitiesByMonth(activities);
          final Map<String, List<Activity>> activitiesByYear = _groupActivitiesByYear(activities);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGroupedActivities(context, 'Deze week', activitiesByWeek),
                _buildGroupedActivities(context, 'Deze maand', activitiesByMonth),
                _buildGroupedActivities(context, 'Dit jaar', activitiesByYear),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddActivityScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Map<String, List<Activity>> _groupActivitiesByWeek(List<Activity> activities) {
    final Map<String, List<Activity>> groupedActivities = {};
    activities.forEach((activity) {
      final weekStartDate = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      final weekEndDate = weekStartDate.add(Duration(days: 6));
      final weekKey = '${DateFormat('yyyy-MM-dd').format(weekStartDate)} - ${DateFormat('yyyy-MM-dd').format(weekEndDate)}';
      if (activity.date.isAfter(weekStartDate.subtract(Duration(days: 1))) && activity.date.isBefore(weekEndDate.add(Duration(days: 1)))) {
        if (groupedActivities.containsKey(weekKey)) {
          groupedActivities[weekKey]!.add(activity);
        } else {
          groupedActivities[weekKey] = [activity];
        }
      }
    });
    return groupedActivities;
  }

  Map<String, List<Activity>> _groupActivitiesByMonth(List<Activity> activities) {
    final Map<String, List<Activity>> groupedActivities = {};
    activities.forEach((activity) {
      final monthKey = DateFormat('yyyy-MM').format(activity.date);
      if (groupedActivities.containsKey(monthKey)) {
        groupedActivities[monthKey]!.add(activity);
      } else {
        groupedActivities[monthKey] = [activity];
      }
    });
    return groupedActivities;
  }

  Map<String, List<Activity>> _groupActivitiesByYear(List<Activity> activities) {
    final Map<String, List<Activity>> groupedActivities = {};
    activities.forEach((activity) {
      final yearKey = activity.date.year.toString();
      if (groupedActivities.containsKey(yearKey)) {
        groupedActivities[yearKey]!.add(activity);
      } else {
        groupedActivities[yearKey] = [activity];
      }
    });
    return groupedActivities;
  }

  Widget _buildGroupedActivities(BuildContext context, String title, Map<String, List<Activity>> groupedActivities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupedActivities.length,
          itemBuilder: (context, index) {
            final key = groupedActivities.keys.elementAt(index);
            final activities = groupedActivities[key]!;
            final totalDuration = activities.fold(Duration.zero, (prev, element) => prev + element.duration);
            return ListTile(
              title: Text(key),
              subtitle: Text('Totaal duur: ${totalDuration.inMinutes} minuten'),
            );
          },
        ),
        Divider(),
      ],
    );
  }
}