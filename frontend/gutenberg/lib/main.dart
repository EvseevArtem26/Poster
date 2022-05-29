import 'package:flutter/material.dart';
import 'package:gutenberg/providers/user_provider.dart';
import 'package:provider/provider.dart';
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
    return ChangeNotifierProvider<UserProvider>(
      create: (_) => UserProvider(),
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const AuthorizationPage(),
          '/registration': (context) => const RegistrationPage(),
          '/home': (context) => const HomePage(),
          '/add': (context) => const NewPostPage(),
          '/drafts': (context) => const DraftsPage(),
        },
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.light,
            seedColor: const Color(0x00ee0290),
          )
          
        ),
      ),
    );
  }
}

