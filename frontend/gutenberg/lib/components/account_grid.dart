import 'dart:convert';

import 'package:flutter/material.dart';
import 'account_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/platform.dart';


class AccountGrid extends StatefulWidget {
  double width, height;
  AccountGrid({ Key? key, required this.width, required this.height }) : super(key: key);

  @override
  State<AccountGrid> createState() => _AccountGridState();
}

class _AccountGridState extends State<AccountGrid> {
  
  List<Platform?> platforms = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getPlatforms(),
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          platforms = snapshot.data as List<Platform?>;
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
                      onSave: (){
                        setState(() {});
                      },
                    ),
                    AccountCard(
                      platform:  findByName('VK'),
                      title: 'VK',
                      onSave: (){
                        setState(() {});
                      },
                    ),
                    AccountCard(
                      platform:  findByName('TW'),
                      title: 'TW',
                      onSave: (){
                        setState(() {});
                      },
                    ),
                    AccountCard(
                      platform: findByName('IG'),
                      title: 'IG',
                      onSave: (){
                        setState(() {});
                      },
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AccountCard(
                      platform: findByName('TT'),
                      title: 'TT',
                      onSave: (){
                        setState(() {});
                      },
                    ),
                    AccountCard(
                      platform: findByName('YT'),
                      title: 'YT',
                      onSave: (){
                        setState(() {});
                      },
                    ),
                    AccountCard(
                      platform:  findByName('TG'),
                      title: 'TG',
                      onSave: (){
                        setState(() {});
                      },
                    ),
                    AccountCard(
                      platform: findByName('OK'),
                      title: 'OK',
                      onSave: (){
                        setState(() {});
                      },
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
     Uri url = Uri(
      scheme: 'http',
      host: 'localhost',
      port: 8000,
      path: 'poster/platforms/',
      queryParameters: {
        'username': (await SharedPreferences.getInstance()).getString('username'),
      },
    );
    http.Response response = await http.get(url);
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