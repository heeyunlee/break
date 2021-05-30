// import 'dart:ui';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/all.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart' as provider;
// import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
// import 'package:workout_player/widgets/empty_content.dart';
// import 'package:workout_player/widgets/max_width_raised_button.dart';
// import 'package:workout_player/format.dart';
// import 'package:workout_player/generated/l10n.dart';
// import 'package:workout_player/models/enum/equipment_required.dart';
// import 'package:workout_player/models/enum/main_muscle_group.dart';
// import 'package:workout_player/models/user.dart';
// import 'package:workout_player/models/workout.dart';
// import 'package:workout_player/services/auth.dart';
// import 'package:workout_player/services/database.dart';
// import 'package:workout_player/widgets/shimmer/workout_detail_screen_shimmer.dart';

// import '../../../constants.dart';
// import 'add_workout_to_routine_screen.dart';
// import 'edit_workout/edit_workout_screen.dart';

// class WorkoutDetailScreen extends ConsumerWidget {
//   WorkoutDetailScreen({
//     required this.workout,
//     required this.database,
//     required this.user,
//     required this.tag,
//   });

//   final Workout workout;
//   final Database database;
//   final User user;
//   final String tag;

//   // For Navigation
//   static Future<void> show(
//     BuildContext context, {
//     required Workout workout,
//     bool isRootNavigation = false,
//     required String tag,
//   }) async {
//     final database = provider.Provider.of<Database>(context, listen: false);
//     final auth = provider.Provider.of<AuthBase>(context, listen: false);
//     final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

//     await HapticFeedback.mediumImpact();

