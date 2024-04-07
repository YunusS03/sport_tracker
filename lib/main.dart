import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:fitness_tracker/screens/ActivityChartScreen.dart';
import 'package:fitness_tracker/screens/AddActivityScreen.dart';
import 'package:fitness_tracker/screens/DetailedActivityScreen.dart';
import 'package:fitness_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(),
      child: MaterialApp(
        title: 'SportTracker',
        theme: ThemeData(
          // Your theme settings...
        ),
        routes: {
          '/addActivity': (context) => AddActivityScreen(),
          '/activityChart': (context) => ActivityChartScreen(),
          '/detailedActivity': (context) => const DetailedActivityScreen(activityType: '',),

        },
        home: const HomeScreen(),
      ),
    );
  }
}
