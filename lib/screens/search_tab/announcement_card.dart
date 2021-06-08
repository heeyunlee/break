// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import '../../constants.dart';

// class AnnouncementCard extends StatelessWidget {
//   final String imageUrl;
//   final String title;
//   final String? subtitle;
//   final Color? color;
//   final void Function()? onTap;

//   const AnnouncementCard({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//     this.subtitle,
//     this.color,
//     this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Container(
//       color: color,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           Image.asset(
//             imageUrl,
//             fit: BoxFit.fitHeight,
//           ),
//           Positioned(
//             bottom: 104,
//             left: 24,
//             child: SizedBox(
//               width: size.width / 2,
//               child: Text(
//                 title,
//                 style: GoogleFonts.blackHanSans(
//                   color: Colors.white,
//                   fontSize: 34,
//                 ),
//               ),
//             ),
//           ),
//           if (subtitle != null)
//             Positioned(
//               bottom: 48,
//               left: 24,
//               child: SizedBox(
//                 width: size.width / 2.2,
//                 child: ElevatedButton(
//                   onPressed: onTap,
//                   style: ElevatedButton.styleFrom(primary: kPrimaryColor),
//                   child: Text(
//                     subtitle!,
//                     style: kSubtitle1,
//                   ),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
