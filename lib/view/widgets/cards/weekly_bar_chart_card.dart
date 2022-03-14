// import 'package:flutter/material.dart';

// import 'package:workout_player/styles/text_styles.dart';

// class WeeklyBarChartCard extends StatefulWidget {
//   const WeeklyBarChartCard({
//     Key? key,
//     required this.cardHeight,
//     required this.cardWidth,
//     required this.titleOnTap,
//     required this.titleIcon,
//     required this.defaultColor,
//     required this.touchedColor,
//     required this.title,
//     required this.chart,
//   }) : super(key: key);

//   final double cardHeight;
//   final double cardWidth;
//   final void Function() titleOnTap;
//   final IconData titleIcon;
//   final Color defaultColor;
//   final Color touchedColor;
//   final String title;
//   final Widget chart;

//   @override
//   _WeeklyBarChartCardState createState() => _WeeklyBarChartCardState();
// }

// class _WeeklyBarChartCardState extends State<WeeklyBarChartCard> {
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       margin: const EdgeInsets.all(16),
//       child: SizedBox(
//         width: widget.cardWidth,
//         height: widget.cardHeight,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//             vertical: 8,
//             horizontal: 16,
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               GestureDetector(
//                 behavior: HitTestBehavior.opaque,
//                 onTap: widget.titleOnTap,
//                 child: Wrap(
//                   children: [
//                     SizedBox(
//                       height: 48,
//                       child: Row(
//                         children: [
//                           Icon(
//                             widget.titleIcon,
//                             color: widget.defaultColor,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             widget.title,
//                             style: TextStyles.subtitle1W900.copyWith(
//                               color: widget.defaultColor,
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 8),
//                             child: Icon(
//                               Icons.arrow_forward_ios_rounded,
//                               color: widget.defaultColor,
//                               size: 16,
//                             ),
//                           ),
//                           const Spacer(),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 16),
//               widget.chart,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
