import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';

import 'ActivityChartScreen.dart';

class DetailedActivityScreen extends StatelessWidget {
  final String activityType;

  const DetailedActivityScreen({super.key, required this.activityType});

  @override
  Widget build(BuildContext context) {
    // Retrieve activities of the selected type from provider
    List<Activity> activities = Provider.of<ActivityProvider>(context).getActivitiesByType(activityType);

    if (activities.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('$activityType Activities'),
        ),
        body: Center(
          child: Text('No $activityType activities available'),
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
          onTap: (index) {
            if (index == 0) {
              // Navigate to the home screen when the home button is tapped
              Navigator.pop(context);
            } else if (index == 1) {
              // Navigate to the chart screen when the chart button is tapped
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ActivityChartScreen()),
              );
            }
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('$activityType Activities'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          // Build list item for each activity
          Activity activity = activities[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                'Date: ${activity.date}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Duration: ${activity.duration.inMinutes} minutes'),
              trailing: Wrap(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      // Navigate to edit activity screen
                      // You can implement this based on your requirement
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Delete the activity
                      Provider.of<ActivityProvider>(context, listen: false).removeActivity(activity.id!);
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
        onTap: (index) {
          if (index == 0) {
            // Navigate to the home screen when the home button is tapped
            Navigator.pop(context);
          } else if (index == 1) {
            // Navigate to the chart screen when the chart button is tapped
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ActivityChartScreen()),
            );
          }
        },
      ),
    );
  }
}
