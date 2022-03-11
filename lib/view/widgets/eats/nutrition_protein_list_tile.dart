import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';

import '../widgets.dart';

class NutritionProteinListTile extends ConsumerWidget {
  const NutritionProteinListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final isOwner = auth.currentUser?.uid == nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showModalPopup(context) : null,
      title: Text(
        S.current.protein,
        style: TextStyles.body2,
      ),
      trailing: Text(
        NutritionsDetailScreenModel.totalProtein(nutrition),
        style: TextStyles.caption1Grey,
      ),
    );
  }

  Future<void> showModalPopup(BuildContext context) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(editNutritionModelProvider(nutrition));

            return NumberPickerBottomSheet(
              numValue: nutrition.proteinAmount,
              model: model,
              intMaxValue: 300,
              title: S.current.protein,
              color: Colors.greenAccent,
              onIntChanged: model.onProteinsIntChanged,
              onDecimalChanged: model.onProteinsDecimalChanged,
            );
          },
        );
      },
    );
  }
}
