import 'package:flutter/material.dart';
import 'package:gutenberg/pages/new_post.dart';
import '../models/post.dart';
import '../util/requests/post_service.dart';
import 'player.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function(Post post) onChanged;
  const PostCard({ 
    Key? key, 
    required this.post,
    required this.onChanged 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 300,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Text(
                post.text,
                softWrap: true,
                overflow: TextOverflow.fade,
              ),
            ),
            Builder(
              builder: (context) {
                if(post.media != null){
                  if (post.media!.path.endsWith('jpg')|| post.media!.path.endsWith('png')){
                    return Image.network(
                      post.media!.path,
                    );
                  }
                  else if (post.media!.path.endsWith('mp4')){
                    return Player(
                      videoUrl: post.media!.path,
                    );
                  }
                }
                return const SizedBox(
                  width: double.infinity,
                  height: 0,
                );
              }
            ),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      timeToString(post.publicationTime),
                      style: Theme.of(context).textTheme.bodyText2?.copyWith(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // chips with platforms
                  Expanded(
                    flex: 1,
                    child: Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: post.platforms.map((platform) {
                        return Chip(
                          label: Text(
                            platform,
                            style: Theme.of(context).textTheme.bodyText2?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          backgroundColor: Theme.of(context).colorScheme.surface,
                  
                        );
                      }).toList(),
                    ),
                  ),
                  const Spacer(flex: 1),
                  // edit button
                  post.status != "draft" ? const SizedBox(width: 0) : IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      editPost(context);
                    },
                  ),
                  // delete button
                  IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await deletePost();
                    },
                  ),
                  // publish button
                  post.status == "published" ? const SizedBox(width: 0) : IconButton(
                    icon: const Icon(
                      Icons.publish,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      await publishPost();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void editPost(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NewPostPage(
          draft: post,
        ),
      ),
    );
  }

  Future<void> deletePost() async {
    await PostService.deletePost(post.id!);
    onChanged(post);
  }

  Future<void> publishPost() async {
    await PostService.publishPost(post.id!);
    onChanged(post);
  }

  String timeToString(DateTime? time) {
    if (time == null) {
      return '';
    }
    return "${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}"; 
  }
}