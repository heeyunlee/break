import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/nutrition.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import '../widgets.dart';

class NutritionLoggedDateListTile extends ConsumerStatefulWidget {
  const NutritionLoggedDateListTile({
    required this.nutrition,
    super.key,
  });

  final Nutrition nutrition;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NutritionLoggedDateListTileState();
}

class _NutritionLoggedDateListTileState
    extends ConsumerState<NutritionLoggedDateListTile> {
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(firebaseAuthProvider);
    final isOwner = auth.currentUser?.uid == widget.nutrition.userId;

    return ListTile(
      onTap: isOwner ? () => showPopUp(context) : null,
      title: Text(S.current.date, style: TextStyles.body1),
      trailing: Text(
        Formatter.yMdjm(widget.nutrition.loggedTime),
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
            final model = ref.watch(
              editNutritionModelProvider(widget.nutrition),
            );

            return AdaptiveDatePicker(
              showButton: true,
              initialDateTime: widget.nutrition.loggedTime.toDate(),
              onDateTimeChanged: model.onDateTimeChanged,
              // onSave: () => model.onPressSave(context),
              onSave: () async {
                final status = await model.onPressSave();

                if (!mounted) return;

                if (status.statusCode == 200) {
                  Navigator.of(context).pop();
                } else {
                  await showExceptionAlertDialog(
                    context,
                    title: S.current.operationFailed,
                    exception: status.exception.toString(),
                  );
                }
              },
            );
          },
        );
      },
    );
  }
}
