// To parse this JSON data, do
//
//     final platformPost = platformPostFromJson(jsonString);

import 'dart:convert';
import 'post.dart';

PlatformPost platformPostFromJson(String str) => PlatformPost.fromJson(json.decode(str));

String platformPostToJson(PlatformPost data) => json.encode(data.toJson());

class PlatformPost {
    PlatformPost({
        this.id,
        this.text,
        this.publicationTime,
        this.status,
        required this.post,
        required this.platform,
    });

    int? id;
    String? text;
    DateTime? publicationTime;
    String? status;
    int? post;
    int platform;

    PlatformPost.fromPost(Post post, int platform) : this(
        text: post.text,
        publicationTime: post.publicationTime,
        status: post.status,
        post: post.id!,
        platform: platform,
    );

    factory PlatformPost.fromJson(Map<String, dynamic> json) => PlatformPost(
        id: json["id"],
        text: json["text"],
        publicationTime: DateTime.parse(json["publication_time"]),
        status: json["status"],
        post: json["post"],
        platform: json["platform"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "publication_time": publicationTime?.toIso8601String(),
        "status": status,
        "post": post,
        "platform": platform,
    };
}
