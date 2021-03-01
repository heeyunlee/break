import 'package:flutter/material.dart';

import '../../../../constants.dart';

typedef void ListCallback(List list);

class NewRoutineEquipmentRequiredScreen extends StatefulWidget {
  final ListCallback selectedEquipmentRequired;

  const NewRoutineEquipmentRequiredScreen(
      {Key key, this.selectedEquipmentRequired})
      : super(key: key);

  @override
  _NewRoutineEquipmentRequiredScreenState createState() =>
      _NewRoutineEquipmentRequiredScreenState();
}

class _NewRoutineEquipmentRequiredScreenState
    extends State<NewRoutineEquipmentRequiredScreen> {
  Map<String, bool> _equipmentRequired = {
    'Barbell': false,
    'Dumbbell': false,
    'Bodyweight': false,
    'Cable': false,
    'Machine': false,
    'EZ Bar': false,
    'Gym ball': false,
    'Bench': false,
  };
  // Map<String, bool> _equipmentRequired =
  List _selectedEquipmentRequired = List();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 8),
          ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: _equipmentRequired.keys.map((String key) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: (_equipmentRequired[key]) ? PrimaryColor : Grey700,
                    child: CheckboxListTile(
                      activeColor: Primary700Color,
                      title: Text(key, style: ButtonText),
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _equipmentRequired[key],
                      onChanged: (bool value) {
                        setState(() {
                          _equipmentRequired[key] = value;
                        });
                        if (_equipmentRequired[key]) {
                          _selectedEquipmentRequired.add(key);
                        } else {
                          _selectedEquipmentRequired.remove(key);
                        }

                        widget.selectedEquipmentRequired(
                            _selectedEquipmentRequired);

                        print(_selectedEquipmentRequired);
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
