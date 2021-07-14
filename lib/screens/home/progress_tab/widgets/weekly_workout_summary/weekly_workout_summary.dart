import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/auth_and_database.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/weekly_weights_lifted_chart/routine_histories_screen.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import 'weekly_workout_summary_model.dart';

class WeeklyWorkoutWidget extends StatefulWidget {
  final AuthBase auth;
  final Database database;
  final User user;
  final WeeklyWorkoutSummaryModel model;

  const WeeklyWorkoutWidget({
    Key? key,
    required this.auth,
    required this.database,
    required this.user,
    required this.model,
  }) : super(key: key);

  static Widget create(
    AuthAndDatabase authAndDatabase,
    User user,
  ) {
    return Consumer(
      builder: (context, ref, child) => WeeklyWorkoutWidget(
        auth: authAndDatabase.auth,
        database: authAndDatabase.database,
        user: user,
        model: ref.watch(weeklyWorkoutSummaryModelProvider),
      ),
    );
  }

  @override
  _WeeklyWorkoutWidgetState createState() => _WeeklyWorkoutWidgetState();
}

class _WeeklyWorkoutWidgetState extends State<WeeklyWorkoutWidget> {
  @override
  void initState() {
    super.initState();
    widget.model.init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomStreamBuilderWidget<List<RoutineHistory?>>(
      stream: widget.database.routineHistoriesThisWeekStream(),
      hasDataWidget: (context, data) {
        final locale = Intl.getCurrentLocale();

        widget.model.setData(data, locale);

        return BlurBackgroundCard(
          onLongPress: () {
            print('on long press');
          },
          onTap: () => RoutineHistoriesScreen.show(context),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.local_fire_department_rounded,
                        color: kPrimaryColor,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        S.current.wokroutsThisWeek,
                        style: kSubtitle1w900Primary,
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: kPrimaryColor,
                        size: 16,
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    7,
                    (index) => Column(
                      children: [
                        Text(
                          widget.model.daysOfTheWeek[index],
                          style: TextStyles.body2_grey_bold,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: CircleAvatar(
                            backgroundColor:
                                (widget.model.weeklyWorkedOutMuscles[index] !=
                                        null)
                                    ? kPrimaryColor
                                    : Colors.transparent,
                            // maxRadius: widget.model.radiuses[index],
                            maxRadius: 16,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: FittedBox(
                                child: Text(
                                  widget.model.weeklyWorkedOutMuscles[index] ??
                                      widget.model.dates[index].day.toString(),
                                  style: TextStyles.caption1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
