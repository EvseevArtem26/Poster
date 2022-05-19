// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';
import 'package:image_picker/image_picker.dart';


Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    Post({
        this.id,
        required this.author,
        required this.text,
        required this.publicationTime,
        required this.status,
        required this.platforms,
        this.media
    });

    int? id;
    String author;
    String text;
    DateTime publicationTime;
    String status;
    XFile? media;
    List<String> platforms;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        author: json["author"],
        text: json["text"],
        publicationTime: DateTime.parse(json["publication_time"]),
        status: json["status"],
        platforms: List<String>.from(json["platforms"]),
      );

    Map<String, dynamic> toJson() => {
        "author": author,
        "text": text,
        "publication_time": publicationTime.toIso8601String(),
        "status": status,
        "platforms": List<dynamic>.from(platforms.map((x) => x)),
    };
}

