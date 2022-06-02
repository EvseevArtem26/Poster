import 'package:flutter/material.dart';
import 'post_list.dart';
import 'post_filter.dart';
import '../models/post.dart';


class PostDisplay extends StatefulWidget {
  PostDisplay({ Key? key, required this.posts}) : super(key: key);
  List<Post> posts;

  @override
  State<PostDisplay> createState() => _PostDisplayState();
}

class _PostDisplayState extends State<PostDisplay> {
  late List<Post> filteredPosts;

  @override
  void initState() {
    super.initState();
    filteredPosts = List<Post>.of(widget.posts);
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.4,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: PostFilter(
                platforms: aggregatePlatforms(widget.posts),
                onPlatformSelected: (List<String> platforms) {
                  setState(() {
                    filteredPosts = filterPosts(widget.posts, platforms);
                  });
                },
              ),
            ),
          ),
          Text("${filteredPosts.length} постов"),
          Expanded(
            child: PostList(
              posts: filteredPosts,
              onChanged: (Post post){
                setState(() {
                  widget.posts.remove(post);
                  filteredPosts = List<Post>.of(widget.posts);
                });
              },
            )
          ),
        ],
      ),
    );
  }
  List<String> aggregatePlatforms(List<Post> posts) {
    final Set<String> platforms = {};
    for (final post in posts) {
      platforms.addAll(post.platforms.toSet());
    }
    return platforms.toList();
  }

  List<Post> filterPosts(List<Post> posts, List<String> platforms) {
    // return posts that have at least one of the selected platforms
    return posts.where((post) {
      return post.platforms.toSet().intersection(platforms.toSet()).isNotEmpty
      || platforms.isEmpty;
    }).toList();
  }
}