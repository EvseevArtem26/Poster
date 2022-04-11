// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);
import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
    Post({
        this.pk,
        required this.text,
        required this.publicationTime,
        required this.author,
        required this.platforms,
        required this.status
    });

    int? pk;
    String text;
    DateTime publicationTime;
    String author;
    List<dynamic> platforms;
    String status;

    factory Post.fromJson(Map<String, dynamic> json) => Post(
        pk: json["pk"],
        text: json["text"],
        publicationTime: DateTime.parse(json["publication_time"]),
        author: json["author"],
        platforms: List<dynamic>.from(json["platforms"].map((x) => x)),
        status: json["status"]
    );

    Map<String, String> toJson() => {
        "text": text,
        "publication_time": publicationTime.toIso8601String(),
        "author": author,
        "platforms": List<dynamic>.from(platforms.map((x) => x)).toString(),
        "status": status
    };
}
