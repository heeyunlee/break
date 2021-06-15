import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/empty_content.dart';

import '../../../styles/constants.dart';
import '../../../utils/formatter.dart';
import 'daily_summary_numbers_widget.dart';

class DailyWeightsWidget extends ConsumerWidget {
  final User user;

  const DailyWeightsWidget({required this.user});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final uid = watch(authServiceProvider).currentUser!.uid;
    final routineHistoriesStream = watch(todaysRHStreamProvider(uid));

    int _totalWeights = 0;
    double _weightsProgress = 0;
    String _mainMuscleGroup = '-';

    return routineHistoriesStream.when(
      loading: () => Container(),
      error: (e, stack) {
        logger.e(e);
        return EmptyContent(message: e.toString());
      },
      data: (routineHistories) {
        if (routineHistories != null) {
          if (routineHistories.isNotEmpty) {
            routineHistories.forEach((e) {
              _totalWeights += e.totalWeights.toInt();
            });

            _weightsProgress = _totalWeights / 20000;
            if (_weightsProgress >= 1) {
              _weightsProgress = 1;
            }

            final latest = routineHistories.last;

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
                if (_mainMuscleGroup == '-') Text('-', style: kHeadline5w900),
                if (_mainMuscleGroup != '-')
                  SizedBox(
                    width: size.width / 5,
                    child: FittedBox(
                      alignment: Alignment.center,
                      child: Text(_mainMuscleGroup, style: kHeadline5w900),
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
                SizedBox(height: size.height / 14),
                SizedBox(
                  height: size.height / 14,
                  child: _buildTotalWeightsWidget(
                    routineHistories,
                    _totalWeights,
                  ),
                ),
                SizedBox(height: size.height / 14),
                SizedBox(height: size.height / 14),
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
