import 'package:flutter/material.dart';
import '../models/platform.dart';
import '../util/requests/platform_service.dart';
import 'platform_chip.dart';

class PlatformPicker extends StatefulWidget {
  const PlatformPicker({ Key? key, required this.onPlatformSelected}) : super(key: key);
  final Function(List<Platform>) onPlatformSelected;


  @override
  State<PlatformPicker> createState() => _PlatformPickerState();
}

class _PlatformPickerState extends State<PlatformPicker> {
  List<Platform> selectedPlatforms = [];
  late Future<List<Platform>> availablePlatforms;

  @override
  void initState() {
    super.initState();
    availablePlatforms = PlatformService.getPlatforms();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: availablePlatforms,
      builder: (BuildContext context, snapshot){
        if(snapshot.hasData){
          return PlatformChoice(
            availablePlatforms: snapshot.data as List<Platform>,
            onPlatformSelected: (List<Platform> platforms){
              setState(() {
                selectedPlatforms = platforms;
                widget.onPlatformSelected(selectedPlatforms);
              });
            },
          );
        }
        else {
          return Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }
      }
    );
  }
}