import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/create_new_routine_model.dart';

class ChooseMainMuscleGroupScreen extends ConsumerWidget {
  const ChooseMainMuscleGroupScreen({
    Key? key,
    required this.animation,
  }) : super(key: key);

  final Animation<double> animation;

  static void showMainMuscleGroup(
    BuildContext context, {
    required CreateNewRoutineModel model,
  }) {
    customFadeTransition(
      context,
      duration: 500,
      screenBuilder: (animation) => ChooseMainMuscleGroupScreen(
        animation: animation,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(createNewROutineModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: Text(S.current.mainMuscleGroup, style: TextStyles.subtitle2),
      ),
      body: Builder(builder: (context) => _buildBody(context, model)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => model.saveMainMuscleGroup(context, model),
        child: const Icon(Icons.arrow_forward_rounded),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateNewRoutineModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: Scaffold.of(context).appBarMaxHeight),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.current.chooseMainMuscleGroupMessage,
              style: TextStyles.body1,
            ),
          ),
          CheckboxListView(
            animation: animation,
            checked: model.selectedMainMuscleGroupEnum.contains,
            items: MainMuscleGroup.values,
            onChangedMainMuscleEnum: (checked, muscle) =>
                model.onChangedMuscleGroup(checked, muscle as MainMuscleGroup),
            getTitle: (muscle) => (muscle as MainMuscleGroup).translation!,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
