import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

import '../widgets.dart';

class NutritionTotalFatListTile extends StatelessWidget {
  const NutritionTotalFatListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final isOwner = auth.currentUser?.uid == nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showModalPopup(context) : null,
      title: Text(
        S.current.totalFat,
        style: TextStyles.body2,
      ),
      trailing: Text(
        NutritionsDetailScreenModel.totalFat(nutrition),
        style: TextStyles.caption1Grey,
      ),
    );
  }

  Future<void> showModalPopup(BuildContext context) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, watch, child) {
            final model = watch(editNutritionModelProvider(nutrition));

            return NumberPickerBottomSheet(
              numValue: nutrition.fat,
              intMaxValue: 300,
              model: model,
              title: S.current.totalFat,
              color: Colors.greenAccent,
              onIntChanged: model.onFatIntChanged,
              onDecimalChanged: model.onFatDecimalChanged,
            );
          },
        );
      },
    );
  }
}
