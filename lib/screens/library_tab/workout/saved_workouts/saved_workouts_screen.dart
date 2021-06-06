import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/workout/workout_detail_screen.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_list_tile_64.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
// import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';

// ignore: must_be_immutable
class SavedWorkoutsScreen extends StatelessWidget {
  final Database database;
  final User user;

  SavedWorkoutsScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static Future<void> show(BuildContext context, {required User user}) async {
    final database = Provider.of<Database>(context, listen: false);
    // final auth = Provider.of<AuthBase>(context, listen: false);
    // final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => SavedWorkoutsScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  List<Future<Workout?>> workoutsFuture = [];

  void _getDocuments() {
    user.savedWorkouts!.forEach((id) {
      Future<Workout?> nextDoc = database.getWorkout(id);
      print(nextDoc);
      workoutsFuture.add(nextDoc);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _getDocuments();

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Text(S.current.savedRoutines, style: kSubtitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: kAppBarColor,
        flexibleSpace: const AppbarBlurBG(),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
      ),
      body: (user.savedRoutines!.isEmpty)
          ? EmptyContent(message: S.current.noSavedRoutinesYet)
          : SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: workoutsFuture.map((element) {
                      return FutureBuilder<Workout?>(
                        future: element,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Workout workout = snapshot.data!;
                            final subtitle = MainMuscleGroup.values
                                .firstWhere(
                                  (e) =>
                                      e.toString() ==
                                      workout.mainMuscleGroup[0],
                                )
                                .translation;

                            return CustomListTile64(
                              tag: 'savedWorkout-${workout.workoutId}',
                              title: workout.workoutTitle,
                              subtitle: subtitle!,
                              imageUrl: workout.imageUrl,
                              onTap: () => WorkoutDetailScreen.show(
                                context,
                                workoutId: workout.workoutId,
                                tag: 'savedWorkout-${workout.workoutId}',
                              ),
                            );
                          } else if (snapshot.hasError) {
                            logger.e(snapshot.error);
                            return const ListTile(
                              leading: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return Center(
                              child: const CircularProgressIndicator(),
                            );
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
    );
  }
}
