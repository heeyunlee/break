import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoutineTitleWidget extends StatelessWidget {
  final String title;

  const RoutineTitleWidget({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (title.length < 21) {
      return Text(
        title,
        style: GoogleFonts.blackHanSans(
          color: Colors.white,
          fontSize: 28,
        ),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    } else if (title.length >= 21 && title.length < 35) {
      return FittedBox(
        child: Text(
          title,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 28,
          ),
        ),
      );
    } else {
      return Text(
        title,
        style: GoogleFonts.blackHanSans(
          color: Colors.white,
          fontSize: 20,
        ),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    }
  }
}
