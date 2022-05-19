import 'package:flutter/material.dart';
import '../models/post.dart';
import 'draft.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  const PostList({ Key? key, required this.posts }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return Draft(
          text: posts[index].text,
          time: posts[index].publicationTime,
          platforms: posts[index].platforms,
        );
      },
      separatorBuilder: (context, index)=>const SizedBox(height: 20)
    );
  }
}