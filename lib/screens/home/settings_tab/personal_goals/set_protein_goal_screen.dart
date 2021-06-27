import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import 'set_protein_goal_model.dart';

class SetProteinGoalScreen extends StatefulWidget {
  final Database database;
  final AuthBase auth;
  final SetProteinGoalModel model;

  const SetProteinGoalScreen({
    Key? key,
    required this.database,
    required this.auth,
    required this.model,
  }) : super(key: key);

  static Future<void> show(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => SetProteinGoalScreen(
            database: database,
            auth: auth,
            model: watch(setProteinGoalModelProvider),
          ),
        ),
      ),
    );
  }

  @override
  _SetProteinGoalScreenState createState() => _SetProteinGoalScreenState();
}

class _SetProteinGoalScreenState extends State<SetProteinGoalScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.initProteinGoal();
    // widget.model.getProteinGoalFromUserData();
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
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
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
          onPressed: () => widget.model.setProteinGoal(context),
          backgroundColor: kPrimaryColor,
          label: Text(S.current.setGoal, style: TextStyles.button1_bold),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: widget.model.decrementProteinGoal,
                icon: const Icon(
                  Icons.remove_rounded,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(width: 32),
              Text('${widget.model.proteinGoal} g',
                  style: TextStyles.headline4),
              const SizedBox(width: 32),
              IconButton(
                onPressed: widget.model.incrementProteinGoal,
                icon: const Icon(
                  Icons.add_rounded,
                  color: Colors.greenAccent,
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
                S.current.proteins,
                style: TextStyles.headline5,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
