class Activity {
  final int? id;
  final DateTime date;
  final String type;
  final Duration duration;
  final int intensity;
  final int? calories; // Updated calories field to be optional

  Activity({
    this.id,
    required this.date,
    required this.type,
    required this.duration,
    required this.intensity,
    this.calories, // Updated calories parameter to be optional
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'duration': duration.inMinutes,
      'intensity': intensity,
      'calories': calories, // Included calories in map
    };
  }
}
