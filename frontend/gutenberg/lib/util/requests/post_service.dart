import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/post.dart';

class PostService {
  
  static Future<List<int>> _getImageBytes(XFile file)async{
    //returns bytes of image
    Uint8List data = await file.readAsBytes();
    List<int> imageBytes = data.cast();
    return imageBytes;
  }

  static Future<List<Post>> getPosts(String status) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;
    String username = prefs.getString('username')!;

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/",
      query: "username=$username&status=$status",
    );
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return List<Post>.from(body.map((x) => Post.fromJson(x)));
    } else {
      throw Exception('Failed to load posts');
    }
  }

  static Future<Post> getPost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/$id",
    );
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Post.fromJson(body);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<int?> savePost(Post post) async {
    
    final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/",
    );

    http.MultipartRequest request = http.MultipartRequest("POST", url,);
    request.headers['Authorization'] = "Token $token";
    request.headers['content-type'] = "multipart/form-data";
    request.headers['accept'] = "application/json";

    request.fields['text'] = post.text;
    request.fields['publication_time'] = post.publicationTime.toIso8601String();
    request.fields['author'] = post.author;
    request.fields['status'] = post.status;
    if(post.media != null){
      List<int> bytes = await _getImageBytes(post.media!);
      request.files.add(http.MultipartFile.fromBytes(
        'media',
        bytes,
        filename: post.media!.name,
      ));
    }
    var response = await request.send();
    if(response.statusCode == 201){
      int? id;
      String body = await response.stream.bytesToString();
      Map<String, dynamic> json = jsonDecode(body);
      id = json['id'];
      print('response id: $id');
      return id;
    }
    else {
      String body = await response.stream.bytesToString();
      throw Exception('Failed to create post\ncode: ${response.statusCode}\nresponse: $body');
    }
  }

  static Future<void> updatePost(Post post) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/${post.id}/",
    );
    http.MultipartRequest request = http.MultipartRequest("PUT", url,);
    request.headers['Authorization'] = "Token $token";
    request.headers['content-type'] = "multipart/form-data";
    request.headers['accept'] = "application/json";

    request.fields['text'] = post.text;
    request.fields['publication_time'] = post.publicationTime.toIso8601String();
    request.fields['author'] = post.author;
    request.fields['status'] = post.status;
    if(post.media != null){
      List<int> bytes = await _getImageBytes(post.media!);
      request.files.add(http.MultipartFile.fromBytes(
        'media',
        bytes,
        filename: post.media!.name,
      ));
    }
    var response = await request.send();
    if(response.statusCode != 200){
      String body = await response.stream.bytesToString();
      throw Exception('Failed to update post\ncode: ${response.statusCode}\nresponse: $body');
    }
  }

  static Future<void> deletePost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/$id/",
    );
    var response = await http.delete(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );
    if(response.statusCode != 204){
        throw Exception('Failed to delete post\ncode: ${response.statusCode}');
    }
  }

  static Future<void> publishPost(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/$id/",
    );
    var response = await http.patch(
      url,
      body: jsonEncode({'status': 'published'}),
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Token $token",
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to publish post\ncode: ${response.statusCode}');
    }
  }
}