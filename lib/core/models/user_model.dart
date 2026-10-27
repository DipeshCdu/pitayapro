class UserModel {
  final String userId;
  final String email;
  final List<String> roles;

  UserModel({required this.userId, required this.email, required this.roles});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      email: json['email'],
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}