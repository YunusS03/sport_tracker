import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';

import '../models/activity.dart';

class ActivityChartScreen extends StatefulWidget {
  const ActivityChartScreen({Key? key}) : super(key: key);

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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFilterButtons(),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildChart(groupedActivities),
            ),
          ],
        ),
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
      return Column(
        children: [
          _buildActivityDistributionChart(activities),
          const SizedBox(height: 16),
          _buildIntensityVsDurationChart(activities),
          const SizedBox(height: 16),
          _buildAverageIntensityChart(activities),
          const SizedBox(height: 16),
          _buildTotalCaloriesBurnedChart(activities),
        ],
      );
    }
  }

  Widget _buildActivityDistributionChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCircularChart(
        title: ChartTitle(text: 'Activity Distribution by Type'),
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.scroll, // Set overflow mode to scroll
        ),
        series: <CircularSeries<ActivityData, String>>[
          DoughnutSeries<ActivityData, String>(
            dataSource: _generateChartData(activities, ChartType.ActivityDistribution),
            xValueMapper: (ActivityData data, _) => data.type,
            yValueMapper: (ActivityData data, _) => data.totalDuration?.toDouble() ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildIntensityVsDurationChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Intensity vs. Duration'),
        primaryXAxis: NumericAxis(title: AxisTitle(text: 'Duration (minutes)')),
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Intensity')),
        series: <ChartSeries>[
          ScatterSeries<ActivityData, int>(
            dataSource: _generateChartData(activities, ChartType.IntensityVsDuration),
            xValueMapper: (ActivityData data, _) => data.totalDuration ?? 0,
            yValueMapper: (ActivityData data, _) => data.intensity ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildAverageIntensityChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Average Intensity by Activity Type'),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Average Intensity')),
        series: <ChartSeries>[
          ColumnSeries<ActivityData, String>(
            dataSource: _generateChartData(activities, ChartType.AverageIntensity),
            xValueMapper: (ActivityData data, _) => data.type,
            yValueMapper: (ActivityData data, _) => data.averageIntensity?.toDouble() ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalCaloriesBurnedChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Total Calories Burned by Activity Type'),
        primaryXAxis: CategoryAxis(),
        series: <ChartSeries>[
          ColumnSeries<ActivityData, String>(
            dataSource: _generateChartData(activities, ChartType.TotalCaloriesBurned),
            xValueMapper: (ActivityData data, _) => data.type,
            yValueMapper: (ActivityData data, _) => data.calories?.toDouble() ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true),
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey,
          ),
        ],
      ),
    );
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

  List<ActivityData> _generateChartData(Map<String, int> activities, ChartType chartType) {
    List<ActivityData> data = [];
    activities.forEach((type, duration) {
      final activity = Provider.of<ActivityProvider>(context, listen: false).getActivityByType(type);
      if (activity != null) {
        switch (chartType) {
          case ChartType.ActivityDistribution:
            data.add(ActivityData(
              type: type,
              totalDuration: duration,
              color: _getColor(type),
              calories: activity.calories,
            ));
            break;
          case ChartType.IntensityVsDuration:
            data.add(ActivityData(
              type: type,
              totalDuration: duration,
              intensity: activity.intensity,
              color: _getColor(type),
            ));
            break;
          case ChartType.AverageIntensity:
            if (!data.any((element) => element.type == type)) {
              // Calculate average intensity for each activity type
              final activitiesOfType = activities.values.where((value) => type == activity.type).length;
              final totalIntensity = activities.entries
                  .where((entry) => entry.key == type)
                  .map((entry) => entry.value)
                  .reduce((value, element) => value + element);
              final averageIntensity = totalIntensity ~/ activitiesOfType;
              data.add(ActivityData(
                type: type,
                averageIntensity: averageIntensity,
                color: _getColor(type),
              ));
            }
            break;
          case ChartType.TotalCaloriesBurned:
            data.add(ActivityData(
              type: type,
              totalDuration: duration,
              calories: activity.calories,
              color: _getColor(type),
            ));
            break;
        }
      }
    });
    return data;
  }

  Color? _getColor(String type) {
    // Pastel color palette
    List<Color?> colors = [
      Colors.blue[200],
      Colors.green[200],
      Colors.orange[200],
      Colors.purple[200],
      Colors.red[200],
      Colors.yellow[200],
      Colors.indigo[200],
      Colors.teal[200],
      Colors.pink[200],
      Colors.amber[200],
      // Add more colors as needed
    ];
    // Generate a hash code based on the activity type
    int hashCode = type.hashCode;

    // Use the hash code to select a color from the list
    return colors[hashCode % colors.length];
  }
}

enum ChartType {
  ActivityDistribution,
  IntensityVsDuration,
  AverageIntensity,
  TotalCaloriesBurned,
}

class ActivityData {
  final String type;
  final int? totalDuration;
  final Color? color;
  final int? calories;
  final int? intensity;
  final int? averageIntensity;

  ActivityData({
    required this.type,
    this.totalDuration,
    this.color,
    this.calories,
    this.intensity,
    this.averageIntensity,
  });
}
