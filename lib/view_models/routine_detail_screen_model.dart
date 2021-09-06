import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/widgets/widgets.dart';

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
  RoutineDetailScreenClass? _data;

  AnimationController get sliverAnimationController =>
      _sliverAnimationController;
  Animation<Offset> get offsetTween => _offsetTween;
  Animation<double> get opacityTween => _opacityTween;
  Animation<Color?> get colorTweeen => _colorTweeen;
  Animation<Color?> get secondColorTweeen => _secondColorTweeen;
  RoutineDetailScreenClass? get data => _data;

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
        .animateTo((notification.metrics.pixels - 280) / 100);

    return true;
  }

  void setData(RoutineDetailScreenClass data) {
    _data = data;
  }

  Future<void> saveUnsaveRoutine(
    BuildContext context,
    bool isRoutineSaved,
  ) async {
    try {
      if (isRoutineSaved) {
        final user = {
          'savedRoutines': FieldValue.arrayRemove([_data!.routine!.routineId]),
        };

        await database!.updateUser(auth!.currentUser!.uid, user);

        getSnackbarWidget(
          S.current.unsavedRoutineSnackBarTitle,
          S.current.unsavedRoutineSnackbar,
        );
      } else {
        final user = {
          'savedRoutines': FieldValue.arrayUnion([_data!.routine!.routineId]),
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

  /// VIEW MODEL
  String location() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return Location.values
            .firstWhere((e) => e.toString() == routine.location)
            .translation!;
      } else {
        return S.current.location;
      }
    } else {
      return S.current.location;
    }
  }

  String equipments() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return Formatter.getJoinedEquipmentsRequired(
          routine.equipmentRequired,
          routine.equipmentRequiredEnum,
        );
      } else {
        return S.current.equipmentRequired;
      }
    } else {
      return S.current.equipmentRequired;
    }
  }

  String muscleGroups() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return Formatter.getJoinedMainMuscleGroups(
          routine.mainMuscleGroup,
          routine.mainMuscleGroupEnum,
        );
      } else {
        return S.current.mainMuscleGroup;
      }
    } else {
      return S.current.mainMuscleGroup;
    }
  }

  String totalWeights() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return Formatter.routineTotalWeights(routine);
      } else {
        return '-,---';
      }
    } else {
      return '-,---';
    }
  }

  String duration() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return Formatter.durationInMin(routine.duration);
      } else {
        return '- ${S.current.minutes}';
      }
    } else {
      return '- ${S.current.minutes}';
    }
  }

  String difficulty() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return Formatter.difficulty(routine.trainingLevel);
      } else {
        return S.current.difficulty;
      }
    } else {
      return S.current.difficulty;
    }
  }

  String description() {
    final data = _data;
    if (data != null) {
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
    } else {
      return S.current.addDescription;
    }
  }

  String imageUrl() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return routine.imageUrl;
      } else {
        return '';
      }
    } else {
      return '';
    }
  }

  String username() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return routine.routineOwnerUserName;
      } else {
        return S.current.displayName;
      }
    } else {
      return S.current.displayName;
    }
  }

  String title() {
    final data = _data;
    if (data != null) {
      final routine = data.routine;

      if (routine != null) {
        return routine.routineTitle;
      } else {
        return S.current.routineTitleTitle;
      }
    } else {
      return S.current.routineTitleTitle;
    }
  }
}
