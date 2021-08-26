import 'dart:io';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:provider/provider.dart' as provider;
import 'package:uuid/uuid.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:youtube_plyr_iframe/youtube_plyr_iframe.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/combined_models.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/view/screens/workout_summary_screen.dart';
import 'package:workout_player/view/screens/youtube_video_detail_screen.dart';
import 'package:workout_player/view/widgets/basic.dart';
import 'package:workout_player/view/widgets/dialogs.dart';
import 'package:workout_player/view/widgets/modal_sheets.dart';

import 'home_screen_model.dart';
import 'main_model.dart';
import 'routine_detail_screen_model.dart';

final double miniplayerMinHeight = Platform.isIOS ? 152 : 120;

final miniplayerModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => MiniplayerModel(
    valueNotifier: ValueNotifier<double>(miniplayerMinHeight),
  ),
);

class MiniplayerModel with ChangeNotifier {
  MiniplayerModel({required this.valueNotifier});

  final ValueNotifier<double> valueNotifier;

  int _currentIndex = 1;
  int _routineWorkoutIndex = 0;
  int _workoutSetIndex = 0;
  int _setsLength = 0;
  bool _isWorkoutPaused = false;
  Object? _currentWorkout;
  List<RoutineWorkout?>? _selectedRoutineWorkouts;
  RoutineWorkout? _currentRoutineWorkout;
  WorkoutSet? _currentWorkoutSet;
  Duration? _restTime;
  final MiniplayerController _miniplayerController = MiniplayerController();
  final CountDownController _countDownController = CountDownController();
  late AnimationController _animationController;
  Timestamp? _workoutStartTime;
  YoutubePlayerController? _youtubeController;
  WorkoutForYoutube? _currentWorkoutForYoutube;
  int _currentWorkoutForYoutubeIndex = 0;

  int get currentIndex => _currentIndex;
  int get routineWorkoutIndex => _routineWorkoutIndex;
  int get workoutSetIndex => _workoutSetIndex;
  int get setsLength => _setsLength;
  bool get isWorkoutPaused => _isWorkoutPaused;
  Object? get currentWorkout => _currentWorkout;
  List<RoutineWorkout?>? get selectedRoutineWorkouts =>
      _selectedRoutineWorkouts;
  RoutineWorkout? get currentRoutineWorkout => _currentRoutineWorkout;
  WorkoutSet? get currentWorkoutSet => _currentWorkoutSet;
  Duration? get restTime => _restTime;
  MiniplayerController get miniplayerController => _miniplayerController;
  CountDownController get countDownController => _countDownController;
  AnimationController get animationController => _animationController;
  Timestamp? get workoutStartTime => _workoutStartTime;
  YoutubePlayerController? get youtubeController => _youtubeController;
  WorkoutForYoutube? get currentWorkoutForYoutube => _currentWorkoutForYoutube;
  int get currentWorkoutForYoutubeIndex => _currentWorkoutForYoutubeIndex;

  void diosposeValues() {
    _currentIndex = 1;
    _routineWorkoutIndex = 0;
    _workoutSetIndex = 0;
    _setsLength = 0;
    _isWorkoutPaused = false;
    _currentWorkout = null;
    _selectedRoutineWorkouts = null;
    _currentRoutineWorkout = null;
    _currentWorkoutSet = null;
    _restTime = null;
    _workoutStartTime = null;
    _youtubeController = null;
    _currentWorkoutForYoutube = null;
    _currentWorkoutForYoutubeIndex = 0;
  }

  double getYOffset({
    required double min,
    required double max,
    required double value,
  }) {
    final percentage = (value - min) / (max - min);

    return kBottomNavigationBarHeight * percentage * 2;
  }

