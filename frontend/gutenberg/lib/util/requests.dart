import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/post.dart';

Future<http.Response> savePost(Post post) async {
  
  var request = post.toJson();

  Uri url = Uri(
    scheme: "http",
    host: "localhost",
    port: 8000,
    path: "/poster/posts/"
  );
  Map body = {
    "title":"Testing post saving",
    "text":"Hello, django",
    "publication_time": DateTime.now().toIso8601String(),
    "author":"1"
  };
  var response = await http.post(
    url, 
    body: jsonEncode(body),
    headers: {
      'Accept': 'application/json',
      "Content-Type":"application/json; charset=UTF-8"
    }
  );
  
  return response;
}

void testSavePost()async{
  Post testPost = Post(
    title: "Testing post saving",
    text: "Hello, django",
    publicationTime: DateTime.now(),
    author: 1,
    platforms: [1]
  );
  http.Response response = await savePost(testPost);
  print(response.body);
}


Future<http.Response> getPosts()async{
  Uri url = Uri(
    scheme: "http",
    host: "localhost",
    port: 8000,
    path: "/poster/posts/"
  );
  http.Response response = await http.get(url);
  return response;
}

void testGetPosts()async{
  http.Response data = await getPosts();
  print(data.body);
}

Future<http.Response> savePlatform()async{
  Uri url = Uri(
    scheme: "http",
    host: "localhost",
    port: 8000,
    path: "/poster/platforms/"
  );
  Map<String, String> body = {
    "login":"test",
    "password":"test",
    "email":"test@mail.ru",
    "phone_number":"111111111",
    "platform":"TW",
    "user":"1"
  };
  http.Response response = await http.post(
    url,
    body: body
  );
  return response;
}

void testSavePlatform()async{
  http.Response response = await savePlatform();
  print(response.body);
}