import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gutenberg/components/platform_picker.dart';
import 'package:gutenberg/models/platform_post.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  '../models/post.dart';
import '../models/platform.dart';
import '../models/platform_post.dart';
import '../util/requests/post_service.dart';
import '../util/requests/platform_post_service.dart';
import 'platform_picker.dart';
import 'file_picker.dart';


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
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 900,
        child: Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 900,
                height: 400,
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
              Row(
                children: [
                  FilePicker(
                    onFileSelected: (XFile? file){
                      setState((){
                        image = file;
                      });
                    },
                  ),
                ],
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
                        await sendPost();
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
      media: image,
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
  Future<void> sendPost ()async{
    // TODO: написать функцию-обертку для обработки исключений
    status='draft';
    Post post = await buildPost();
    int? id = await PostService.savePost(post);
    print("save post returned: $id");
    post.id = id!;
    print("saved post id: ${post.id}");
  
    List<PlatformPost> platformPosts = buildPlatformPosts(post, selectedPlatforms);
    for(PlatformPost platformPost in platformPosts){
      try {
        await PlatformPostService.savePlatformPost(platformPost);
      } catch (e) {
        print(e);
      }
    }
  }
}
