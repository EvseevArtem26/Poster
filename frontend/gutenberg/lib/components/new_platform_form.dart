import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/platform.dart';
import '../util/requests/platform_service.dart';

class NewPlatformForm extends StatefulWidget {
  const NewPlatformForm({ Key? key, required this.availablePlatforms, required this.onChanged }) : super(key: key);
  final List<String> availablePlatforms;
  final VoidCallback onChanged;

  @override
  State<NewPlatformForm> createState() => _NewPlatformFormState();
}

class _NewPlatformFormState extends State<NewPlatformForm> {
  String login = '';
  String password ='';
  String email = '';
  String phoneNumber = '';
  int selectedPlatform = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 1000,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Добавить аккаунт",
            style: GoogleFonts.secularOne(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextField(
            decoration: InputDecoration(
              constraints: const BoxConstraints.tightFor(width: 800, height: 80),
              hintText: "Логин",
              hintStyle: GoogleFonts.secularOne(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
              fontSize: 24
            ),
            onChanged: (value) => login = value,
          ),
          TextField(
            decoration: InputDecoration(
              constraints: const BoxConstraints.tightFor(width: 800, height: 80),
              hintText: "Пароль",
              hintStyle: GoogleFonts.secularOne(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
              fontSize: 24
            ),
            obscureText: true,
            onChanged: (value) => password = value,
          ),
          TextField(
            decoration: InputDecoration(
              constraints: const BoxConstraints.tightFor(width: 800, height: 80),
              hintText: "Email",
              hintStyle: GoogleFonts.secularOne(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
              fontSize: 24
            ),
            onChanged: (value) => email = value,
          ),
          TextField(
            decoration: InputDecoration(
              constraints: const BoxConstraints.tightFor(width: 800, height: 80),
              hintText: "Номер телефона",
              hintStyle: GoogleFonts.secularOne(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
            ),
            textAlign: TextAlign.center,
            style: GoogleFonts.secularOne(
              fontSize: 24
            ),
            onChanged: (value) => phoneNumber = value,
          ),
          Container(
            width: 800,
            height: 70,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(2)),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Выберите платформу:",
                  style: GoogleFonts.secularOne(
                    fontSize: 24,
                  ),
                ),
                Wrap(
                  alignment: WrapAlignment.spaceAround,
                  runAlignment: WrapAlignment.spaceAround,
                  spacing: 8,
                  children: List<Widget>.generate(
                    widget.availablePlatforms.length, 
                    (index) => ChoiceChip(
                      label: Text(widget.availablePlatforms[index]), 
                      labelStyle: GoogleFonts.secularOne(
                        fontSize: 14,
                      ),
                      selected: selectedPlatform == index,
                      selectedColor: Theme.of(context).colorScheme.primary,
                      onSelected: (bool value) {
                        setState(() {
                          selectedPlatform = index;
                        });
                      },
                    )
                  )
                ),
                ElevatedButton(
                  onPressed: () async {
                    Platform platform = await buildPlatform();
                    await PlatformService.savePlatform(platform);
                    widget.onChanged();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("Сохранить")
                  ),
                ),
              ],
            )
          ),
        ],
      ),
    );
  }
  Future<Platform> buildPlatform()async{
    // builds platform object from card state
    final prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username')!;

    return Platform(
      platform: widget.availablePlatforms[selectedPlatform],
      login: login,
      password: password,
      email: email,
      phoneNumber: phoneNumber,
      user: username,
    );
  }
}