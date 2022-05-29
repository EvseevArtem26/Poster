import 'dart:convert';

import 'package:flutter/material.dart';
import '../util/requests/platform_service.dart';
import 'account_card.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/platform.dart';


class AccountGrid extends StatefulWidget {
  final double width;
  final double height;
  final String username;
  final String token;
  const AccountGrid({ 
    Key? key, 
    required this.width, 
    required this.height,
    required this.username,
    required this.token
  }) : super(key: key);

  @override
  State<AccountGrid> createState() => _AccountGridState();
}

class _AccountGridState extends State<AccountGrid> {
  
  List<Platform?> platforms = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: PlatformService.getPlatforms(widget.username, widget.token),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          platforms = List<Platform?>.from(snapshot.data as List<Platform?>);
          while(platforms.length<8){
            platforms.add(null);
          }
          return  Container(
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
                      platform: findByName('FB'),
                      title: 'FB',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    ),
                    AccountCard(
                      platform:  findByName('VK'),
                      title: 'VK',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    ),
                    AccountCard(
                      platform:  findByName('TW'),
                      title: 'TW',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    ),
                    AccountCard(
                      platform: findByName('IG'),
                      title: 'IG',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AccountCard(
                      platform: findByName('TT'),
                      title: 'TT',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    ),
                    AccountCard(
                      platform: findByName('YT'),
                      title: 'YT',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    ),
                    AccountCard(
                      platform:  findByName('TG'),
                      title: 'TG',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    ),
                    AccountCard(
                      platform: findByName('OK'),
                      title: 'OK',
                      onChanged: (){
                        setState(() {});
                      },
                      token: widget.token,
                      username: widget.username,
                    )
                  ],
                )
              ]
            ),
          );
        }
        else {
          return Container(
            width: widget.width,
            height: widget.height,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      }
    );
  }
  Future<List<Platform?>> getPlatforms () async {
    // final prefs = await SharedPreferences.getInstance();
    // String? username = prefs.getString('username');
    // String token = prefs.getString('token') ?? '';
     Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/',
      queryParameters: {
        'username': widget.username,
      },
    );
    http.Response response = await http.get(
      url,
      headers: {
        'Authorization': 'Token ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<Platform?> platforms = [];
      for (var i = 0; i < data.length; i++) {
        platforms.add(Platform.fromJson(data[i]));
      }
      return platforms;
    }
    else {
      throw Exception('Failed to load platforms');
    }
  }

  Platform? findByName (String name){
    return platforms.singleWhere((element) => element?.platform==name, orElse: ()=>null);
  }
  
}