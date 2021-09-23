// import 'package:flutter/material.dart';
// import 'package:workout_player/models/youtube_video.dart';
// import 'package:workout_player/styles/text_styles.dart';
// import 'package:workout_player/view/screens/library/youtube_screen.dart';
// import 'package:workout_player/view/widgets/widgets.dart';
// import 'package:workout_player/view_models/main_model.dart';

// class YoutubeVideosTab extends StatelessWidget {
//   const YoutubeVideosTab({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     logger.d('[YoutubeVideosTab] tab...');

//     final size = MediaQuery.of(context).size;

//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           YoutubeVideoCard(
//             youtubeVideo: YoutubeVideo(
//               youtubeVideoId: '',
//               videoId: 'assets/test/thumnail_1.jpeg',
//             ),
//           ),
//           // InkWell(
//           //   onTap: () => YoutubeScreen.show(context),
//           //   child: Card(
//           //     color: Colors.transparent,
//           //     margin: EdgeInsets.all(16),
//           //     clipBehavior: Clip.antiAliasWithSaveLayer,
//           //     child: Stack(
//           //       alignment: Alignment(0, 0),
//           //       children: [
//           //         Image.asset(
//           //           'assets/test/thumnail_1.jpeg',
//           //           width: double.infinity,
//           //           height: 220,
//           //           fit: BoxFit.cover,
//           //         ),
//           //         Container(
//           //           decoration: BoxDecoration(
//           //             gradient: LinearGradient(
//           //               begin: Alignment(0, -0.5),
//           //               end: Alignment(0, 1.00),
//           //               colors: [
//           //                 Colors.transparent,
//           //                 Colors.black87,
//           //               ],
//           //             ),
//           //           ),
//           //           width: double.infinity,
//           //           height: 220,
//           //         ),
//           //         Positioned(
//           //           bottom: 16,
//           //           child: SizedBox(
//           //             width: size.width - 64,
//           //             child: Row(
//           //               children: [
//           //                 Column(
//           //                   crossAxisAlignment: CrossAxisAlignment.start,
//           //                   children: [
//           //                     Text('Get Abs in 2 Weeks',
//           //                         style: TextStyles.body1),
//           //                     const SizedBox(height: 4),
//           //                     Text(
//           //                       'Abs  •  45 Mins   •   At Home',
//           //                       style: TextStyles.body2_grey,
//           //                     ),
//           //                   ],
//           //                 ),
//           //                 Spacer(),
//           //                 CircleAvatar(radius: 16),
//           //               ],
//           //             ),
//           //           ),
//           //         ),
//           //         Image.asset(
//           //           'assets/test/yt_icon_rgb.png',
//           //           height: 32,
//           //         ),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
