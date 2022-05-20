import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/platform.dart';

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