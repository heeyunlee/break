import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_list_tile_64.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';

import '../../../../constants.dart';
import '../routine_detail_screen.dart';

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

  final List<Routine> _lists = [];

  final _routinesFuture = <Future<Routine?>>[];

  void getDocuments() {
    print('1');
    user.savedRoutines!.forEach((routineId) {
      print('2');
      Future<Routine?> nextDoc = database.getRoutineDoc(routineId);
      if (nextDoc != null) {
        _routinesFuture.add(nextDoc);
      }
    });
    print('3');
    print('${_routinesFuture.length}');
  }

  // Future<void> makeSync() {
  //   _routinesFuture.forEach((element) async {
  //     var i = await element;
  //     _lists.add(i);
  //     print('4');
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    getDocuments();
    // makeSync();

    print('5');

    print('length is ${_lists.length}');

    return Scaffold(
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        title: Text(S.current.savedRoutines, style: Subtitle2),
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: AppBarColor,
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
                    children: _routinesFuture.map((element) {
                      return FutureBuilder<Routine?>(
                        future: element,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data != null) {
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
                                  isRootNavigation: false,
                                  tag: 'savedRoutiness-${routine.routineId}',
                                ),
                              );
                            } else {
                              return Container();
                            }
                          } else if (snapshot.hasError) {
                            return const ListTile(
                              leading: Icon(
                                Icons.error_outline_outlined,
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return Center(
                                child: const CircularProgressIndicator());
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
