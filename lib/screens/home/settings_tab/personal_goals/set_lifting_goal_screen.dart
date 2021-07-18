import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

import 'personal_goals_screen_model.dart';

class SetLiftingGoalScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final PersonalGoalsScreenModel model;
  final User user;
  final bool isRoot;

  const SetLiftingGoalScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.model,
    required this.user,
    required this.isRoot,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required User user,
    required bool isRoot,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context, rootNavigator: isRoot).push(
      CupertinoPageRoute(
        fullscreenDialog: isRoot,
        builder: (context) => Consumer(
          builder: (context, watch, child) => SetLiftingGoalScreen(
            database: database,
            auth: auth,
            model: watch(personalGoalsScreenModelProvider),
            user: user,
            isRoot: isRoot,
          ),
        ),
      ),
    );
  }

  @override
  _SetLiftingGoalScreenState createState() => _SetLiftingGoalScreenState();
}

class _SetLiftingGoalScreenState extends State<SetLiftingGoalScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.initLiftingGoal();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            (!widget.isRoot)
                ? Icons.arrow_back_ios_rounded
                : Icons.close_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) => _buildBody(context),
      ),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: () => widget.model.setLiftingGoal(context),
          backgroundColor: kPrimaryColor,
          label: Text(S.current.setGoal, style: TextStyles.button1_bold),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final unit = Formatter.unitOfMass(widget.user.unitOfMass);
    final formatted = Formatter.weights(widget.model.liftingGoal);

    return Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPressStart:
                      widget.model.onLongPressStartDecrementLifting,
                  onLongPressEnd: widget.model.onLongPressEndDecrementLifting,
                  child: InkWell(
                    onTap: widget.model.decrementLiftingGoal,
                    borderRadius: BorderRadius.circular(32),
                    child: const SizedBox(
                      width: 64,
                      height: 64,
                      child: Icon(
                        Icons.remove_rounded,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '$formatted $unit',
                      style: TextStyles.headline4,
                    ),
                  ),
                ),
                GestureDetector(
                  onLongPressStart:
                      widget.model.onLongPressStartIncrementLifting,
                  onLongPressEnd: widget.model.onLongPressEndIncrementLifting,
                  child: InkWell(
                    onTap: widget.model.incrementLiftingGoal,
                    borderRadius: BorderRadius.circular(32),
                    child: const SizedBox(
                      width: 64,
                      height: 64,
                      child: Icon(
                        Icons.add_rounded,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 96),
            Center(
              child: Text(S.current.liftingGoal, style: TextStyles.headline5),
            ),
          ],
        ),
      ],
    );
  }
}
