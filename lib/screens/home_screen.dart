import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/activiteitenprovider.dart';
import 'AddActivityScreen.dart';
import 'ActivityDetailScreen.dart'; // Import the ActivityDetailScreen

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SportTracker',
          style: TextStyle(
            fontFamily: 'Montserrat', // Using a fitness-themed font
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // Customizing the app bar color
        centerTitle: true,
        // Adding a settings icon for configuration
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Implement settings functionality here
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupedActivities(context, 'This Week', Provider.of<ActivityProvider>(context).activitiesByWeek),
            _buildGroupedActivities(context, 'This Month', Provider.of<ActivityProvider>(context).activitiesByMonth),
            _buildGroupedActivities(context, 'This Year', Provider.of<ActivityProvider>(context).activitiesByYear),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddActivityScreen()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green, // Customizing the FAB color
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Plan',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
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
            final activities = groupedActivities[key];

            // Customizing activity card design
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: _getActivityIcon(activities![0].type), // Using the icon of the first activity
                title: Text(
                  key,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _getConsolidatedActivityDescription(activities), // Display consolidated activity description
                  style: TextStyle(fontSize: 14),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActivityDetailScreen(groupKey: key), // Pass the group key to detail screen
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  String _getConsolidatedActivityDescription(List<Activity> activities) {
    Map<String, Duration> consolidatedActivities = {};

    // Sum up durations for each activity type
    for (final activity in activities) {
      if (consolidatedActivities.containsKey(activity.type)) {
        consolidatedActivities[activity.type] = consolidatedActivities[activity.type]! + activity.duration;
      } else {
        consolidatedActivities[activity.type] = activity.duration;
      }
    }

    // Format consolidated activity description
    String consolidatedDescription = '';
    consolidatedActivities.forEach((type, duration) {
      consolidatedDescription += '$type: ${_formatDuration(duration)}, ';
    });

    return consolidatedDescription.substring(0, consolidatedDescription.length - 2); // Remove trailing comma and space
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '$hours u $minutes min';
  }

  Icon _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return Icon(Icons.directions_run, color: Colors.blue);
      case 'cycling':
        return Icon(Icons.directions_bike, color: Colors.green);
      case 'swimming':
        return Icon(Icons.pool, color: Colors.blueAccent);
      case 'walking':
        return Icon(Icons.directions_walk, color: Colors.orange);
      default:
        return Icon(Icons.help, color: Colors.grey); // Default icon for unknown activities
    }
  }
}
