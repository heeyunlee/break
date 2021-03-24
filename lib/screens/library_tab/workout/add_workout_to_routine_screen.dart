import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:workout_player/common_widgets/appbar_blur_bg.dart';
import 'package:workout_player/common_widgets/custom_list_tile_64.dart';
import 'package:workout_player/common_widgets/empty_content.dart';
import 'package:workout_player/common_widgets/show_exception_alert_dialog.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/models/workout.dart';
import 'package:workout_player/screens/library_tab/routine/routine_detail_screen.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';

import '../../../constants.dart';

Logger logger = Logger();

class AddWorkoutToRoutineScreen extends StatefulWidget {
  const AddWorkoutToRoutineScreen({
    Key key,
    this.database,
    this.workout,
    this.auth,
    this.user,
  }) : super(key: key);

  final Database database;
  final Workout workout;
  final AuthBase auth;
  final User user;

  static void show(BuildContext context, {Workout workout}) async {
    final database = Provider.of<Database>(context, listen: false);
    final auth = Provider.of<AuthBase>(context, listen: false);
    // await Navigator.of(context, rootNavigator: false).push(
    //   CupertinoPageRoute(
    //     builder: (context) => AddWorkoutToRoutineScreen(
    //       workout: workout,
    //       database: database,
    //       auth: auth,
    //     ),
    //     fullscreenDialog: true,
    //   ),
    // );

    await pushNewScreen(
      context,
      pageTransitionAnimation: PageTransitionAnimation.slideUp,
      withNavBar: false,
      screen: AddWorkoutToRoutineScreen(
        workout: workout,
        database: database,
        auth: auth,
      ),
    );
  }

  @override
  _AddWorkoutToRoutineScreenState createState() =>
      _AddWorkoutToRoutineScreenState();
}

class _AddWorkoutToRoutineScreenState extends State<AddWorkoutToRoutineScreen> {
  Future<void> _submit(Routine routine) async {
    try {
      final routineWorkouts =
          await widget.database.routineWorkoutsStream(routine).first;
      if (routineWorkouts != null) {
        final index = routineWorkouts.length + 1;

        final routineWorkout = RoutineWorkout(
          routineWorkoutId: documentIdFromCurrentDate(),
          workoutId: widget.workout.workoutId,
          routineId: routine.routineId,
          routineWorkoutOwnerId: widget.auth.currentUser.uid,
          workoutTitle: widget.workout.workoutTitle,
          isBodyWeightWorkout: widget.workout.isBodyWeightWorkout,
          totalWeights: 0,
          numberOfSets: 0,
          numberOfReps: 0,
          duration: 0,
          secondsPerRep: widget.workout.secondsPerRep,
          sets: [],
          index: index,
        );
        await widget.database.setRoutineWorkout(routine, routineWorkout);
        Navigator.of(context).popUntil((route) => route.isFirst);
        await RoutineDetailScreen.show(
          context,
          routine: routine,
          isRootNavigation: false,
          tag: '',
        );
        // TODO: ADD SNACKBAR
      }
    } on Exception catch (e) {
      logger.d(e);
      await showExceptionAlertDialog(
        context,
        title: 'Operation Failed',
        exception: e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: BackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: AppbarBlurBG(),
        title: const Text('Add workout to Your Routine', style: Subtitle1),
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
        message: 'You haven\'t created routines yet',
      ),
      itemsPerPage: 10,
      header: SizedBox(height: Scaffold.of(context).appBarMaxHeight + 8),
      footer: const SizedBox(height: 16),
      onError: (error) => EmptyContent(
        message: 'Something went wrong: $error',
      ),
      itemBuilder: (index, context, documentSnapshot) {
        final documentId = documentSnapshot.id;
        final data = documentSnapshot.data();
        final routine = Routine.fromMap(data, documentId);

        return CustomListTile64(
          tag: 'routine${routine.routineId}',
          title: routine.routineTitle,
          subtitle: 'by ${routine.routineOwnerUserName}',
          imageUrl: routine.imageUrl,
          onTap: () => _submit(routine),
        );
      },
      isLive: true,
    );
  }
}
