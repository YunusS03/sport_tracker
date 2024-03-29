// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import '../providers/activityProvider.dart';
//
//
// class ActivityDetailScreen extends StatelessWidget {
//   final String groupKey;
//
//   ActivityDetailScreen({required this.groupKey});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Activity Details'),
//       ),
//       body: FutureBuilder<List<Activity>>(
//         future: _getActivities(context),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final activities = snapshot.data!;
//             return ListView.builder(
//               itemCount: activities.length,
//               itemBuilder: (context, index) {
//                 final activity = activities[index];
//                 return Card(
//                   child: ListTile(
//                     title: Text('Type: ${activity.type}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Date: ${DateFormat.yMMMd().format(activity.date)}'),
//                         Text('Duration: ${activity.duration.inMinutes} minutes'),
//                         Text('Intensity: ${activity.intensity}'),
//                       ],
//                     ),
//                     trailing: IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         _removeActivity(context, activity);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   // Future<List<Activity>> _getActivities(BuildContext context) async {
//   //   final provider = Provider.of<ActivityProvider>(context, listen: false);
//   //   final activities = await provider.getActivitiesByGroupKey(groupKey);
//   //   return activities;
//   // }
//
//   void _removeActivity(BuildContext context, Activity activity) async {
//     final activityProvider = Provider.of<ActivityProvider>(context, listen: false);
//     await activityProvider.removeActivity(activity.id!); // Pass the ID of the activity to be removed
//     Navigator.pop(context); // Navigate back to the previous screen
//   }
//
// }
