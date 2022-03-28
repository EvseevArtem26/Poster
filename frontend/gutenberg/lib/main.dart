import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'components/navbar.dart';
import 'util/requests.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AddPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class AddPage extends StatefulWidget {
  const AddPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  static List platforms=[];
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const TextField(),
              // текстовое поле
              Container(
                width: 900,
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(5.0))
                ),
                child: const TextField(
                  expands: true,
                  maxLines: null,
                ),
              ),
              // ограничение по символам
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "500 символов (максимальное количество - 300)",
                    style: TextStyle(
                      color: Colors.redAccent
                    ),
                  ),
                ],
              ),
              // добавить в черновик
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ElevatedButton(
                    onPressed: testSavePlatform, 
                    child: Text("Добавить в черновик")
                  ),
                  const ElevatedButton(
                    onPressed: testSavePost,
                    child: Text("Опубликовать"),
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
              // время публикации
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Время публикации"),
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
                        onChanged: (val) => print(val),
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                      ),
                    ),
                  ],
                ),
              )
            ]
          ),
        )
      ),
    );
  }
}
