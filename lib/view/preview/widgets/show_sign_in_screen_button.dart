import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/providers.dart' show previewModelProvider;
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class ShowSignInScreenButton extends ConsumerWidget {
  const ShowSignInScreenButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(previewModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: OutlinedButton(
        style: ButtonStyles.elevatedFullWidth(context),
        onPressed: () => model.onPressed(context),
        child: Text(
          (model.currentPageIndex == 2) ? S.current.getStarted : S.current.next,
          style: TextStyles.button1,
        ),
      ),
    );
  }
}
