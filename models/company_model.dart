class CompanyModel {
  final String id;
  final String name;
  final String description;
  final List<String> positions;

  CompanyModel({
    required this.id,
    required this.name,
    required this.description,
    required this.positions,
  });

  factory CompanyModel.fromMap(Map<String, dynamic> map, String id) {
    return CompanyModel(
      id: id,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      positions: List<String>.from(map['positions'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'positions': positions,
    };
  }
}

