import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();
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
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
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
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
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
                    TextFormField(
                      controller: passwordConfirmController,
                      decoration: InputDecoration(
                        hintText: "Confirm password",
                        hintStyle: GoogleFonts.secularOne(
                          color: const Color.fromARGB(255, 128, 128, 128),
                          
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
                      onPressed: ()async{
                        if(validateForm()){
                          try{
                          int statusCode = await signUp();
                          print(statusCode);
                          }catch(e){
                            print('Caught error: $e');
                          }
                        }
                      },
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
                        "Sign up",
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
                'I already have an account',
                style: GoogleFonts.roboto(
                  fontSize: 36,
                  color: const Color.fromARGB(255, 50, 50, 50),
                  fontWeight: FontWeight.w100,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
  bool validateForm(){
    //validate form and register user
    if(usernameController.text.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter your name"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else if(emailController.text.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter your email"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else if(passwordController.text.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please enter your password"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else if(passwordConfirmController.text.isEmpty){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Please confirm your password"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else if(passwordController.text != passwordConfirmController.text){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Password are not the same"),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
      );
      return false;
    }
    else{
      return true;
    }
      

  }
  Future<int> signUp()async{
    Uri url = Uri(
      scheme: "http",
      host: "localhost",
      port: 8000,
      path: "auth/users/"
    );
    http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "username": usernameController.text,
        "email": emailController.text,
        "password": passwordController.text,
      })
    );
    if(response.statusCode == 201){      
      Navigator.pushNamed(context, "/login");
      return response.statusCode;
    }
    else {
      print('Failed to create user\ncode: ${response.statusCode}');
      return response.statusCode;
    }
  }
}