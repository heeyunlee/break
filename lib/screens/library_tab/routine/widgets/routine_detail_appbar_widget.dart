// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:workout_player/generated/l10n.dart';
// import 'package:workout_player/models/enum/equipment_required.dart';
// import 'package:workout_player/models/enum/location.dart';
// import 'package:workout_player/models/enum/main_muscle_group.dart';
// import 'package:workout_player/models/routine.dart';
// import 'package:workout_player/models/routine_workout.dart';
// import 'package:workout_player/models/user.dart';
// import 'package:workout_player/screens/library_tab/routine/edit_routine/edit_routine_screen.dart';
// import 'package:workout_player/screens/library_tab/routine/log_routine/log_routine_screen.dart';
// import 'package:workout_player/services/auth.dart';
// import 'package:workout_player/services/database.dart';
// import 'package:workout_player/services/main_provider.dart';
// import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
// import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

// import '../../../../constants.dart';
// import '../../../../format.dart';
// import 'routine_start_button.dart';

// class RoutineDetailAppBarWidget extends StatefulWidget {
//   final Routine routine;
//   final AsyncValue<List<RoutineWorkout?>> asyncValue;
//   final String tag;
//   final Database database;
//   final AuthBase auth;
//   final User user;

//   const RoutineDetailAppBarWidget({
//     Key? key,
//     required this.routine,
//     required this.asyncValue,
//     required this.tag,
//     required this.database,
//     required this.auth,
//     required this.user,
//   }) : super(key: key);

//   @override
//   _RoutineDetailAppBarWidgetState createState() =>
//       _RoutineDetailAppBarWidgetState();
// }

// class _RoutineDetailAppBarWidgetState extends State<RoutineDetailAppBarWidget> {
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     // FORMATTING
//     final _trainingLevel = Format.difficulty(widget.routine.trainingLevel)!;
//     final _duration = Format.durationInMin(widget.routine.duration);
//     final _weights = Format.weights(widget.routine.totalWeights);
//     final _unitOfMass = Format.unitOfMass(widget.routine.initialUnitOfMass);

//     String _mainMuscleGroups = '';
//     for (var i = 0; i < widget.routine.mainMuscleGroup.length; i++) {
//       String _mainMuscleGroup;
//       if (i == 0) {
//         _mainMuscleGroups = MainMuscleGroup.values
//             .firstWhere(
//                 (e) => e.toString() == widget.routine.mainMuscleGroup[i])
//             .translation!;
//       } else {
//         _mainMuscleGroup = MainMuscleGroup.values
//             .firstWhere(
//                 (e) => e.toString() == widget.routine.mainMuscleGroup[i])
//             .translation!;
//         _mainMuscleGroups = _mainMuscleGroups + ', $_mainMuscleGroup';
//       }
//     }

//     String _equipments = '';
//     for (var i = 0; i < widget.routine.equipmentRequired.length; i++) {
//       String _equipment;
//       if (i == 0) {
//         _equipments = EquipmentRequired.values
//             .firstWhere(
//                 (e) => e.toString() == widget.routine.equipmentRequired[i])
//             .translation!;
//       } else {
//         _equipment = EquipmentRequired.values
//             .firstWhere(
//                 (e) => e.toString() == widget.routine.equipmentRequired[i])
//             .translation!;
//         _equipments = _equipments + ', $_equipment';
//       }
//     }

//     String _location = Location.values
//         .firstWhere((e) => e.toString() == widget.routine.location)
//         .translation!;