  void init(TickerProvider vsync) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 200),
    );
  }

  void startRoutine(
    BuildContext context,
    RoutineDetailScreenClass data,
  ) {
    diosposeValues();

    final routineWorkouts = data.routineWorkouts!;

    if (routineWorkouts.isNotEmpty) {
      final sets = routineWorkouts[0].sets;

      _currentWorkout = data.routine;
      _selectedRoutineWorkouts = routineWorkouts;
      _currentRoutineWorkout = routineWorkouts[0];
      _currentWorkoutSet = sets.isEmpty ? null : routineWorkouts[0].sets[0];

      // Setting Routine Length
      int routineLength = 0;
      for (int i = 0; i < routineWorkouts.length; i++) {
        final int length = routineWorkouts[i].sets.length;

        routineLength += length;
      }

      _setsLength = routineLength;
      _workoutStartTime = Timestamp.now();

      _miniplayerController.animateToHeight(state: PanelState.MAX);
    } else {
      showAlertDialog(
        context,
        title: S.current.emptyRoutineAlertTitle,
        content: S.current.addWorkoutToRoutine,
        defaultActionText: S.current.ok,
      );
    }

    notifyListeners();
  }

  void startYouTubeWorkout(YoutubeVideo youtubeVideo) {
    logger.d('`startYouTubeWorkout()` function called');

    diosposeValues();

    _workoutStartTime = Timestamp.now();
    _currentWorkout = youtubeVideo;
    final video = _currentWorkout as YoutubeVideo?;

    _youtubeController = YoutubePlayerController(
      initialVideoId: video!.videoId,
      params: const YoutubePlayerParams(
        // autoPlay: true,
        // mute: false,
        showControls: false,
        // showFullscreenButton: false,
      ),
    );

    _currentWorkoutForYoutube = video.workouts[0];

    _miniplayerController.animateToHeight(state: PanelState.MAX);

    notifyListeners();
  }

  Future<bool?> endWorkout(BuildContext context) {
    return showAdaptiveModalBottomSheet(
      context,
      title: Text(
        S.current.endWorkoutWarningMessage,
        textAlign: TextAlign.center,
      ),
      firstActionText: S.current.stopTheWorkout,
      isFirstActionDefault: false,
      firstActionOnPressed: () {
        Navigator.of(context).pop();

        diosposeValues();

        _miniplayerController.animateToHeight(state: PanelState.MIN);

        notifyListeners();

        getSnackbarWidget(
          S.current.cancelWorkoutSnackbarTitle,
          S.current.cancelWorkoutSnackbarMessage,
        );
      },
      cancelText: S.current.cancel,
      isCancelDefault: true,
    );
  }

  Future<void> pauseOrPlay() async {
    if (_currentWorkoutSet != null) {
      if (!_isWorkoutPaused) {
        _isWorkoutPaused = !_isWorkoutPaused;
        _youtubeController?.pause();

        await _animationController.forward();
        if (_currentWorkoutSet!.isRest) _countDownController.pause();
      } else {
        _youtubeController?.play();

        _isWorkoutPaused = !_isWorkoutPaused;

        await _animationController.reverse();
        if (_currentWorkoutSet!.isRest) _countDownController.resume();
      }
    } else {
      if (!_isWorkoutPaused) {
        _isWorkoutPaused = !_isWorkoutPaused;

        _youtubeController?.pause();

        await _animationController.forward();
      } else {
        _youtubeController?.play();

        _isWorkoutPaused = !_isWorkoutPaused;

        await _animationController.reverse();
      }
    }

    notifyListeners();
  }

  void nextWorkoutSet() {
    // Reverse animation if workout is paused & Set isWorkoutPaused false
    if (_isWorkoutPaused) _animationController.reverse();
    _isWorkoutPaused = false;

    if (_currentWorkout.runtimeType == Routine) {
      // increase current index by 1
      _currentIndex++;

      // workout set Index by 1
      _workoutSetIndex++;

      assert(_workoutSetIndex < _currentRoutineWorkout!.sets.length);

      // set Workout Set
      _currentWorkoutSet = _currentRoutineWorkout!.sets[_workoutSetIndex];

      // Set Rest Time
      _restTime = Duration(seconds: _currentWorkoutSet!.restTime ?? 60);
    } else {
      final video = _currentWorkout as YoutubeVideo?;

      if (_currentWorkoutForYoutubeIndex < video!.workouts.length - 1) {
        _youtubeController!.seekTo(
            video.workouts[_currentWorkoutForYoutubeIndex + 1].position);
      }
    }

    notifyListeners();
  }

  void previousWorkoutSet() {
    // Reverse animation if workout is paused & Set isWorkoutPaused false
    if (_isWorkoutPaused) _animationController.reverse();
    _isWorkoutPaused = false;

    if (_currentWorkout.runtimeType == Routine) {
      // Decrease current index by 1
      _currentIndex--;

      // Decrement WorkoutSet index
      _workoutSetIndex--;

      // Set Workout Set
      _currentWorkoutSet = _currentRoutineWorkout!.sets[_workoutSetIndex];

      // Set Rest Time
      _restTime = Duration(seconds: _currentWorkoutSet!.restTime ?? 60);
    } else {
      final video = _currentWorkout as YoutubeVideo?;

      if (_currentWorkoutForYoutubeIndex != 0) {
        _youtubeController!.seekTo(
            video!.workouts[_currentWorkoutForYoutubeIndex - 1].position);
      }
    }

    notifyListeners();
  }

  void nextRoutineWorkout() {
    if (_currentIndex < _setsLength) {
      final workoutSetLength = _currentRoutineWorkout!.sets.length - 1;
      _currentIndex += -workoutSetIndex + workoutSetLength + 1;
    }

    // set workout index to 0
    _workoutSetIndex = 0;

    // increase RW Index by 1
    _routineWorkoutIndex++;

    // set is Workout Paused to false
    if (_isWorkoutPaused) _animationController.reverse();
    _isWorkoutPaused = false;

    _currentRoutineWorkout = _selectedRoutineWorkouts![_routineWorkoutIndex];

    // sets from new Routine Workout
    final sets = _currentRoutineWorkout!.sets;

    if (sets.isNotEmpty) {
      _currentWorkoutSet = sets[0];

      if (_currentWorkoutSet!.isRest) {
        _restTime = Duration(seconds: currentWorkoutSet!.restTime ?? 90);
      } else {
        _restTime = null;
      }
    } else {
      _currentWorkoutSet = null;
      _restTime = null;
    }
    notifyListeners();
  }

  void previousRoutineWorkout() {
    // set isWorkoutPaused to false
    if (_isWorkoutPaused) _animationController.reverse();
    _isWorkoutPaused = false;

    // new index = currentIndex - workoutIndex - workoutSetLength
    final workoutSetLength = _currentIndex -
        _workoutSetIndex -
        _selectedRoutineWorkouts![_routineWorkoutIndex - 1]!.sets.length;

    // set current index
    _currentIndex = workoutSetLength;

    // set Workout Set Index
    _workoutSetIndex = 0;

    // set RW Index
    _routineWorkoutIndex--;

    // set Routine Workout
    _currentRoutineWorkout = _selectedRoutineWorkouts![_routineWorkoutIndex];

    // set Workout Set
    if (_currentRoutineWorkout!.sets.isNotEmpty) {
      _currentWorkoutSet = _currentRoutineWorkout!.sets[_workoutSetIndex];

      // set Duration
      if (_currentWorkoutSet!.isRest) {
        _restTime = Duration(seconds: _currentWorkoutSet!.restTime ?? 0);
      }
    } else {
      _currentWorkoutSet = null;
      _restTime = null;
    }

    notifyListeners();
  }

  void timerOnComplete(BuildContext context) {
    if (_currentIndex <= _setsLength) {
      // Find length of routine workout
      final routineWorkoutLength = _selectedRoutineWorkouts!.length - 1;

      // Find length of workout set
      final workoutSetLength = _currentRoutineWorkout!.sets.length - 1;

      _currentIndex++;

      if (_isWorkoutPaused) _animationController.reverse();
      _isWorkoutPaused = false;

      // If workout set is NOT last
      if (_workoutSetIndex < workoutSetLength) {
        _workoutSetIndex++;

        _currentWorkoutSet = _currentRoutineWorkout!.sets[_workoutSetIndex];

        if (_currentWorkoutSet!.isRest) {
          _restTime = Duration(seconds: _currentWorkoutSet!.restTime ?? 60);
        }
      } else {
        // If workout set is LAST && Routine Workout is NOT last
        if (_routineWorkoutIndex < routineWorkoutLength) {
          _workoutSetIndex = 0;

          _routineWorkoutIndex++;

          _currentRoutineWorkout =
              _selectedRoutineWorkouts![_routineWorkoutIndex];

          _currentWorkoutSet = _currentRoutineWorkout!.sets[_workoutSetIndex];

          if (_currentWorkoutSet!.isRest) {
            _restTime = Duration(seconds: _currentWorkoutSet!.restTime ?? 60);
          }
        }
      }
    }
    notifyListeners();
  }

  Future<void> submit(BuildContext context, User user) async {
    try {
      final database = provider.Provider.of<Database>(context, listen: false);

      final workoutEndTime = Timestamp.now();
      final routineHistoryId = 'RH${const Uuid().v1()}';
      final workoutEndDate = workoutEndTime.toDate();
      final workoutStartDate = _workoutStartTime!.toDate();
      final duration = workoutEndDate.difference(workoutStartDate).inSeconds;
      final workoutDate = DateTime.utc(
        workoutStartDate.year,
        workoutStartDate.month,
        workoutStartDate.day,
      );

      if (_currentWorkout.runtimeType == Routine) {
        final routine = _currentWorkout as Routine?;

        /// For Routine History

        final isBodyWeightWorkout = _selectedRoutineWorkouts?.any(
              (element) => element!.isBodyWeightWorkout == true,
            ) ??
            false;

        final muscleGroup = routine!.mainMuscleGroupEnum ??
            Formatter.getListOfMainMuscleGroupFromStrings(
                routine.mainMuscleGroup);

        final equipments = routine.equipmentRequiredEnum ??
            Formatter.getListOfEquipmentsFromStrings(routine.equipmentRequired);
        final unitOfMass = routine.unitOfMassEnum ??
            UnitOfMass.values[routine.initialUnitOfMass ?? 0];

        final routineHistory = RoutineHistory(
          routineHistoryId: routineHistoryId,
          userId: user.userId,
          username: user.displayName,
          routineId: routine.routineId,
          routineTitle: routine.routineTitle,
          isPublic: true,
          workoutStartTime: _workoutStartTime!,
          workoutEndTime: workoutEndTime,
          notes: '',
          totalCalories: 0,
          totalDuration: duration,
          totalWeights: routine.totalWeights,
          isBodyWeightWorkout: isBodyWeightWorkout,
          workoutDate: workoutDate,
          imageUrl: routine.imageUrl,
          mainMuscleGroupEnum: muscleGroup,
          equipmentRequiredEnum: equipments,
          unitOfMassEnum: unitOfMass,
          routineHistoryType: 'routine',
        );

        await database.setRoutineHistory(routineHistory);

        final workoutHistories =
            _selectedRoutineWorkouts!.map((routineWorkout) {
          final id = 'WH${const Uuid().v1()}';

          return WorkoutHistory(
            workoutHistoryId: id,
            routineHistoryId: routineHistoryId,
            workoutId: routineWorkout!.workoutId,
            routineId: routineWorkout.routineId,
            uid: user.userId,
            index: routineWorkout.index,
            workoutTitle: routineWorkout.workoutTitle,
            numberOfSets: routineWorkout.numberOfSets,
            numberOfReps: routineWorkout.numberOfReps,
            totalWeights: routineWorkout.totalWeights,
            isBodyWeightWorkout: routineWorkout.isBodyWeightWorkout,
            duration: routineWorkout.duration,
            secondsPerRep: routineWorkout.secondsPerRep,
            translated: routineWorkout.translated,
            sets: routineWorkout.sets,
            workoutTime: workoutEndTime,
            workoutDate: Timestamp.fromDate(workoutDate),
            unitOfMass: routine.initialUnitOfMass,
          );
        }).toList();

        await database.batchWriteWorkoutHistories(workoutHistories);

        diosposeValues();
        _miniplayerController.animateToHeight(state: PanelState.MIN);

        WorkoutSummaryScreen.show(
          context,
          routineHistory: routineHistory,
        );
      } else {
        final video = _currentWorkout as YoutubeVideo?;

        /// For Routine History

        final isBodyWeightWorkout = video!.equipmentsRequired.contains(
          EquipmentRequired.bodyweight,
        );

        final muscleGroups = video.mainMuscleGroups;

        final equipments = video.equipmentsRequired;

        final routineHistory = RoutineHistory(
          routineHistoryId: routineHistoryId,
          userId: user.userId,
          username: user.displayName,
          routineId: video.youtubeVideoId,
          routineTitle: video.title,
          isPublic: true,
          workoutStartTime: _workoutStartTime!,
          workoutEndTime: workoutEndTime,
          notes: '',
          totalCalories: video.caloriesBurnt,
          totalDuration: duration,
          totalWeights: video.totalWeights,
          isBodyWeightWorkout: isBodyWeightWorkout,
          workoutDate: workoutDate,
          imageUrl: video.thumnail,
          mainMuscleGroupEnum: muscleGroups,
          equipmentRequiredEnum: equipments,
          routineHistoryType: 'youtube',
        );

        await database.setRoutineHistory(routineHistory);

        diosposeValues();
        _miniplayerController.animateToHeight(state: PanelState.MIN);

        WorkoutSummaryScreen.show(
          context,
          routineHistory: routineHistory,
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

  void jumpToCurrentWorkout(HomeScreenModel model) {
    final currentContext =
        HomeScreenModel.tabNavigatorKeys[model.currentTab]!.currentContext!;
    _miniplayerController.animateToHeight(
      state: PanelState.MIN,
    );

    if (_currentWorkout.runtimeType == Routine) {
      final routine = _currentWorkout as Routine?;

      RoutineDetailScreenModel.show(
        currentContext,
        routine: routine!,
        tag: 'miniplayer${routine.routineId}',
      );
    } else {
      final video = _currentWorkout as YoutubeVideo?;

      YoutubeVideoDetailScreen.show(
        currentContext,
        youtubeVideo: video!,
        heroTag: 'heroTag',
      );
    }
  }

  // TODO(heeyunlee): fix here
  // ignore: use_setters_to_change_properties
  void updateCurrentIndex(int value) {
    _currentWorkoutForYoutubeIndex = value;
  }

  bool isPreviousButtonDisabled() {
    if (_currentWorkout.runtimeType == Routine) {
      return _currentIndex == 1 || _workoutSetIndex == 0;
    } else {
      return _currentWorkoutForYoutubeIndex == 0;
    }
  }

  bool isBackwardButtonDisabled() {
    if (_currentWorkout.runtimeType == Routine) {
      return routineWorkoutIndex == 0;
    } else {
      return true;
    }
  }

  bool isNextButtonDisabled() {
    if (_currentWorkout.runtimeType == Routine) {
      if (_currentWorkoutSet != null) {
        return _workoutSetIndex == _currentRoutineWorkout!.sets.length - 1;
      } else {
        return true;
      }
    } else {
      final video = _currentWorkout as YoutubeVideo?;

      return _currentWorkoutForYoutubeIndex >= (video!.workouts.length - 1);
    }
  }

  bool isForwardButtonDisabled() {
    if (_currentWorkout.runtimeType == Routine) {
      return _routineWorkoutIndex == _selectedRoutineWorkouts!.length - 1;
    } else {
      return true;
    }
  }
}
