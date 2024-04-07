import 'package:flutter/material.dart';
import 'package:fitness_tracker/providers/activityProvider.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class UserInformationScreen extends StatefulWidget {
  @override
  _UserInformationScreenState createState() => _UserInformationScreenState();
}

class _UserInformationScreenState extends State<UserInformationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with user information
    User? user = Provider.of<ActivityProvider>(context, listen: false).getUser();
    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(text: user?.age.toString() ?? '');
  }

  @override
  void dispose() {
    // Dispose text controllers
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Information'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _ageController,
              decoration: InputDecoration(labelText: 'Age'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Save updated user information
                String name = _nameController.text;
                int age = int.tryParse(_ageController.text) ?? 0;
                User updatedUser = User(name: name, age: age);
                Provider.of<ActivityProvider>(context, listen: false).setUser(updatedUser);

                // Print message to console
                print('User information saved: $updatedUser');

                // Return to the previous page
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),

          ],
        ),
      ),
    );
  }
}
