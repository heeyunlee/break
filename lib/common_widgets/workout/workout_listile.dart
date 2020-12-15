// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:workout_player/screens/workouts/workout_detail_screen.dart';
//
// import '../../constants.dart';
//
// class WorkoutListTile extends StatelessWidget {
//   String title;
//   String subtitle;
//   int index;
//
//   WorkoutListTile(this.title, this.subtitle, this.index);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
//       child: ListTile(
//         // tileColor: CardColor,
//         // leading: ConstrainedBox(
//         //   constraints: BoxConstraints(
//         //       maxWidth: 56, maxHeight: 56, minHeight: 56, minWidth: 56),
//         //   child: Image.asset('images/leg.png'),
//         // ),
//         leading: Hero(
//           tag: 'heroTag$index',
//           child: Container(
//             width: 56,
//             height: 56,
//             child: Image.asset('images/place_holder_workout_playlist.png'),
//           ),
//         ),
//
//         title: Text(
//           title,
//           style: BodyText1Bold,
//         ),
//         subtitle: Text(
//           subtitle,
//           style: BodyText2Light,
//         ),
//         onTap: () {
//           Navigator.of(context).pushNamed(WorkoutDetailScreen.routeName);
//           // Navigator.push(context,
//           //     CupertinoPageRoute(builder: (context) => WorkoutDetailScreen()));
//         },
//         onLongPress: () {},
//       ),
//     );
//   }
// }
