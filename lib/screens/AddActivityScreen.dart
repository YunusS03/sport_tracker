import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/activityProvider.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _durationController = TextEditingController();
  int _selectedIntensity = 1; // Default intensity

  DateTime _selectedDate = DateTime.now();
  String _selectedActivityType = 'Running'; // Default activity type

  // List of predefined activity types
  final List<String> activityTypes = [
    'Running',
    'Cycling',
    'Swimming',
    'Walking',
    'Hiking',
    'Yoga',
    'Weightlifting',
    'Pilates',
    'Dancing',
    'Basketball',
    'Soccer',
    'Tennis',
    'Golf',
    'Surfing',
    'Skiing',
    'Snowboarding',
    'Skateboarding',
    'Rock Climbing',
    'Other'
  ];

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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            TextFormField(
              controller: _durationController,
              decoration: InputDecoration(labelText: 'Duration (minutes)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text(
              'Intensity:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                    (index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIntensity = index + 1;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: _selectedIntensity == index + 1 ? Colors.blue : Colors.grey),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: _selectedIntensity == index + 1 ? Colors.blue : Colors.black,
                          fontWeight: _selectedIntensity == index + 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
                final int duration = int.tryParse(_durationController.text) ?? 0;

                activityProvider.addActivity(Activity(
                  date: _selectedDate,
                  type: _selectedActivityType,
                  duration: Duration(minutes: duration),
                  intensity: _selectedIntensity,
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
