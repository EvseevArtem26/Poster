import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage({ Key? key }) : super(key: key);

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Poster",
                  style: GoogleFonts.courierPrime(
                    fontSize: 72,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Image.asset(
                  "assets/icons/typewriter-logo.png",
                ),
              ],
            ),
            Container(
              width: 600,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 70, 110, 182),
                border: Border.all(),
                borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              ),
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextFormField(
                      controller: loginController,
                      decoration: InputDecoration(
                        hintText: "Username or email",
                        hintStyle: GoogleFonts.secularOne(
                          color: const Color.fromARGB(255, 128, 128, 128)
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        constraints: const BoxConstraints.tightFor(
                          width: 450,
                          height: 100
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.secularOne(
                        fontSize: 24
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle: GoogleFonts.secularOne(
                          color: const Color.fromARGB(255, 128, 128, 128)
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        constraints: const BoxConstraints.tightFor(
                          width: 450,
                          height: 100
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                        ),
                      ),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.secularOne(
                        fontSize: 24
                      ),
                    ),
                    ElevatedButton(
                      onPressed: login,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => states.contains(MaterialState.disabled)
                            ? Colors.grey[600]
                            : Colors.white,
                        ),
                        shape: MaterialStateProperty.resolveWith(
                          (states) => const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(40.0))
                          ),
                        ),
                        textStyle: MaterialStateProperty.resolveWith(
                          (states) => states.contains(MaterialState.disabled)
                            ? GoogleFonts.secularOne(
                                fontSize: 24,
                                color: Colors.grey[600],
                              )
                            : GoogleFonts.secularOne(
                                fontSize: 24,
                                color: Colors.black,
                              )
                        ),
                        fixedSize: MaterialStateProperty.resolveWith(
                          (states) => states.contains(MaterialState.disabled)
                            ? const Size(300, 100)
                            : const Size(300, 100),
                        ),
                        padding: MaterialStateProperty.resolveWith((states) => 
                          states.contains(MaterialState.disabled)
                            ? const EdgeInsets.symmetric(vertical: 20, horizontal: 30)
                            : const EdgeInsets.symmetric(vertical: 20, horizontal: 30)
                        ),
                      ),
                      child:  Text(
                        "Sign in",
                        style: GoogleFonts.secularOne(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            TextButton(
              child: Text(
                'Create an account',
                style: GoogleFonts.roboto(
                  fontSize: 36,
                  color: const Color.fromARGB(255, 50, 50, 50),
                  fontWeight: FontWeight.w100,
                ),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Future<void>login()async{
    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "auth/token/login"
    );

    http.Response response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "username": loginController.text,
        "password": passwordController.text
      })
    );
    if(response.statusCode == 200){
      Map body = jsonDecode(response.body);
      //save token and username to shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("token", body["auth_token"]);
      prefs.setString("username", loginController.text);
      Navigator.pushReplacementNamed(
        context,
        '/home'
      );
    }
  }
}