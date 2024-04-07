class User {
  final int? id;
  final String name;
  final int age;
  final double weight; // New field
  final double height; // New field

  User({
    this.id,
    required this.name,
    required this.age,
    required this.weight,
    required this.height,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'weight': weight,
      'height': height,
    };
  }
}
