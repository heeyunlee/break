import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';

import '../../../../constants.dart';

typedef void StringCallback(List list);

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
  // MainMuscleGroup _mainMuscleGroup;
  Map<String, bool> _mainMuscleGroup = MainMuscleGroup.values[0].map;
  List<String> _selectedMainMuscleGroup = List();

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
          // Theme(
          //   data: ThemeData(
          //     unselectedWidgetColor: Colors.grey,
          //   ),
          //   child: ListView.builder(
          //     shrinkWrap: true,
          //     physics: const NeverScrollableScrollPhysics(),
          //     itemCount: MainMuscleGroup.values.length,
          //     itemBuilder: (context, index) => Padding(
          //       padding:
          //           const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          //       child: ClipRRect(
          //         borderRadius: BorderRadius.circular(10),
          //         child: Container(
          //           height: 56,
          //           color: Grey700,
          //           child: RadioListTile<MainMuscleGroup>(
          //             title: Text(
          //               '${MainMuscleGroup.values[index].label}',
          //               style: ButtonText,
          //             ),
          //             activeColor: PrimaryColor,
          //             value: MainMuscleGroup.values[index],
          //             groupValue: _mainMuscleGroup,
          //             onChanged: (MainMuscleGroup value) {
          //               setState(() {
          //                 _mainMuscleGroup = value;
          //                 widget.mainMuscleGroupCallback(_mainMuscleGroup);
          //               });
          //             },
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
