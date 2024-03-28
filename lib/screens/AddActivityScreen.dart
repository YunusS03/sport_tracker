import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/activiteitenprovider.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _intensityController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedActivityType = 'Running'; // Default activity type

  // List of predefined activity types
  final List<String> activityTypes = ['Running', 'Cycling', 'Swimming', 'Walking', 'Other'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Activity'),
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
              child: Text('Select Date: ${DateFormat.yMMMd().format(_selectedDate)}'),
            ),
            DropdownButtonFormField(
              value: _selectedActivityType,
              onChanged: (String? value) {
                setState(() {
                  _selectedActivityType = value!;
                });
              },
              items: activityTypes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Activity Type'),
            ),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            TextFormField(
              controller: _intensityController,
              decoration: InputDecoration(labelText: 'Intensity (1-5)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
                final int duration = int.tryParse(_durationController.text) ?? 0;
                final int intensity = int.tryParse(_intensityController.text) ?? 0;

                activityProvider.addActivity(Activity(
                  date: _selectedDate,
                  type: _selectedActivityType,
                  duration: Duration(minutes: duration),
                  intensity: intensity,
                ));

                Navigator.pop(context); // Go back to HomeScreen
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
