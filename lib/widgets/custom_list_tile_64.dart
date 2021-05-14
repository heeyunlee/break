import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class CustomListTile64 extends StatelessWidget {
  const CustomListTile64({
    Key? key,
    required this.tag,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.onLongTap,
    this.trailingIconButton,
  }) : super(key: key);

  final String tag;
  final String imageUrl;
  final String title;
  final String subtitle;
  final void Function()? onTap;
  final void Function()? onLongTap;
  final Widget? trailingIconButton;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: Hero(
                    tag: tag,
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: kCardColor,
                        highlightColor: Colors.white,
                        child: Container(
                          width: 64,
                          height: 64,
                          color: kCardColor,
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
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
                        style: kBodyText1Bold,
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        softWrap: false,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        style: kBodyText2Grey,
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
