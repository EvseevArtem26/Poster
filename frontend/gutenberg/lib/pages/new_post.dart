import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../components/post_form.dart';
import '../models/post.dart';


class NewPostPage extends StatefulWidget {
  NewPostPage({Key? key, this.draft}) : super(key: key);

  Post? draft;

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: const PreferredSize(
        child: NavBar(initialIndex: 1,),
        preferredSize: Size.fromHeight(60),
      ),
      body: Center(
        child: PostForm(draft: widget.draft),
      ),
    );
  }
}
