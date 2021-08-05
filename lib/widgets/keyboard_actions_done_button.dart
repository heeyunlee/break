import 'package:flutter/material.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';

class KeyboardActionsDoneButton extends StatelessWidget {
  final void Function() onTap;

  const KeyboardActionsDoneButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Text(S.current.done, style: TextStyles.button1),
      ),
    );
  }
}
