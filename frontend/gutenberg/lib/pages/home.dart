import 'package:flutter/material.dart';
import 'package:gutenberg/components/account_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navbar.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, Color> platforms = 
    {
      'Facebook': const Color.fromARGB(255, 59, 89, 152),
      'Vkontakte': const Color.fromARGB(255, 38, 5, 137),
      'Twitter': const Color.fromARGB(255, 0, 172, 237),
      'Instagram': const Color.fromARGB(247, 224, 221, 14),
      'TikTok': const Color.fromARGB(255, 255, 64, 129),
      'Youtube': const Color.fromARGB(255, 222, 18, 18),
      'Telegram':  const Color.fromARGB(255, 0, 172, 237),
      'Odnoklassniki': const Color.fromARGB(255, 237, 118, 0),
    };
  
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const PreferredSize(
        child: NavBar(),
        preferredSize: Size.fromHeight(60),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Artem Evseev',
                  style: GoogleFonts.secularOne(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Text(
              'Accounts',
              style: GoogleFonts.secularOne(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            //4x2 grid of account cards from platforms map
            AccountGrid(
              width: double.infinity,
              height: 800,
            )           
          ],
          
        )
      )
    );
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}