import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../styles/constants.dart';
import '../models/enum/main_muscle_group.dart';

class ChoiceChipsAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final StringCallback callback;

  const ChoiceChipsAppBarWidget({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  _ChoiceChipsAppBarWidgetState createState() =>
      _ChoiceChipsAppBarWidgetState();

  @override
  Size get preferredSize {
    return Size.fromHeight(48.0);
  }
}

class _ChoiceChipsAppBarWidgetState extends State<ChoiceChipsAppBarWidget> {
  final List<String> _mainMuscleGroup =
      ['All'] + MainMuscleGroup.values[0].list;
  final List<String> _mainMuscleGroupTranslated =
      ['All'] + MainMuscleGroup.values[0].translatedList;

  // TODO: CHANGE SELECTED INDEX BASED ON DIFFERENT MUSCLE
  int _selectedIndex = 0;
  late String _selectedChipLabel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chips = [];

    chips.add(SizedBox(width: 12));
    for (var i = 0; i < _mainMuscleGroup.length; i++) {
      var choiceChip = ChoiceChip(
        labelPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: StadiumBorder(
          side: BorderSide(
              color: (_selectedIndex == i) ? kPrimary300Color : Colors.grey,
              width: 1),
        ),
        label: Text(_mainMuscleGroupTranslated[i], style: TextStyles.button1),
        selected: _selectedIndex == i,
        backgroundColor: kAppBarColor,
        selectedColor: kPrimaryColor,
        onSelected: (bool selected) {
          // setState(() {
          if (selected) {
            _selectedIndex = i;
            _selectedChipLabel = _mainMuscleGroup[i];
            widget.callback(_selectedChipLabel);
          }
          debugPrint(_selectedChipLabel);
          // });
        },
      );

      chips.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: choiceChip,
        ),
      );
    }
    chips.add(SizedBox(width: 12));

    return PreferredSize(
      preferredSize: Size.fromHeight(32),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips,
        ),
      ),
    );
  }
}
