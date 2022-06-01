import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/platform.dart';
import '../util/requests/platform_service.dart';

class PlatformCard extends StatefulWidget {
  const PlatformCard({ 
    Key? key,
    required this.platform,
    required this.onChanged,

  }) : super(key: key);

  final Platform platform;
  final VoidCallback onChanged;

  @override
  State<PlatformCard> createState() => _PlatformCardState();
}

class _PlatformCardState extends State<PlatformCard> {
  bool passvordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: 1000,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          width: 3,
          color: Theme.of(context).colorScheme.primary,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.platform.title,
                  style: GoogleFonts.secularOne(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                Text(
                  "Логин: ${widget.platform.login}",
                  style: GoogleFonts.secularOne(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                Text(
                  "Почта: ${widget.platform.email}",
                  style: GoogleFonts.secularOne(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                Text(
                  "Телефон: ${widget.platform.phoneNumber}",
                  style: GoogleFonts.secularOne(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                Row(
                  children: [
                    Text(
                      "Пароль: ${passvordVisible ? widget.platform.password : "*" * widget.platform.password.length}",
                      style: GoogleFonts.secularOne(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    IconButton(
                      onPressed: () => setState(() => passvordVisible = !passvordVisible),
                      icon: Icon(
                        passvordVisible ? Icons.visibility_off : Icons.visibility,
                      )
                    )
                  ],
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  "assets/icons/${widget.platform.platform}.png",
                  width: 200,
                  height: 200,
                ),
                IconButton(
                  iconSize: 40,
                  color: Colors.red[800],
                  onPressed: () async {
                    await PlatformService.deletePlatform(widget.platform.id!);
                    widget.onChanged();
                  }, 
                  icon: const Icon(
                    Icons.delete
                  )
                )
              ],
            ),
          )
        ],
      )
    );
  }
}