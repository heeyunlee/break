import 'package:flutter/material.dart';
import 'package:workout_player/classes/enum/equipment_required.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/styles/text_styles.dart';

class EquipmentRequiredWidget extends StatelessWidget {
  final Routine routine;

  const EquipmentRequiredWidget({
    Key? key,
    required this.routine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    String _equipments = '';
    for (var i = 0; i < routine.equipmentRequired.length; i++) {
      String _equipment;
      if (i == 0) {
        _equipments = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation!;
      } else {
        _equipment = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation!;
        _equipments = _equipments + ', $_equipment';
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.fitness_center_rounded,
            size: 20,
            color: Colors.white,
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: size.width - 68,
            child: Text(
              _equipments,
              style: TextStyles.body1,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
