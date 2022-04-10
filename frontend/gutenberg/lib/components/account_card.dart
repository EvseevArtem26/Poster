import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AccountCard extends StatefulWidget {
  final String platform;
  final Color color;
  const AccountCard(
    { Key? key, required this.platform, this.color=const Color.fromARGB(255, 70, 110, 182) }
    ) : super(key: key);

  @override
  State<AccountCard> createState() => _AccountCardState();
}

class _AccountCardState extends State<AccountCard> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      front: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        child: Text(
          widget.platform,
          style: GoogleFonts.secularOne(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      back: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: Form(
          //form with login, password, email and phone number fields
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextFormField(
                controller: loginController,
                decoration: const InputDecoration(
                  labelText: 'Login',
                ),
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                ),
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  //send data to server
                  saveAccount();
                  cardKey.currentState!.toggleCard();
                },
                
              ),
            ],
          ),
        ),
      ),
      // fill: Fill.fillBack,
      direction: FlipDirection.VERTICAL,
    );
  }

  Future<void> saveAccount() async {
    //save account to server
    Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/',
    );

    http.Response response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        "Content-Type": "application/json",
      },
      //get username from shared preferences
      body: jsonEncode({
        'user': (await SharedPreferences.getInstance()).getString('username'),
        'platform': 'TG',
        'login': loginController.text,
        'password': passwordController.text,
        'email': emailController.text,
        'phone_number': phoneController.text,
      }),
    );
    if(response.statusCode == 201){      
      print('Account saved');
    }
    else {
      print('Failed to create account\ncode: ${response.statusCode}');
      print(response.body);
    }
  }
}