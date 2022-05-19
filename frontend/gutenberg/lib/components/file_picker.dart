import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FilePicker extends StatefulWidget {
  const FilePicker({ Key? key, required this.onFileSelected }) : super(key: key);
  final Function(XFile) onFileSelected;

  @override
  State<FilePicker> createState() => _FilePickerState();
}

class _FilePickerState extends State<FilePicker> {
  XFile? image;
  @override
  Widget build(BuildContext context) {
    if (image == null) {
      return SizedBox(
        width: 200,
        height: 100,
        child: ElevatedButton(
          child: const Text('Select Image'),
          onPressed: () async {
            XFile? file = await ImagePicker().pickImage(
              source: ImageSource.gallery,
            );
            setState(() {
              image = file;
              widget.onFileSelected(image!);
            });
          },
        ),
      );
    } else {
      return SizedBox(
        width: 200,
        height: 100,
        child: Image.network(
          image!.path,
          fit: BoxFit.cover,
        ),
      );
      
    }
  }
}