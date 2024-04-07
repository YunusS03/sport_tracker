import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import '../models/activity.dart';
import 'activity_chart_screen.dart';

class DetailedActivityScreen extends StatefulWidget {
  final String activityType;

  const DetailedActivityScreen({super.key, required this.activityType});

  @override
  _DetailedActivityScreenState createState() => _DetailedActivityScreenState();
}

class _DetailedActivityScreenState extends State<DetailedActivityScreen> {
  bool _ascendingOrder = true; // Default ordering is ascending

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.activityType} Activities'),
        actions: [
          _buildOrderByDropdown(),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, activityProvider, _) {
          return _buildActivityList(context, activityProvider);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildActivityList(BuildContext context, ActivityProvider activityProvider) {
    List<Activity> activities = activityProvider.getActivitiesByType(widget.activityType);

    if (activities.isEmpty) {
      return Center(
        child: Text('No ${widget.activityType} activities available'),
      );
    }

    // Sort activities based on selected order
    activities.sort((a, b) => _ascendingOrder ? a.date.compareTo(b.date) : b.date.compareTo(a.date));

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        Activity activity = activities[index];
        return _buildActivityCard(context, activity, activityProvider);
      },
    );
  }

  Widget _buildActivityCard(BuildContext context, Activity activity, ActivityProvider activityProvider) {
    String formattedDateTime = DateFormat.yMMMMd().add_Hm().format(activity.date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            formattedDateTime,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timer, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 4),
                  Text('Duration: ${activity.duration.inMinutes} minutes'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.fireplace, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text('Burned Calories: ${activity.calories} kcal', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit, color: Theme.of(context).primaryColor),
                onPressed: () {
                  // Navigate to edit activity screen
                  // You can implement this based on your requirement
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Delete the activity
                  activityProvider.removeActivity(activity.id!);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityChartScreen()),
          );
        }
      },
    );
  }

  Widget _buildOrderByDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: DropdownButton<String>(
        value: _ascendingOrder ? 'Ascending' : 'Descending',
        icon: const Icon(Icons.sort),
        onChanged: (String? newValue) {
          setState(() {
            _ascendingOrder = newValue == 'Ascending';
          });
        },
        items: <String>['Ascending', 'Descending'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
