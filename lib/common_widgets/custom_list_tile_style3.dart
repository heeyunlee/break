import 'package:flutter/material.dart';

import '../constants.dart';

class CustomListTileStyle3 extends StatefulWidget {
  CustomListTileStyle3({
    Key key,
    this.imageUrl,
    this.title,
    this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.color,
    this.isSelected,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final onTap;
  final onLongTap;
  final Widget trailingIconButton;
  final Color color;
  final ValueChanged<bool> isSelected;

  @override
  _CustomListTileStyle3State createState() => _CustomListTileStyle3State();
}

class _CustomListTileStyle3State extends State<CustomListTileStyle3> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: (isSelected == false) ? null : widget.color,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          width: 48,
          height: 48,
          child: (widget.imageUrl == "" || widget.imageUrl == null)
              ? Image.asset('images/place_holder_workout_playlist.png')
              : Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                ),
        ),
      ),
      title: Text(widget.title, style: BodyText2),
      subtitle: Text(widget.subtitle, style: Caption1Grey),
      trailing: widget.trailingIconButton,
      // onTap: () {
      //   setState(() {
      //     isSelected = !isSelected;
      //   });
      //   print(isSelected);
      // },
      onTap: widget.onTap,
      // onTap: () {},
      onLongPress: widget.onLongTap,
    );
  }
}
