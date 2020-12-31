import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../constants.dart';

class RestWidget extends StatelessWidget {
  final int restTime;

  const RestWidget({Key key, this.restTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 16),
        Text('휴식', style: BodyText1),
        Spacer(),
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            height: 32,
            padding: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text('$restTime 초', style: BodyText1),
            color: PrimaryColor,
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: Colors.grey),
          onPressed: () async {
            HapticFeedback.mediumImpact();
            await showCupertinoModalPopup(
              context: context,
              builder: (context) =>
                  _modalBottomSheetForRestBetweenSets(context),
            );
          },
        ),
      ],
    );
  }

  Widget _modalBottomSheetForRestBetweenSets(BuildContext context) {
    return CupertinoActionSheet(
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('휴식 수정'),
          onPressed: () {},
          isDefaultAction: true,
        ),
        CupertinoActionSheetAction(
          child: Text('휴식 삭제'),
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
