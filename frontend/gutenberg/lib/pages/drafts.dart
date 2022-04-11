import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../components/navbar.dart';
import '../components/draft.dart';
import '../models/post.dart';

class DraftsPage extends StatefulWidget {
  const DraftsPage({ Key? key }) : super(key: key);

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(
          future: getPosts(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = snapshot.data as List<Post>;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Draft(
                    text: posts[index].text,
                  );
                }
              );
            }else{
              return Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              );
            }
          }
        )
      )
    );
  }

  Future<List<Post>> getPosts() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    String? username = prefs.getString('username');

    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "/poster/posts/",
      query: "username=$username&status=draft",
    );
    print(url);
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      print(body);
      return List<Post>.from(body.map((x) => Post.fromJson(x)));
    } else {
      throw Exception('Failed to load posts');
    }
  }
}