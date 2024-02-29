import 'dart:convert';

class User {
  int? id;
  String username;
  String email;
  String hashedPassword;
  String? preferences;
  DateTime joinDate;

  User({
    this.id,
    required this.username,
    required this.email,
    required this.hashedPassword,
    this.preferences = '',
    required this.joinDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'hashedPassword': hashedPassword,
      'preferences': preferences,
      'joinDate': joinDate
    };
  }

  Map<String, dynamic> toMapDbString() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'hashedPassword': hashedPassword,
      'preferences': preferences,
      'joinDate': joinDate.toIso8601String()
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id']?.toInt() ?? 0,
      username: map['username'],
      email: map['email'],
      hashedPassword: map['hashedPassword'],
      preferences: map['preferences'],
      joinDate: DateTime.parse(map['joinDate'])
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(id: $id, username: $username, email: $email, hashedPassword: $hashedPassword, preferences: $preferences, joinDate: $joinDate)';
  }
}
