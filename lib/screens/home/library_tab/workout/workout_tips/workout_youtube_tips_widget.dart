// import 'package:flutter/material.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// class WorkoutYoutubeTipsWidget implements YoutubePlayer {
//   const WorkoutYoutubeTipsWidget({Key? key}) : super(key: key);

//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //   final s = YoutubePlayer.convertUrlToId(
//   //       'https://www.youtube.com/watch?v=Ia9DYFMkMmU');

//   //   _controller = YoutubePlayerController(
//   //     initialVideoId: s!,
//   //     flags: YoutubePlayerFlags(
//   //       autoPlay: false,
//   //       mute: true,
//   //     ),
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     final s = YoutubePlayer.convertUrlToId(
//         'https://www.youtube.com/watch?v=Ia9DYFMkMmU');

//     return YoutubePlayer(
//       controller: YoutubePlayerController(initialVideoId: s!),
//       // controller: _controller,
//       showVideoProgressIndicator: true,
//       progressIndicatorColor: Colors.amber,
//       onReady: () {
//         // _controller.addListener(listener);
//       },
//     );
//   }
// }
