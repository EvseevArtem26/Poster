// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';
import 'platform.dart';
import 'platform_post.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    Post({
        this.id,
        required this.author,
        required this.text,
        required this.publicationTime,
        required this.status,
        this.platforms = const [],
    });

    int? id;
    String author;
    String text;
    DateTime publicationTime;
    String status;
    List<PlatformPost> platforms;


    Post.generic({
      this.id, 
      required this.author, 
      required this.text, 
      required this.publicationTime, 
      required this.status, 
      List<Platform> platforms = const [],
      })
      : platforms = platforms.map((platform) => PlatformPost(
        post: id,
        text: text,
        publicationTime: publicationTime,
        status: status,
        platform: platform.id!,
      )).toList();

    Post.specified({
        this.id,
        required this.author,
        required this.text,
        required this.publicationTime,
        required this.status,
        required this.platforms
    });
      

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"],
        author: json["author"],
        text: json["text"],
        publicationTime: DateTime.parse(json["publication_time"]),
        status: json["status"],
        platforms: List<PlatformPost>.from(json["platforms"].map((x) => PlatformPost.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "author": author,
        "text": text,
        "publication_time": publicationTime.toIso8601String(),
        "status": status,
        "platforms": List<dynamic>.from(platforms.map((x) => x.toJson())),
    };
}

