import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/basic.dart';
import 'package:workout_player/view/widgets/dialogs.dart';
import 'package:workout_player/view/widgets/widgets.dart';

final editRoutineScreenModelProvider = ChangeNotifierProvider(
  (ref) => EditRoutineScreenModel(),
);

class EditRoutineScreenModel with ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  EditRoutineScreenModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

  late TextEditingController _titleEditingController;
  late TextEditingController _descriptionEditingController;
  late FocusNode _titleFocusNode;
  late FocusNode _descriptionFocusNode;
  late bool _isRoutinePublic;
  late double _difficulty;
  late AnimationController _sliverAnimationController;
  late Animation<Offset> _offsetTween;
  late Animation<double> _opacityTween;
  late Animation<Color?> _colorTweeen;

  TextEditingController get titleEditingController => _titleEditingController;
  TextEditingController get descriptionEditingController =>
      _descriptionEditingController;
  FocusNode get titleFocusNode => _titleFocusNode;
  FocusNode get descriptionFocusNode => _descriptionFocusNode;
  bool get isRoutinePublic => _isRoutinePublic;
  double get difficulty => _difficulty;
  AnimationController get sliverAnimationController =>
      _sliverAnimationController;
  Animation<Offset> get offsetTween => _offsetTween;
  Animation<double> get opacityTween => _opacityTween;
  Animation<Color?> get colorTweeen => _colorTweeen;

  void init(TickerProvider vsync, Routine routine, ThemeData theme) {
    _titleEditingController = TextEditingController(text: routine.routineTitle);
    _descriptionEditingController = TextEditingController(
      text: routine.description,
    );

    _titleFocusNode = FocusNode();
    _descriptionFocusNode = FocusNode();
    _isRoutinePublic = routine.isPublic;
    _difficulty = routine.trainingLevel.toDouble();

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
      begin: theme.backgroundColor,
      end: theme.appBarTheme.backgroundColor,
    ).animate(_sliverAnimationController);
  }

  bool onNotification(ScrollNotification notification) {
    notification.metrics.pixels;

    _sliverAnimationController
        .animateTo((notification.metrics.pixels - 80) / 48);

    return true;
  }

  void isPublicOnChanged(bool value) {
    _isRoutinePublic = value;

    notifyListeners();
  }

  void difficultyOnChanged(double value) {
    _difficulty = value;

    notifyListeners();
  }

  bool _validateAndSaveForm() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Submit data to Firestore
  Future<void> submit(BuildContext context, Routine routine) async {
    if (_validateAndSaveForm()) {
      try {
        final lastEditedDate = Timestamp.now();
        final updatedRoutine = {
          'routineTitle': _titleEditingController.text,
          'lastEditedDate': lastEditedDate,
          'description': _descriptionEditingController.text,
          'isPublic': _isRoutinePublic,
          'trainingLevel': _difficulty.toInt(),
        };
        await database!.updateRoutine(routine, updatedRoutine);

        await HapticFeedback.mediumImpact();
        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.editRoutineTitle,
          S.current.editRoutineSnackbar,
        );
      } on FirebaseException catch (e) {
        await showExceptionAlertDialog(
          context,
          title: S.current.operationFailed,
          exception: e.toString(),
        );
      }
    }
  }

  static final formKey = GlobalKey<FormState>();
}
