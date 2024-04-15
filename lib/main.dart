import 'package:fitness_tracker/screens/calendar_screen.dart';
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
    // Biedt de ActivityProvider aan de widget tree
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Verwijder de debug banner
        title: 'Vitality Vault',
        theme: ThemeData(
          // Uw thema-instellingen...
        ),
        // Definieer route mappings
        routes: {
          '/addActivity': (context) => const AddActivityScreen(),
          '/activityChart': (context) => const ActivityChartScreen(),
          '/detailedActivity': (context) => const DetailedActivityScreen(activityType: ''),
          '/home': (context) => const HomeScreen(),
          '/plan': (context) => CalendarScreen(),
        },
        home: const HomeScreen(), // Standaard startscherm
      ),
    );
  }
}
