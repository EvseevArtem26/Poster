import 'package:flutter/material.dart';
import '../components/navbar.dart';
import '../components/post_form.dart';


class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  State<NewPostPage> createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {

  late String text;
  late DateTime publicationTime;
  late String author;
  late List platforms = [];
  late String status = 'draft';

  @override
  Widget build(BuildContext context) {
  
    return const Scaffold(
      appBar: PreferredSize(
        child: NavBar(),
        preferredSize: Size.fromHeight(60),
      ),
      body: Center(
        child: PostForm(),
      ),
    );
  }
}
