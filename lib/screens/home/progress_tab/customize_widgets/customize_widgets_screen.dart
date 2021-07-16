import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/appbar_close_button.dart';

class CustomizeWidgetsScreen extends StatefulWidget {
  const CustomizeWidgetsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => CustomizeWidgetsScreen(),
      ),
    );
  }

  @override
  _CustomizeWidgetsScreenState createState() => _CustomizeWidgetsScreenState();
}

class _CustomizeWidgetsScreenState extends State<CustomizeWidgetsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        leading: const AppBarCloseButton(),
      ),
    );
  }
}
