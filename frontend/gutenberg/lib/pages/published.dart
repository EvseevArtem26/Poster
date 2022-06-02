import 'package:flutter/material.dart';
import 'package:gutenberg/util/requests/post_service.dart';
import '../components/navbar.dart';
import '../components/post_display.dart';
import '../models/post.dart';

class PublishedPage extends StatefulWidget {
  const PublishedPage({ Key? key }) : super(key: key);

  @override
  State<PublishedPage> createState() => _PublishedPageState();
}

class _PublishedPageState extends State<PublishedPage> {

  late Future<List<Post>> posts;
  late List<Post> filteredPosts;

  @override
  void initState() {
    super.initState();
    posts = PostService.getPosts("published");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(initialIndex: 3),
      ),
      body: Container(
        alignment: Alignment.center,
        child: FutureBuilder(

          future: posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> allPosts = snapshot.data as List<Post>;
              return PostDisplay(
                posts: allPosts,
              );
            }
            else if (snapshot.hasError){
              return Center(child: Text("${snapshot.error}"));
            }
            else{
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            }
          }
        )
      )
    );
  }
}