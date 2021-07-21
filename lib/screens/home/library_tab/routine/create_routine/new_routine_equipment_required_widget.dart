import 'package:flutter/material.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/screens/home/library_tab/routine/create_routine/create_new_routine_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class NewRoutineEquipmentRequiredWidget extends StatelessWidget {
  final CreateNewROutineModel model;

  const NewRoutineEquipmentRequiredWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: model.equipmentRequired.keys.map(
              (String key) {
                final title = EquipmentRequired.values
                    .firstWhere((e) => e.toString() == key)
                    .translation;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: (model.equipmentRequired[key]!)
                          ? kPrimaryColor
                          : kGrey700,
                      child: CheckboxListTile(
                        activeColor: kPrimary700Color,
                        title: Text(title!, style: TextStyles.button1),
                        controlAffinity: ListTileControlAffinity.trailing,
                        value: model.equipmentRequired[key],
                        onChanged: (bool? value) =>
                            model.onChangedEquipmentRequired(value, key),
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
