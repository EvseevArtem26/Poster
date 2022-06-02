import 'package:flutter/material.dart';
import 'pages/registration.dart';
import 'pages/authorization.dart';
import 'pages/home.dart';
import 'pages/new_post.dart';
import 'pages/drafts.dart';
import 'pages/delayed.dart';
import 'pages/published.dart';


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
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: const Color(0x00EE0290)
        )
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const AuthorizationPage(),
        '/registration': (context) => const RegistrationPage(),
        '/home': (context) => const HomePage(),
        '/add': (context) => NewPostPage(),
        '/drafts': (context) => const DraftsPage(),
        '/delayed': (context) => const DelayedPage(),
        '/published': (context) => const PublishedPage(),
      },
    );
  }
}

