import 'package:flutter/material.dart';
import '../models/post.dart';
import 'post_card.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  final Function(Post post) onChanged;
  const PostList({ Key? key, required this.posts, required this.onChanged }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      padding: const EdgeInsets.all(20),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return PostCard(
          post: posts[index],
          onChanged: (Post post){
            onChanged(post);
          },
        );
      },
      separatorBuilder: (context, index)=>const SizedBox(height: 20)
    );
  }
}