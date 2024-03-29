import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';

class DetailedActivityScreen extends StatelessWidget {
  final String activityType;

  DetailedActivityScreen({required this.activityType});

  @override
  Widget build(BuildContext context) {
    // Retrieve activities of the selected type from provider
    List<Activity> activities = Provider.of<ActivityProvider>(context).getActivitiesByType(activityType);

    return Scaffold(
      appBar: AppBar(
        title: Text('$activityType Activities'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          // Build list item for each activity
          Activity activity = activities[index];
          return ListTile(
            title: Text('Date: ${activity.date} - Duration: ${activity.duration.inMinutes} minutes'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to edit activity screen
                    // You can implement this based on your requirement
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Delete the activity
                    Provider.of<ActivityProvider>(context, listen: false).removeActivity(activity.id!);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