//     if (!isRootNavigation) {
//       await Navigator.of(context, rootNavigator: false).push(
//         CupertinoPageRoute(
//           builder: (context) => WorkoutDetailScreen(
//             workout: workout,
//             database: database,
//             user: user,
//             tag: tag,
//           ),
//         ),
//       );
//     } else {
//       await Navigator.of(context, rootNavigator: true).pushReplacement(
//         CupertinoPageRoute(
//           builder: (context) => WorkoutDetailScreen(
//             workout: workout,
//             database: database,
//             user: user,
//             tag: tag,
//           ),
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context, ScopedReader watch) {
//     final size = MediaQuery.of(context).size;
//     final workoutStream = watch(workoutStreamProvider(workout.workoutId));

//     return workoutStream.when(
//       data: (workout) => DefaultTabController(
//         length: 2,
//         child: Scaffold(
//           backgroundColor: kBackgroundColor,
//           body: NestedScrollView(
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return <Widget>[
//                 Container(height: 400, color: Colors.green),
//                 // _buildSliverAppBar(context, workout!),
//                 // _buildHeaderWidget(context, workout!),
//               ];
//             },
//             body: SizedBox(
//               height: size.height,
//               child: Column(
//                 children: [
//                   TabBar(
//                     labelColor: Colors.white,
//                     unselectedLabelColor: kGrey400,
//                     indicatorColor: kPrimaryColor,
//                     tabs: [
//                       Tab(text: 'Instructions'),
//                       Tab(text: 'Histories'),
//                     ],
//                   ),
//                   SizedBox(
//                     height: size.height,
//                     child: TabBarView(
//                       children: [
//                         Placeholder(),
//                         Placeholder(),
//                         // _buildWorkoutHistory(),
//                         // _buildWorkoutHistory(),
//                         // RoutinesTab(),
//                         // WorkoutsTab(),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // body: TabBarView(
//           //   children: [
//           //     // RoutinesTab(),
//           //     // WorkoutsTab(),
//           //   ],
//           // ),
//         ),
//         // body: Stack(
//         //   children: [
//         //     CustomScrollView(
//         //       physics: const BouncingScrollPhysics(),
//         //       slivers: [
//         //         _buildSliverAppBar(context, workout!),
//         //         _buildSliverToBoxAdapter(workout),
//         //       ],
//         //     ),
//         //   ],
//         // ),
//       ),
//       loading: () => WorkoutDetailScreenShimmer(),
//       error: (e, stackTrace) => EmptyContent(),
//     );
//     // return DefaultTabController(
//     //   length: 2,
//     //   child: Scaffold(
//     //     backgroundColor: kBackgroundColor,
//     //     body: CustomStreamBuilderWidget<Workout>(
//     //       initialData: widget.workout,
//     //       stream: widget.database.workoutStream(
//     //         workoutId: widget.workout.workoutId,
//     //       ),
//     //       hasDataWidget: (context, snapshot) {
//     //         return Stack(
//     //           children: [
//     //             CustomScrollView(
//     //               physics: const BouncingScrollPhysics(),
//     //               slivers: [
//     //                 _buildSliverAppBar(context, snapshot.data!),
//     //                 _buildSliverToBoxAdapter(snapshot.data!),
//     //               ],
//     //             ),
//     //           ],
//     //         );
//     //       },
//     //     ),
//     //     // body: StreamBuilder<Workout>(
//     //     //   initialData: workoutDummyData,
//     //     //   stream: widget.database.workoutStream(
//     //     //     workoutId: widget.workout.workoutId,
//     //     //   ),
//     //     //   builder: (context, snapshot) {
//     //     //     final workout = snapshot.data;

//     //     //     return Stack(
//     //     //       children: [
//     //     //         CustomScrollView(
//     //     //           physics: const BouncingScrollPhysics(),
//     //     //           slivers: [
//     //     //             _buildSliverAppBar(context, workout),
//     //     //             // _buildSliverToBoxAdapter(workout),
//     //     //           ],
//     //     //         ),
//     //     //       ],
//     //     //     );
//     //     //   },
//     //     // ),
//     //   ),
//     // );
//   }

//   Widget _buildSliverAppBar(BuildContext context, Workout workout) {
//     final size = MediaQuery.of(context).size;

//     return SliverAppBar(
//       brightness: Brightness.dark,
//       leading: IconButton(
//         icon: const Icon(
//           Icons.arrow_back_rounded,
//           color: Colors.white,
//         ),
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//       ),
//       backgroundColor: kBackgroundColor,
//       floating: false,
//       pinned: true,
//       snap: false,
//       stretch: true,
//       expandedHeight: size.height * 2 / 5,
//       centerTitle: true,
//       // title: isShrink ? Text(workout.workoutTitle, style: kSubtitle1) : null,
//       // bottom: TabBar(
//       //   labelColor: Colors.white,
//       //   unselectedLabelColor: kGrey400,
//       //   indicatorColor: kPrimaryColor,
//       //   tabs: [
//       //     Tab(text: 'Instructions'),
//       //     Tab(text: 'Histories'),
//       //   ],
//       // ),
//       actions: <Widget>[
//         if (user.userId == workout.workoutOwnerId)
//           IconButton(
//             icon: const Icon(Icons.edit_rounded, color: Colors.white),
//             onPressed: () => EditWorkoutScreen.show(
//               context,
//               workout: workout,
//             ),
//           ),
//         // IconButton(
//         //   // icon: Icon(Icons.favorite_border_rounded),
//         //   icon: Icon(
//         //     (widget.userSavedWorkout.isSavedWorkout)
//         //         ? Icons.favorite_rounded
//         //         : Icons.favorite_border_rounded,
//         //     color: (widget.userSavedWorkout.isSavedWorkout)
//         //         ? kPrimaryColor
//         //         : Colors.white,
//         //   ),
//         //   onPressed: () => _toggleFavorites(context),
//         // ),
//         const SizedBox(width: 8),
//       ],
//       flexibleSpace: _buildFlexibleSpaceBarWidget(workout, context),
//       // flexibleSpace: _FlexibleSpaceBarWidget(
//       //   workout: widget.workout,
//       //   tag: widget.tag,
//       // ),
//     );
//   }

//   Widget _buildHeaderWidget(BuildContext context, Workout workout) {
//     final size = MediaQuery.of(context).size;
//     final locale = Intl.getCurrentLocale();

//     final mainMuscleGroup = MainMuscleGroup.values
//         .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
//         .translation!;
//     final equipmentRequired = EquipmentRequired.values
//         .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
//         .translation!;
//     final difficulty = Format.difficulty(workout.difficulty)!;
//     final description = workout.description;

//     return Stack(
//       fit: StackFit.passthrough,
//       children: [
//         Hero(
//           tag: tag,
//           child: CachedNetworkImage(
//             imageUrl: workout.imageUrl,
//             errorWidget: (context, url, error) => Icon(Icons.error),
//             fit: BoxFit.cover,
//           ),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment(0.0, -0.5),
//               end: Alignment.bottomCenter,
//               colors: [
//                 kBackgroundColor.withOpacity(0.5),
//                 Colors.transparent,
//                 kBackgroundColor,
//               ],
//             ),
//           ),
//         ),
//         Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Text(
//               workout.translated[locale],
//               textAlign: TextAlign.center,
//               style: GoogleFonts.blackHanSans(
//                 color: Colors.white,
//                 fontSize: 40,
//               ),
//               maxLines: 2,
//               overflow: TextOverflow.ellipsis,
//               softWrap: true,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.end,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   // Main Muscle Group
//                   Container(
//                     width: size.width / 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(S.current.mainMuscleGroup, style: kCaption1Grey),
//                         const SizedBox(height: 8),
//                         Text(
//                           mainMuscleGroup,
//                           style: kSubtitle2,
//                         ),
//                       ],
//                     ),
//                   ),

//                   Container(
//                     color: Colors.white.withOpacity(0.1),
//                     width: 1,
//                     height: 56,
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                   ),

//                   // Equipment Required
//                   Container(
//                     width: size.width / 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           S.current.equipmentRequired,
//                           style: kCaption1Grey,
//                         ),
//                         const SizedBox(height: 8),
//                         Text(equipmentRequired, style: kSubtitle2),
//                       ],
//                     ),
//                   ),

//                   Container(
//                     color: Colors.white.withOpacity(0.1),
//                     width: 1,
//                     height: 56,
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                   ),

