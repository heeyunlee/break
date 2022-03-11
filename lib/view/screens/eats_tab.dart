import 'package:flutter/material.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class EatsTab extends StatefulWidget {
  const EatsTab({Key? key}) : super(key: key);

  @override
  _EatsTabTabState createState() => _EatsTabTabState();
}

class _EatsTabTabState extends State<EatsTab> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: EatsTabBodyWidget(),
    );
  }
}
