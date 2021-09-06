import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';

class RoutineFlexibleSpaceBar extends StatelessWidget {
  const RoutineFlexibleSpaceBar({
    Key? key,
    required this.model,
    required this.imageTag,
  }) : super(key: key);

  final RoutineDetailScreenModel model;
  final String imageTag;

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: imageTag,
            child: CachedNetworkImage(
              imageUrl: model.imageUrl(),
              errorWidget: (_, __, ___) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0, -0.50),
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  kBackgroundColor,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(context, title: model.title()),
                Text(
                  model.username(),
                  style: TextStyles.subtitle2BoldGrey,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, {required String title}) {
    final size = MediaQuery.of(context).size;

    if (title.length < 21) {
      return Text(
        title,
        style: TextStyles.blackHans1,
        maxLines: 1,
        overflow: TextOverflow.fade,
        softWrap: false,
      );
    } else if (title.length >= 21 && title.length < 35) {
      return FittedBox(
        child: Text(
          title,
          style: TextStyles.blackHans1,
        ),
      );
    } else {
      return SizedBox(
        width: size.width - 32,
        child: Text(
          title,
          style: TextStyles.blackHans3,
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        ),
      );
    }
  }
}
