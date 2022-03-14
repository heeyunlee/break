// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:enum_to_string/enum_to_string.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_blurhash/flutter_blurhash.dart';
// import 'package:workout_player/generated/l10n.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:workout_player/models/youtube_video.dart';
// import 'package:workout_player/providers.dart';
// import 'package:workout_player/styles/text_styles.dart';
// import 'package:workout_player/utils/formatter.dart';
// import 'package:workout_player/view/widgets/watch/youtube_workout_list_tile.dart';
// import 'package:workout_player/view/widgets/widgets.dart';
// 
// import 'package:workout_player/view_models/miniplayer_model.dart';

// class YoutubeVideoDetailScreen extends StatelessWidget {
//   const YoutubeVideoDetailScreen({
//     Key? key,
//     required this.miniplayerModel,
//     required this.heroTag,
//   }) : super(key: key);

//   final MiniplayerModel miniplayerModel;
//   final String heroTag;

//   static void show(
//     BuildContext context, {
//     required YoutubeVideo youtubeVideo,
//     required String heroTag,
//   }) {
//     customPush(
//       context,
//       rootNavigator: false,
//       builder: (context, auth, database) => Consumer(
//         builder: (context, ref, child) => YoutubeVideoDetailScreen(
//           heroTag: heroTag,
//           miniplayerModel: ref.watch(miniplayerModelProvider),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     logger.d('`YoutubeVideoDetailScreen()` building...');

//     final size = MediaQuery.of(context).size;
//     final theme = Theme.of(context);
//     final heightFactor = (size.height > 700) ? 2 : 1.5;

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: CustomScrollView(
//         slivers: [
//           SliverAppBar(
//             pinned: true,
//             stretch: true,
//             leading: const AppBarBackButton(),
//             expandedHeight: size.height / heightFactor,
//             actions: [
//               TextButton(
//                 onPressed: () {},
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(4),
//                     border: Border.all(color: Colors.white),
//                   ),
//                   child: const Padding(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: 8,
//                       vertical: 4,
//                     ),
//                     child: Text(
//                       'Open YouTube',
//                       style: TextStyles.button2,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//             ],
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.passthrough,
//                 children: <Widget>[
//                   SizedBox(
//                     height: size.width / 2,
//                     width: size.width,
//                     child: BlurHash(
//                       hash: model.blurHash,
//                       imageFit: BoxFit.cover,
//                       color: Colors.white,
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: const Alignment(0, 0.85),
//                         colors: [
//                           Colors.transparent,
//                           theme.backgroundColor,
//                         ],
//                       ),
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomLeft,
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Hero(
//                             tag: heroTag,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: CachedNetworkImage(
//                                 height: 150,
//                                 fit: BoxFit.fitWidth,
//                                 imageUrl: model.thumbnail,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             model.title,
//                             style: TextStyles.subtitle1,
//                             maxLines: 2,
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(vertical: 16),
//                             child: MaxWidthRaisedButton(
//                               icon: const Icon(Icons.play_arrow_rounded),
//                               onPressed: () => miniplayerModel
//                                   .startYouTubeWorkout(context, model.video),
//                               buttonText: S.current.startNow,
//                               color: theme.primaryColor,
//                               width: size.width - 32,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Text(
//                                 Formatter.getJoinedMainMuscleGroups(
//                                   null,
//                                   model.muscleGroups,
//                                 ),
//                                 style: TextStyles.body2Grey,
//                               ),
//                               const Text(
//                                 '   •   ',
//                                 style: TextStyles.body2Grey,
//                               ),
//                               Text(
//                                 '${model.duration} ${S.current.minutes}',
//                                 style: TextStyles.body2Grey,
//                               ),
//                               const Text(
//                                 '   •   ',
//                                 style: TextStyles.body2Grey,
//                               ),
//                               Text(
//                                 EnumToString.convertToString(
//                                   model.location,
//                                   camelCase: true,
//                                 ),
//                                 style: TextStyles.body2Grey,
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 radius: 12,
//                                 backgroundImage: CachedNetworkImageProvider(
//                                   model.profileUrl,
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Text(
//                                 model.authorName,
//                                 style: TextStyles.body2,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SliverToBoxAdapter(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 4,
//                       ),
//                       child: Text(
//                         S.current.workoutsInThisVideo,
//                         style: TextStyles.headline6,
//                       ),
//                     ),
//                     ListView.builder(
//                       physics: const NeverScrollableScrollPhysics(),
//                       shrinkWrap: true,
//                       padding: EdgeInsets.zero,
//                       itemCount: model.video.workouts.length,
//                       itemBuilder: (context, index) {
//                         return YoutubeWorkoutListTile(
//                           workout: model.video.workouts[index],
//                         );
//                       },
//                     ),
//                     const SizedBox(height: kBottomNavigationBarHeight + 32),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
