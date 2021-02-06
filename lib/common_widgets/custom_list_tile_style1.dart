import 'package:flutter/material.dart';
import 'package:workout_player/models/images.dart';

import '../constants.dart';

class CustomListTileStyle1 extends StatelessWidget {
  const CustomListTileStyle1({
    Key key,
    this.tag,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.imageIndex,
  }) : super(key: key);

  final Object tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final onTap;
  final onLongTap;
  final Widget trailingIconButton;
  final int imageIndex;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 56,
          height: 56,
          child: Hero(
            tag: tag,
            child: Image.asset(
              ImageList[imageIndex],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: BodyText1.copyWith(fontWeight: FontWeight.bold),
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      subtitle: Text(
        subtitle,
        style: Caption1Grey,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      ),
      trailing: trailingIconButton,
      onTap: onTap,
      onLongPress: onLongTap,
    );
  }
}
