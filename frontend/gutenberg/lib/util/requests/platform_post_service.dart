import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/platform_post.dart';
class PlatformPostService {
  
  static Future<List<int>> _getImageBytes(XFile file)async{
    //returns bytes of image
    Uint8List data = await file.readAsBytes();
    List<int> imageBytes = data.cast();
    return imageBytes;
  }

  static Future<List<PlatformPost>> getPlatformPosts () async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
     Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platform-posts/',
    );
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<PlatformPost> platformPosts = [];
      for (var i = 0; i < data.length; i++) {
        platformPosts.add(PlatformPost.fromJson(data[i]));
      }
      return platformPosts;
    }
    else {
      throw Exception('Failed to load platform posts');
    }
  }

  static Future<PlatformPost> getPlatformPost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/platform-posts/$id/",
    );
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return PlatformPost.fromJson(body);
    } else {
      throw Exception('Failed to load platform post');
    } 
  }

  static Future<void> savePlatformPost(PlatformPost platformPost) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platform-posts/',
    );

    http.MultipartRequest request = http.MultipartRequest("POST", url,);
    request.headers['Authorization'] = "Token $token";
    request.headers['content-type'] = "multipart/form-data";
    request.headers['accept'] = "application/json";

    request.fields['text'] = platformPost.text!;
    request.fields['publication_time'] = platformPost.publicationTime!.toIso8601String();
    request.fields['status'] = platformPost.status!;
    request.fields['post'] = platformPost.post.toString();
    request.fields['platform'] = platformPost.platform.toString();

    if(platformPost.media != null){
      List<int> bytes = await _getImageBytes(platformPost.media!);
      request.files.add(http.MultipartFile.fromBytes(
        'media',
        bytes,
        filename: platformPost.media!.name,
      ));
    }
    var response = await request.send();
    if(response.statusCode != 201){
      throw Exception('Failed to create platform post\ncode: ${response.statusCode}');
    }
  }

  static Future<void> updatePlatformPost(PlatformPost platformPost) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platform-posts/${platformPost.id}/',
    );

    http.Response response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: jsonEncode(platformPost)
    );
    if(response.statusCode != 200){
      throw Exception('Failed to update platform post\ncode: ${response.statusCode}');
    }
  }

  static Future<void> deletePlatformPost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platform-posts/$id/',
    );

    http.Response response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if(response.statusCode != 204){
      throw Exception('Failed to delete platform post\ncode: ${response.statusCode}');
    }
  }
}