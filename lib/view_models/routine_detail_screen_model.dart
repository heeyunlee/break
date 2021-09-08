import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'home_screen_model.dart';
import 'main_model.dart';

final routineDetailScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => RoutineDetailScreenModel(),
);

class RoutineDetailScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  RoutineDetailScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  late AnimationController _sliverAnimationController;
  late Animation<Offset> _offsetTween;
  late Animation<double> _opacityTween;
  late Animation<Color?> _colorTweeen;
  late Animation<Color?> _secondColorTweeen;

  AnimationController get sliverAnimationController =>
      _sliverAnimationController;
  Animation<Offset> get offsetTween => _offsetTween;
  Animation<double> get opacityTween => _opacityTween;
  Animation<Color?> get colorTweeen => _colorTweeen;
  Animation<Color?> get secondColorTweeen => _secondColorTweeen;

  void init(TickerProvider vsync) {
    _sliverAnimationController = AnimationController(
      vsync: vsync,
      duration: Duration.zero,
    );

    _offsetTween = Tween<Offset>(begin: const Offset(0, 8), end: Offset.zero)
        .animate(_sliverAnimationController);

    _opacityTween = Tween<double>(begin: 0, end: 1).animate(
      _sliverAnimationController,
    );

    _colorTweeen = ColorTween(
      begin: kBackgroundColor,
      end: kAppBarColor,
    ).animate(_sliverAnimationController);

    _secondColorTweeen = ColorTween(
      begin: kBackgroundColor,
      end: Colors.transparent,
    ).animate(_sliverAnimationController);
  }

  bool onNotification(ScrollNotification notification) {
    notification.metrics.pixels;

    _sliverAnimationController
        .animateTo((notification.metrics.pixels - 264) / 120);

    return true;
  }

  Future<void> saveUnsaveRoutine(
    BuildContext context,
    bool isRoutineSaved,
    RoutineDetailScreenClass data,
  ) async {
    try {
      if (isRoutineSaved) {
        final user = {
          'savedRoutines': FieldValue.arrayRemove([data.routine!.routineId]),
        };

        await database!.updateUser(auth!.currentUser!.uid, user);

        getSnackbarWidget(
          S.current.unsavedRoutineSnackBarTitle,
          S.current.unsavedRoutineSnackbar,
        );
      } else {
        final user = {
          'savedRoutines': FieldValue.arrayUnion([data.routine!.routineId]),
        };

        await database!.updateUser(auth!.currentUser!.uid, user);

        getSnackbarWidget(
          S.current.savedRoutineSnackBarTitle,
          S.current.savedRoutineSnackbar,
        );
      }
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }

    notifyListeners();
  }

  Future<bool?> showBottomSheet(BuildContext currentContext, Routine routine) {
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    return showModalBottomSheet<bool>(
      context: homeContext,
      isDismissible: true,
      builder: (context) => RoutineBottomSheet(
        routine: routine,
        onTap: () => delete(currentContext, routine: routine),
      ),
    );
  }

  Future<void> delete(
    BuildContext context, {
    required Routine routine,
  }) async {
    try {
      database!.deleteRoutine(routine);

      final homeContext =
          HomeScreenModel.homeScreenNavigatorKey.currentContext!;

      Navigator.of(homeContext).pop();
      Navigator.of(context).pop();

      getSnackbarWidget(
        S.current.deleteRoutineSnackbarTitle,
        S.current.deleteRoutineSnackbar,
      );
    } on FirebaseException catch (e) {
      logger.e(e);
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  /// VIEW MODEL
  String location(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return Location.values
          .firstWhere((e) => e.toString() == routine.location)
          .translation!;
    } else {
      return S.current.location;
    }
  }

  String equipments(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return Formatter.getJoinedEquipmentsRequired(
        routine.equipmentRequired,
        routine.equipmentRequiredEnum,
      );
    } else {
      return S.current.equipmentRequired;
    }
  }

  String muscleGroups(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return Formatter.getJoinedMainMuscleGroups(
        routine.mainMuscleGroup,
        routine.mainMuscleGroupEnum,
      );
    } else {
      return S.current.mainMuscleGroup;
    }
  }

  String totalWeights(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return Formatter.routineTotalWeights(routine);
    } else {
      return '-,---';
    }
  }

  String duration(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return Formatter.durationInMin(routine.duration);
    } else {
      return '- ${S.current.minutes}';
    }
  }

  String difficulty(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return Formatter.difficulty(routine.trainingLevel);
    } else {
      return S.current.difficulty;
    }
  }

  String description(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      final description = routine.description;
      if (description != null) {
        if (description.isNotEmpty) {
          return routine.description!;
        } else {
          return S.current.addDescription;
        }
      } else {
        return S.current.addDescription;
      }
    } else {
      return S.current.addDescription;
    }
  }

  String imageUrl(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return routine.imageUrl;
    } else {
      return '';
    }
  }

  String username(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return routine.routineOwnerUserName;
    } else {
      return S.current.displayName;
    }
  }

  String title(RoutineDetailScreenClass data) {
    final routine = data.routine;

    if (routine != null) {
      return routine.routineTitle;
    } else {
      return S.current.routineTitleTitle;
    }
  }
}
