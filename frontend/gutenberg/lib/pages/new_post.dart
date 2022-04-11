import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navbar.dart';
import '../models/post.dart';
import '../util/requests.dart';

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
  
    return Scaffold(
      appBar: const PreferredSize(
        child: NavBar(),
        preferredSize: Size.fromHeight(60),
      ),
      body: Center(
        child: SizedBox(
          width: 900,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                Container(
                  width: 900,
                  height: 400,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: const BorderRadius.all(Radius.circular(5.0))
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: ()async{
                        status='draft';
                        Post post = await buildPost();
                        savePost(post);
                      },
                      child: Text("Добавить в черновик")
                    ),
                    const ElevatedButton(
                      onPressed: null,
                      child: Text("Опубликовать"),
                    ),
                    
                  ],
                ),
                // время публикации
                Row(
                  children: [
                    SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            width: 300,
                            height: 100,
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
                          SizedBox(
                            height: 100, 
                            width: 300,
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
                              initialValue: platforms,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  platforms = value;
                                });
                              },
                            ),
                          ),
                        ],
                        
                      ),
                    ),
                  ],
                )
              ]
            ),
          ),
        )
      ),
    );
  }

  Future<Post> buildPost()async{
    final prefs = await SharedPreferences.getInstance();
    // String token = prefs.getString('token') ?? '';
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
