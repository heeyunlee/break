import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';

import '../buttons.dart';

class SaveAndExitButton extends ConsumerWidget {
  const SaveAndExitButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(miniplayerModelProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: MaxWidthRaisedButton(
        width: double.infinity,
        buttonText: S.current.saveAndEndWorkout,
        color: Colors.grey[700],
        onPressed: () => model.submit(context, user),
      ),
    );
  }
}
