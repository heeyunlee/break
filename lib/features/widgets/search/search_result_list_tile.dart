import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

class SearchResultListTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final void Function()? onTap;

  const SearchResultListTile({
    Key? key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: size.width,
        height: 64,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.fitness_center_outlined, size: 16),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) Text(title!, style: TextStyles.body2),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyles.caption1Grey,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
