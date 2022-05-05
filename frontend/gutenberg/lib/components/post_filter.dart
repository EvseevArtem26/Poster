import 'package:flutter/material.dart';

class PostFilter extends StatefulWidget {

  final List<String> platforms;
  final Function(List<String>) onPlatformSelected;
  const PostFilter({ 
    Key? key, 
    required this.platforms, 
    required  this.onPlatformSelected 
    }) : super(key: key);


  @override
  State<PostFilter> createState() => _PostFilterState();
}

class _PostFilterState extends State<PostFilter> {
  List<String> selectedPlatforms = [];
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: widget.platforms.map((String platform) => 
          ChoiceChip(
            label: Text(platform),
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
      ),
    );
  }
}