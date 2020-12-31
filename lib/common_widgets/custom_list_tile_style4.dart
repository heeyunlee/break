import 'package:flutter/material.dart';

import '../constants.dart';

class CustomListTileStyle4Model {
  CustomListTileStyle4Model({
    this.tag,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
  });

  final Object tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final onTap;
  final onLongTap;
  final Widget trailingIconButton;
}

class CustomListTileStyle4 extends StatelessWidget {
  const CustomListTileStyle4({this.model});

  final CustomListTileStyle4Model model;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 56,
          height: 56,
          child: Hero(
            tag: model.tag,
            child: (model.imageUrl == "" || model.imageUrl == null)
                ? Image.asset('images/place_holder_workout_playlist.png')
                : Image.network(
                    model.imageUrl,
                    fit: BoxFit.cover,
                  ),
          ),
        ),
      ),
      title: Text(model.title, style: BodyText1Bold),
      subtitle: Text(model.subtitle, style: Caption1Grey),
      trailing: model.trailingIconButton,
      onTap: model.onTap,
      onLongPress: model.onLongTap,
    );
  }
}
