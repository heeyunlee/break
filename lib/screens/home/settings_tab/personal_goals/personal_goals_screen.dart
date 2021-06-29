import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/set_protein_goal_screen.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../../styles/constants.dart';
import 'set_lifting_goal_screen.dart';

class PersonalGoalsScreen extends StatelessWidget {
  final Database database;
  final AuthBase auth;
  final bool isRoot;

  const PersonalGoalsScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.isRoot,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {required bool isRoot}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: isRoot).push(
      CupertinoPageRoute(
        fullscreenDialog: isRoot,
        builder: (context) => PersonalGoalsScreen(
          database: database,
          auth: auth,
          isRoot: isRoot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        flexibleSpace: AppbarBlurBG(),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: (isRoot)
              ? Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                )
              : Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(S.current.personalGoals, style: kSubtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<User?>(
      initialData: userDummyData,
      stream: database.userStream(),
      builder: (context, snapshot) {
        final unit = Formatter.unitOfMass(snapshot.data!.unitOfMass);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),
              ListTile(
                onTap: () => SetProteinGoalScreen.show(
                  context,
                  isRoot: !isRoot,
                ),
                leading: const Icon(
                  Icons.restaurant_menu_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  S.current.proteinsGoal,
                  style: TextStyles.body2,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (snapshot.data!.dailyProteinGoal != null)
                      Text(
                        '${snapshot.data!.dailyProteinGoal!} g',
                        style: kBodyText2Grey,
                      ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ),
              ListTile(
                onTap: () => SetLiftingGoalScreen.show(
                  context,
                  user: snapshot.data!,
                  isRoot: !isRoot,
                ),
                leading: const Icon(
                  Icons.fitness_center_rounded,
                  color: Colors.white,
                ),
                title: Text(
                  S.current.liftingGoal,
                  style: TextStyles.body2,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (snapshot.data!.dailyWeightsGoal != null)
                      Text(
                        '${Formatter.weights(snapshot.data!.dailyWeightsGoal!)} $unit',
                        style: kBodyText2Grey,
                      ),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ],
                ),
              ),
              // const Divider(color: kGrey700, indent: 16, endIndent: 16),
            ],
          ),
        );
      },
    );
  }
}
