import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

class SearchCategoryWidget extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color color;

  const SearchCategoryWidget({
    Key? key,
    required this.text,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(8),
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        child: ClipPath(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: color, width: 2),
                bottom: BorderSide(color: color, width: 3),
              ),
            ),
            child: Center(
              child: Text(text, style: TextStyles.subtitle2W900),
            ),
          ),
        ),
      ),
    );
  }
}