//     return AnimatedBuilder(
//       animation: _colorAnimationController,
//       builder: (context, child) => SliverAppBar(
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_rounded,
//             color: Colors.white,
//           ),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         centerTitle: true,
//         brightness: Brightness.dark,
//         title: Transform.translate(
//           offset: _transTween.value,
//           child: Text(widget.routine.routineTitle, style: kSubtitle1),
//         ),
//         backgroundColor: _colorTween.value,
//         floating: false,
//         pinned: true,
//         snap: false,
//         stretch: true,
//         elevation: 0,
//         expandedHeight: size.height / 2 + 24,
//         flexibleSpace: FlexibleSpaceBar(
//           background: Column(
//             children: [
//               SizedBox(
//                 height: size.height / 4,
//                 width: size.width,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   fit: StackFit.passthrough,
//                   children: [
//                     Hero(
//                       tag: widget.tag,
//                       child: CachedNetworkImage(
//                         imageUrl: widget.routine.imageUrl,
//                         errorWidget: (context, url, error) =>
//                             const Icon(Icons.error),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     Container(
//                       decoration: const BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment(0.0, 0.0),
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             kAppBarColor,
//                           ],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 16,
//                       left: 16,
//                       child: _getTitleWidget(widget.routine.routineTitle),
//                     ),
//                     Positioned(
//                       bottom: 0,
//                       left: 16,
//                       child: Text(
//                         widget.routine.routineOwnerUserName,
//                         style: kSubtitle2BoldGrey,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Expanded(
//                 child: Container(
//                   width: double.maxFinite,
//                   color: kAppBarColor,
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 4),
//                           child: Row(
//                             children: [
//                               Text(
//                                 _weights + ' ' + _unitOfMass,
//                                 style: kBodyText2Light,
//                               ),
//                               const Text('  \u2022  ', style: kCaption1),
//                               Text(
//                                 '$_duration ${S.current.minutes}',
//                                 style: kBodyText2Light,
//                               ),
//                               const Text('  \u2022  ', style: kCaption1),
//                               Text(_trainingLevel, style: kBodyText2Light)
//                             ],
//                           ),
//                         ),

