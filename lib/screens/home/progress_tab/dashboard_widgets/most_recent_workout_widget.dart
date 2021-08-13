import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/combined/progress_tab_class.dart';
import 'package:workout_player/classes/routine_history.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';

import 'detail_screens/routine_histories_screen.dart';

class MostRecentWorkout extends StatelessWidget {
  final BoxConstraints constraints;
  final ProgressTabClass data;

  const MostRecentWorkout({
    Key? key,
    required this.constraints,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final heightFactor = (constraints.maxHeight > 600) ? 4 : 3.5;

    timeago.setLocaleMessages('en', timeago.EnMessages());
    timeago.setLocaleMessages('ko', timeago.KoMessages());
    final locale = Intl.getCurrentLocale();

    RoutineHistory? last =
        data.routineHistories.isEmpty ? null : data.routineHistories.last;

    final weight = Formatter.numWithDecimal(last?.totalWeights ?? 0);
    final unit = Formatter.unitOfMass(
      last?.unitOfMass,
      last?.unitOfMassEnum,
    );
    final time = Formatter.durationInMin(last?.totalDuration ?? 0);

    String ago = (last != null)
        ? timeago.format(last.workoutEndTime.toDate(), locale: locale)
        : '';

    String title = last?.routineTitle ?? 'No recent workout yet!';

    return SizedBox(
      height: constraints.maxHeight / heightFactor,
      width: constraints.maxWidth,
      child: BlurBackgroundCard(
        onTap: () => RoutineHistoriesScreen.show(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title, style: TextStyles.body1),
                  Text(ago, style: TextStyles.overline_grey),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$weight $unit',
                          style: TextStyles.headline5_menlo_w900_primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.current.liftedWeights,
                          style: TextStyles.caption1_grey,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$time ${S.current.minutes}',
                          style: TextStyles.headline5_menlo_w900_primary,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          S.current.time,
                          style: TextStyles.caption1_grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
