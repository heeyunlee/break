import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../styles/constants.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final double? width;
  final bool isAppBarTitle;

  const TitleWidget({
    Key? key,
    required this.title,
    this.width,
    this.isAppBarTitle = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: width ?? size.width - 32,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isAppBarTitle) {
      return Center(child: Text(title, style: kSubtitle1));
    } else {
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
}
