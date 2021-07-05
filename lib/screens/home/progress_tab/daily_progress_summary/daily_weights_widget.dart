import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../progress_tab_model.dart';
import 'daily_summary_numbers_widget.dart';

class DailyWeightsWidget extends StatelessWidget {
  final Database database;
  final AuthBase auth;
  final User user;
  final ProgressTabModel model;

  const DailyWeightsWidget({
    required this.database,
    required this.auth,
    required this.user,
    required this.model,
  });

  static Widget create(
    BuildContext context, {
    required User user,
    required ProgressTabModel model,
  }) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final database = provider.Provider.of<Database>(context, listen: false);

    return DailyWeightsWidget(
      database: database,
      auth: auth,
      user: user,
      model: model,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilderWidget<List<RoutineHistory>?>(
      stream: database.routineHistorySelectedDayStream(model.selectedDate),
      loadingWidget: Container(),
      hasDataWidget: (context, data) {
        int _totalWeights = 0;
        double _weightsProgress = 0;
        String _mainMuscleGroup = '-';

        num _liftingGoal = user.dailyWeightsGoal ?? 20000;

        if (data != null) {
          if (data.isNotEmpty) {
            data.forEach((e) {
              _totalWeights += e.totalWeights.toInt();
            });

            _weightsProgress = _totalWeights / _liftingGoal;
            if (_weightsProgress >= 1) {
              _weightsProgress = 1;
            }

            final latest = data.last;

            final mainMuscleGroup = MainMuscleGroup.values
                .firstWhere((e) => e.toString() == latest.mainMuscleGroup[0])
                .broadGroup!;

            _mainMuscleGroup = mainMuscleGroup;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                if (_mainMuscleGroup == '-')
                  Text('-', style: TextStyles.headline5_w900),
                if (_mainMuscleGroup != '-')
                  SizedBox(
                    width: size.width / 5,
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Text(
                        _mainMuscleGroup,
                        style: TextStyles.headline5_w900,
                      ),
                    ),
                  ),
                CircularPercentIndicator(
                  radius: size.width / 2.4,
                  lineWidth: 12,
                  percent: _weightsProgress,
                  backgroundColor: kPrimaryColor.withOpacity(0.25),
                  progressColor: kPrimaryColor,
                  animation: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                SizedBox(height: size.height / 13),
                SizedBox(
                  height: size.height / 13,
                  child: _buildTotalWeightsWidget(data, _totalWeights),
                ),
                SizedBox(height: size.height / 13),
                SizedBox(height: size.height / 13),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalWeightsWidget(List<RoutineHistory>? data, weights) {
    String? tensOfThousands;
    String? thousands;
    String? hundreds;
    String? tens;
    String? ones;

    if (data != null) {
      int length = weights.toString().length - 1;
      String totalWeightsInString = weights.toString();

      ones = totalWeightsInString[length];
      tens = (length > 0) ? totalWeightsInString[length - 1] : '0';
      hundreds = (length > 1) ? totalWeightsInString[length - 2] : '0';
      thousands = (length > 2) ? totalWeightsInString[length - 3] : '0';
      tensOfThousands = (length > 3) ? totalWeightsInString[length - 4] : '0';
    }

    final unit = Formatter.unitOfMass(user.unitOfMass);

    return DailySummaryNumbersWidget(
      title: S.current.liftedWeights,
      tensOfTousands: tensOfThousands,
      thousands: thousands,
      hundreds: hundreds,
      tens: tens,
      ones: ones,
      unit: unit,
    );
  }
}
