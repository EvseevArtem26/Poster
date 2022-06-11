import 'dart:html';
import 'dart:typed_data';
import 'package:cross_file/cross_file.dart';
import 'player.dart';
import 'package:flutter/material.dart';

class FileDisplay extends StatelessWidget {
  const FileDisplay({ Key? key, this.file}) : super(key: key);
  final XFile? file;


  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context){
        if(file!=null){
          print("file.path: ${file!.path}");
          print("file.name: ${file!.name}");
          if (file!.path.isEmpty){
            // if file comes from the device
            return FutureBuilder(
              future: file!.readAsBytes(),
              builder: (context, snapshot){
                if(snapshot.connectionState == ConnectionState.done){
                  Uint8List bytes = snapshot.data as Uint8List;
                  if (file!.name.endsWith('jpg') || file!.name.endsWith('png')) {
                    return Container(
                      alignment: Alignment.center,
                      height: 300,
                      child: AspectRatio(
                        aspectRatio: 16/9,
                        child: Image.memory(
                          bytes,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }
                  else if(file!.name.endsWith('mp4')) {
                      final blob = Blob([bytes]);
                      final url = Url.createObjectUrlFromBlob(blob);
                      return Container(
                        height: 300,
                        alignment: Alignment.center,
                        child: Player(videoUrl: url,)
                      );
                    }
                  else {
                    return Text(
                      "${file!.name} is not an image or video"
                    );
                  }
                }
                else {
                  return Text(
                    "Loading ${file!.name}"
                  );
                }
              },
            );
          }
          else {
            // if file comes from the server
             if (file!.path.endsWith("jpg") || file!.path.endsWith("png")){
              return Container(
                alignment: Alignment.center,
                height: 300,
                child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Image.network(file!.path)
                )
              );
            }
            else if(file!.path.endsWith("mp4")){
              return Container(
                height: 300,
                alignment: Alignment.center,
                child: Player(videoUrl: file!.path)
              );
            }
            else {
              return const Text("File type not supported");
            }
          }
        }
        else {
          return const SizedBox(
            width: 0,
            height: 0,
          );
        }
      },
    );
  }
}