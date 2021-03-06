import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/equipment_required.dart';

import '../../../../constants.dart';

typedef ListCallback = void Function(List list);

class NewWorkoutEquipmentRequiredScreen extends StatefulWidget {
  final ListCallback equipmentRequiredCallback;

  const NewWorkoutEquipmentRequiredScreen(
      {Key key, this.equipmentRequiredCallback})
      : super(key: key);

  @override
  _NewWorkoutEquipmentRequiredScreenScreenState createState() =>
      _NewWorkoutEquipmentRequiredScreenScreenState();
}

class _NewWorkoutEquipmentRequiredScreenScreenState
    extends State<NewWorkoutEquipmentRequiredScreen> {
  final Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;
  final List _selectedEquipmentRequired = [];

  @override
  Widget build(BuildContext context) {
    debugPrint('NewWorkoutEquipmentRequiredScreen building...');

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

                        widget.equipmentRequiredCallback(
                            _selectedEquipmentRequired);

                        debugPrint('$_selectedEquipmentRequired');
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
