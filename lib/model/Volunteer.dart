import 'package:dtdc/model/User.dart';
import 'package:dtdc/model/VolunteerFamily.dart';

class Volunteer {
  late int id;
  late User? user; // Refers to a User object
  late List<VolunteerFamily>
      volunteerFamily; // Refers to a VolunteerFamily object
  late String dptCount;
  late String phoneNumber;
  late String rt;
  late String houseNumber;
  late String photo;
  late double latitude;
  late double longitude;
  late String address;
  late String status;
  late String answer1;
  late String answer2;
  late String answer3;
  late DateTime createdAt;
  late DateTime updatedAt;

  Volunteer({
    required this.id,
    this.user,
    required this.volunteerFamily,
    required this.dptCount,
    required this.phoneNumber,
    required this.rt,
    required this.houseNumber,
    required this.photo,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.status,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.createdAt,
    required this.updatedAt,
  });

  Volunteer.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    user = json['user'] != null
        ? User.fromJson(json['user'])
        : null; // Refers to related User object
    volunteerFamily = json['families'] != null
        ? (json['families'] as List)
            .map((e) => VolunteerFamily.fromJson(e))
            .toList()
        : []; // Refers to related VolunteerFamily object

    phoneNumber = json['phone_number'] ?? '';
    rt = json['rt'] ?? '';
    houseNumber = json['house_number'] ?? '';
    photo = json['photo'] ?? '';
    latitude = double.parse(json['latitude']);
    longitude = double.parse(json['longitude']);
    dptCount = json['dpt_count'] ?? '';
    address = json['address'] ?? '';
    status = json['status'] ?? '';
    answer1 = json['answer1'] ?? '';
    answer2 = json['answer2'] ?? '';
    answer3 = json['answer3'] ?? '';
    createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toString());
    updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'volunteer_family': volunteerFamily.map((e) => e.toJson()).toList(),
      'phone_number': phoneNumber,
      'rt': rt,
      'house_number': houseNumber,
      'photo': photo,
      'latitude': latitude,
      'longitude': longitude,
      'dpt_count': dptCount,
      'address': address,
      'status': status,
      'created_at': createdAt.toString(),
      'updated_at': updatedAt.toString(),
    };
  }
}
