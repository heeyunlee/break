import 'package:flutter/material.dart';

import '../../../constants.dart';

class CreateNewWorkoutWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 56,
        width: 56,
        color: Grey800,
        child: Icon(
          Icons.add_rounded,
          color: Grey200,
        ),
      ),
      title: Text(
        '커스텀 운동 추가',
        style: BodyText1.copyWith(fontWeight: FontWeight.bold),
      ),
      // onTap: () => CreateNewWorkoutForm.show(context),
      // onTap: () {
      //   pushNewScreen(
      //     context,
      //     pageTransitionAnimation: PageTransitionAnimation.slideUp,
      //     screen: EditWorkoutScreen(
      //       database: Provider.of<Database>(context, listen: false),
      //     ),
      //     withNavBar: false,
      //   );
      // },
      onLongPress: () {},
    );
  }
}
