import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class MostRecentWorkout extends StatelessWidget {
  const MostRecentWorkout({
    this.width,
    this.height,
    this.cardMargin,
    this.cardOnTap,
    this.cardOnLongPress,
    this.contentPadding = const EdgeInsets.all(24.0),
    this.workoutEndTime,
    this.routineTitle,
    this.unit,
    this.totalWeights,
    this.durationInMins,
    Key? key,
  }) : super(key: key);

  final double? width;
  final double? height;
  final EdgeInsets? cardMargin;
  final VoidCallback? cardOnTap;
  final VoidCallback? cardOnLongPress;
  final EdgeInsets contentPadding;
  final DateTime? workoutEndTime;
  final String? routineTitle;
  final UnitOfMass? unit;
  final num? totalWeights;
  final int? durationInMins;

  String get ago {
    final now = DateTime.now();
    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final locale = Intl.getCurrentLocale();

    return timeago.format(workoutEndTime ?? now, locale: locale);
  }

  String get title => routineTitle ?? 'No Workout Yet';

  String get weights {
    if (totalWeights != null) {
      final formatter = NumberFormat(',###,###.#');
      final formattedWeight = formatter.format(totalWeights);
      final unitOfMass = unit?.label ?? 'Kg';

      return '$formattedWeight $unitOfMass';
    } else {
      return '-,--- Kg';
    }
  }

  String get duration => Formatter.durationInMin(durationInMins);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Card(
        margin: cardMargin,
        child: SizedBox(
          height: 144,
          child: InkWell(
            onTap: cardOnTap,
            onLongPress: cardOnLongPress,
            child: Padding(
              padding: contentPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ago, style: TextStyles.overlineGrey),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyles.body1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            weights,
                            style: TextStyles.headline5MenloW900RedAccent,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.current.liftedWeights,
                            style: TextStyles.caption1Grey,
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 48,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        color: Colors.white24,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            duration,
                            style: TextStyles.headline5MenloW900RedAccent,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            S.current.time,
                            style: TextStyles.caption1Grey,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
