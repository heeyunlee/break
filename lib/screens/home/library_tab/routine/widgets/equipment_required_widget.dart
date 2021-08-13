import 'package:flutter/material.dart';
import 'package:workout_player/classes/routine.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class EquipmentRequiredWidget extends StatelessWidget {
  final Routine routine;

  const EquipmentRequiredWidget({
    Key? key,
    required this.routine,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final equipments = Formatter.getJoinedEquipmentsRequired(
      routine.equipmentRequired,
      routine.equipmentRequiredEnum,
    );

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
              equipments,
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
