import 'package:flutter/material.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view/screens/choose_background_screen.dart';

class ChooseBackgroundButton extends StatelessWidget {
  final User user;

  const ChooseBackgroundButton({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => ChooseBackgroundScreen.show(
        context,
        user: user,
      ),
      icon: const Icon(Icons.wallpaper_rounded),
    );
  }
}
