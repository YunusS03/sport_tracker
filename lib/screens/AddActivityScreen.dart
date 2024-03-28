import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/activiteitenprovider.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _intensityController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nieuwe activiteit toevoegen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null && pickedDate != _selectedDate) {
                  setState(() {
                    _selectedDate = pickedDate;
                  });
                }
              },
              child: Text('Selecteer datum: ${DateFormat.yMMMd().format(_selectedDate)}'),
            ),
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type activiteit'),
            ),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duur (minuten)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _intensityController,
              decoration: InputDecoration(labelText: 'Intensiteit (1-5)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
                final String type = _typeController.text;
                final int duration = int.tryParse(_durationController.text) ?? 0;
                final int intensity = int.tryParse(_intensityController.text) ?? 0;

                activityProvider.addActivity(Activity(
                  date: _selectedDate,
                  type: type,
                  duration: Duration(minutes: duration),
                  intensity: intensity,
                ));

                Navigator.pop(context); // Ga terug naar HomeScreen
              },
              child: Text('Opslaan'),
            ),
          ],
        ),
      ),
    );
  }
}