//                         // Main Muscle Group
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Row(
//                             children: [
//                               CachedNetworkImage(
//                                 imageUrl: kBicepEmojiUrl,
//                                 color: Colors.white,
//                                 width: 20,
//                                 height: 20,
//                               ),
//                               const SizedBox(width: 16),
//                               SizedBox(
//                                 width: size.width - 68,
//                                 child: Text(
//                                   _mainMuscleGroups,
//                                   style: kBodyText1,
//                                   maxLines: 1,
//                                   softWrap: false,
//                                   overflow: TextOverflow.fade,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Equipment Required
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.fitness_center_rounded,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                               const SizedBox(width: 16),
//                               SizedBox(
//                                 width: size.width - 68,
//                                 child: Text(
//                                   _equipments,
//                                   style: kBodyText1,
//                                   maxLines: 1,
//                                   softWrap: false,
//                                   overflow: TextOverflow.fade,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),

//                         // Location
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.location_on_rounded,
//                                 size: 20,
//                                 color: Colors.white,
//                               ),
//                               const SizedBox(width: 16),
//                               Text(_location, style: kBodyText1),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 16),

//                         // Description
//                         Text(
//                           widget.routine.description ??
//                               S.current.addDescription,
//                           style: kBodyText2LightGrey,
//                           maxLines: 3,
//                           overflow: TextOverflow.ellipsis,
//                           softWrap: false,
//                         ),
//                         const SizedBox(height: 24),

//                         // Log and Start Button
//                         Row(
//                           children: [
//                             OutlinedButton(
//                               style: OutlinedButton.styleFrom(
//                                 minimumSize: Size((size.width - 48) / 2, 48),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 side:
//                                     BorderSide(width: 2, color: kPrimaryColor),
//                               ),
//                               onPressed: () => LogRoutineScreen.show(
//                                 context,
//                                 routine: widget.routine,
//                                 database: widget.database,
//                                 auth: widget.auth,
//                                 user: widget.user,
//                               ),
//                               child: Text(S.current.logRoutine,
//                                   style: kButtonText),
//                             ),
//                             const SizedBox(width: 16),
//                             RoutineStartButton(
//                               routine: widget.routine,
//                               asyncValue: widget.asyncValue,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           if (widget.auth.currentUser!.uid != widget.routine.routineOwnerId)
//             _getSaveButton(),
//           if (widget.auth.currentUser!.uid == widget.routine.routineOwnerId)
//             IconButton(
//               icon: const Icon(
//                 Icons.edit_rounded,
//                 color: Colors.white,
//               ),
//               onPressed: () => EditRoutineScreen.show(
//                 context,
//                 routine: widget.routine,
//               ),
//             ),
//           const SizedBox(width: 8),
//         ],
//       ),
//     );
//   }

//   Widget _getTitleWidget(String routineTitle) {
//     if (routineTitle.length < 21) {
//       return Text(
//         routineTitle,
//         style: GoogleFonts.blackHanSans(
//           color: Colors.white,
//           fontSize: 28,
//         ),
//         maxLines: 1,
//         overflow: TextOverflow.fade,
//         softWrap: false,
//       );
//     } else if (routineTitle.length >= 21 && routineTitle.length < 35) {
//       return FittedBox(
//         child: Text(
//           routineTitle,
//           style: GoogleFonts.blackHanSans(
//             color: Colors.white,
//             fontSize: 28,
//           ),
//         ),
//       );
//     } else {
//       return Text(
//         routineTitle,
//         style: GoogleFonts.blackHanSans(
//           color: Colors.white,
//           fontSize: 20,
//         ),
//         maxLines: 1,
//         overflow: TextOverflow.fade,
//         softWrap: false,
//       );
//     }
//   }

//   Widget _saveButton() {
//     return IconButton(
//       icon: Icon(
//         Icons.bookmark_border_rounded,
//         color: Colors.white,
//       ),
//       onPressed: () async {
//         try {
//           final user = {
//             'savedRoutines': FieldValue.arrayUnion([widget.routine.routineId]),
//           };

//           await widget.database.updateUser(widget.auth.currentUser!.uid, user);

//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text(S.current.savedRoutineSnackbar),
//               duration: Duration(seconds: 2),
//               behavior: SnackBarBehavior.floating,
//             ),
//           );

//           debugPrint('added routine to saved routine');
//         } on FirebaseException catch (e) {
//           logger.e(e);
//           await showExceptionAlertDialog(
//             context,
//             title: S.current.operationFailed,
//             exception: e.toString(),
//           );
//         }
//       },
//     );
//   }

//   Widget _unsaveButton() {
//     return IconButton(
//       icon: Icon(
//         Icons.bookmark_rounded,
//         color: Colors.white,
//       ),
//       onPressed: () async {
//         final user = {
//           'savedRoutines': FieldValue.arrayRemove([widget.routine.routineId]),
//         };

//         await widget.database.updateUser(widget.auth.currentUser!.uid, user);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(S.current.unsavedRoutineSnackbar),
//             duration: Duration(seconds: 2),
//             behavior: SnackBarBehavior.floating,
//           ),
//         );

//         debugPrint('Removed routine from saved routine');
//       },
//     );
//   }

//   Widget _getSaveButton() {
//     return CustomStreamBuilderWidget<User?>(
//       initialData: widget.user,
//       stream: widget.database.userStream(widget.auth.currentUser!.uid),
//       hasDataWidget: (context, snapshot) {
//         final User user = snapshot.data!;

//         if (user.savedRoutines != null) {
//           if (user.savedRoutines!.isNotEmpty) {
//             if (user.savedRoutines!.contains(widget.routine.routineId)) {
//               return _unsaveButton();
//             } else {
//               return _saveButton();
//             }
//           } else {
//             return _saveButton();
//           }
//         } else {
//           return _saveButton();
//         }
//       },
//       errorWidget: const Icon(Icons.error, color: Colors.white),
//       loadingWidget: const Icon(Icons.sync, color: Colors.white),
//     );
//   }
// }
