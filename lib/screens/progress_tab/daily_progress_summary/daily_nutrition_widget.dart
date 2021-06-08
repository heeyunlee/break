import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/empty_content.dart';

import '../../../constants.dart';
import 'daily_summary_numbers_widget.dart';

class DailyNutritionWidget extends ConsumerWidget {
  final User user;

  const DailyNutritionWidget({required this.user});

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final size = MediaQuery.of(context).size;

    final uid = watch(authServiceProvider).currentUser!.uid;
    final nutritionsStream = watch(todaysNutritionStreamProvider(uid));

    late int _totalProteins = 0;
    late double _proteinsProgress = 0;

    return nutritionsStream.when(
      loading: () => Container(),
      error: (e, stack) => EmptyContent(message: e.toString()),
      data: (nutritions) {
        if (nutritions != null) {
          nutritions.forEach((e) {
            _totalProteins += e.proteinAmount.toInt();
          });
          _proteinsProgress = _totalProteins / 150;
          if (_proteinsProgress >= 1) {
            _proteinsProgress = 1;
          }
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width / 2.2,
              child: Center(
                child: CircularPercentIndicator(
                  radius: size.width / 2.7,
                  lineWidth: 12,
                  percent: _proteinsProgress,
                  backgroundColor: Colors.greenAccent.withOpacity(0.25),
                  progressColor: Colors.greenAccent,
                  animation: true,
                  animationDuration: 1000,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              children: [
                SizedBox(height: size.height / 12),
                SizedBox(height: size.height / 12),
                SizedBox(
                  height: size.height / 12,
                  child: _buildTotalNutritionWidget(nutritions, _totalProteins),
                ),
                SizedBox(height: size.height / 12),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTotalNutritionWidget(List<Nutrition>? data, int proteins) {
    String? hundreds;
    String? tens;
    String? ones;

    if (data != null) {
      int length = proteins.toString().length - 1;
      String totalProteinsInString = proteins.toString();

      ones = totalProteinsInString[length];
      tens = (length > 0) ? totalProteinsInString[length - 1] : '0';
      hundreds = (length > 1) ? totalProteinsInString[length - 2] : '0';
    }

    return DailySummaryNumbersWidget(
      title: S.current.proteins,
      backgroundColor: Colors.greenAccent,
      textStyle: kBodyText1Menlo.copyWith(color: Colors.deepPurpleAccent),
      hundreds: hundreds,
      tens: tens,
      ones: ones,
      unit: 'g',
    );
  }
}
