import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/activiteitenprovider.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String groupKey;

  ActivityDetailScreen({required this.groupKey});

  @override
  Widget build(BuildContext context) {
    final groupedActivities = Provider.of<ActivityProvider>(context).activitiesByWeek[groupKey];
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: ListView.builder(
        itemCount: groupedActivities!.length,
        itemBuilder: (context, index) {
          final activity = groupedActivities[index];
          return Card(
            child: ListTile(
              title: Text('Type: ${activity.type}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: ${DateFormat.yMMMd().format(activity.date)}'),
                  Text('Duration: ${activity.duration.inMinutes} minutes'),
                  Text('Intensity: ${activity.intensity}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _removeActivity(context, activity);
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActivityDetailScreen(groupKey: groupKey), // Pass the groupKey to detail screen
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _removeActivity(BuildContext context, Activity activity) {
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    activityProvider.removeActivity(activity);
    Navigator.pop(context); // Navigate back to the previous screen
  }
}