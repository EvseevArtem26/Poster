import 'package:flutter/material.dart';
import 'pages/registration.dart';
import 'pages/authorization.dart';
import 'pages/home.dart';
import 'pages/new_post.dart';
import 'pages/drafts.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegistrationPage(),
      initialRoute: '/login',
      routes: {
        // '/': (context) => RegistrationPage(),
        '/login': (context) => AuthorizationPage(),
        '/registration': (context) => RegistrationPage(),
        '/home': (context) => HomePage(),
        '/add': (context) => NewPostPage(),
        '/drafts': (context) => DraftsPage(),
      },
    );
  }
}

