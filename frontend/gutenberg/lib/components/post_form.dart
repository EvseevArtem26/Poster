import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:gutenberg/components/file_display.dart';
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
        side: BorderSide(
          width: 2.0,
          color: Theme.of(context).colorScheme.primary
        )
      ),
      child: SizedBox(
        width: 900,
        child: Form(
          //TODO: очищать поля при отправке
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 2.0,
                      color: Theme.of(context).colorScheme.primary
                    )
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: 900,
                      height: 250,
                      child: TextField(
                        expands: true,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        controller: _textController,
                        showCursor: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        )
                      ),
                    ),
                    SizedBox(
                      width: 900,
                      child: FileDisplay(
                        key: ValueKey(image),
                        file: image,
                      ),
                    ),
                  ]
                ),
              ),
              
              SizedBox(
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Flexible(
                      flex: 2,
                      child: ElevatedButton(
                        child: image == null ? Text('Добавить файл') : Text('Удалить файл'),
                        onPressed: image == null ? 
                        ()async {
                          await pickFile();
                        } : 
                        (){
                          setState(() {
                            image = null;
                          });
                        },
                      ),
                    ),
                    Spacer(),
                    Flexible(
                      flex: 3,
                      child: DateTimePicker(
                        type: DateTimePickerType.dateTime,
                        initialValue: publicationTime.isBefore( DateTime.now() ) ? DateTime.now().toString() : publicationTime.toString(),
                        locale: const Locale('ru', 'RU'),
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
                      flex: 3,
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
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: ()async{
                        bool edit = widget.draft != null;
                        await sendPost(editMode: edit, draft: false);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Опубликовать",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      //TODO: блокировка кнопки после нажатия
                      onPressed: ()async{
                        bool edit = widget.draft != null;
                        await sendPost(editMode: edit, draft: true);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Добавить в черновик",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                          ),
                        ),
                      )
                    ),
                  ],
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'mp4']
    );
    XFile? file;
    if (result != null && result.files.isNotEmpty){
      file = XFile(
        '', 
        name: result.files.first.name, 
        bytes: result.files.first.bytes, 
        length: result.files.first.size
      );
    }
    setState(() {
      image = file;
    });
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
        // for(PlatformPost platformPost in platformPosts){
          // try {
            // await PlatformPostService.savePlatformPost(platformPost);
          // } catch (e) {
            // print(e);
          // }
        // }
        Future.wait(platformPosts.map((platformPost) async{
          try {
            await PlatformPostService.savePlatformPost(platformPost);
          } catch (e) {
            print(e);
          }
        }));
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
      // Navigator.pushReplacementNamed(context, '/add');
      Future.wait(platformPosts.map((platformPost) async{
          try {
            await PlatformPostService.savePlatformPost(platformPost);
          } catch (e) {
            print(e);
          }
        }));
    }
  }
}
