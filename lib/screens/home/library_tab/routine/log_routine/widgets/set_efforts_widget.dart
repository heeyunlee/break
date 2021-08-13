import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/home/library_tab/routine/log_routine/log_routine_screen_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class SetEffortsWidget extends ConsumerWidget {
  const SetEffortsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    logger.d('[SetEffortsWidget] building');
    final model = watch(logRoutineModelProvider);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 64,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(
            child: RatingBar(
              initialRating: model.effort,
              glow: false,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 8),
              ratingWidget: RatingWidget(
                empty: Image.asset(
                  'assets/emojis/fire_none.png',
                ),
                full: Image.asset(
                  'assets/emojis/fire_full.png',
                ),
                half: Image.asset(
                  'assets/emojis/fire_half.png',
                ),
              ),
              onRatingUpdate: model.onRatingUpdate,
            ),
          ),
        ),
        Positioned(
          left: 12,
          top: -6,
          child: Container(
            color: kBackgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                S.current.effort,
                style: TextStyles.caption1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
