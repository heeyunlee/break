import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

class LibraryListTile extends StatelessWidget {
  final String tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final Widget? trailingIconButton;

  const LibraryListTile({
    Key? key,
    required this.tag,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: SizedBox(
                width: 64,
                height: 64,
                child: Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    errorWidget: (_, __, ___) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyles.body1_bold,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: TextStyles.body2_grey,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
