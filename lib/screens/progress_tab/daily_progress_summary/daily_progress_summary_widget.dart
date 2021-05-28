import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/constants.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import 'daily_summary_numbers_widget.dart';

class DailyProgressSummaryWidget extends StatefulWidget {
  final User user;

  DailyProgressSummaryWidget({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  _DailyProgressSummaryWidgetState createState() =>
      _DailyProgressSummaryWidgetState();
}

class _DailyProgressSummaryWidgetState
    extends State<DailyProgressSummaryWidget> {
  late int _totalWeights = 0;
  late double _weightsProgress = 0;
  bool _totalWeightsCalculated = false;
  late int _totalProteins = 0;
  late double _proteinsProgress = 0;
  bool _totalProteinsCalculated = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final uid = watch(authServiceProvider).currentUser!.uid;
        final routineHistoriesStream = watch(todaysRHStreamProvider(uid));
        final nutritionsStream = watch(todaysNutritionStreamProvider(uid));

        return routineHistoriesStream.when(
          data: (routineHistories) => nutritionsStream.when(
            data: (nutritions) => _buildChild(
              context,
              routineHistories,
              nutritions,
            ),
            loading: () => ProgressTabShimmer(),
            error: (e, stack) => EmptyContent(message: e.toString()),
          ),
          loading: () => ProgressTabShimmer(),
          error: (e, stack) => EmptyContent(message: e.toString()),
        );
      },
    );
  }

  Widget _buildChild(
    BuildContext context,
    List<RoutineHistory>? routineHistories,
    List<Nutrition>? nutritions,
  ) {
    if (!_totalWeightsCalculated) {
      if (routineHistories != null) {
        routineHistories.forEach((e) {
          _totalWeights += e.totalWeights.toInt();
        });
        _weightsProgress = _totalWeights / 20000;
        if (_weightsProgress >= 0) {
          _weightsProgress = 1;
        }
      }
      _totalWeightsCalculated = true;
    }

    if (!_totalProteinsCalculated) {
      if (nutritions != null) {
        nutritions.forEach((e) {
          _totalProteins += e.proteinAmount.toInt();
        });
        _proteinsProgress = _totalProteins / 150;
        if (_proteinsProgress >= 1) {
          _proteinsProgress = 1;
        }
      }
      _totalProteinsCalculated = true;
    }

    final size = MediaQuery.of(context).size;
    final String today = DateFormat.MMMEd().format(DateTime.now());

    return Container(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.current.progressTabIntroduction(widget.user.displayName),
                  style: kHeadline6,
                ),
                const Spacer(),
                Text(today, style: kBodyText1),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text('-', style: kHeadline4Bold),
                            CircularPercentIndicator(
                              radius: size.width / 2.7,
                              lineWidth: 12,
                              percent: _proteinsProgress,
                              backgroundColor:
                                  Colors.greenAccent.withOpacity(0.25),
                              progressColor: Colors.greenAccent,
                              animation: true,
                              animationDuration: 1000,
                              circularStrokeCap: CircularStrokeCap.round,
                            ),
                            CircularPercentIndicator(
                              radius: size.width / 2.2,
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
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildTotalWeightsWidget(routineHistories),
                            const SizedBox(height: 16),
                            _buildTotalNutritionWidget(nutritions),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 96),
                  Center(
                    child: SvgPicture.asset(
                      'assets/images/person_lifting.svg',
                      width: size.width / 2.5,
                      height: size.width / 2.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalWeightsWidget(List<RoutineHistory>? data) {
    String? tensOfThousands;
    String? thousands;
    String? hundreds;
    String? tens;
    String? ones;

    if (data != null) {
      int length = _totalWeights.toString().length - 1;
      String totalWeightsInString = _totalWeights.toString();

      ones = totalWeightsInString[length];
      tens = (length > 0) ? totalWeightsInString[length - 1] : null;
      hundreds = (length > 1) ? totalWeightsInString[length - 2] : null;
      thousands = (length > 2) ? totalWeightsInString[length - 3] : null;
      tensOfThousands = (length > 3) ? totalWeightsInString[length - 4] : null;
    }

    final unit = Format.unitOfMass(widget.user.unitOfMass);

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

  Widget _buildTotalNutritionWidget(List<Nutrition>? data) {
    String? hundreds;
    String? tens;
    String? ones;

    if (data != null) {
      int length = _totalProteins.toString().length - 1;
      String totalProteinsInString = _totalProteins.toString();

      ones = totalProteinsInString[length];
      tens = (length > 0) ? totalProteinsInString[length - 1] : '0';
      hundreds = (length > 1) ? totalProteinsInString[length - 2] : '0';
    }

    return DailySummaryNumbersWidget(
      title: S.current.proteins,
      backgroundColor: Colors.greenAccent,
      textStyle: kBodyText1Menlo.copyWith(color: Colors.blueGrey),
      hundreds: hundreds,
      tens: tens,
      ones: ones,
      unit: 'g',
    );
  }
}
