import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import '../models/activity.dart';
import 'activity_chart_screen.dart';

// GedetailleerdActiviteitenscherm widget, toont alle activiteiten van een bepaald type
class DetailedActivityScreen extends StatefulWidget {
  final String activityType;

  const DetailedActivityScreen({super.key, required this.activityType});

  @override
  _DetailedActivityScreenState createState() => _DetailedActivityScreenState();
}

// _DetailedActivityScreenState vertegenwoordigt de status van de DetailedActivityScreen widget
class _DetailedActivityScreenState extends State<DetailedActivityScreen> {
  bool _ascendingOrder = true; // Standaard sorteerorde is oplopend

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.activityType} Activiteiten'),
        actions: [
          _buildOrderByDropdown(),
        ],
      ),
      body: Consumer<ActivityProvider>(
        builder: (context, activityProvider, _) {
          return _buildActivityList(context, activityProvider);
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  // Bouw de lijst van activiteiten op
  Widget _buildActivityList(BuildContext context, ActivityProvider activityProvider) {
    List<Activity> activities = activityProvider.getActivitiesByType(widget.activityType);

    if (activities.isEmpty) {
      return Center(
        child: Text('Geen ${widget.activityType} activiteiten beschikbaar'),
      );
    }

    // Sorteer activiteiten op basis van de geselecteerde volgorde
    activities.sort((a, b) => _ascendingOrder ? a.date.compareTo(b.date) : b.date.compareTo(a.date));

    return ListView.builder(
      itemCount: activities.length,
      itemBuilder: (context, index) {
        Activity activity = activities[index];
        return _buildActivityCard(context, activity, activityProvider);
      },
    );
  }

  // Bouw de kaart voor elke activiteit op
  Widget _buildActivityCard(BuildContext context, Activity activity, ActivityProvider activityProvider) {
    String formattedDateTime = DateFormat.yMMMMd().add_Hm().format(activity.date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(
            formattedDateTime,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.timer, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 4),
                  Text('Duur: ${activity.duration.inMinutes} minuten'),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.fireplace, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text('Verbrande calorieën: ${activity.calories} kcal', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Weet je zeker dat je deze activiteit wilt verwijderen?',
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Sluit het bottom sheet
                                  },
                                  child: Text('Annuleren'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    // Verwijder de activiteit
                                    activityProvider.removeActivity(activity.id!);
                                    Navigator.of(context).pop(); // Sluit het bottom sheet
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: Text('Verwijderen'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }

  // Bouw de onderste navigatiebalk op
  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.show_chart),
          label: 'Grafieken',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Plannen',
        ),
      ],
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        if (index == 0) {
          Navigator.pop(context);
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ActivityChartScreen()),
          );
        }
      },
    );
  }

  // Bouw de dropdown voor het sorteren op
  Widget _buildOrderByDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: DropdownButton<String>(
        value: _ascendingOrder ? 'Oplopend' : 'Aflopend',
        icon: const Icon(Icons.sort),
        onChanged: (String? newValue) {
          setState(() {
            _ascendingOrder = newValue == 'Oplopend';
          });
        },
        items: <String>['Oplopend', 'Aflopend'].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
