import 'package:flutter/material.dart';
import 'package:workout_player/models/enum_values.dart';

import '../../../../constants.dart';

typedef void StringCallback(MainMuscleGroup mainMuscleGroup);

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
  MainMuscleGroup _mainMuscleGroup;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          Theme(
            data: ThemeData(
              unselectedWidgetColor: Colors.grey,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: MainMuscleGroup.values.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 56,
                    color: Grey700,
                    child: RadioListTile<MainMuscleGroup>(
                      title: Text(
                        '${MainMuscleGroup.values[index].label}',
                        style: ButtonText,
                      ),
                      activeColor: PrimaryColor,
                      value: MainMuscleGroup.values[index],
                      groupValue: _mainMuscleGroup,
                      onChanged: (MainMuscleGroup value) {
                        setState(() {
                          _mainMuscleGroup = value;
                          widget.mainMuscleGroupCallback(_mainMuscleGroup);
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
