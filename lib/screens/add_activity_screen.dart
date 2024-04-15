import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/activity.dart';
import '../models/user.dart';
import '../providers/activityProvider.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final TextEditingController _hoursController = TextEditingController();
  final TextEditingController _minutesController = TextEditingController();
  int _selectedIntensity = 1; // Standaardintensiteit

  DateTime _selectedDate = DateTime.now();
  String _selectedActivityType = 'Running'; // Standaardactiviteitstype

  // Lijst met vooraf gedefinieerde activiteitstypes
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
    _hoursController.text = '0'; // Standaardwaarde voor uren
    _minutesController.text = '0'; // Standaardwaarde voor minuten
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Activity'), // Titel van de app-balk
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _selectDateTime, // Functie om datum en tijd te selecteren
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined), // Modern pictogram voor datumkiezer
                  const SizedBox(width: 10),
                  Text(
                    ' ${DateFormat.yMMMd().format(_selectedDate)} ${DateFormat.Hm().format(_selectedDate)}', // Weergave van geselecteerde datum en tijd
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildActivityTypeDropdown(), // Bouw het dropdown-menu voor activiteitstype
            const SizedBox(height: 20),
            const Text(
              'Duration:', // Duurtekstlabel
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildDurationButton('+15 min', 15), // Knoppen voor het toevoegen van tijdsduur
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
                    decoration: const InputDecoration(labelText: 'Hours'), // Tekstveld voor uren
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: _minutesController,
                    decoration: const InputDecoration(labelText: 'Minutes'), // Tekstveld voor minuten
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Intensity:', // Tekstlabel voor intensiteit
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
                      _selectedIntensity = index + 1; // Update de geselecteerde intensiteit
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
                        '${index + 1}', // Toon het intensiteitsniveau
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
              onPressed: _saveActivity, // Functie om de activiteit op te slaan
              child: const Text('Save'), // Tekst op de knop
            ),
          ],
        ),
      ),
    );
  }

  // Functie om de datum en tijd te selecteren
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
              primary: Colors.blue, // Hoofdkleur van de app
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Tekstkleur van de knop
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
          _selectedDate = selectedDateTime; // Update de geselecteerde datum en tijd
        });
      }
    }
  }

  // Functie om het dropdown-menu voor activiteitstype te bouwen
  Widget _buildActivityTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedActivityType,
      onChanged: (value) {
        setState(() {
          _selectedActivityType = value!; // Update het geselecteerde activiteitstype
        });
      },
      items: activityTypes.map((type) {
        return DropdownMenuItem<String>(
          value: type,
          child: Row(
            children: [
              _getActivityIcon(type), // Pictogram voor het activiteitstype
              const SizedBox(width: 10),
              Text(type), // Naam van het activiteitstype
            ],
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Activity Type', // Label voor het dropdown-menu
        border: OutlineInputBorder(), // Randstijl voor het dropdown-menu
      ),
    );
  }

  // Functie om de activiteit op te slaan
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
            title: const Text('Error'), // Foutmeldingstitel
            content: const Text('Duration cannot be 0. Please enter a valid duration.'), // Foutmeldingstekst
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'), // Tekst op de knop
              ),
            ],
          );
        },
      );
      return;
    }

    // Bereken verbrande calorieën
    double calories = calculateCalories(Activity(
        date: _selectedDate, // Geef de geselecteerde datum door
        type: _selectedActivityType,
        duration: Duration(minutes: totalMinutes),
        intensity: _selectedIntensity,
        calories: 0
    ));

    // Voeg de activiteit toe aan de provider
    activityProvider.addActivity(Activity(
      date: _selectedDate, // Geef de geselecteerde datum door
      type: _selectedActivityType,
      duration: Duration(minutes: totalMinutes),
      intensity: _selectedIntensity,
      calories: calories.toInt(), // Geef de berekende calorieën door
    ));

    Navigator.pop(context); // Ga terug naar het startscherm
  }

  // Functie om calorieën te berekenen op basis van activiteit
  double calculateCalories(Activity activity) {
    // Haal het gebruikersobject op uit de ActivityProvider
    User? user = Provider.of<ActivityProvider>(context, listen: false).getUser();

    // Constanten
    double weightKg = user?.weight ?? 70; // Gebruik het gewicht van de gebruiker of een standaardwaarde

    const double caloriesPerKgPerHour = 1.05; // Voorbeeldwaarde voor verbrande calorieën per kg per uur

    // MET-waarden voor verschillende activiteitstypes
    final Map<String, double> metValues = {
      'Running': 8.0,
      'Cycling': 7.0,
      'Swimming': 7.0,
      'Walking': 3.5,
      'Hiking': 6.0,
      'Yoga': 2.5,
      'Weightlifting': 3.0,
      'Pilates': 3.0,
      'Dancing': 5.0,
      'Basketball': 6.0,
      'Soccer': 7.0,
      'Tennis': 7.0,
      'Golf': 4.5,
      'Surfing': 3.5,
      'Snowboarding': 5.5,
      'Skateboarding': 4.0,
      'Rock Climbing': 8.0,
      'Other': 3.0, // Standaard MET-waarde voor onbekende activiteiten
    };

    // Haal de MET-waarde op voor het activiteitstype
    double baseMet = metValues[activity.type] ?? 3.0; // Standaard naar 3.0 als er geen overeenkomende MET-waarde is gevonden

    // Pas de intensiteitsvermenigvuldiger toe
    double intensityMultiplier = 1.0;
    switch (activity.intensity) {
      case 1:
        intensityMultiplier = 0.8; // Licht intensiteitsniveau
        break;
      case 2:
        intensityMultiplier = 1.0; // Gemiddeld intensiteitsniveau
        break;
      case 3:
        intensityMultiplier = 1.2; // Krachtig intensiteitsniveau
        break;
      case 4:
        intensityMultiplier = 1.5; // Zeer krachtig intensiteitsniveau
        break;
      case 5:
        intensityMultiplier = 1.8; // Uiterst krachtig intensiteitsniveau
        break;
      default:
        intensityMultiplier = 1.0; // Standaard naar gemiddeld intensiteitsniveau
        break;
    }

    // Bereken de duur in uren
    double durationHours = activity.duration.inMinutes / 60.0;

    // Bereken verbrande calorieën
    double calories = (caloriesPerKgPerHour * weightKg * baseMet * intensityMultiplier * durationHours).roundToDouble();

    return calories;
  }

  // Functie om een knop voor de tijdsduur te bouwen
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
      child: Text(label), // Tekst op de knop
    );
  }

  // Functie om het pictogram voor de activiteit op te halen op basis van het activiteitstype
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
        return const Icon(Icons.help, color: Colors.grey); // Standaardpictogram voor onbekende activiteiten
    }
  }
}
