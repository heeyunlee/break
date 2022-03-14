// import 'package:flutter/material.dart';

// import 'package:workout_player/models/youtube_video.dart';
// import 'package:workout_player/services/database.dart';
// import 'package:workout_player/styles/text_styles.dart';
// import 'package:workout_player/view/widgets/widgets.dart';
// 

// class WatchTab extends StatelessWidget {
//   const WatchTab({
//     Key? key,
//     required this.database,
//   }) : super(key: key);

//   final Database database;

//   static void show(BuildContext context) {
//     customPush(
//       context,
//       rootNavigator: false,
//       builder: (context, auth, database) => WatchTab(database: database),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     logger.d('[WatchTab] building...');

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         leading: const AppBarBackButton(),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Watch', style: TextStyles.subtitle2),
//             const SizedBox(width: 8),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.red,
//                 borderRadius: BorderRadius.circular(4),
//               ),
//               child: const Padding(
//                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 child: Text('BETA', style: TextStyles.button2),
//               ),
//             ),
//           ],
//         ),
//         flexibleSpace: const AppbarBlurBG(),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             CustomStreamBuilder<List<YoutubeVideo>>(
//               stream: database.youtubeVideosStream(),
//               builder: (context, videos) {
//                 return CustomListViewBuilder<YoutubeVideo>(
//                   items: videos,
//                   itemBuilder: (context, video, index) => YoutubeVideoCard(
//                     heroTag: video.youtubeVideoId,
//                     youtubeVideo: video,
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: kBottomNavigationBarHeight + 32)
//           ],
//         ),
//       ),
//     );
//   }
// }
