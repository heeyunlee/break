import 'package:flutter/material.dart';
import 'package:workout_player/models/user.dart';

import '../../screens/customize_widgets_screen.dart';

class CustomizeWidgetsButton extends StatelessWidget {
  final User user;

  const CustomizeWidgetsButton({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => CustomizeWidgetsScreen.show(
        context,
        user: user,
      ),
      icon: const Icon(Icons.dashboard_customize_rounded),
    );
  }
}
