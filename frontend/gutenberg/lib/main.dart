import 'package:flutter/material.dart';
import 'pages/registration.dart';
import 'pages/authorization.dart';
import 'pages/home.dart';
import 'pages/new_post.dart';


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
      home: RegistrationPage(),
      initialRoute: 'registration',
      routes: {
        // '/': (context) => RegistrationPage(),
        '/login': (context) => AuthorizationPage(),
        '/registration': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/newPost': (context) => NewPostPage(),
      },
    );
  }
}

