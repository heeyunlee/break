import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AppPreviewWidget extends StatelessWidget {
  const AppPreviewWidget({
    Key key,
    this.imageRoot,
    this.subtitle,
  }) : super(key: key);

  final String imageRoot;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      overflow: Overflow.visible,
      children: [
        Positioned(
          child: CachedNetworkImage(
            imageUrl: imageRoot,
            height: size.height * 5 / 6,
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          top: -80,
        ),
        Positioned(
          bottom: 16,
          child: Text(subtitle, style: BodyText1),
        ),
      ],
      alignment: Alignment.center,
    );
  }
}
