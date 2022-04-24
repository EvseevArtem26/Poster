import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import  '../models/post.dart';
import '../util/requests.dart';


class PostForm extends StatefulWidget {
  const PostForm({ Key? key }) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {

  late String text;
  late DateTime publicationTime;
  late String author;
  late List<int> platforms = [];
  List<String> platformsNames = [];
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
                decoration: BoxDecoration(
                  color: Colors.grey[200],

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
                      onPressed: ()async{
                        status='draft';
                        Post post = await buildPost();
                        PostService.savePost(post);
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
                      child: MultiSelectFormField(
                        title: const Text("Опубликовать в:"),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                          return null;
                        },
                        dataSource: const [
                          {
                            "display": "Twitter",
                            "value": "Twitter",
                          },
                          {
                            "display": "Facebook",
                            "value": "Facebook",
                          },
                          {
                            "display": "Vkontakte",
                            "value": "Vkontakte",
                          },
                          {
                            "display": "Instagram",
                            "value": "Instagram",
                          },
                          {
                            "display": "Youtube",
                            "value": "Youtube",
                          },
                          {
                            "display": "Tiktok",
                            "value": "Tiktok",
                          },
                          {
                            "display": "Odnoklassniki",
                            "value": "Odnoklassniki",
                          },
                        ],
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        hintWidget: const Text('Please choose one or more'),
                        initialValue: platformsNames,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            platformsNames = value;
                          });
                        },
                      ),
                    ),
                    const Spacer(),
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
      platforms: platforms,
      status: status,
    );
  }
}