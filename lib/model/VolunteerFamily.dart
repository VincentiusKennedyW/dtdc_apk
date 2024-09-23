import 'package:dtdc/model/Volunteer.dart';

class VolunteerFamily {
  late int id;
  late Volunteer? volunteer; // Refers to a Volunteer object
  late String name;
  late String age;
  late String position;
  late DateTime createdAt;
  late DateTime updatedAt;

  VolunteerFamily({
    required this.id,
    this.volunteer,
    required this.name,
    required this.age,
    required this.position,
    required this.createdAt,
    required this.updatedAt,
  });

  VolunteerFamily.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    volunteer = json['volunteer'] != null
        ? Volunteer.fromJson(json['volunteer'])
        : null; // Refers to Volunteer object
    name = json['name'] ?? '';
    age = json['age'] ?? '';
    position = json['position'] ?? '';
    createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toString());
    updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'volunteer': volunteer?.toJson(), // Convert volunteer object to JSON
      'name': name,
      'age': age,
      'position': position,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
