// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
    User({
        this.pk,
        required this.username,
        required this.email,
    });

    int? pk;
    String username;
    String email;

    factory User.fromJson(Map<String, dynamic> json) => User(
        pk: json["pk"],
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "username": username,
        "email": email,
    };
}
