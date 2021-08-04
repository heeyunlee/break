import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/reusable_screens/choose_title_screen.dart';

import 'create_new_routine_model.dart';

class CreateNewRoutineListTile extends StatelessWidget {
  const CreateNewRoutineListTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => ChooseTitleScreen.show<CreateNewRoutineModel>(
        context,
        formKey: CreateNewRoutineModel.formKey,
        provider: createNewROutineModelProvider,
        appBarTitle: S.current.routineTitleTitle,
        hintText: S.current.routineTitleHintText,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Card(
          color: Colors.transparent,
          elevation: 0,
          child: Row(
            children: <Widget>[
              Container(
                width: 64,
                height: 64,
                child: const Icon(Icons.add_rounded, size: 32),
              ),
              const SizedBox(width: 16),
              Text(S.current.createNewRoutine, style: TextStyles.body1_bold),
            ],
          ),
        ),
      ),
    );
  }
}
