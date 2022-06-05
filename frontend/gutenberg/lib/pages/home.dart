import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/navbar.dart';
import '../components/platform_card.dart';
import '../components/new_platform_form.dart';
import '../models/platform.dart';
import '../util/requests/platform_service.dart';

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  const PreferredSize(
        child: NavBar(initialIndex: 0),
        preferredSize: Size.fromHeight(60),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FutureBuilder(
                    future: getUser(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        String name = snapshot.data as String;
                        return Text(
                          name,
                          style: GoogleFonts.secularOne(
                            fontSize: 32,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  OutlinedButton(
                    child: Text(
                      'Выйти',
                      style: GoogleFonts.secularOne(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(
                        BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (Route<dynamic> route) => false);
                    },
                  ),
                ], 
              ),
            ),
            Text(
              'Аккаунты',
              style: GoogleFonts.secularOne(
                fontSize: 32,
              ),
            ),
            //4x2 grid of account cards from platforms map
            Container(
              width: 1200,
              height: 800,
              alignment: Alignment.center,
              child: FutureBuilder(
                future: PlatformService.getPlatforms(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<Platform> platforms = snapshot.data as List<Platform>;
                    int itemcount = platforms.length > 8 ? 9 : platforms.length + 1;
                    return Swiper(
                      itemCount: itemcount,
                      itemWidth: 1000,
                      itemHeight: 600,
                      itemBuilder: (context, index){
                        if(itemcount > platforms.length && index == itemcount-1){
                          Set<String> allPlatforms = {"VK", "FB", "TW", "IG", "TT", "YT", "TG", "OK", "PT"};
                          Set<String> existingPlatforms = platforms.map((platform) => platform.platform).toSet();
                          Set<String> availablePlatforms = allPlatforms.difference(existingPlatforms);
                          return Center(
                            child: NewPlatformForm(
                              availablePlatforms: availablePlatforms.toList(),
                              onChanged: (){
                                setState(() {});
                              },
                            ),
                          );
                        }
                        else{
                          return Center(
                            child: PlatformCard(
                              platform: platforms[index],
                              onChanged: (){
                                setState(() {});
                              },
                            ),
                          );
                        }
                      },
                      control: SwiperControl(
                        color: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.all(5)
                      ),
                    );
                  }
                  else if (snapshot.hasError){
                    return Center(
                      child: Text(snapshot.error.toString())
                    );
                  }
                  else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],     
        )
      )
    );
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<String?> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}