import 'dart:convert';
class User {
  User({
    this.id,
    this.userName,
    this.role,
  });

  final int id;
  final String userName;
  final int role;

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    userName: json["user_name"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_name": userName,
    "role": role,
  };
}
