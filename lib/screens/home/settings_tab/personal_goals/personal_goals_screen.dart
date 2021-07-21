import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/set_body_fat_percentage_screen.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/set_protein_goal_screen.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../../../../styles/constants.dart';
import 'set_lifting_goal_screen.dart';
import 'set_weight_goal_screen.dart';

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
        title: Text(S.current.personalGoals, style: TextStyles.subtitle1),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomStreamBuilderWidget<User?>(
      initialData: userDummyData,
      stream: database.userStream(),
      hasDataWidget: (context, user) {
        final unit = Formatter.unitOfMass(user!.unitOfMass);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),

              // WEIGHT GOAL
              ListTile(
                onTap: () => SetWeightGoalScreen.show(
                  context,
                  isRoot: !isRoot,
                  user: user,
                ),
                leading: const Icon(
                  Icons.monitor_weight_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  S.current.weightGoal,
                  style: TextStyles.body2,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (user.weightGoal != null)
                      Text(
                        '${Formatter.weightsWithDecimal(user.weightGoal!)} $unit',
                        style: TextStyles.body2_grey,
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

              // BODY FAT PERCENTAGE GOAL
              ListTile(
                onTap: () => SetBodyFatPercentageScreen.show(
                  context,
                  isRoot: !isRoot,
                  user: user,
                ),
                leading: const Icon(
                  Icons.monitor_weight_outlined,
                  color: Colors.white,
                ),
                title: Text(
                  S.current.bodyFatGoal,
                  style: TextStyles.body2,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (user.bodyFatPercentageGoal != null)
                      Text(
                        '${Formatter.weightsWithDecimal(user.bodyFatPercentageGoal!)} %',
                        style: TextStyles.body2_grey,
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

              // PROTEIN GOAL
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
                    if (user.dailyProteinGoal != null)
                      Text(
                        '${user.dailyProteinGoal!} g',
                        style: TextStyles.body2_grey,
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

              // LIFTING GOAL
              ListTile(
                onTap: () => SetLiftingGoalScreen.show(
                  context,
                  user: user,
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
                    if (user.dailyWeightsGoal != null)
                      Text(
                        '${Formatter.weights(user.dailyWeightsGoal!)} $unit',
                        style: TextStyles.body2_grey,
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
            ],
          ),
        );
      },
    );
  }
}
