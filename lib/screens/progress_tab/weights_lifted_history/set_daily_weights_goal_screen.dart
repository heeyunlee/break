import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../styles/constants.dart';

class SetDailyWeightsGoalScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final User user;

  const SetDailyWeightsGoalScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => SetDailyWeightsGoalScreen(
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );

    // await pushNewScreen(
    //   context,
    //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
    //   withNavBar: false,
    //   screen: SetDailyWeightsGoalScreen(
    //     database: database,
    //     auth: auth,
    //     user: user!,
    //   ),
    // );
  }

  @override
  _SetDailyWeightsGoalScreenState createState() =>
      _SetDailyWeightsGoalScreenState();
}

class _SetDailyWeightsGoalScreenState extends State<SetDailyWeightsGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Set',
          style: kSubtitle2,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: const AppbarBlurBG(),
      ),
      body: Center(
        child: Placeholder(),
      ),
    );
  }
}
