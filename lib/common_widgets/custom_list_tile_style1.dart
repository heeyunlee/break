import 'package:flutter/material.dart';

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
  }) : super(key: key);

  final Object tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final onTap;
  final onLongTap;
  final Widget trailingIconButton;

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
            child: (imageUrl == "" || imageUrl == null)
                ? Image.asset('images/place_holder_workout_playlist.png')
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
      title:
          Text(title, style: BodyText1.copyWith(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: Caption1Grey),
      trailing: trailingIconButton,
      onTap: onTap,
      onLongPress: onLongTap,
    );
  }
}
