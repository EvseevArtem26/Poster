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
  PostForm({ Key? key, this.draft }) : super(key: key);
  Post? draft;

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  String text = '';
  DateTime publicationTime = DateTime.now();
  List<Platform> selectedPlatforms = [];
  XFile? image;

  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    if (widget.draft != null) {
      text = widget.draft!.text;
      _textController = TextEditingController(text: widget.draft!.text);
      publicationTime = widget.draft!.publicationTime;
      image = widget.draft!.media;
      setState((){});
    }
    else {
      _textController = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 900,
        child: Form(
          //TODO: очищать поля при отправке
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
                  controller: _textController,
                  // onChanged: (String value){
                  // setState((){
                  //   text = value;
                  // });
                // },
                ),
              ),
              Row(
                children: [
                  MyFilePicker(
                    onFileSelected: (XFile? file){
                      setState((){
                        image = file;
                      });
                    },
                    image: image,
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
                        bool edit = widget.draft != null;
                        await sendPost(editMode: edit, draft: true);
                      },
                      child: const Text("Добавить в черновик")
                    ),
                    ElevatedButton(
                      onPressed: ()async{
                        bool edit = widget.draft != null;
                        await sendPost(editMode: edit, draft: false);
                      },
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
                        initialValue: publicationTime.isBefore( DateTime.now() ) ? DateTime.now().toString() : publicationTime.toString(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                        icon: const Icon(Icons.event),
                        dateLabelText: 'Дата',
                        timeLabelText: "Время",
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
  Future<Post> buildPost({required String status})async{
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    return Post(   
      text: _textController.text,
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
  Future<void> sendPost ({bool editMode=false, bool draft=true})async{
    // TODO: написать функцию-обертку для обработки исключений
    if(editMode){
      if (draft){
        Post post = await buildPost(status: 'draft');
        post.id = widget.draft!.id!;
        await PostService.updatePost(post);
      }
      else {
        await PostService.deletePost(widget.draft!.id!);
        String status = publicationTime.subtract(Duration(minutes: 5)).isBefore(DateTime.now()) ? 'waiting' : 'delayed';
        Post post = await buildPost(status: status);
        int? id = await PostService.savePost(post);
        post.id = id!;
    
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
    else {
      // if post is completely new:
      String status = 'draft';
      if (!draft){
        status = publicationTime.subtract(Duration(minutes: 5)).isBefore(DateTime.now()) ? 'waiting' : 'delayed';
      }
      Post post = await buildPost(status: status);
      int? id = await PostService.savePost(post);
      post.id = id!;
    
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
}
