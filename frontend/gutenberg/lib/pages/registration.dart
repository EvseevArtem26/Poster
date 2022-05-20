import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../util/requests/user_service.dart';
import '../util/validators.dart';


class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

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
                        if(SignUpValidator.validate(
                          context,
                          usernameController.text, 
                          passwordController.text, 
                          passwordConfirmController.text,
                          emailController.text
                        )){
                          bool success = await UserService.signUp(
                            usernameController.text,
                            passwordController.text,
                            emailController.text,
                          );
                          if(success){
                            Navigator.pushReplacementNamed(context, "/login");
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
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}