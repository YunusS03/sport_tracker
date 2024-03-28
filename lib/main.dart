import 'package:fitness_tracker/providers/activiteitenprovider.dart';
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
        home: HomeScreen(),
      ),
    );
  }
}
