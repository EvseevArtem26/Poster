import 'package:flutter/material.dart';


class Draft extends StatelessWidget {
  final String text;
  final DateTime? time;
  final List<int> platforms;
  const Draft({ 
    Key? key, 
    required this.text, 
    this.time, required 
    this.platforms 
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        // padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 6,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Text(
                  text,
                  softWrap: true,
                  overflow: TextOverflow.fade,
                ),
              ),
            ),
            // const Spacer(flex: 1),
            Expanded(
              flex: 2,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        timeToString(time),
                        style: Theme.of(context).textTheme.bodyText2?.copyWith(
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 20),
                    // chips with platforms
                    Expanded(
                      flex: 1,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: platforms.map((platform) {
                          return Chip(
                            label: Text(
                              "$platform",
                              style: Theme.of(context).textTheme.bodyText2?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.surface,
                    
                          );
                        }).toList(),
                      ),
                    ),
                    const Spacer(flex: 1),
                    // edit button
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        ),
                      onPressed: () {},
                    ),
                    // delete button
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                    // publish button
                    IconButton(
                      icon: const Icon(
                        Icons.publish,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ],
                  
                  
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String timeToString(DateTime? time) {
    if (time == null) {
      return '';
    }
    return "${time.day}/${time.month}/${time.year} ${time.hour}:${time.minute}"; 
  }
}