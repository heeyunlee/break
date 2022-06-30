import 'package:flutter/material.dart';

import 'package:workout_player/styles/text_styles.dart';

class CreateListTile extends StatelessWidget {
  const CreateListTile({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              const SizedBox(
                width: 64,
                height: 64,
                child: Icon(Icons.add_rounded, size: 32),
              ),
              const SizedBox(width: 16),
              Text(title, style: TextStyles.body1Bold),
            ],
          ),
        ),
      ),
    );
  }
}
