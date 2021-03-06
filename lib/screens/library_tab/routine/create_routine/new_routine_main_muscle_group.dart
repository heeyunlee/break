import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../../../constants.dart';

typedef StringCallback = void Function(List list);

class NewRoutineMainMuscleGroupScreen extends StatefulWidget {
  final StringCallback mainMuscleGroupCallback;

  const NewRoutineMainMuscleGroupScreen({Key key, this.mainMuscleGroupCallback})
      : super(key: key);

  @override
  _NewRoutineMainMuscleGroupScreenState createState() =>
      _NewRoutineMainMuscleGroupScreenState();
}

class _NewRoutineMainMuscleGroupScreenState
    extends State<NewRoutineMainMuscleGroupScreen> {
  final Map<String, bool> _mainMuscleGroup = MainMuscleGroup.values[0].map;
  final List<String> _selectedMainMuscleGroup = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _mainMuscleGroup.keys.map((String key) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: (_mainMuscleGroup[key]) ? PrimaryColor : Grey700,
                    child: CheckboxListTile(
                      activeColor: Primary700Color,
                      title: Text(key, style: ButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _mainMuscleGroup[key],
                      onChanged: (bool value) {
                        setState(() {
                          _mainMuscleGroup[key] = value;
                        });
                        if (_mainMuscleGroup[key]) {
                          _selectedMainMuscleGroup.add(key);
                        } else {
                          _selectedMainMuscleGroup.remove(key);
                        }

                        widget.mainMuscleGroupCallback(
                          _selectedMainMuscleGroup,
                        );

                        print(_selectedMainMuscleGroup);
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
