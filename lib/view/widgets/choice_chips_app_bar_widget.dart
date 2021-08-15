import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class ChoiceChipsAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String selectedChip;
  final void Function(bool selected, String string) onSelected;

  const ChoiceChipsAppBarWidget({
    Key? key,
    required this.selectedChip,
    required this.onSelected,
  }) : super(key: key);

  @override
  Size get preferredSize {
    return Size.fromHeight(64.0);
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _mainMuscleGroup = [
      'Saved',
      'All',
      ...MainMuscleGroup.values[0].list,
    ];

    final List<Widget> chips = _mainMuscleGroup.map((string) {
      final label = (string == 'All')
          ? S.current.all
          : (string == 'Saved')
              ? S.current.saved
              : MainMuscleGroup.values
                  .firstWhere((element) => element.toString() == string)
                  .translation!;

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: ChoiceChip(
          backgroundColor: kAppBarColor,
          selectedColor: kPrimaryColor,
          label: Text(label, style: TextStyles.button1),
          labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          shape: StadiumBorder(
            side: BorderSide(
              color: (selectedChip == string) ? kPrimary300Color : Colors.grey,
              width: 1,
            ),
          ),
          selected: selectedChip == string,
          onSelected: (bool selected) => onSelected(selected, string),
        ),
      );
    }).toList();

    return PreferredSize(
      preferredSize: Size.fromHeight(64),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(children: chips),
        ),
      ),
    );
  }
}
