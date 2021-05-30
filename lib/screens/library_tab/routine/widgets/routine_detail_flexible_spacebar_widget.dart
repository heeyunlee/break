import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
// import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

import '../../../../constants.dart';
// import '../../../../format.dart';

class RoutineDetailFlexibleSpaceWidget extends StatelessWidget {
  final String tag;
  final Routine routine;
  final Database database;

  const RoutineDetailFlexibleSpaceWidget({
    Key? key,
    required this.tag,
    required this.routine,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final routineTitle = routine.routineTitle;
    final routineOwnerUserName = routine.routineOwnerUserName;

    // // FORMATTING
    // final trainingLevel = Format.difficulty(routine.trainingLevel)!;
    // final duration = Format.durationInMin(routine.duration);
    // final weights = Format.weights(routine.totalWeights);
    // final unitOfMass = Format.unitOfMass(routine.initialUnitOfMass);

    // final String description = routine.description == null
    //     ? S.current.addDescription
    //     : routine.description!.isEmpty
    //         ? S.current.addDescription
    //         : routine.description!;

    String _mainMuscleGroups = '';
    for (var i = 0; i < routine.mainMuscleGroup.length; i++) {
      String _mainMuscleGroup;
      if (i == 0) {
        _mainMuscleGroups = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[i])
            .translation!;
      } else {
        _mainMuscleGroup = MainMuscleGroup.values
            .firstWhere((e) => e.toString() == routine.mainMuscleGroup[i])
            .translation!;
        _mainMuscleGroups = _mainMuscleGroups + ', $_mainMuscleGroup';
      }
    }

    String _equipments = '';
    for (var i = 0; i < routine.equipmentRequired.length; i++) {
      String _equipment;
      if (i == 0) {
        _equipments = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation!;
      } else {
        _equipment = EquipmentRequired.values
            .firstWhere((e) => e.toString() == routine.equipmentRequired[i])
            .translation!;
        _equipments = _equipments + ', $_equipment';
      }
    }

    // String location = Location.values
    //     .firstWhere((e) => e.toString() == routine.location)
    //     .translation!;

    Widget _getTitleWidget() {
      if (routineTitle.length < 21) {
        return Text(
          routineTitle,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 28,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      } else if (routineTitle.length >= 21 && routineTitle.length < 35) {
        return FittedBox(
          child: Text(
            routineTitle,
            style: GoogleFonts.blackHanSans(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        );
      } else {
        return Text(
          routineTitle,
          style: GoogleFonts.blackHanSans(
            color: Colors.white,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.fade,
          softWrap: false,
        );
      }
    }

    return FlexibleSpaceBar(
      background: CustomStreamBuilderWidget<Routine?>(
          initialData: routine,
          stream: database.routineStream(routine.routineId),
          hasDataWidget: (context, snapshot) {
            // return SizedBox(
            //   height: size.height * 2 / 5,
            //   width: size.width,
            //   child: Hero(
            //     tag: tag,
            //     child: CachedNetworkImage(
            //       imageUrl: routine.imageUrl,
            //       errorWidget: (context, url, error) => const Icon(Icons.error),
            //       // fit: BoxFit.contain,
            //       fit: BoxFit.cover,
            //       // fit: BoxFit.fill,
            //       // fit: BoxFit.fitHeight,
            //       // fit: BoxFit.fitWidth,
            //       // fit: BoxFit.scaleDown,
            //       // fit: BoxFit.none,
            //     ),
            //   ),
            // );
            return Stack(
              alignment: Alignment.center,
              fit: StackFit.passthrough,
              children: [
                Hero(
                  tag: tag,
                  child: CachedNetworkImage(
                    imageUrl: routine.imageUrl,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    // fit: BoxFit.contain,
                    fit: BoxFit.cover,
                    // fit: BoxFit.fill,
                    // fit: BoxFit.fitHeight,
                    // fit: BoxFit.fitWidth,
                    // fit: BoxFit.scaleDown,
                    // fit: BoxFit.none,
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -0.3),
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        kBackgroundColor,
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   top: 0,
                //   child: SizedBox(
                //     height: size.height * 2 / 5,
                //     width: size.width,
                //     child: Hero(
                //       tag: tag,
                //       child: CachedNetworkImage(
                //         imageUrl: routine.imageUrl,
                //         errorWidget: (context, url, error) =>
                //             const Icon(Icons.error),
                //         // fit: BoxFit.contain,
                //         fit: BoxFit.cover,
                //         // fit: BoxFit.fill,
                //         // fit: BoxFit.fitHeight,
                //         // fit: BoxFit.fitWidth,
                //         // fit: BoxFit.scaleDown,
                //         // fit: BoxFit.none,
                //       ),
                //     ),
                //   ),
                // ),
                Positioned(
                  bottom: 8,
                  child: SizedBox(
                    width: size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getTitleWidget(),
                          const SizedBox(height: 4),
                          Text(
                            routineOwnerUserName,
                            style: kSubtitle2BoldGrey,
                          ),
                          const SizedBox(height: 4),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 4),
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         weights + ' ' + unitOfMass,
                          //         style: kBodyText2Light,
                          //       ),
                          //       const Text('  \u2022  ', style: kCaption1),
                          //       Text(
                          //         '$duration ${S.current.minutes}',
                          //         style: kBodyText2Light,
                          //       ),
                          //       const Text('  \u2022  ', style: kCaption1),
                          //       Text(trainingLevel, style: kBodyText2Light)
                          //     ],
                          //   ),
                          // ),

                          // // Main Muscle Group
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8),
                          //   child: Row(
                          //     children: [
                          //       CachedNetworkImage(
                          //         imageUrl: kBicepEmojiUrl,
                          //         color: Colors.white,
                          //         width: 20,
                          //         height: 20,
                          //       ),
                          //       const SizedBox(width: 16),
                          //       SizedBox(
                          //         width: size.width - 68,
                          //         child: Text(
                          //           _mainMuscleGroups,
                          //           style: kBodyText1,
                          //           maxLines: 1,
                          //           softWrap: false,
                          //           overflow: TextOverflow.fade,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // // Equipment Required
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8),
                          //   child: Row(
                          //     children: [
                          //       const Icon(
                          //         Icons.fitness_center_rounded,
                          //         size: 20,
                          //         color: Colors.white,
                          //       ),
                          //       const SizedBox(width: 16),
                          //       SizedBox(
                          //         width: size.width - 68,
                          //         child: Text(
                          //           _equipments,
                          //           style: kBodyText1,
                          //           maxLines: 1,
                          //           softWrap: false,
                          //           overflow: TextOverflow.fade,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                          // // Location
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(vertical: 8),
                          //   child: Row(
                          //     children: [
                          //       const Icon(
                          //         Icons.location_on_rounded,
                          //         size: 20,
                          //         color: Colors.white,
                          //       ),
                          //       const SizedBox(width: 16),
                          //       Text(location, style: kBodyText1),
                          //     ],
                          //   ),
                          // ),
                          // const SizedBox(height: 16),
                          // Text(
                          //   description,
                          //   style: kBodyText2LightGrey,
                          //   maxLines: 3,
                          //   overflow: TextOverflow.ellipsis,
                          //   softWrap: false,
                          // ),
                          // const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                // Positioned(
                //   bottom: 8,
                //   child: SizedBox(
                //     width: size.width,
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 16),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           _getTitleWidget(),
                //           const SizedBox(height: 4),
                //           Text(
                //             routineOwnerUserName,
                //             style: kSubtitle2BoldGrey,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            );
          }),
    );
  }
}
