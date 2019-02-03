import 'dart:convert';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromJson(jsonData);
}

String userToJson(User data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

class User {
  String username;
  String token;

  User({
    this.username,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => new User(
    username: json["Username"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "Username": username,
    "token": token,
  };
}
