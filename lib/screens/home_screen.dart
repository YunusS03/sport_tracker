import 'package:flutter/material.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:provider/provider.dart';
import 'AddActivityScreen.dart';
import 'ActivityDetailScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SportTracker',
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
            _buildGroupedActivities(context, 'This Week'),
            _buildGroupedActivities(context, 'This Month'),
            _buildGroupedActivities(context, 'This Year'),
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
        backgroundColor: Colors.green,
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

  Widget _buildGroupedActivities(BuildContext context, String title) {
    final provider = Provider.of<ActivityProvider>(context);
    Map<String, List<Activity>> groupedActivities = {};

    switch (title) {
      case 'This Week':
        groupedActivities = provider.activitiesByWeek();
        break;
      case 'This Month':
        groupedActivities = provider.activitiesByMonth();
        break;
      case 'This Year':
        groupedActivities = provider.activitiesByYear();
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: groupedActivities.length,
          itemBuilder: (context, index) {
            final activityType = groupedActivities.keys.elementAt(index);
            final activities = groupedActivities[activityType]!;

            final totalDuration = activities.fold<Duration>(
                Duration.zero, (previousValue, element) =>
            previousValue + element.duration);

            // Calculate progress percentage based on goals
            double progress = totalDuration.inMinutes / 600; // Assuming goal is 10 hours (600 minutes)
            if (progress > 1.0) progress = 1.0;

            return ListTile(
              leading: _getActivityIcon(activityType),
              title: Text(activityType),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Text(
                    '${totalDuration.inHours} hours ${totalDuration.inMinutes.remainder(60)} minutes',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10),
      ],
    );
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
