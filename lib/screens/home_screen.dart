import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:provider/provider.dart';
import '../helpers/MotivationalQuotes.dart';
import '../models/activity.dart';
import 'user_information_screen.dart';
import 'detailed_activity_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Vitality Vault',
          style: TextStyle(
            fontFamily: 'BebasNeue',
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 5.0,
          ),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserInformationScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Image.asset(
                    'assets/images/carousel1.jpg',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: RandomQuoteWidget(), // Add the RandomQuoteWidget
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildGroupedActivities(context, 'This Week'),
            _buildGroupedActivities(context, 'This Month'),
            _buildGroupedActivities(context, 'This Year'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddActivityScreen(context);
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
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          switch (index) {
            case 0:
              _navigateToHomeScreen(context);
              break;
            case 1:
              _navigateToChartScreen(context);
              break;
            case 2:
              _navigateToPlanScreen(context);
              break;
          }
        },
      ),
    );
  }
  void _navigateToAddActivityScreen(BuildContext context) {
    Navigator.pushNamed(context, '/addActivity');
  }

  void _navigateToChartScreen(BuildContext context) {
    Navigator.pushNamed(context, '/activityChart');
  }

  void _navigateToHomeScreen(BuildContext context) {
    Navigator.pushNamed(context, '/home');
  }

  void _navigateToPlanScreen(BuildContext context) {
    Navigator.pushNamed(context, '/plan');
  }

  Widget _buildGroupedActivities(BuildContext context, String title) {
    final provider = Provider.of<ActivityProvider>(context);
    final groupedActivities = _getGroupedActivities(provider, title);

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
            final totalDuration = _calculateTotalDuration(activities);
            final totalCalories = _calculateTotalCalories(activities);
            final activityCount = activities.length;

            return ListTile(
              leading: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getActivityIcon(activityType),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      Icon(Icons.whatshot, size: 16, color: Colors.orange), // Calorie icon
                      const SizedBox(width: 4),
                      Text(
                        '$totalCalories',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
              title: Text(activityType),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(
                    value: totalDuration.inMinutes / 600, // Assuming goal is 10 hours (600 minutes)
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                  Text(
                    '${totalDuration.inHours} hours ${totalDuration.inMinutes.remainder(60)} minutes ($activityCount activities)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              onTap: () => _navigateToDetailedActivityScreen(context, activityType),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  int _calculateTotalCalories(List<Activity> activities) {
    return activities.fold<int>(
      0,
          (previousValue, element) => previousValue + element.calories,
    );
  }

  void _navigateToDetailedActivityScreen(BuildContext context, String activityType) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailedActivityScreen(activityType: activityType)),
    );
  }

  Map<String, List<Activity>> _getGroupedActivities(ActivityProvider provider, String title) {
    switch (title) {
      case 'This Week':
        return provider.activitiesByWeek();
      case 'This Month':
        return provider.activitiesByMonth();
      case 'This Year':
        return provider.activitiesByYear();
      default:
        return {};
    }
  }

  Duration _calculateTotalDuration(List<Activity> activities) {
    return activities.fold<Duration>(
      Duration.zero,
          (previousValue, element) => previousValue + element.duration,
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
