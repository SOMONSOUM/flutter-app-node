import "dart:convert";

class User {
  final int id;
  final String name;
  final String email;
  final int phoneNumber;
  final String password;
  final String confirmPassword;
  final String role;
  final bool isAdmin;
  final bool isActive;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.role,
    required this.isAdmin,
    required this.isActive,
    required this.token,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "password": password,
        "confirmPassword": confirmPassword,
        "role": role,
        "isAdmin": isAdmin,
        "isActive": isActive,
        "token": token
      };

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? 0,
      password: map['password'] ?? '',
      confirmPassword: map['confirmPassword'] ?? '',
      role: map['role'] ?? '',
      isAdmin: map['isAdmin'] ?? false,
      isActive: map['isActive'] ?? false,
      token: map['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
