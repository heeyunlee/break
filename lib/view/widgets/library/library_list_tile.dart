import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class LibraryListTile extends StatelessWidget {
  final String? tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final Widget? trailingIconButton;
  final String? leadingString;
  final bool? selected;

  const LibraryListTile({
    Key? key,
    this.tag,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
    this.leadingString,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          color: (selected ?? false)
              ? kPrimaryColor.withOpacity(0.2)
              : Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Stack(
                    fit: StackFit.passthrough,
                    children: [
                      Hero(
                        tag: tag ?? '',
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          errorWidget: (_, __, ___) => const Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (leadingString != null)
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: FittedBox(
                            child: Text(
                              leadingString!,
                              style: TextStyles.blackHans1,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyles.body1Bold,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: TextStyles.body2Grey,
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
      ),
    );
  }
}
