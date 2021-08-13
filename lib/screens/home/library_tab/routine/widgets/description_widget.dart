import 'package:flutter/material.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

class DescriptionWidget extends StatelessWidget {
  final Routine routine;

  const DescriptionWidget({
    Key? key,
    required this.routine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (routine.description != null) {
      if (routine.description!.isNotEmpty) {
        return Text(
          routine.description!,
          style: TextStyles.body2_light_grey,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        );
      } else {
        return Text(
          S.current.addDescription,
          style: TextStyles.body2_light_grey,
        );
      }
    } else {
      return Text(S.current.addDescription, style: TextStyles.body2_light_grey);
    }
  }
}
