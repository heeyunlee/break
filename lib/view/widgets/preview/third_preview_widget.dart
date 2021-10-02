import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/view/widgets/eats.dart';

class ThirdPreviewWidget extends StatelessWidget {
  const ThirdPreviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: size.height / 3),
          Text(
            S.current.recordConsumedNutritions,
            style: TextStyles.body1Menlo,
          ),
          SizedBox(height: size.height / 6),
          // ...List.generate(
          //   DummyData.nutritions.length,
          //   (index) => NutritionsListTile(
          //     isPreview: true,
          //     nutrition: DummyData.nutritionDummyData,
          //   ),
          // ),
          ...DummyData.nutritions
              .map(
                (nutrition) => NutritionsListTile(
                  isPreview: true,
                  nutrition: nutrition,
                ),
              )
              .toList(),
          SizedBox(height: size.height / 6),
        ],
      ),
    );
  }
}
