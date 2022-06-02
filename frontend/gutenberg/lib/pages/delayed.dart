import 'package:flutter/material.dart';
import 'package:gutenberg/util/requests/post_service.dart';
import '../components/navbar.dart';
import '../components/post_display.dart';
import '../models/post.dart';

class DelayedPage extends StatefulWidget {
  const DelayedPage({ Key? key }) : super(key: key);

  @override
  State<DelayedPage> createState() => _DelayedPageState();
}

class _DelayedPageState extends State<DelayedPage> {

  late Future<List<Post>> posts;
  late List<Post> filteredPosts;

  @override
  void initState() {
    super.initState();
    posts = PostService.getPosts("delayed");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NavBar(initialIndex: 4),
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