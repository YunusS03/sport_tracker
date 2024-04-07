class Activity {
  final int? id;
  final DateTime date;
  final String type;
  final Duration duration;
  final int intensity;
  final int calories; // Added calories field

  Activity({
    this.id,
    required this.date,
    required this.type,
    required this.duration,
    required this.intensity,
    required this.calories, // Added calories parameter
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
