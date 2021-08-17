import 'package:timeago/timeago.dart' as timeago;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/progress_tab_class.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/cards/blur_background_card.dart';
import 'package:collection/collection.dart';

import '../../../../view/screens/routine_histories_screen.dart';

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

    RoutineHistory? last = data.routineHistories.lastOrNull;

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
                          Formatter.routineHistoryWeights(last),
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
                          Formatter.durationInMin(last?.totalDuration),
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
