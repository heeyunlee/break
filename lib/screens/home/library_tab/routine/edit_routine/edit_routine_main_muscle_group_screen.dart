import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/screens/home/library_tab/routine/edit_routine/edit_routine_main_muscle_group_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

class EditRoutineMainMuscleGroupScreen extends StatefulWidget {
  final Routine routine;
  final Database database;
  final User user;
  final EditRoutineMainMuscleGroupModel model;

  const EditRoutineMainMuscleGroupScreen({
    Key? key,
    required this.routine,
    required this.database,
    required this.user,
    required this.model,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context, {
    required Routine routine,
  }) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => Consumer(
          builder: (context, watch, child) => EditRoutineMainMuscleGroupScreen(
            database: database,
            routine: routine,
            user: user,
            model: watch(editRoutineMainMuscleGroupModel),
          ),
        ),
      ),
    );
  }

  @override
  _EditRoutineMainMuscleGroupScreenState createState() =>
      _EditRoutineMainMuscleGroupScreenState();
}

class _EditRoutineMainMuscleGroupScreenState
    extends State<EditRoutineMainMuscleGroupScreen> {
  @override
  void initState() {
    super.initState();
    widget.model.init(widget.routine);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(),
        leading: AppBarBackButton(
          onPressed: () => widget.model.submitAndPop(
            context,
            database: widget.database,
            routine: widget.routine,
          ),
        ),
        title: Text(S.current.mainMuscleGroup, style: TextStyles.subtitle1),
      ),
      body: Builder(
        builder: (context) => ListView.builder(
          padding: EdgeInsets.only(
            top: Scaffold.of(context).appBarMaxHeight! + 16,
            bottom: 8,
          ),
          itemCount: MainMuscleGroup.values.length,
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final muscle = MainMuscleGroup.values[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: widget.model.selected(muscle)
                      ? kPrimaryColor
                      : kCardColorLight,
                  child: CheckboxListTile(
                    activeColor: kPrimary700Color,
                    title: Text(muscle.translation!, style: TextStyles.button1),
                    controlAffinity: ListTileControlAffinity.trailing,
                    value: widget.model.selected(muscle),
                    selected: widget.model.selected(muscle),
                    onChanged: (bool? checked) => widget.model
                        .addOrRemoveMainMuscleGroup(checked, muscle),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
