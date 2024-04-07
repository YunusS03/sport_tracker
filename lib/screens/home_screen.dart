import 'package:flutter/material.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:provider/provider.dart';
import 'ActivityChartScreen.dart';
import 'AddActivityScreen.dart';
import 'DetailedActivityScreen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            icon: const Icon(Icons.settings),
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
            MaterialPageRoute(builder: (context) => const AddActivityScreen()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
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
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          if (index == 1) {
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
          physics: const NeverScrollableScrollPhysics(),
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
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Text(
                    '${totalDuration.inHours} hours ${totalDuration.inMinutes.remainder(60)} minutes',
                    style: const TextStyle(fontSize: 12),
                  )
                  ,
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedActivityScreen(activityType: activityType),
                  ),
                );
              },
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }


  Icon _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return const Icon(Icons.directions_run, color: Colors.blue);
      case 'cycling':
        return const Icon(Icons.directions_bike, color: Colors.green);
      case 'swimming':
        return const Icon(Icons.pool, color: Colors.blueAccent);
      case 'walking':
        return const Icon(Icons.directions_walk, color: Colors.orange);
      case 'hiking':
        return const Icon(Icons.terrain, color: Colors.brown);
      case 'yoga':
        return const Icon(Icons.self_improvement, color: Colors.purple);
      case 'weightlifting':
        return const Icon(Icons.fitness_center, color: Colors.red);
      case 'pilates':
        return const Icon(Icons.spa, color: Colors.lightGreen);
      case 'dancing':
        return const Icon(Icons.music_note, color: Colors.pink);
      case 'basketball':
        return const Icon(Icons.sports_basketball, color: Colors.orange);
      case 'soccer':
        return const Icon(Icons.sports_soccer, color: Colors.green);
      case 'tennis':
        return const Icon(Icons.sports_tennis, color: Colors.blue);
      case 'golf':
        return const Icon(Icons.sports_golf, color: Colors.yellow);
      case 'surfing':
        return const Icon(Icons.surfing, color: Colors.lightBlue);
      case 'snowboarding':
        return const Icon(Icons.snowboarding, color: Colors.indigo);
      case 'skateboarding':
        return const Icon(Icons.skateboarding, color: Colors.deepOrange);
      case 'rock climbing':
        return const Icon(Icons.explore, color: Colors.brown);
      default:
        return const Icon(Icons.help, color: Colors.grey); // Default icon for unknown activities
    }
  }

}