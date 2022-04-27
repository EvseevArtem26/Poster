import 'package:flutter/material.dart';
import '../models/platform.dart';

class PlatformChoice extends StatefulWidget {
  final List<Platform> availablePlatforms;
  final Function(List<Platform>) onPlatformSelected;
  PlatformChoice({ Key? key, required this.availablePlatforms, required this.onPlatformSelected }) : super(key: key);

  @override
  State<PlatformChoice> createState() => _PlatformChoiceState();
}

class _PlatformChoiceState extends State<PlatformChoice> {
  List<Platform> selectedPlatforms = [];
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.availablePlatforms.map((Platform platform) => 
        ChoiceChip(
          label: Text(platform.title),
          selected: selectedPlatforms.contains(platform),
          onSelected: (bool selected) {
            setState(() {
              selectedPlatforms.contains(platform) ? selectedPlatforms.remove(platform) : selectedPlatforms.add(platform);
              widget.onPlatformSelected(selectedPlatforms);
            });
          },
          selectedColor: Theme.of(context).colorScheme.primary,
        )
      ).toList(),
    );
  }
}