//                   // Experience Level
//                   Container(
//                     width: size.width / 4,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(S.current.difficulty, style: kCaption1Grey),
//                         const SizedBox(height: 8),
//                         Text(difficulty, style: kSubtitle2),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),
//               Text(
//                 description,
//                 style: kBodyText2LightGrey,
//                 maxLines: 5,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: false,
//               ),
//               const SizedBox(height: 24),
//               MaxWidthRaisedButton(
//                 width: double.infinity,
//                 color: kGrey800,
//                 icon: const Icon(
//                   Icons.add_rounded,
//                   color: Colors.white,
//                   size: 20,
//                 ),
//                 buttonText: S.current.addWorkoutToRoutinekButtonText,
//                 onPressed: () => AddWorkoutToRoutineScreen.show(
//                   context,
//                   workout: workout,
//                 ),
//               ),
//               // SizedBox(height: 48),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildFlexibleSpaceBarWidget(Workout workout, BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     final locale = Intl.getCurrentLocale();

//     final mainMuscleGroup = MainMuscleGroup.values
//         .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
//         .translation!;
//     final equipmentRequired = EquipmentRequired.values
//         .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
//         .translation!;
//     final difficulty = Format.difficulty(workout.difficulty)!;
//     final description = workout.description;

//     return FlexibleSpaceBar(
//       background: Stack(
//         fit: StackFit.passthrough,
//         children: [
//           Hero(
//             tag: tag,
//             child: CachedNetworkImage(
//               imageUrl: workout.imageUrl,
//               errorWidget: (context, url, error) => Icon(Icons.error),
//               fit: BoxFit.cover,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment(0.0, -0.5),
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   kBackgroundColor.withOpacity(0.5),
//                   Colors.transparent,
//                   kBackgroundColor,
//                 ],
//               ),
//             ),
//           ),
//           Center(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Text(
//                 workout.translated[locale],
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.blackHanSans(
//                   color: Colors.white,
//                   fontSize: 40,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 softWrap: true,
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     // Main Muscle Group
//                     Container(
//                       width: size.width / 4,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(S.current.mainMuscleGroup, style: kCaption1Grey),
//                           const SizedBox(height: 8),
//                           Text(
//                             mainMuscleGroup,
//                             style: kSubtitle2,
//                           ),
//                         ],
//                       ),
//                     ),

//                     Container(
//                       color: Colors.white.withOpacity(0.1),
//                       width: 1,
//                       height: 56,
//                       margin: const EdgeInsets.symmetric(horizontal: 8),
//                     ),

//                     // Equipment Required
//                     Container(
//                       width: size.width / 4,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             S.current.equipmentRequired,
//                             style: kCaption1Grey,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(equipmentRequired, style: kSubtitle2),
//                         ],
//                       ),
//                     ),

//                     Container(
//                       color: Colors.white.withOpacity(0.1),
//                       width: 1,
//                       height: 56,
//                       margin: const EdgeInsets.symmetric(horizontal: 8),
//                     ),

//                     // Experience Level
//                     Container(
//                       width: size.width / 4,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(S.current.difficulty, style: kCaption1Grey),
//                           const SizedBox(height: 8),
//                           Text(difficulty, style: kSubtitle2),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 24),
//                 Text(
//                   description,
//                   style: kBodyText2LightGrey,
//                   maxLines: 5,
//                   overflow: TextOverflow.ellipsis,
//                   softWrap: false,
//                 ),
//                 const SizedBox(height: 24),
//                 MaxWidthRaisedButton(
//                   width: double.infinity,
//                   color: kGrey800,
//                   icon: const Icon(
//                     Icons.add_rounded,
//                     color: Colors.white,
//                     size: 20,
//                   ),
//                   buttonText: S.current.addWorkoutToRoutinekButtonText,
//                   onPressed: () => AddWorkoutToRoutineScreen.show(
//                     context,
//                     workout: workout,
//                   ),
//                 ),
//                 // SizedBox(height: 48),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSliverToBoxAdapter(Workout workout) {
//     return SliverToBoxAdapter(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // _buildInstructions(),
//             // SizedBox(height: 24),
//             _buildWorkoutHistory(),
//           ],
//         ),
//       ),
//     );
//   }

//   // Widget _buildInstructions() {
//   //   return Column(
//   //     crossAxisAlignment: CrossAxisAlignment.start,
//   //     children: [
//   //       const Text('Instructions', style: kHeadline6),
//   //       const SizedBox(height: 8),
//   //       Container(
//   //         height: 500,
//   //         child: PageView(
//   //           controller: _pageController,
//   //           children: <Widget>[
//   //             Column(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: [
//   //                 const Text(
//   //                   '1. Vestibulum non suscipit lacus',
//   //                   style: kSubtitle1,
//   //                 ),
//   //                 const SizedBox(height: 4),
//   //                 const Padding(
//   //                   padding: const EdgeInsets.all(8.0),
//   //                   child: const Center(child: Placeholder()),
//   //                 ),
//   //               ],
//   //             ),
//   //             Column(
//   //               mainAxisAlignment: MainAxisAlignment.center,
//   //               children: [
//   //                 const Text(
//   //                   '2. eget maximus lacus. Vestibulum',
//   //                   style: kSubtitle1,
//   //                 ),
//   //                 const SizedBox(height: 4),
//   //                 const Padding(
//   //                   padding: const EdgeInsets.all(8.0),
//   //                   child: const Center(child: Placeholder()),
//   //                 ),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       const SizedBox(height: 16),
//   //       Container(
//   //         height: 24,
//   //         alignment: Alignment.center,
//   //         child: SmoothPageIndicator(
//   //           controller: _pageController,
//   //           count: 2,
//   //           effect: ScrollingDotsEffect(
//   //             activeDotScale: 1.5,
//   //             dotHeight: 8,
//   //             dotWidth: 8,
//   //             dotColor: Colors.white.withOpacity(0.3),
//   //             activeDotColor: kPrimaryColor,
//   //           ),
//   //         ),
//   //       ),
//   //       SizedBox(height: 16),
//   //     ],
//   //   );
//   // }

//   Widget _buildWorkoutHistory() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         const Text('History', style: kHeadline6),
//         const SizedBox(height: 8),
//         Container(
//           child: Card(
//             color: kCardColor,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: const Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: const Placeholder(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// // class _FlexibleSpaceBarWidget extends StatelessWidget {
// //   final Workout workout;
// //   final String tag;

// //   const _FlexibleSpaceBarWidget({
// //     Key key,
// //     this.workout,
// //     this.tag,
// //   }) : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     final size = MediaQuery.of(context).size;
// //     final locale = Intl.getCurrentLocale();

// //     final mainMuscleGroup = MainMuscleGroup.values
// //             .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
// //             .translation ??
// //         'Null';
// //     final equipmentRequired = EquipmentRequired.values
// //             .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
// //             .translation ??
// //         'Null';
// //     // final equipmentRequired = workout?.equipmentRequired[0] ?? 'NULL';
// //     final difficulty = Format.difficulty(workout.difficulty);
// //     final description = workout?.description ?? 'Add description';

// //     return FlexibleSpaceBar(
// //       background: Stack(
// //         fit: StackFit.passthrough,
// //         children: [
// //           Hero(
// //             tag: tag,
// //             child: CachedNetworkImage(
// //               imageUrl: workout.imageUrl,
// //               errorWidget: (context, url, error) => Icon(Icons.error),
// //               fit: BoxFit.cover,
// //             ),
// //           ),
// //           Container(
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 begin: Alignment(0.0, -0.5),
// //                 end: Alignment.bottomCenter,
// //                 colors: [
// //                   kBackgroundColor.withOpacity(0.5),
// //                   Colors.transparent,
// //                   kBackgroundColor,
// //                 ],
// //               ),
// //             ),
// //           ),
// //           Center(
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Text(
// //                 workout.translated[locale],
// //                 textAlign: TextAlign.center,
// //                 style: GoogleFonts.blackHanSans(
// //                   color: Colors.white,
// //                   fontSize: 40,
// //                 ),
// //                 maxLines: 2,
// //                 overflow: TextOverflow.ellipsis,
// //                 softWrap: true,
// //               ),
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(16.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.end,
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                   children: <Widget>[
// //                     // Main Muscle Group
// //                     Container(
// //                       width: size.width / 4,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: <Widget>[
// //                           Text(S.current.mainMuscleGroup, style: kCaption1Grey),
// //                           const SizedBox(height: 8),
// //                           Text(
// //                             mainMuscleGroup,
// //                             style: kSubtitle2,
// //                           ),
// //                         ],
// //                       ),
// //                     ),

// //                     Container(
// //                       color: Colors.white.withOpacity(0.1),
// //                       width: 1,
// //                       height: 56,
// //                       margin: const EdgeInsets.symmetric(horizontal: 8),
// //                     ),

// //                     // Equipment Required
// //                     Container(
// //                       width: size.width / 4,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: <Widget>[
// //                           Text(
// //                             S.current.equipmentRequired,
// //                             style: kCaption1Grey,
// //                           ),
// //                           const SizedBox(height: 8),
// //                           Text(equipmentRequired, style: kSubtitle2),
// //                         ],
// //                       ),
// //                     ),

// //                     Container(
// //                       color: Colors.white.withOpacity(0.1),
// //                       width: 1,
// //                       height: 56,
// //                       margin: const EdgeInsets.symmetric(horizontal: 8),
// //                     ),

// //                     // Experience Level
// //                     Container(
// //                       width: size.width / 4,
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: <Widget>[
// //                           Text(S.current.difficulty, style: kCaption1Grey),
// //                           const SizedBox(height: 8),
// //                           Text(difficulty, style: kSubtitle2),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 const SizedBox(height: 24),
// //                 Text(
// //                   description,
// //                   style: kBodyText2LightGrey,
// //                   maxLines: 5,
// //                   overflow: TextOverflow.ellipsis,
// //                   softWrap: false,
// //                 ),
// //                 const SizedBox(height: 24),
// //                 MaxWidthRaisedButton(
// //                   width: double.infinity,
// //                   color: kGrey800,
// //                   icon: const Icon(
// //                     Icons.add_rounded,
// //                     color: Colors.white,
// //                     size: 20,
// //                   ),
// //                   kButtonText: S.current.addWorkoutToRoutinekButtonText,
// //                   onPressed: () => AddWorkoutToRoutineScreen.show(
// //                     context,
// //                     workout: workout,
// //                   ),
// //                 ),
// //                 // SizedBox(height: 48),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/max_width_raised_button.dart';
import 'package:workout_player/format.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import '../../../constants.dart';
import 'add_workout_to_routine_screen.dart';
import 'edit_workout/edit_workout_screen.dart';

class WorkoutDetailScreen extends StatefulWidget {
  WorkoutDetailScreen({
    required this.workout,
    required this.database,
    required this.user,
    required this.tag,
  });
  final Workout workout;
  final Database database;
  final User user;
  final String tag;
  // For Navigation
  static Future<void> show(
    BuildContext context, {
    required Workout workout,
    bool isRootNavigation = false,
    required String tag,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;
    await HapticFeedback.mediumImpact();
    if (!isRootNavigation) {
      await Navigator.of(context, rootNavigator: false).push(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            database: database,
            user: user,
            tag: tag,
          ),
        ),
      );
    } else {
      await Navigator.of(context, rootNavigator: true).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => WorkoutDetailScreen(
            workout: workout,
            database: database,
            user: user,
            tag: tag,
          ),
        ),
      );
    }
  }

  @override
  _WorkoutDetailScreenState createState() => _WorkoutDetailScreenState();
}

class _WorkoutDetailScreenState extends State<WorkoutDetailScreen> {
  // PageController _pageController = PageController();
  @override
  void initState() {
    super.initState();
    debugPrint('workout detail screen init');
  }

  @override
  void dispose() {
    debugPrint('workout detail screen dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: CustomStreamBuilderWidget<Workout?>(
        initialData: widget.workout,
        stream: widget.database.workoutStream(widget.workout.workoutId),
        hasDataWidget: (context, snapshot) {
          return Stack(
            children: [
              CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  _buildSliverAppBar(context, snapshot.data!),
                  // _buildSliverToBoxAdapter(workout),
                ],
              ),
            ],
          );
        },
      ),
      // body: StreamBuilder<Workout>(
      //   initialData: workoutDummyData,
      //   stream: widget.database.workoutStream(
      //     workoutId: widget.workout.workoutId,
      //   ),
      //   builder: (context, snapshot) {
      //     final workout = snapshot.data;
      //     return Stack(
      //       children: [
      //         CustomScrollView(
      //           physics: const BouncingScrollPhysics(),
      //           slivers: [
      //             _buildSliverAppBar(context, workout),
      //             // _buildSliverToBoxAdapter(workout),
      //           ],
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, Workout workout) {
    final size = MediaQuery.of(context).size;
    return SliverAppBar(
      brightness: Brightness.dark,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: kBackgroundColor,
      floating: false,
      pinned: true,
      snap: false,
      stretch: true,
      expandedHeight: size.height * 4 / 5,
      centerTitle: true,
      // title: isShrink ? Text(workout.workoutTitle, style: kSubtitle1) : null,
      // bottom: TabBar(
      //   labelColor: Colors.white,
      //   unselectedLabelColor: kGrey400,
      //   indicatorColor: kPrimaryColor,
      //   tabs: [
      //     Tab(text: 'Instructions'),
      //     Tab(text: 'Histories'),
      //   ],
      // ),
      actions: <Widget>[
        if (widget.user.userId == workout.workoutOwnerId)
          IconButton(
            icon: const Icon(Icons.edit_rounded, color: Colors.white),
            onPressed: () => EditWorkoutScreen.show(
              context,
              workout: workout,
            ),
          ),
        // IconButton(
        //   // icon: Icon(Icons.favorite_border_rounded),
        //   icon: Icon(
        //     (widget.userSavedWorkout.isSavedWorkout)
        //         ? Icons.favorite_rounded
        //         : Icons.favorite_border_rounded,
        //     color: (widget.userSavedWorkout.isSavedWorkout)
        //         ? kPrimaryColor
        //         : Colors.white,
        //   ),
        //   onPressed: () => _toggleFavorites(context),
        // ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: _buildFlexibleSpaceBarWidget(workout),
      // flexibleSpace: _FlexibleSpaceBarWidget(
      //   workout: widget.workout,
      //   tag: widget.tag,
      // ),
    );
  }

  Widget _buildFlexibleSpaceBarWidget(Workout workout) {
    final size = MediaQuery.of(context).size;
    final locale = Intl.getCurrentLocale();
    final mainMuscleGroup = MainMuscleGroup.values
        .firstWhere((e) => e.toString() == workout.mainMuscleGroup[0])
        .translation!;
    final equipmentRequired = EquipmentRequired.values
        .firstWhere((e) => e.toString() == workout.equipmentRequired[0])
        .translation!;
    final difficulty = Format.difficulty(workout.difficulty)!;
    final description = workout.description;
    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.passthrough,
        children: [
          Hero(
            tag: widget.tag,
            child: CachedNetworkImage(
              imageUrl: workout.imageUrl,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.0, -0.5),
                end: Alignment.bottomCenter,
                colors: [
                  kBackgroundColor.withOpacity(0.5),
                  Colors.transparent,
                  kBackgroundColor,
                ],
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                workout.translated[locale],
                textAlign: TextAlign.center,
                style: GoogleFonts.blackHanSans(
                  color: Colors.white,
                  fontSize: 40,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    // Main Muscle Group
                    Container(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(S.current.mainMuscleGroup, style: kCaption1Grey),
                          const SizedBox(height: 8),
                          Text(
                            mainMuscleGroup,
                            style: kSubtitle2,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    // Equipment Required
                    Container(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.current.equipmentRequired,
                            style: kCaption1Grey,
                          ),
                          const SizedBox(height: 8),
                          Text(equipmentRequired, style: kSubtitle2),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                      height: 56,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    // Experience Level
                    Container(
                      width: size.width / 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(S.current.difficulty, style: kCaption1Grey),
                          const SizedBox(height: 8),
                          Text(difficulty, style: kSubtitle2),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  description,
                  style: kBodyText2LightGrey,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                const SizedBox(height: 24),
                MaxWidthRaisedButton(
                  width: double.infinity,
                  color: kGrey800,
                  icon: const Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  buttonText: S.current.addWorkoutToRoutinekButtonText,
                  onPressed: () => AddWorkoutToRoutineScreen.show(
                    context,
                    workout: workout,
                  ),
                ),
                // SizedBox(height: 48),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
