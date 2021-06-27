import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/screens/miniplayer/workout_miniplayer_provider.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_adaptive_modal_bottom_sheet.dart';

class CloseMiniplayerButton extends StatelessWidget {
  Future<bool?> _closeModalBottomSheet(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      title: Text(
        S.current.endWorkoutWarningMessage,
        textAlign: TextAlign.center,
      ),
      firstActionText: S.current.stopTheWorkout,
      isFirstActionDefault: false,
      firstActionOnPressed: () {
        Navigator.of(context).pop();

        context
            .read(miniplayerProviderNotifierProvider.notifier)
            .makeValuesNull();
        context.read(miniplayerIndexProvider).setEveryIndexToDefault(1);
        context.read(restTimerDurationProvider).state = null;

        getSnackbarWidget(
          S.current.cancelWorkoutSnackbarTitle,
          S.current.cancelWorkoutSnackbarMessage,
        );
      },
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: ElevatedButton(
        onPressed: () => _closeModalBottomSheet(context),
        style: ElevatedButton.styleFrom(
          primary: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          S.current.endMiniplayerButtonText,
          style: TextStyles.button1,
        ),
      ),
    );
  }
}
