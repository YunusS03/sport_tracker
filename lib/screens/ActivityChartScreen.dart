import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';


class ActivityChartScreen extends StatefulWidget {
  const ActivityChartScreen({super.key});

  @override
  _ActivityChartScreenState createState() => _ActivityChartScreenState();


}

class _ActivityChartScreenState extends State<ActivityChartScreen> {
  String _selectedFilter = 'This Week';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final activities = provider.getAllActivities(); // Get all activities

    // Filter activities based on selected filter
    List<Activity> filteredActivities = _filterActivities(activities);

    // Group activities by type
    Map<String, int> groupedActivities = _groupActivities(filteredActivities);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Charts'),
      ),
      body: Column(
        children: [
          _buildFilterButtons(),
          const SizedBox(height: 16),
          Expanded(
            child: _buildChart(groupedActivities),
          ),
        ],
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
        showSelectedLabels: true,
        showUnselectedLabels: true,
        onTap: (index) {
          if (index == 0) {
            // Navigate to the home screen when the home button is tapped
            Navigator.popUntil(context, ModalRoute.withName('/'));

          } else if (index == 2) {
            // Navigate to the detailed activity screen when the plan button is tapped
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => DetailedActivityScreen(activityType: '',)),
            // );
          }
        },
      ),
    );
  }

  Widget _buildFilterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilterButton('This Week'),
        _buildFilterButton('This Month'),
        _buildFilterButton('This Year'),
      ],
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filter ? Colors.blue : null,
      ),
      child: Text(filter),
    );
  }

  Widget _buildChart(Map<String, int> activities) {
    if (activities.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      return SfCircularChart(
        title: ChartTitle(text: 'Activity Distribution by Type'),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.wrap, // Wrap legend items if there's not enough space
        ),
        series: <CircularSeries<ActivityData, String>>[
          DoughnutSeries<ActivityData, String>(
            dataSource: _generateChartData(activities),
            xValueMapper: (ActivityData data, _) => data.type, // Activity Type
            yValueMapper: (ActivityData data, _) => data.totalDuration.toDouble(), // Total Duration (Numeric)
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey, // Custom color mapping
          ),
        ],
      );
    }
  }

  List<Activity> _filterActivities(List<Activity> activities) {
    switch (_selectedFilter) {
      case 'This Week':
        return activities.where((activity) {
          return DateTime.now().difference(activity.date).inDays <= 7;
        }).toList();
      case 'This Month':
        final now = DateTime.now();
        final startOfMonth = DateTime(now.year, now.month, 1);
        return activities.where((activity) {
          return activity.date.isAfter(startOfMonth);
        }).toList();
      case 'This Year':
        final now = DateTime.now();
        final startOfYear = DateTime(now.year, 1, 1);
        return activities.where((activity) {
          return activity.date.isAfter(startOfYear);
        }).toList();
      default:
        return activities;
    }
  }

  Map<String, int> _groupActivities(List<Activity> activities) {
    Map<String, int> groupedActivities = {};
    for (var activity in activities) {
      if (groupedActivities.containsKey(activity.type)) {
        groupedActivities[activity.type] = (groupedActivities[activity.type] ?? 0) + activity.duration.inMinutes;
      } else {
        groupedActivities[activity.type] = activity.duration.inMinutes;
      }
    }
    return groupedActivities;
  }

  List<ActivityData> _generateChartData(Map<String, int> activities) {
    List<ActivityData> data = [];
    int index = 0;
    activities.forEach((type, duration) {
      data.add(ActivityData(
        type: type,
        totalDuration: duration,
        color: _getColor(index),
      ));
      index++;
    });
    return data;
  }

  Color? _getColor(int index) {
    // Pastel color palette
    List<Color?> colors = [
      Colors.blue[200],
      Colors.green[200],
      Colors.blueAccent[100],
      Colors.orange[200],
      Colors.brown[200],
      Colors.purple[200],
      Colors.red[200],
      Colors.lightGreen[200],
      Colors.pink[200],
      Colors.orange[200],
      Colors.green[200],
      Colors.blue[200],
      Colors.yellow[200],
      Colors.lightBlue[200],
      Colors.indigo[200],
      Colors.deepOrange[200],
      Colors.brown[200],
    ];
    // If index exceeds the color palette, cycle back to the beginning
    return colors[index % colors.length];
  }
}

class ActivityData {
  final String type;
  final int totalDuration;
  final Color? color;

  ActivityData({
    required this.type,
    required this.totalDuration,
    required this.color,
  });
}
