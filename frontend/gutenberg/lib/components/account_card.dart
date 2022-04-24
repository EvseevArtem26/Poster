import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gutenberg/util/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/platform.dart';

class AccountCard extends StatefulWidget {
  final Platform? platform;
  final String title;
  final Function() onChanged;
  const AccountCard(
    { 
      Key? key, 
      this.platform, 
      required this.title,
      required this.onChanged,
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
                ElevatedButton(
                  onPressed: ()async{
                    await PlatformService.deletePlatform(widget.platform!.id!);
                    cardKey.currentState?.toggleCard();
                    loginController.clear();
                    passwordController.clear();
                    emailController.clear();
                    phoneController.clear();
                    widget.onChanged();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('Delete account'),
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
                onPressed: () async {
                  //send data to server
                  Platform platform = await buildPlatform();
                  await PlatformService.savePlatform(platform);
                  cardKey.currentState!.toggleCard();
                  widget.onChanged();
                },
                
              ),
            ],
          ),
        ),
      ),
      direction: FlipDirection.VERTICAL,
    );
    }
  }

  Future<Platform> buildPlatform()async{
    // builds platform object from card state
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username')!;

    return Platform(
      platform: widget.title,
      login: loginController.text,
      password: passwordController.text,
      email: emailController.text,
      phoneNumber: phoneController.text,
      user: username,
    );
  }
}