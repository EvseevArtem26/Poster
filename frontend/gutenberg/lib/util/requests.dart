import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/platform.dart';
import '../models/platform_post.dart';
import '../models/post.dart';
import '../models/user.dart';


class PostService {

  static Future<List<Post>> getPosts(String status) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String? username = prefs.getString('username');

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/experimental",
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

  static Future<void> savePost(Post post) async {
    
    final prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/experimental/",
    );
    String json = jsonEncode(post.toJson());
    var response = await http.post(
      url, 
      body: json,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Token $token"
      }
    );
    if(response.statusCode == 201){
      post.id = jsonDecode(response.body)['id'];
    }
    else {
      throw Exception('Failed to create post\ncode: ${response.statusCode}');
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
    String json = jsonEncode(post.toJson());
    var response = await http.put(
      url, 
      body: json,
      headers: {
        "content-type": "application/json",
        "accept": "application/json",
        "Authorization": "Token $token"
      }
    );
    if(response.statusCode != 200){
        throw Exception('Failed to update post\ncode: ${response.statusCode}');
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
}

class PlatformService {
  static Future<List<Platform>> getPlatforms () async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    String token = prefs.getString('token') ?? '';
     Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/',
      query: 'username=$username',
    );
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Platform> platforms = [];
      for (var i = 0; i < data.length; i++) {
        platforms.add(Platform.fromJson(data[i]));
      }
      return platforms;
    }
    else {
      throw Exception('Failed to load platforms');
    }
  }

  static Future<Platform> getPlatform(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/platforms/$id/",
    );
    http.Response response = await http.get(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);
      return Platform.fromJson(body);
    } else {
      throw Exception('Failed to load platform');
    } 
  }

  static Future<void> savePlatform(Platform platform) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/',
    );

    http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: jsonEncode(platform)
    );
    if(response.statusCode != 201){
      throw Exception('Failed to create account\ncode: ${response.statusCode}');
    }
  }

  static Future<void> updatePlatform(Platform platform) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/${platform.id}/',
    );

    http.Response response = await http.put(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: jsonEncode(platform)
    );
    if(response.statusCode != 200){
      throw Exception('Failed to update account\ncode: ${response.statusCode}');
    }
  }

  static Future<void> deletePlatform(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/$id/',
    );

    http.Response response = await http.delete(
      url,
      headers: {
        'Authorization': 'Token $token',
      },
    );
    if(response.statusCode != 204){
      throw Exception('Failed to delete platform\ncode: ${response.statusCode}');
    }
  }
}

class PlatformPostService {

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

    http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
        "Authorization": "Token $token",
      },
      body: jsonEncode(platformPost)
    );
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

class UserService {

  static Future<User> getUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/users/$id/",
    );
    return http.get(
      url,
      headers: {
        "Authorization": "Token $token",
      },
    ).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> body = jsonDecode(response.body);
        return User.fromJson(body);
      } else {
        throw Exception('Failed to load user');
      } 
    });
  }

  static Future<bool>login(String login, String password)async{
    // authorizes user and saves token to shared preferences
    // returns true if login was successful, false otherwise
    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "auth/token/login"
    );

    http.Response response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "username": login,
        "password": password
      })
    );
    if(response.statusCode == 200){
      Map body = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", body["auth_token"]);
      prefs.setString("username", login);
      return true;
    }
    else{
      return false;
    }
  }

  static Future<bool> signUp(String username, String password, String email) async {
    // registers user
    // returns true if registration was successful, false otherwise
    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "auth/users/"
    );
    http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": username,
        "email": email,
        "password": password
      })
    );
    return response.statusCode == 201;
  }
}