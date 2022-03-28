// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);
import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    Post({
        this.pk,
        required this.title,
        required this.text,
        required this.publicationTime,
        required this.author,
        required this.platforms,
    });

    int? pk;
    String title;
    String text;
    DateTime publicationTime;
    int author;
    List<dynamic> platforms;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        pk: json["pk"],
        title:json["title"],
        text: json["text"],
        publicationTime: DateTime.parse(json["publication_time"]),
        author: json["author"],
        platforms: List<dynamic>.from(json["platforms"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "title": title,
        "text": text,
        "publication_time": publicationTime.toIso8601String(),
        "author": author.toString(),
        "platforms": List<dynamic>.from(platforms.map((x) => x)).toString(),
    };
}
