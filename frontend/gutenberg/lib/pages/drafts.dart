import 'package:flutter/material.dart';
import 'package:gutenberg/util/requests.dart';
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
          future: PostService.getPosts("draft"),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = snapshot.data as List<Post>;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return Draft(
                    text: posts[index].text,
                    time: posts[index].publicationTime,
                  );
                }
              );
            }else{
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