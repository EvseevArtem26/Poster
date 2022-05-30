import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';

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