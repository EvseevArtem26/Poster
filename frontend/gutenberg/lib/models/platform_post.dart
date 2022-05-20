// To parse this JSON data, do
//
//     final platformPost = platformPostFromJson(jsonString);

import 'dart:convert';
import 'package:image_picker/image_picker.dart';

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
        this.media,
    });

    int? id;
    String? text;
    DateTime? publicationTime;
    String? status;
    int post;
    XFile? media;
    int platform;

    PlatformPost.fromPost(Post post, int platform) : this(
        text: post.text,
        publicationTime: post.publicationTime,
        status: post.status,
        post: post.id!,
        platform: platform,
        media: post.media,
    );

    factory PlatformPost.fromJson(Map<String, dynamic> json) => PlatformPost(
        id: json["id"],
        text: json["text"],
        publicationTime: DateTime.parse(json["publication_time"]),
        status: json["status"],
        post: json["post"],
        platform: json["platform"],
    );

    Map<String, String> toJson() => {
        "id": id.toString(),
        "text": text!,
        "publication_time": publicationTime!.toIso8601String(),
        "status": status!,
        "post": post.toString(),
        "platform": platform.toString(),
    };
}
