import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class WorkoutSetWidget extends StatelessWidget {
  const WorkoutSetWidget({
    Key key,
    @required this.setTitle,
    @required this.setWeights,
    @required this.setReps,
  }) : super(key: key);

  final String setTitle;
  final int setWeights;
  final int setReps;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16, height: 48),
        Text(setTitle, style: BodyText1Bold),
        Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            color: Color(0xff3C3C3C),
            child: Text('$setWeights kg', style: BodyText1),
          ),
        ),
        SizedBox(width: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            color: Color(0xff3C3C3C),
            child: Text('$setReps x', style: BodyText1),
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.grey),
          onPressed: () async {
            HapticFeedback.mediumImpact();
            await showCupertinoModalPopup(
              context: context,
              builder: (context) => _modalBottomSheetForWorkoutSetInfo(context),
            );
          },
        ),
      ],
    );
  }

  Widget _modalBottomSheetForWorkoutSetInfo(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('세트 수정'),
          onPressed: () {},
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text('세트 삭제'),
          onPressed: () {},
          isDestructiveAction: true,
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text('취소'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
