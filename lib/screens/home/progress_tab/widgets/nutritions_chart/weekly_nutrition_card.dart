import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import 'protein_entries_screen.dart';
import 'weekly_nutrition_chart.dart';
import 'weekly_nutrition_chart_model.dart';

class WeeklyNutritionCard extends StatelessWidget {
  final AuthBase auth;
  final Database database;
  final User user;
  // final double gridHeight;
  // final double gridWidth;

  const WeeklyNutritionCard({
    Key? key,
    required this.auth,
    required this.database,
    required this.user,
    // required this.gridHeight,
    // required this.gridWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlurBackgroundCard(
      // width: gridWidth,
      // height: gridHeight / 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => ProteinEntriesScreen.show(context),
              child: Wrap(
                children: [
                  SizedBox(
                    height: 48,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.restaurant_menu_rounded,
                          color: Colors.greenAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.current.addProteins,
                          style: kSubtitle1w900GreenAc,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.greenAccent,
                            size: 16,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 32),
                    child: Text(
                      S.current.proteinChartContentText,
                      style: TextStyles.body2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Consumer(
              builder: (context, ref, child) =>
                  CustomStreamBuilderWidget<List<Nutrition>?>(
                stream: database.thisWeeksNutritionsStream(),
                hasDataWidget: (context, data) => WeeklyNutritionChart(
                  nutritions: data!,
                  user: user,
                  model: ref.watch(weeklyNutritionChartModelProvider),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
