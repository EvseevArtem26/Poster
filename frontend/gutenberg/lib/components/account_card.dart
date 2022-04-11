import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/platform.dart';

class AccountCard extends StatefulWidget {
  final Platform? platform;
  final String title;
  final Function() onSave;
  const AccountCard(
    { 
      Key? key, 
      this.platform, 
      required this.title,
      required this.onSave,
    }
    ) : super(key: key);
  static const Map<String, String> titles = {
    "VK": "Vkontakte",
    "FB": "Facebook",
    "TT": "TikTok",
    "TW": "Twitter",
    "YT": "Youtube",
    "OK": "Odnoklassniki",
    "TG": "Telegram",
    "IG": "Instagram"
  };
  static const Map<String, Color> platformColors = 
    {
      'FB': Color.fromARGB(255, 59, 89, 152),
      'VK': Color.fromARGB(255, 38, 5, 137),
      'TW': Color.fromARGB(255, 2, 157, 214),
      'IG': Color.fromARGB(247, 224, 221, 14),
      'TT': Color.fromARGB(255, 255, 64, 129),
      'YT': Color.fromARGB(255, 222, 18, 18),
      'TG':  Color.fromARGB(255, 27, 178, 232),
      'OK': Color.fromARGB(255, 237, 118, 0),
    };

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
    if(widget.platform != null){
      loginController.text = widget.platform!.login;
      passwordController.text = widget.platform!.password;
      emailController.text = widget.platform!.email;
      phoneController.text = widget.platform!.phoneNumber;
      return FlipCard(
        front: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            color: AccountCard.platformColors[widget.title]!,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: Text(
            AccountCard.titles[widget.title]!,
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
            color: AccountCard.platformColors[widget.title]!,
            borderRadius: BorderRadius.circular(20),
            
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: Form(
            //disabled form with login, password, email and phone number fields
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  enabled: false,
                  controller: loginController,
                  decoration: const InputDecoration(
                    labelText: 'Login',
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  enabled: false,
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone number',
                  ),
                ),
              ],
            ),
          ),
        ),
        direction: FlipDirection.VERTICAL,
      );
    }
    else {
    return FlipCard(
      key: cardKey,
      front: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AccountCard.platformColors[widget.title]!,
              width: 5,
            ),
        ),
        alignment: Alignment.center,
        child: Text(
          AccountCard.titles[widget.title]!,
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
          color: Colors.grey,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: AccountCard.platformColors[widget.title]!,
              width: 5,
            ),
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
                child: 
                const Text('Submit'),
                onPressed: () {
                  //send data to server
                  saveAccount();
                  cardKey.currentState!.toggleCard();
                  widget.onSave();
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
        'platform': widget.title,
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