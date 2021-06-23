import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_list_tile_64.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../routine_detail_screen.dart';

// ignore: must_be_immutable
class SavedRoutinesScreen extends StatelessWidget {
  final Database database;
  final User user;

  SavedRoutinesScreen({
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
        builder: (context) => SavedRoutinesScreen(
          database: database,
          user: user,
        ),
      ),
    );
  }

  List<Future<Routine?>> routinesFuture = [];

  void _getDocuments() {
    user.savedRoutines!.forEach((id) {
      Future<Routine?> nextDoc = database.getRoutine(id);
      print(nextDoc);
      routinesFuture.add(nextDoc);
      // routinesFuture.add(nextDoc);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _getDocuments();
    // print('doc length is ${routinesFuture[0]}');

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
                    children: routinesFuture.map((element) {
                      return FutureBuilder<Routine?>(
                        future: element,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Routine routine = snapshot.data!;
                            final subtitle = MainMuscleGroup.values
                                .firstWhere(
                                  (e) =>
                                      e.toString() ==
                                      routine.mainMuscleGroup[0],
                                )
                                .translation;

                            return CustomListTile64(
                              tag: 'savedRoutiness-${routine.routineId}',
                              title: routine.routineTitle,
                              subtitle: subtitle!,
                              imageUrl: routine.imageUrl,
                              onTap: () => RoutineDetailScreen.show(
                                context,
                                routine: routine,
                                tag: 'savedRoutiness-${routine.routineId}',
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
                          } else if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: const CircularProgressIndicator(),
                            );
                          } else {
                            return Container();
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
