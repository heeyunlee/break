import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_workout.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/features/widgets/widgets.dart';

class ReorderRoutineWorkoutsScreenModel with ChangeNotifier {
  ReorderRoutineWorkoutsScreenModel({required this.database});

  final Database database;

  List<RoutineWorkout?> _newList = [];
  Map<int, RoutineWorkout?> _newMap = {};
  bool _areMapsEqual = true;

  List<RoutineWorkout?> get newList => _newList;
  Map<int, RoutineWorkout?> get newMap => _newMap;
  bool get areMapsEqual => _areMapsEqual;

  void initList(List<RoutineWorkout?> list) {
    _newList = list;
    _newMap = list.asMap();
  }

  void onReorder(int oldIndex, int newIndex) {
    int index = newIndex;

    if (index > oldIndex) {
      index -= 1;
    }
    final itemToReorder = _newList.removeAt(oldIndex);
    _newList.insert(index, itemToReorder);

    _newMap = _newList.asMap();
    _areMapsEqual = false;
    HapticFeedback.lightImpact();

    notifyListeners();
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  Future<void> onSubmit(BuildContext context, Routine routine) async {
    try {
      _newMap.forEach((key, value) {
        if (key + 1 != value!.index) {
          final routineWokrout = {
            'index': key + 1,
          };

          database.updateRoutineWorkout(
            routine: routine,
            routineWorkout: value,
            data: routineWokrout,
          );
        }
      });

      Navigator.of(context).pop();

      // getSnackbarWidget(
      //   S.current.editRoutineWorkoutOrderSnackbarTitle,
      //   S.current.editRoutineWorkoutOrderSnackbarMessage,
      // );
    } on Exception catch (e) {
      _showError(e, context);
    }
  }

  void _showError(Exception exception, BuildContext context) {
    showExceptionAlertDialog(
      context,
      title: S.current.signInFailed,
      exception: exception.toString(),
    );
  }
}
