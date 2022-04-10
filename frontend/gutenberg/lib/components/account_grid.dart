import 'package:flutter/material.dart';
import 'account_card.dart';

class AccountGrid extends StatefulWidget {
  double width, height;
  AccountGrid({ Key? key, required this.width, required this.height }) : super(key: key);

  @override
  State<AccountGrid> createState() => _AccountGridState();
}

class _AccountGridState extends State<AccountGrid> {
  Map<String, Color> platforms = 
    {
      'Facebook': Color.fromARGB(255, 59, 89, 152),
      'Vkontakte': Color.fromARGB(255, 38, 5, 137),
      'Twitter': Color.fromARGB(255, 2, 157, 214),
      'Instagram': Color.fromARGB(247, 224, 221, 14),
      'TikTok': Color.fromARGB(255, 255, 64, 129),
      'Youtube': Color.fromARGB(255, 222, 18, 18),
      'Telegram':  Color.fromARGB(255, 27, 178, 232),
      'Odnoklassniki': Color.fromARGB(255, 237, 118, 0),
    };
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AccountCard(
                platform: 'Facebook',
                color: platforms['Facebook']!,
              ),
              AccountCard(
                platform: 'Vkontakte',
                color: platforms['Vkontakte']!,
              ),
              AccountCard(
                platform: 'Twitter',
                color: platforms['Twitter']!,
              ),
              AccountCard(
                platform: 'Instagram',
                color: platforms['Instagram']!,
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AccountCard(
                platform: 'TikTok',
                color: platforms['TikTok']!,
              ),
              AccountCard(
                platform: 'Youtube',
                color: platforms['Youtube']!,
              ),
              AccountCard(
                platform: 'Telegram',
                color: platforms['Telegram']!,
              ),
              AccountCard(
                platform: 'Odnoklassniki',
                color: platforms['Odnoklassniki']!,
              )
            ],
          )
        ]
      ),
    );
  }
}