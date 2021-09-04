import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';

class RestTimerWidget extends StatelessWidget {
  final MiniplayerModel model;

  const RestTimerWidget({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paddingFactor = (size.height > 700) ? 56 : 104;

    return Card(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
      child: SizedBox(
        width: size.width - paddingFactor,
        height: size.width - paddingFactor,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CircularCountDownTimer(
            textStyle: TextStyles.headline2,
            controller: model.countDownController,
            width: 280,
            height: 280,
            duration: model.restTime!.inSeconds,
            fillColor: Colors.grey[600]!,
            ringColor: Colors.red,
            isReverse: true,
            strokeWidth: 8,
            onComplete: () => model.timerOnComplete(context),
          ),
        ),
      ),
    );
  }
}
