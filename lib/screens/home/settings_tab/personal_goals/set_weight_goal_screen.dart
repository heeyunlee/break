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

class SetWeightGoalScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final PersonalGoalsScreenModel model;
  final bool isRoot;
  final User user;

  const SetWeightGoalScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.model,
    required this.isRoot,
    required this.user,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required bool isRoot,
    required User user,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);

    await Navigator.of(context, rootNavigator: isRoot).push(
      CupertinoPageRoute(
        fullscreenDialog: isRoot,
        builder: (context) => Consumer(
          builder: (context, ref, child) => SetWeightGoalScreen(
            database: database,
            auth: auth,
            model: ref.watch(personalGoalsScreenModelProvider),
            isRoot: isRoot,
            user: user,
          ),
        ),
      ),
    );
  }

  @override
  _SetWeightGoalScreenState createState() => _SetWeightGoalScreenState();
}

class _SetWeightGoalScreenState extends State<SetWeightGoalScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.initWeightGoal(context);
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
          onPressed: () => widget.model.setWeightGoal(context),
          backgroundColor: kPrimaryColor,
          label: Text(S.current.setGoal, style: TextStyles.button1_bold),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final formattedWeightGoal = Formatter.weightsWithDecimal(
      widget.model.weightGoal,
    );
    final unit = Formatter.unitOfMass(widget.user.unitOfMass);

    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onLongPressStart: widget.model.onLongPressStartDecrementWeight,
                onLongPressEnd: widget.model.onLongPressEndDecrementWeight,
                child: InkWell(
                  onTap: widget.model.decrementWeightGoal,
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: Icon(
                      Icons.remove_rounded,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 32),
              Text('$formattedWeightGoal $unit', style: TextStyles.headline4),
              const SizedBox(width: 32),
              GestureDetector(
                onLongPressStart: widget.model.onLongPressStartIncrementWeight,
                onLongPressEnd: widget.model.onLongPressEndIncrementWeight,
                child: InkWell(
                  onTap: widget.model.incrementWeightGoal,
                  borderRadius: BorderRadius.circular(32),
                  child: SizedBox(
                    width: 64,
                    height: 64,
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.greenAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 96),
            Center(
              child: Text(
                S.current.weightGoal,
                style: TextStyles.headline5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
