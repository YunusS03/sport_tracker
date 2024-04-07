import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../providers/activityProvider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

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

  @override
  void initState() {
    super.initState();
    _hoursController.text = '0'; // Default value for hours
    _minutesController.text = '0'; // Default value for minutes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _selectDateTime,
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined), // Modern date picker icon
                  const SizedBox(width: 10),
                  Text(
                    ' ${DateFormat.yMMMd().format(_selectedDate)} ${DateFormat.Hm().format(_selectedDate)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActivityTypeDropdown(),
            const SizedBox(height: 20),
            const Text(
              'Duration:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDurationButton('+15 min', 15),
                _buildDurationButton('+30 min', 30),
                _buildDurationButton('+45 min', 45),
                _buildDurationButton('+1 H', 60),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hoursController,
                    decoration: const InputDecoration(labelText: 'Hours'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minutesController,
                    decoration: const InputDecoration(labelText: 'Minutes'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Intensity:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
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
                      color: _selectedIntensity == index + 1 ? Colors.blue : Colors.white,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: _selectedIntensity == index + 1 ? Colors.white : Colors.black,
                          fontWeight: _selectedIntensity == index + 1 ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveActivity,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show date and time picker dialog
  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
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
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        setState(() {
          _selectedDate = selectedDateTime;
        });
      }
    }
  }

  // Function to build activity type dropdown
  Widget _buildActivityTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedActivityType,
      onChanged: (value) {
        setState(() {
          _selectedActivityType = value!;
        });
      },
      items: activityTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Row(
            children: [
              _getActivityIcon(type),
              const SizedBox(width: 10),
              Text(type),
            ],
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Activity Type',
        border: OutlineInputBorder(),
      ),
    );
  }

  // Function to save activity
  void _saveActivity() {
    final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
    final int hours = int.tryParse(_hoursController.text) ?? 0;
    final int minutes = int.tryParse(_minutesController.text) ?? 0;
    final int totalMinutes = hours * 60 + minutes;

    if (totalMinutes == 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Duration cannot be 0. Please enter a valid duration.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    // Calculate calories burned
    double calories = calculateCalories(Activity(
      date: _selectedDate, // Pass the selected date
      type: _selectedActivityType,
      duration: Duration(minutes: totalMinutes),
      intensity: _selectedIntensity,
    ));



    activityProvider.addActivity(Activity(
      date: _selectedDate, // Pass the selected date
      type: _selectedActivityType,
      duration: Duration(minutes: totalMinutes),
      intensity: _selectedIntensity,
      calories: calories.toInt(), // Pass the calculated calories
    ));


    Navigator.pop(context); // Go back to HomeScreen
  }

  double calculateCalories(Activity activity) {
    // Constants
    const double weightKg = 70; // Example weight in kilograms
    const double caloriesPerKgPerHour = 1.05; // Example value for calories burned per kg per hour

    // Convert intensity to MET value
    double met;
    switch (activity.intensity) {
      case 1:
        met = 4.3; // Light intensity
        break;
      case 2:
        met = 6.0; // Moderate intensity
        break;
      case 3:
        met = 8.0; // Vigorous intensity
        break;
      case 4:
        met = 10.0; // Very vigorous intensity
        break;
      case 5:
        met = 12.0; // Extremely vigorous intensity
        break;
      default:
        met = 1.0; // Default to resting metabolic rate
        break;
    }

    // Calculate duration in hours
    double durationHours = activity.duration.inMinutes / 60.0;

    // Calculate calories burned
    double calories = (caloriesPerKgPerHour * weightKg * met * durationHours).roundToDouble();

    return calories;
  }


  // Function to build duration button
  Widget _buildDurationButton(String label, int minutes) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          final int currentHours = int.tryParse(_hoursController.text) ?? 0;
          final int currentMinutes = int.tryParse(_minutesController.text) ?? 0;
          final int totalCurrentMinutes = currentHours * 60 + currentMinutes;

          final int newTotalMinutes = totalCurrentMinutes + minutes;

          _hoursController.text = (newTotalMinutes ~/ 60).toString();
          _minutesController.text = (newTotalMinutes % 60).toString();
        });
      },
      child: Text(label),
    );
  }

  // Function to get activity icon based on activity type
  Icon _getActivityIcon(String activityType) {
    switch (activityType.toLowerCase()) {
      case 'running':
        return const Icon(Icons.directions_run, color: Colors.blue);
      case 'cycling':
        return const Icon(Icons.directions_bike, color: Colors.green);
      case 'swimming':
        return const Icon(Icons.pool, color: Colors.blueAccent);
      case 'walking':
        return const Icon(Icons.directions_walk, color: Colors.orange);
      case 'hiking':
        return const Icon(Icons.terrain, color: Colors.brown);
      case 'yoga':
        return const Icon(Icons.self_improvement, color: Colors.purple);
      case 'weightlifting':
        return const Icon(Icons.fitness_center, color: Colors.red);
      case 'pilates':
        return const Icon(Icons.spa, color: Colors.lightGreen);
      case 'dancing':
        return const Icon(Icons.music_note, color: Colors.pink);
      case 'basketball':
        return const Icon(Icons.sports_basketball, color: Colors.orange);
      case 'soccer':
        return const Icon(Icons.sports_soccer, color: Colors.green);
      case 'tennis':
        return const Icon(Icons.sports_tennis, color: Colors.blue);
      case 'golf':
        return const Icon(Icons.sports_golf, color: Colors.yellow);
      case 'surfing':
        return const Icon(Icons.surfing, color: Colors.lightBlue);
      case 'snowboarding':
        return const Icon(Icons.snowboarding, color: Colors.indigo);
      case 'skateboarding':
        return const Icon(Icons.skateboarding, color: Colors.deepOrange);
      case 'rock climbing':
        return const Icon(Icons.explore, color: Colors.brown);
      default:
        return const Icon(Icons.help, color: Colors.grey); // Default icon for unknown activities
    }
  }
}
