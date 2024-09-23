class Tps {
  late int id;
  late String name;
  late DateTime createdAt;
  late DateTime updatedAt;

  Tps({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  Tps.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? '';
    createdAt = DateTime.parse(json['created_at'] ?? DateTime.now().toString());
    updatedAt = DateTime.parse(json['updated_at'] ?? DateTime.now().toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
