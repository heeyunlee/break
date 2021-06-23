import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/styles/constants.dart';

class NewRoutineMainMuscleGroupScreen extends StatefulWidget {
  final ListCallback mainMuscleGroupCallback;

  const NewRoutineMainMuscleGroupScreen({
    Key? key,
    required this.mainMuscleGroupCallback,
  }) : super(key: key);

  @override
  _NewRoutineMainMuscleGroupScreenState createState() =>
      _NewRoutineMainMuscleGroupScreenState();
}

class _NewRoutineMainMuscleGroupScreenState
    extends State<NewRoutineMainMuscleGroupScreen> {
  final List<String> _selectedMainMuscleGroup = [];
  final Map<String, bool> _mainMuscleGroupMap = MainMuscleGroup.abs.map;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _mainMuscleGroupMap.keys.map((String key) {
              final title = MainMuscleGroup.values
                  .firstWhere((e) => e.toString() == key)
                  .translation;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color:
                        (_mainMuscleGroupMap[key]!) ? kPrimaryColor : kGrey700,
                    child: CheckboxListTile(
                      activeColor: kPrimary700Color,
                      title: Text(title!, style: kButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _mainMuscleGroupMap[key],
                      onChanged: (bool? value) {
                        setState(() {
                          _mainMuscleGroupMap[key] = value!;
                        });
                        if (_mainMuscleGroupMap[key]!) {
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
