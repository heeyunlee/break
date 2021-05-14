import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workout_player/models/routine.dart';

import '../../../../constants.dart';

class RoutineFlexibleSpaceBarWidget extends StatelessWidget {
  final String tag;
  final Routine routine;

  const RoutineFlexibleSpaceBarWidget({
    Key? key,
    required this.tag,
    required this.routine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final routineTitle = routine.routineTitle;
    final routineOwnerUserName = routine.routineOwnerUserName;

    Widget _getTitleWidget() {
      if (routineTitle.length < 21) {
        return Text(
          routineTitle,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 28,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      } else if (routineTitle.length >= 21 && routineTitle.length < 35) {
        return FittedBox(
          child: Text(
            routineTitle,
            style: GoogleFonts.blackHanSans(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        );
      } else {
        return Text(
          routineTitle,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      }
    }

    return FlexibleSpaceBar(
      background: Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: routine.imageUrl,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -0.3),
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  kBackgroundColor,
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 8,
            child: SizedBox(
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getTitleWidget(),
                    const SizedBox(height: 4),
                    Text(
                      'Created by $routineOwnerUserName',
                      style: kSubtitle2BoldGrey,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
