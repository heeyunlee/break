import 'package:flutter/material.dart';
import 'package:workout_player/models/images.dart';

import '../constants.dart';

class CustomListTileStyle2 extends StatefulWidget {
  CustomListTileStyle2({
    Key key,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.color,
    this.imageIndex,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final onTap;
  final onLongTap;
  final Widget trailingIconButton;
  final Color color;
  final int imageIndex;

  @override
  _CustomListTileStyle2State createState() => _CustomListTileStyle2State();
}

class _CustomListTileStyle2State extends State<CustomListTileStyle2> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      selected: false,
      selectedTileColor: PrimaryColor,
      tileColor: widget.color,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 48,
          height: 48,
          child: Image.asset(
            ImageList[widget.imageIndex],
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(widget.title, style: BodyText2),
      subtitle: Text(widget.subtitle, style: Caption1Grey),
      trailing: widget.trailingIconButton,
      onTap: widget.onTap,
      onLongPress: widget.onLongTap,
    );
  }
}
