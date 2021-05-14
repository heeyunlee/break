import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/widgets/shimmer/app_preview_shimmer.dart';

import '../../../constants.dart';

class AppPreviewWidget extends StatelessWidget {
  const AppPreviewWidget({
    Key? key,
    required this.imageRoot,
    required this.subtitle,
  }) : super(key: key);

  final String imageRoot;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      clipBehavior: Clip.antiAlias,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -80,
          child: CachedNetworkImage(
            imageUrl: imageRoot,
            height: size.height * 5 / 6,
            errorWidget: (context, url, error) => const Icon(Icons.error),
            placeholder: (context, url) => AppPreviewShimmer(),
          ),
        ),
        Positioned(
          bottom: 16,
          child: Text(subtitle, style: kBodyText1),
        ),
      ],
    );
  }
}
