import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/appbar_blur_bg.dart';
import 'package:workout_player/widgets/custom_list_tile_64.dart';
import 'package:workout_player/widgets/empty_content.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

class AddWorkoutToRoutineScreen extends StatefulWidget {
  const AddWorkoutToRoutineScreen({
    Key? key,
    required this.database,
    required this.workout,
    required this.auth,
    required this.user,
  }) : super(key: key);

  final Database database;
  final Workout workout;
  final AuthBase auth;
  final User user;

  static void show(
    BuildContext context, {
    required Workout workout,
  }) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    final User user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => AddWorkoutToRoutineScreen(
          workout: workout,
          database: database,
          auth: auth,
          user: user,
        ),
      ),
    );

    // await pushNewScreen(
    //   context,
    //   pageTransitionAnimation: PageTransitionAnimation.slideUp,
    //   withNavBar: false,
    //   screen: AddWorkoutToRoutineScreen(
    //     workout: workout,
    //     database: database,
    //     auth: auth,
    //     user: user,
    //   ),
    // );
  }

  @override
  _AddWorkoutToRoutineScreenState createState() =>
      _AddWorkoutToRoutineScreenState();
}

class _AddWorkoutToRoutineScreenState extends State<AddWorkoutToRoutineScreen> {
  Future<void> _submit(Routine routine) async {
    try {
      final routineWorkouts =
          await widget.database.routineWorkoutsStream(routine.routineId).first;
      final index = routineWorkouts.length + 1;

      final routineWorkout = RoutineWorkout(
        routineWorkoutId: documentIdFromCurrentDate(),
        workoutId: widget.workout.workoutId,
        routineId: routine.routineId,
        routineWorkoutOwnerId: widget.auth.currentUser!.uid,
        workoutTitle: widget.workout.workoutTitle,
        isBodyWeightWorkout: widget.workout.isBodyWeightWorkout,
        totalWeights: 0,
        numberOfSets: 0,
        numberOfReps: 0,
        duration: 0,
        secondsPerRep: widget.workout.secondsPerRep,
        sets: [],
        index: index,
        translated: widget.workout.translated,
      );
      await widget.database.setRoutineWorkout(routine, routineWorkout);
      Navigator.of(context).popUntil((route) => route.isFirst);
      await RoutineDetailScreen.show(
        context,
        routine: routine,
        tag: '',
      );

      // TODO: add snack bar HERE
    } on Exception catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        brightness: Brightness.dark,
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: Text(S.current.addWorkoutToRoutine, style: kSubtitle1),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Builder(builder: (BuildContext context) => _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return PaginateFirestore(
      shrinkWrap: true,
      query: widget.database.routinesPaginatedUserQuery(),
      physics: const AlwaysScrollableScrollPhysics(),
      itemBuilderType: PaginateBuilderType.listView,
      emptyDisplay: EmptyContent(
        message: S.current.emptyRoutineMessage,
      ),
      itemsPerPage: 10,
      header: SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 8),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: '${S.current.somethingWentWrong}: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        // final documentId = documentSnapshot.id;
        // final data = documentSnapshot.data()!;
        // final routine = Routine.fromJson(data, documentId);
        final snapshot = documentSnapshot as DocumentSnapshot<Routine?>;
        final routine = snapshot.data()!;

        return CustomListTile64(
          tag: 'routine${routine.routineId}',
          title: routine.routineTitle,
          subtitle: routine.routineOwnerUserName,
          imageUrl: routine.imageUrl,
          onTap: () => _submit(routine),
        );
      },
      isLive: true,
    );
  }
}
