import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/create_new_routine_model.dart';

class ChooseEquipmentRequiredScreen extends ConsumerWidget {
  const ChooseEquipmentRequiredScreen({Key? key}) : super(key: key);

  static void showEquipmentRequired(
    BuildContext context, {
    required CreateNewRoutineModel model,
  }) {
    custmFadeTransition(
      context,
      duration: 500,
      screen: const ChooseEquipmentRequiredScreen(),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(createNewROutineModelProvider);

    return CustomScaffold(
      appBarTitle: S.current.equipmentRequired,
      buildBody: (context) => _buildBody(context, model),
      fabWidget: FloatingActionButton(
        onPressed: () => model.saveEquipmentRequired(context, model),
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
              S.current.chooseEquipmentRequiredMessage,
              style: TextStyles.body1,
            ),
          ),
          CheckboxListView(
            checked: model.selectedEquipmentRequiredEnum.contains,
            items: EquipmentRequired.values,
            onChangedMainMuscleEnum: (checked, equipment) => model
                .onChangedEquipment(checked, equipment as EquipmentRequired),
            getTitle: (muscle) => (muscle as EquipmentRequired).translation!,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
