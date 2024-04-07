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
  late TextEditingController _weightController;
  late TextEditingController _heightController;

  @override
  void initState() {
    super.initState();
    User? user = Provider.of<ActivityProvider>(context, listen: false).getUser();
    _nameController = TextEditingController(text: user?.name ?? '');
    _ageController = TextEditingController(text: user?.age.toString() ?? '');
    _weightController = TextEditingController(text: user?.weight.toString() ?? '');
    _heightController = TextEditingController(text: user?.height.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
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
            SizedBox(height: 10.0),
            TextField(
              controller: _weightController,
              decoration: InputDecoration(labelText: 'Weight'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _heightController,
              decoration: InputDecoration(labelText: 'Height'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String name = _nameController.text;
                int age = int.tryParse(_ageController.text) ?? 0;
                double weight = double.tryParse(_weightController.text) ?? 0.0;
                double height = double.tryParse(_heightController.text) ?? 0.0;
                User updatedUser = User(name: name, age: age, weight: weight, height: height);
                Provider.of<ActivityProvider>(context, listen: false).setUser(updatedUser);
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
