import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AdaptiveCachedNetworkImage extends StatelessWidget {
  const AdaptiveCachedNetworkImage({
    required this.imageUrl,
    this.size,
    this.fit,
    this.placeholderBuilder,
    this.errorWidgetBuilder,
    this.color,
    super.key,
  });

  final String imageUrl;
  final Size? size;
  final BoxFit? fit;
  final Widget Function(BuildContext, String)? placeholderBuilder;
  final Widget Function(BuildContext, String, dynamic)? errorWidgetBuilder;
  final Color? color;

  static ImageProvider<Object> provider(
    BuildContext context, {
    required String imageUrl,
  }) {
    final targetPlatform = Theme.of(context).platform;

    switch (targetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CachedNetworkImageProvider(imageUrl);
      default:
        return NetworkImage(imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final targetPlatform = Theme.of(context).platform;

    switch (targetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CachedNetworkImage(
          imageUrl: imageUrl,
          width: size?.width,
          height: size?.height,
          fit: fit,
          placeholder: placeholderBuilder,
          color: color,
          errorWidget: errorWidgetBuilder,
        );
      default:
        return Image.network(
          imageUrl,
          width: size?.width,
          height: size?.height,
          fit: fit,
          color: color,
        );
    }
  }
}
