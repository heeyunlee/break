import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';
import 'rest_widget.dart';
import 'workout_set_widget.dart';

class WorkoutMediumCard extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  WorkoutMediumCard({
    this.workoutTitle,
    this.numberOfSets,
    this.numberOfReps,
    this.sets,
  });

  final String workoutTitle;
  final int numberOfSets;
  final int numberOfReps;
  final List sets;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      color: CardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Colors.white,
        ),
        child: GestureDetector(
          onLongPress: () async {
            await showCupertinoModalPopup(
              context: context,
              builder: (context) => _showModalBottomSheet(context),
            );
          },
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(workoutTitle, style: Headline6),
            subtitle: Row(
              children: <Widget>[
                Text('$numberOfSets 세트', style: Subtitle2),
                Text('  •  ', style: Subtitle2),
                Text('$numberOfReps Reps', style: Subtitle2),
              ],
            ),
            childrenPadding: EdgeInsets.all(0),
            maintainState: true,
            children: [
              if (sets == null)
                Divider(endIndent: 8, indent: 8, color: Grey700),
              if (sets == null)
                Container(
                  height: 80,
                  child: Center(
                    child: Text('세트를 추가하세요', style: BodyText2),
                  ),
                ),
              Divider(endIndent: 8, indent: 8, color: Grey700),
              if (sets != null)
                ListView.separated(
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sets.length,
                  itemBuilder: (context, index) {
                    if (sets[index]['isRest'] == false) {
                      return WorkoutSetWidget(
                        setTitle: sets[index]['setTitle'],
                        setWeights: sets[index]['weights'],
                        setReps: sets[index]['reps'],
                      );
                    }
                    return RestWidget(
                      restTime: sets[index]['restTime'],
                    );
                    ;
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      indent: 16,
                      endIndent: 16,
                      color: Grey800,
                    );
                  },
                ),
              if (sets != null)
                Divider(endIndent: 8, indent: 8, color: Grey700),
              IconButton(
                icon: Icon(
                  Icons.add_rounded,
                  color: Colors.grey,
                ),
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  // await showCupertinoModalPopup(
                  //   context: context,
                  //   builder: (context) =>
                  //       _showModalBottomSheetForDeleteRoutineWorkout(context),
                  // );
                },
              ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showModalBottomSheet(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('세로운 세트 추가'),
          isDefaultAction: true,
          onPressed: () {},
        ),
        CupertinoActionSheetAction(
          child: Text('새로운 휴식 추가'),
          isDefaultAction: true,
          onPressed: () {},
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('취소'),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  // WIdget _showModalBottomSheetForDeleteRoutineWorkout(BuildContext context) {}
}
