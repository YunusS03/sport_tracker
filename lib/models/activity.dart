
class Activity {
  final int? id;
  final DateTime date;
  final String type;
  final Duration duration;
  final int intensity;

  Activity({
    this.id,
    required this.date,
    required this.type,
    required this.duration,
    required this.intensity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'type': type,
      'duration': duration.inMinutes,
      'intensity': intensity,
    };
  }
}
