import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import '../widgets.dart';

class NutritionLoggedDateListTile extends ConsumerWidget {
  const NutritionLoggedDateListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final isOwner = auth.currentUser?.uid == nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showPopUp(context) : null,
      title: Text(S.current.date, style: TextStyles.body1),
      trailing: Text(
        Formatter.yMdjm(nutrition.loggedTime),
        style: TextStyles.body2Grey,
      ),
    );
  }

  Future<void> showPopUp(BuildContext context) async {
    return showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final model = ref.watch(editNutritionModelProvider(nutrition));

            return AdaptiveDatePicker(
              showButton: true,
              initialDateTime: nutrition.loggedTime.toDate(),
              onDateTimeChanged: model.onDateTimeChanged,
              onSave: () => model.onPressSave(context),
            );
          },
        );
      },
    );
  }
}
