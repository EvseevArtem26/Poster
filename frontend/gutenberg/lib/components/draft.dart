import 'package:flutter/material.dart';

class Draft extends StatelessWidget {
  final String text;
  const Draft({ Key? key, required this.text }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.center,
      child: Container(
        width: 900,
        height: 450,
        padding: const EdgeInsets.all(20),
        child: Text(
          text,
          softWrap: true,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          border: Border.all(
            color: Colors.blue,
            width: 2,
          ),
        ),
        
      ),
    );
  }
}