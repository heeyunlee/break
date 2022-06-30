import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/widgets.dart';

class SummaryRowWidget extends StatelessWidget {
  const SummaryRowWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  final String imageUrl;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AdaptiveCachedNetworkImage(
            imageUrl: imageUrl,
            size: const Size(36, 36),
          ),
          const SizedBox(width: 16),
          RichText(
            text: TextSpan(
              style: TextStyles.headline3,
              children: <TextSpan>[
                TextSpan(text: title),
                if (subtitle != null)
                  TextSpan(
                    text: subtitle,
                    style: TextStyles.subtitle1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
