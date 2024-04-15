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
  String _selectedFilter = 'This Week'; // Geselecteerde filter voor activiteiten

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ActivityProvider>(context);
    final activities = provider.getAllActivities(); // Alle activiteiten ophalen

    // Activiteiten filteren op basis van geselecteerde filter
    List<Activity> filteredActivities = _filterActivities(activities);

    // Activiteiten groeperen per type
    Map<String, int> groupedActivities = _groupActivities(filteredActivities);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity Charts'), // Titel van de app-balk
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFilterButtons(), // Filterknoppen weergeven
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildChart(groupedActivities), // Grafiek weergeven
            ),
          ],
        ),
      ),
    );
  }

  // Methode om filterknoppen weer te geven
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

  // Methode om individuele filterknop weer te geven
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

  // Methode om grafiek weer te geven op basis van activiteiten
  Widget _buildChart(Map<String, int> activities) {
    if (activities.isEmpty) {
      return const Center(
        child: Text(
          'No data available', // Geen gegevens beschikbaar
          style: TextStyle(fontSize: 18),
        ),
      );
    } else {
      return Column(
        children: [
          _buildActivityDistributionChart(activities), // Grafiek voor activiteitendistributie
          const SizedBox(height: 16),
          _buildIntensityVsDurationChart(activities), // Grafiek voor intensiteit vs. duur
          const SizedBox(height: 16),
          _buildAverageIntensityChart(activities), // Grafiek voor gemiddelde intensiteit
          const SizedBox(height: 16),
          _buildTotalCaloriesBurnedChart(activities), // Grafiek voor totaal verbrande calorieën
        ],
      );
    }
  }

  // Methode om grafiek voor activiteitendistributie weer te geven
  Widget _buildActivityDistributionChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCircularChart(
        title: ChartTitle(text: 'Activity Distribution by Type'), // Titel van de grafiek
        legend: Legend(
          isVisible: true,
          overflowMode: LegendItemOverflowMode.scroll, // Scrollen voor legende-items
        ),
        series: <CircularSeries<ActivityData, String>>[
          DoughnutSeries<ActivityData, String>(
            dataSource: _generateChartData(activities, ChartType.ActivityDistribution),
            xValueMapper: (ActivityData data, _) => data.type,
            yValueMapper: (ActivityData data, _) => data.totalDuration?.toDouble() ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true), // Gegevenslabels weergeven
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey, // Kleur toewijzen aan punten
          ),
        ],
      ),
    );
  }

  // Methode om grafiek voor intensiteit vs. duur weer te geven
  Widget _buildIntensityVsDurationChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Intensity vs. Duration'), // Titel van de grafiek
        primaryXAxis: NumericAxis(title: AxisTitle(text: 'Duration (minutes)')), // X-as instellingen
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Intensity')), // Y-as instellingen
        series: <ChartSeries>[
          ScatterSeries<ActivityData, int>(
            dataSource: _generateChartData(activities, ChartType.IntensityVsDuration),
            xValueMapper: (ActivityData data, _) => data.totalDuration ?? 0,
            yValueMapper: (ActivityData data, _) => data.intensity ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true), // Gegevenslabels weergeven
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey, // Kleur toewijzen aan punten
          ),
        ],
      ),
    );
  }

  // Methode om grafiek voor gemiddelde intensiteit weer te geven
  Widget _buildAverageIntensityChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Average Intensity by Activity Type'), // Titel van de grafiek
        primaryXAxis: CategoryAxis(), // Categorie-as instellingen
        primaryYAxis: NumericAxis(title: AxisTitle(text: 'Average Intensity')), // Y-as instellingen
        series: <ChartSeries>[
          ColumnSeries<ActivityData, String>(
            dataSource: _generateChartData(activities, ChartType.AverageIntensity),
            xValueMapper: (ActivityData data, _) => data.type,
            yValueMapper: (ActivityData data, _) => data.averageIntensity?.toDouble() ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true), // Gegevenslabels weergeven
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey, // Kleur toewijzen aan punten
          ),
        ],
      ),
    );
  }

  // Methode om grafiek voor totaal verbrande calorieën weer te geven
  Widget _buildTotalCaloriesBurnedChart(Map<String, int> activities) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(text: 'Total Calories Burned by Activity Type'), // Titel van de grafiek
        primaryXAxis: CategoryAxis(), // Categorie-as instellingen
        series: <ChartSeries>[
          ColumnSeries<ActivityData, String>(
            dataSource: _generateChartData(activities, ChartType.TotalCaloriesBurned),
            xValueMapper: (ActivityData data, _) => data.type,
            yValueMapper: (ActivityData data, _) => data.calories?.toDouble() ?? 0,
            dataLabelSettings: const DataLabelSettings(isVisible: true), // Gegevenslabels weergeven
            pointColorMapper: (ActivityData data, _) => data.color ?? Colors.grey, // Kleur toewijzen aan punten
          ),
        ],
      ),
    );
  }

  // Methode om activiteiten te filteren op basis van geselecteerde filter
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

  // Methode om activiteiten te groeperen
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

  // Methode om gegevens voor grafiek te genereren
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
              // Gemiddelde intensiteit berekenen voor elk activiteitstype
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

  // Methode om kleur op basis van activiteitstype te genereren
  Color? _getColor(String type) {
    // Pastelkleurenpalet
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
      // Voeg meer kleuren toe indien nodig
    ];
    // Hash-code genereren op basis van het activiteitstype
    int hashCode = type.hashCode;

    // Gebruik de hash-code om een kleur te selecteren uit de lijst
    return colors[hashCode % colors.length];
  }
}

// Enum voor verschillende soorten grafieken
enum ChartType {
  ActivityDistribution,
  IntensityVsDuration,
  AverageIntensity,
  TotalCaloriesBurned,
}

// Gegevensklasse voor grafiek
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
