import 'package:dtdc/model/TpsReport.dart';

class TpsAttachment {
  late int id;
  late TpsReport tpsReport; // Refers to a TpsReport object
  late String type;
  late String file;
  late DateTime createdAt;
  late DateTime updatedAt;

  TpsAttachment({
    required this.id,
    required this.tpsReport,
    required this.type,
    required this.file,
    required this.createdAt,
    required this.updatedAt,
  });

  TpsAttachment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    tpsReport = TpsReport.fromJson(
        json['tps_report'] ?? {}); // Refers to TpsReport object
    type = json['type'] ?? '';
    file = json['file'] ?? '';
    createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toString());
    updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tps_report': tpsReport.toJson(), // Convert TpsReport object to JSON
      'type': type,
      'file': file,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
