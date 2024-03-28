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
        title: Text(
          'SportTracker',
          style: TextStyle(
            fontFamily: 'Montserrat', // Use a fitness-themed font
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue, // Customize the app bar color
        centerTitle: true,
        // Add an icon or logo related to fitness here if desired
        actions: [
          IconButton(
            icon: Icon(Icons.settings), // Add a settings icon
            onPressed: () {
              // Implement settings functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGroupedActivities(context, 'Deze week', Provider.of<ActivityProvider>(context).activitiesByWeek),
            _buildGroupedActivities(context, 'Deze maand', Provider.of<ActivityProvider>(context).activitiesByMonth),
            _buildGroupedActivities(context, 'Dit jaar', Provider.of<ActivityProvider>(context).activitiesByYear),
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
        backgroundColor: Colors.green, // Customize the FAB color
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Grafieken',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Plannen',
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

            // Custom activity card design
            return Card(
              elevation: 3,
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: Icon(
                  Icons.directions_run, // Use an appropriate activity icon
                  color: Colors.blue,
                ),
                title: Text(
                  key,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final activity in activities!)
                      Text(
                        '${activity.type} • ${DateFormat('dd MMM').format(activity.date)} • ${activity.duration} min',
                        style: TextStyle(fontSize: 14),
                      ),
                  ],
                ),
                onTap: () {
                  // Implement activity details screen
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
