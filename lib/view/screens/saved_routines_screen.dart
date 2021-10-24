import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/routine_detail_screen.dart';
import 'package:workout_player/view/widgets/library/library_list_tile.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/widgets.dart';

class SavedRoutinesScreen extends StatelessWidget {
  final Database database;
  final User user;

  const SavedRoutinesScreen({
    Key? key,
    required this.database,
    required this.user,
  }) : super(key: key);

  static void show(BuildContext context, {required User user}) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context, auth, database) => SavedRoutinesScreen(
        database: database,
        user: user,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(S.current.savedRoutines, style: TextStyles.subtitle2),
        centerTitle: true,
        leading: const AppBarBackButton(),
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
                    children: _list(),
                  ),
                ),
              ),
            ),
    );
  }

  List<Widget> _list() {
    return user.savedRoutines!.map((id) {
      final Future<Routine?> future = database.getRoutine(id);

      return CustomFutureBuilder<Routine?>(
        future: future,
        errorWidget: Container(),
        builder: (context, routine) {
          if (routine != null) {
            return LibraryListTile(
              tag: 'savedRoutiness-${routine.routineId}',
              title: routine.routineTitle,
              subtitle: Formatter.getJoinedMainMuscleGroups(
                routine.mainMuscleGroup,
                routine.mainMuscleGroupEnum,
              ),
              imageUrl: routine.imageUrl,
              onTap: () => RoutineDetailScreen.show(
                context,
                routine: routine,
                tag: 'savedRoutiness-${routine.routineId}',
              ),
            );
          } else {
            return Container();
          }
        },
      );
    }).toList();
  }
}
