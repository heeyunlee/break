import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart' as provider;
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/dialogs.dart';

final workoutSummaryScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => WorkoutSummaryScreenModel(),
);

class WorkoutSummaryScreenModel with ChangeNotifier {
  late ConfettiController _confettiController;
  late bool _isPublic;
  late num _effort;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  // Map<String, dynamic> _updatedRoutineHistory = {};

  ConfettiController get confettiController => _confettiController;
  bool get isPublic => _isPublic;
  num get effort => _effort;
  TextEditingController get textEditingController => _textEditingController;
  FocusNode get focusNode => _focusNode;

  void init(RoutineHistory routineHistory) {
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    _isPublic = routineHistory.isPublic;
    _effort = routineHistory.effort ?? 2.5;

    _textEditingController = TextEditingController(text: routineHistory.notes);
    _focusNode = FocusNode();
  }

  void isPublicOnChanged(bool value) {
    _isPublic = value;
    // _updatedRoutineHistory = {
    //   'isPublic': value,
    // };

    // _updatedRoutineHistory['isPublic'] = value;

    // print(_updatedRoutineHistory);

    notifyListeners();
  }

  void onRatingUpdate(double value) {
    _effort = value;
    notifyListeners();
  }

  // Submit data to Firestore
  Future<void> update(
    BuildContext context,
    RoutineHistory routineHistory,
  ) async {
    try {
      final database = provider.Provider.of<Database>(context, listen: false);

      final updatedRoutineHistory = {
        'isPublic': _isPublic,
        'notes': _textEditingController.text,
        'effort': _effort,
      };

      await database.updateRoutineHistory(
        routineHistory,
        updatedRoutineHistory,
      );

      Navigator.of(context).pop();
      await HapticFeedback.mediumImpact();
    } on FirebaseException catch (e) {
      await showExceptionAlertDialog(
        context,
        title: S.current.operationFailed,
        exception: e.toString(),
      );
    }
  }

  static final formKey = GlobalKey<FormState>();
}
