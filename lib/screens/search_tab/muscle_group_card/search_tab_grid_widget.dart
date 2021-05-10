import 'package:flutter/material.dart';

import '../../../constants.dart';

class SearchTabGridWidget extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color color;

  const SearchTabGridWidget({
    Key? key,
    required this.text,
    this.onTap,
    this.color = PrimaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        borderOnForeground: true,
        margin: const EdgeInsets.all(8),
        elevation: 6,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        color: CardColor,
        child: ClipPath(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: color, width: 2),
                bottom: BorderSide(color: color, width: 2),
              ),
            ),
            child: Center(
              child: Text(
                text,
                style: Subtitle1w900,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
