class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String qualities;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.qualities,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? '',
      qualities: map['qualities'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'qualities': qualities,
    };
  }
}

