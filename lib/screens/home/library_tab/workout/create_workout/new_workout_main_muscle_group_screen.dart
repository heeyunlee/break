import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

class NewWorkoutMainMuscleGroupScreen extends StatefulWidget {
  final ListCallback mainMuscleGroupCallback;

  const NewWorkoutMainMuscleGroupScreen(
      {Key? key, required this.mainMuscleGroupCallback})
      : super(key: key);

  @override
  _NewWorkoutMainMuscleGroupScreenState createState() =>
      _NewWorkoutMainMuscleGroupScreenState();
}

class _NewWorkoutMainMuscleGroupScreenState
    extends State<NewWorkoutMainMuscleGroupScreen> {
  final List<String> _selectedMainMuscleGroup = [];
  final Map<String, bool> _mainMuscleGroup = MainMuscleGroup.abs.map;

  @override
  Widget build(BuildContext context) {
    debugPrint('NewWorkoutMainMuscleGroupScreen building...');

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _mainMuscleGroup.keys.map((String key) {
              final String title = MainMuscleGroup.values
                  .firstWhere((e) => e.toString() == key)
                  .translation!;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: (_mainMuscleGroup[key]!) ? kPrimaryColor : kGrey700,
                    child: CheckboxListTile(
                      activeColor: kPrimary700Color,
                      title: Text(title, style: TextStyles.button1),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _mainMuscleGroup[key],
                      onChanged: (bool? value) {
                        setState(() {
                          _mainMuscleGroup[key] = value!;
                        });
                        if (_mainMuscleGroup[key]!) {
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
