import 'dart:html';
import 'dart:typed_data';
import 'player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart'; 

class MyFilePicker extends StatefulWidget {
  const MyFilePicker({ Key? key, required this.onFileSelected, this.image }) : super(key: key);
  final Function(XFile?) onFileSelected;
  final XFile? image;

  @override
  State<MyFilePicker> createState() => _MyFilePickerState();
}

class _MyFilePickerState extends State<MyFilePicker> {
  @override
  void initState() {
    super.initState();
    image = widget.image;
  }
  XFile? image;
  Uint8List? bytes;
  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return SizedBox(
        width: 200,
        height: 100,
        child: ElevatedButton(
          child: const Text('Select Image'),
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['png', 'jpg', 'mp4']
            );
            XFile? file;
            if (result != null && result.files.isNotEmpty){
              file = XFile(
                '', 
                name: result.files.first.name, 
                bytes: result.files.first.bytes, 
                length: result.files.first.size
              );
              bytes = result.files.first.bytes;
            }
            
            setState(() {
              image = file;
              widget.onFileSelected(image);
            });
          },
        ),
      );
    } 
    else {
      if(widget.image!=null) {
        // if image comes from the server
        if(image!.path.endsWith("jpg") || image!.path.endsWith("png")){
          return Image.network(
            image!.path,
            width: 200,
            height: 100,
          );
        }
        else if(image!.path.endsWith("mp4")){
          return Player(videoUrl: image!.path);
        }
        else {
          return SizedBox(
            width: 200,
            height: 100,
            child: Text(
              "${image!.path} is not an image or video"
            ),
          );
        }
      }
      else { 
        // if image comes from the device  
        if (image!.name.endsWith('jpg') || image!.name.endsWith('png')) {
          return SizedBox(
            width: 200,
            height: 100,
            child: Image.memory(
              bytes!,
              fit: BoxFit.cover,
            ),
          );
        }
        else if(image!.name.endsWith('mp4')) {
            final blob = Blob([bytes!]);
            final url = Url.createObjectUrlFromBlob(blob);
            return SizedBox(
              width: 200,
              height: 100,
              child: Player(videoUrl: url,),
            );
          }
        else {
          return SizedBox(
            width: 200,
            height: 100,
            child: Text(
              "${image!.name} is not an image or video"
            ),
          );
        }
      }
    }
  }
}