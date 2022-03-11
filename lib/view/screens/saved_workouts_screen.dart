import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import 'workout_detail_screen.dart';

class SavedWorkoutsScreen extends ConsumerWidget {
  final User user;

  const SavedWorkoutsScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => SavedWorkoutsScreen(
        user: user,
      ),
    );
  }

  void _getDocuments(List<Future<Workout?>> workoutsFuture, Database database) {
    user.savedWorkouts?.map((id) {
      final Future<Workout?> nextDoc = database.getWorkout(id);
      workoutsFuture.add(nextDoc);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Future<Workout?>> workoutsFuture = [];

    final size = MediaQuery.of(context).size;

    _getDocuments(workoutsFuture, ref.read(databaseProvider));

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.savedWorkouts, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
      ),
      body: (user.savedWorkouts!.isEmpty)
          ? EmptyContent(message: S.current.noSavedWorkoutsYet)
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
                            final Workout workout = snapshot.data!;

                            final subtitle = MainMuscleGroup.values
                                .firstWhere(
                                  (e) =>
                                      e.toString() ==
                                      workout.mainMuscleGroup[0],
                                )
                                .translation;

                            return LibraryListTile(
                              tag: 'savedWorkout-${workout.workoutId}',
                              title: workout.workoutTitle,
                              subtitle: subtitle!,
                              imageUrl: workout.imageUrl,
                              onTap: () => WorkoutDetailScreen.show(
                                context,
                                workout: workout,
                                workoutId: workout.workoutId,
                                tag: 'savedWorkout-${workout.workoutId}',
                              ),
                            );
                          } else if (snapshot.hasError) {
                            return const ListTile(
                              leading: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(),
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
