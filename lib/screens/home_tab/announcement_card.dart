import 'package:flutter/material.dart';

import '../../constants.dart';

class AnnouncementCard extends StatelessWidget {
  final Color cardColor;
  final Widget child;
  final Function onTap;

  const AnnouncementCard({
    Key key,
    this.cardColor = CardColor,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        color: cardColor,
        child: child,
      ),
    );
  }
}
