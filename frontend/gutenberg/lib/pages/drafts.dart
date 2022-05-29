import 'package:flutter/material.dart';
import 'package:gutenberg/util/requests/post_service.dart';
import 'package:provider/provider.dart';
import '../components/navbar.dart';
import '../components/post_list.dart';
import '../components/post_filter.dart';
import '../models/post.dart';
import '../providers/user_provider.dart';

class DraftsPage extends StatefulWidget {
  const DraftsPage({ Key? key }) : super(key: key);

  @override
  State<DraftsPage> createState() => _DraftsPageState();
}

class _DraftsPageState extends State<DraftsPage> {

  late Future<List<Post>> posts;
  late List<Post> filteredPosts;

  @override
  void initState() {
    super.initState();
    // get token from userProvider
    String username = Provider.of<UserProvider>(context, listen: false).currentUser!;
    String token = Provider.of<UserProvider>(context, listen: false).token!;

    posts = PostService.getPosts(
      username: username,
      token: token,
      status: 'draft',
    );
  }
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

          future: posts,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Post> posts = snapshot.data as List<Post>;
              filteredPosts = List<Post>.of(posts);

              return FractionallySizedBox(
                widthFactor: 0.4,
                child: Column(
                  children: [
                    PostFilter(
                      platforms: aggregatePlatforms(posts),
                      onPlatformSelected: (List<String> platforms) {
                        setState(() {
                          filteredPosts = filterPosts(posts, platforms);
                          posts = filterPosts(posts, platforms);
                        });
                      },
                    ),
                    Text("${posts.length} drafts"),
                    Expanded(
                      child: PostList(posts:posts)
                    ),
                  ],
                ),
              );
            }
            else if (snapshot.hasError) {
              return Text("${snapshot.error}");
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
  
  List<String> aggregatePlatforms(List<Post> posts) {
    final List<String> platforms = [];
    for (final post in posts) {
      for (final platform in post.platforms) {
        if (!platforms.contains(platform)) {
          // platforms.add(platform);
        }
      }
    }
    return platforms;
  }

  List<Post> filterPosts(List<Post> posts, List<String> platforms) {
    // return posts that have at least one of the selected platforms
    return posts.where((post) {
      for (final platform in platforms) {
        if (post.platforms.contains(platform)) {
          return true;
        }
      }
      return false;
    }).toList();
  }
}