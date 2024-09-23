import 'package:dtdc/model/Tps,.dart';
import 'package:dtdc/model/User.dart';

class TpsReport {
  late int id;
  late String type;
  late Tps tps; // Refers to a Tps object
  late User user; // Refers to a User object
  late int? candidate1Count;
  late int? candidate2Count;
  late int? candidate3Count;
  late DateTime createdAt;
  late DateTime updatedAt;

  TpsReport({
    required this.id,
    required this.type,
    required this.tps,
    required this.user,
    this.candidate1Count,
    this.candidate2Count,
    this.candidate3Count,
    required this.createdAt,
    required this.updatedAt,
  });

  TpsReport.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    type = json['type'] ?? '';
    tps = Tps.fromJson(json['tps'] ?? {}); // Refers to Tps object
    user = User.fromJson(json['user'] ?? {}); // Refers to User object
    candidate1Count = json['candidate1_count'];
    candidate2Count = json['candidate2_count'];
    candidate3Count = json['candidate3_count'];
    createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toString());
    updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'tps': tps.toJson(), // Convert Tps object to JSON
      'user': user.toJson(), // Convert User object to JSON
      'candidate1_count': candidate1Count,
      'candidate2_count': candidate2Count,
      'candidate3_count': candidate3Count,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
