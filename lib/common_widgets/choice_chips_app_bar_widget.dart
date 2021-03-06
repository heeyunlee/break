import 'package:flutter/material.dart';

import '../constants.dart';
import '../models/enum/main_muscle_group.dart';

typedef StringCallback = void Function(String val);

class ChoiceChipsAppBarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final StringCallback callback;

  const ChoiceChipsAppBarWidget({Key key, this.callback}) : super(key: key);

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

  int _selectedIndex = 0;
  String _selectedChipLabel = 'All';

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
    final chips = [];

    chips.add(SizedBox(width: 12));
    for (var i = 0; i < _mainMuscleGroup.length; i++) {
      var choiceChip = ChoiceChip(
        padding: EdgeInsets.symmetric(horizontal: 8),
        label: Text(_mainMuscleGroup[i], style: ButtonText),
        selected: _selectedIndex == i,
        backgroundColor: Colors.grey[700],
        selectedColor: PrimaryColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
              _selectedChipLabel = _mainMuscleGroup[i];
              widget.callback(_selectedChipLabel);
            }
            debugPrint(_selectedChipLabel);
          });
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
      preferredSize: Size.fromHeight(48),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips,
        ),
      ),
    );
  }
}
