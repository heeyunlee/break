import 'package:flutter/material.dart';

import '../constants.dart';

class CustomListTileStyle2 extends StatefulWidget {
  CustomListTileStyle2({
    Key key,
    this.tag,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.color,
  }) : super(key: key);

  final Object tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final onTap;
  final onLongTap;
  final Widget trailingIconButton;
  final Color color;

  @override
  _CustomListTileStyle2State createState() => _CustomListTileStyle2State();
}

class _CustomListTileStyle2State extends State<CustomListTileStyle2> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: widget.color,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 48,
          height: 48,
          child: Hero(
            tag: widget.tag,
            child: (widget.imageUrl == "" || widget.imageUrl == null)
                ? Image.asset('images/place_holder_workout_playlist.png')
                : Image.network(
                    widget.imageUrl,
                    fit: BoxFit.cover,
                  ),
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
