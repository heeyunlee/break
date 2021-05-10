import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class ActivityListTile extends StatelessWidget {
  const ActivityListTile({
    Key? key,
    required this.index,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  final int index;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          tileColor: CardColor,
          leading: Container(
            width: 40,
            height: 56,
            child: Center(
              child: Text(
                '$index',
                style: GoogleFonts.blackHanSans(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          title: Text(title, style: BodyText1),
          subtitle: Text(subtitle, style: BodyText1Grey),
        ),
      ),
    );
  }
}
