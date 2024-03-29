import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/activityProvider.dart';

class AddActivityScreen extends StatefulWidget {
  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
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
    'Snowboarding',
    'Skateboarding',
    'Rock Climbing',
    'Other'
  ];

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  void initState() {
    super.initState();
    _hoursController.text = '1'; // Default value for hours
    _minutesController.text = '0'; // Default value for minutes
  }

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
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_outlined), // Modern date picker icon
                  SizedBox(width: 10),
                  Text(
                    'Select Date: ${DateFormat.yMMMd().format(_selectedDate)}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
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
                  child: Row(
                    children: [
                      _getActivityIcon(value), // Add icon here
                      SizedBox(width: 10), // Adjust spacing between icon and text
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              decoration: InputDecoration(labelText: 'Activity Type'),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hoursController,
                    decoration: InputDecoration(labelText: 'Hours'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minutesController,
                    decoration: InputDecoration(labelText: 'Minutes'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            const Text(
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
                final int hours = int.tryParse(_hoursController.text) ?? 0;
                final int minutes = int.tryParse(_minutesController.text) ?? 0;
                final int totalMinutes = hours * 60 + minutes;

                activityProvider.addActivity(Activity(
                  date: _selectedDate,
                  type: _selectedActivityType,
                  duration: Duration(minutes: totalMinutes),
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

  // Function to get activity icon based on activity type
  Icon _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return Icon(Icons.directions_run, color: Colors.blue);
      case 'cycling':
        return Icon(Icons.directions_bike, color: Colors.green);
      case 'swimming':
        return Icon(Icons.pool, color: Colors.blueAccent);
      case 'walking':
        return Icon(Icons.directions_walk, color: Colors.orange);
      case 'hiking':
        return Icon(Icons.terrain, color: Colors.brown);
      case 'yoga':
        return Icon(Icons.self_improvement, color: Colors.purple);
      case 'weightlifting':
        return Icon(Icons.fitness_center, color: Colors.red);
      case 'pilates':
        return Icon(Icons.spa, color: Colors.lightGreen);
      case 'dancing':
        return Icon(Icons.music_note, color: Colors.pink);
      case 'basketball':
        return Icon(Icons.sports_basketball, color: Colors.orange);
      case 'soccer':
        return Icon(Icons.sports_soccer, color: Colors.green);
      case 'tennis':
        return Icon(Icons.sports_tennis, color: Colors.blue);
      case 'golf':
        return Icon(Icons.sports_golf, color: Colors.yellow);
      case 'surfing':
        return Icon(Icons.surfing, color: Colors.lightBlue);
      case 'snowboarding':
        return Icon(Icons.snowboarding, color: Colors.indigo);
      case 'skateboarding':
        return Icon(Icons.skateboarding, color: Colors.deepOrange);
      case 'rock climbing':
        return Icon(Icons.explore, color: Colors.brown);
      default:
        return Icon(Icons.help, color: Colors.grey); // Default icon for unknown activities
    }
  }

  // Function to show date picker dialog
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary: Colors.blue, // Header background color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
