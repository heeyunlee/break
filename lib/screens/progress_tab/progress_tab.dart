import 'package:flutter/material.dart';
import 'package:workout_player/common_widgets/speed_dial_fab.dart';

import '../../constants.dart';

class ProgressTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('LibraryTab scaffold building...');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        body: Placeholder(),
        floatingActionButton: SpeedDialFAB(),
      ),
    );
  }
}
