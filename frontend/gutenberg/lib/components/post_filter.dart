import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Платформы:",
                style: GoogleFonts.secularOne(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
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
          ]
        ),
      ),
    );
  }
}