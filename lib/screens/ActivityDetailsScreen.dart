import 'package:flutter/material.dart';

import '../providers/activiteitenprovider.dart';

class ActivityDetailsScreen extends StatelessWidget {
  final Activity activity;

  ActivityDetailsScreen({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Type: ${activity.type}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Duur: ${activity.duurInMinuten} minuten'),
            SizedBox(height: 10),
            Text('Intensiteit: ${activity.intensiteit}'),
          ],
        ),
      ),
    );
  }
}
