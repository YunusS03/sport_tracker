import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:fitness_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ActivityProvider(),
      child: MaterialApp(
        title: 'SportTracker',
        theme: ThemeData(
          // Your theme settings...
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
