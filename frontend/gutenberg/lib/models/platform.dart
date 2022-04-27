 import 'package:flutter/material.dart';

class Platform {
  int? id;
  late String login;
  late String password;
  late String email;
  late String phoneNumber;
  late String platform;
  late String user;

  Platform(
    {
      this.id,
      required this.login,
      required this.password,
      required this.email,
      required this.phoneNumber,
      required this.platform,
      required this.user
    }
  );

  Platform.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    login = json['login'];
    password = json['password'];
    email = json['email'];
    phoneNumber = json['phone_number'];
    platform = json['platform'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['login'] = login;
    data['password'] = password;
    data['email'] = email;
    data['phone_number'] = phoneNumber;
    data['platform'] = platform;
    data['user'] = user;
    return data;
  }

  String get title {
    const Map<String, String> titles = {
      "VK": "Vkontakte",
      "FB": "Facebook",
      "TT": "TikTok",
      "TW": "Twitter",
      "YT": "Youtube",
      "OK": "Odnoklassniki",
      "TG": "Telegram",
      "IG": "Instagram"
    };
    return titles[platform]!; 
  }

  Color get color {
    const Map<String, Color> platformColors = 
    {
      'FB': Color.fromARGB(255, 59, 89, 152),
      'VK': Color.fromARGB(255, 38, 5, 137),
      'TW': Color.fromARGB(255, 2, 157, 214),
      'IG': Color.fromARGB(247, 224, 221, 14),
      'TT': Color.fromARGB(255, 255, 64, 129),
      'YT': Color.fromARGB(255, 222, 18, 18),
      'TG':  Color.fromARGB(255, 27, 178, 232),
      'OK': Color.fromARGB(255, 237, 118, 0),
    };
    return platformColors[platform]!;
  }
}