import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';

Future<void> savePost(Post post) async {
  
  final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';

  Uri url = Uri(
    scheme: "http",
    host: "localhost",
    port: 8000,
    path: "/poster/posts/"
  );
  String json = jsonEncode(post.toJson());
  print(json);
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
      print('Post saved');
    }
    else {
      print('Failed to create post\ncode: ${response.statusCode}');
      print(response.body);
    }
}

