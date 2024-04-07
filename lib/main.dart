import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:fitness_tracker/screens/activity_chart_screen.dart';
import 'package:fitness_tracker/screens/add_activity_screen.dart';
import 'package:fitness_tracker/screens/detailed_activity_screen.dart';
import 'package:fitness_tracker/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Remove the debug banner
        title: 'SportTracker',
        theme: ThemeData(
          // Your theme settings...
        ),
        routes: {
          '/addActivity': (context) => const AddActivityScreen(),
          '/activityChart': (context) => const ActivityChartScreen(),
          '/detailedActivity': (context) => const DetailedActivityScreen(activityType: ''),
          '/home': (context) => const HomeScreen()
        },
        home: const HomeScreen(),
      ),
    );
  }
}
