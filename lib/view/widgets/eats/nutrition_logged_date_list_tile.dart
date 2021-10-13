import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';

import '../widgets.dart';

class NutritionLoggedDateListTile extends StatelessWidget {
  const NutritionLoggedDateListTile({
    Key? key,
    required this.nutrition,
  }) : super(key: key);

  final Nutrition nutrition;

  @override
  Widget build(BuildContext context) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
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
          builder: (context, watch, child) {
            final model = watch(
              editNutritionEntryScreenModelProvider(nutrition),
            );

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
