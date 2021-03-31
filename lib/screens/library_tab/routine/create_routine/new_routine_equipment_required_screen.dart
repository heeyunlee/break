import 'package:flutter/material.dart';
import 'package:workout_player/models/enum/equipment_required.dart';

import '../../../../constants.dart';

typedef ListCallback = void Function(List list);

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
  final Map<String, bool> _equipmentRequired = EquipmentRequired.values[0].map;
  final List _selectedEquipmentRequired = [];

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
              final title = EquipmentRequired.values
                  .firstWhere((e) => e.toString() == key)
                  .translation;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: (_equipmentRequired[key]) ? PrimaryColor : Grey700,
                    child: CheckboxListTile(
                      activeColor: Primary700Color,
                      title: Text(title, style: ButtonText),
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
