import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gutenberg/components/platform_picker.dart';
import 'package:gutenberg/models/platform_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  '../models/post.dart';
import '../models/platform.dart';
import '../models/platform_post.dart';
import '../util/requests.dart';
import 'platform_picker.dart';


class PostForm extends StatefulWidget {
  const PostForm({ Key? key }) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  late String text;
  late DateTime publicationTime;
  late String author;
  List<Platform> selectedPlatforms = [];
  late String status = 'draft';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        // decoration: BoxDecoration(
        //   color: Colors.blue[400],
        //   borderRadius: BorderRadius.circular(10),
        // ),
        width: 900,
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
    
              Container(
                width: 900,
                height: 400,
                decoration: const BoxDecoration(
                  // color: Colors.grey[200],

                ),
                child: TextField(
                  expands: true,
                  maxLines: null,
                  onChanged: (String value){
                  setState((){
                    text = value;
                  });
                },
                ),
              ),
              // добавить в черновик
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      //TODO: блокировка кнопки после нажатия
                      onPressed: ()async{
                        status='draft';
                        Post post = await makePost(selectedPlatforms);
                        await PostService.savePost(post);
                        // // print(post.id);
                        // List<PlatformPost> platformPosts = buildPlatformPosts(post, selectedPlatforms);
                        // for(PlatformPost platformPost in platformPosts){
                        //   platformPost.post=post.id!;
                        //   PlatformPostService.savePlatformPost(platformPost);
                        // }
                      },
                      child: const Text("Добавить в черновик")
                    ),
                    const ElevatedButton(
                      onPressed: null,
                      child: Text("Опубликовать"),
                    ),
                    
                  ],
                ),
              ),
              // время публикации
              SizedBox(
                height: 100,
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Flexible(
                      flex: 2,
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTime,
                        initialValue: DateTime.now().toString(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Date',
                        timeLabelText: "Hour",
                        onChanged: (String value){
                          setState(() {
                            publicationTime = DateTime.parse(value);
                          });
                        },
                        validator: (val) {
                          return null;
                        },
                        onSaved: (String? value){
                          setState(() {
                            publicationTime = DateTime.parse(value!);
                          });
                        },
                      ),
                    ),
                    const Spacer(),
                    Flexible(
                      flex: 2,
                      child: PlatformPicker(
                        onPlatformSelected: (List<Platform> platforms){
                          setState(() {
                            selectedPlatforms = platforms;
                          });
                        },
                      )
                    ),
                    const Spacer()
                  ],
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
  Future<Post> buildPost()async{
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    return Post(   
      text: text,
      publicationTime: publicationTime,
      author: username,
      platforms: [],
      status: status,
    );
  }

  List<PlatformPost> buildPlatformPosts(Post basePost, List<Platform> platforms){
    List<PlatformPost> platformPosts = [];
    for(Platform platform in platforms){
      platformPosts.add(PlatformPost.fromPost(
        basePost,
        platform.id!,
      ));
    }
    return platformPosts;
  }
  Future<Post> makePost(List<Platform> platforms)async{
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    return Post.generic(
      text: text,
      publicationTime: publicationTime,
      author: username,
      status: status,
      platforms: platforms,
    );

  }
}