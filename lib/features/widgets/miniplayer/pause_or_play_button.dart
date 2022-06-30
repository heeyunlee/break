import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';

import '../../../../view_models/miniplayer_model.dart';

class PauseOrPlayButton extends StatefulWidget {
  const PauseOrPlayButton({
    Key? key,
    this.iconSize = 56,
    required this.model,
  }) : super(key: key);

  final double? iconSize;
  final MiniplayerModel model;

  @override
  State<PauseOrPlayButton> createState() => _PauseOrPlayButtonState();
}

class _PauseOrPlayButtonState extends State<PauseOrPlayButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this);
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      verticalOffset: -56,
      message: (widget.model.isWorkoutPaused)
          ? S.current.pauseWorkout
          : S.current.resumeWorkout,
      child: IconButton(
        color: Colors.white,
        onPressed: widget.model.pauseOrPlay,
        iconSize: widget.iconSize!,
        icon: AnimatedIcon(
          icon: AnimatedIcons.pause_play,
          progress: widget.model.animationController,
        ),
      ),
    );
  }
}
