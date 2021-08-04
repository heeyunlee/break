import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' as provider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:workout_player/classes/measurement.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/models/text_field_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/show_exception_alert_dialog.dart';

import 'add_measurements_screen.dart';

final addMeasurementsModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => AddMeasurementsModel(),
);

class AddMeasurementsModel with ChangeNotifier {
  late TextEditingController _bodyweightController;
  late TextEditingController _bodyFatController;
  late TextEditingController _smmController;
  late TextEditingController _bmiController;
  late TextEditingController _notesController;

  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;
  late FocusNode _focusNode5;

  Timestamp _loggedTime = Timestamp.now();
  Color _borderColor = Colors.grey;

  TextEditingController get bodyweightController => _bodyweightController;
  TextEditingController get bodyFatController => _bodyFatController;
  TextEditingController get smmController => _smmController;
  TextEditingController get bmiController => _bmiController;
  TextEditingController get notesController => _notesController;

  FocusNode get focusNode1 => _focusNode1;
  FocusNode get focusNode2 => _focusNode2;
  FocusNode get focusNode3 => _focusNode3;
  FocusNode get focusNode4 => _focusNode4;
  FocusNode get focusNode5 => _focusNode5;

  num get bodyWeight => num.parse(_bodyweightController.text);
  num? get bodyFat => num.tryParse(_bodyFatController.text);
  num? get skeletalMuscleMass => num.tryParse(_smmController.text);
  num? get bmi => num.tryParse(_bmiController.text);
  String? get notes => _notesController.text;
  Timestamp get loggedTime => _loggedTime;
  Color get borderColor => _borderColor;

  List<FocusNode> get focusNodes => [
        _focusNode1,
        _focusNode2,
        _focusNode3,
        _focusNode4,
        _focusNode5,
      ];

  void init() {
    _bodyweightController = TextEditingController();
    _bodyFatController = TextEditingController();
    _smmController = TextEditingController();
    _bmiController = TextEditingController();
    _notesController = TextEditingController();

    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
    _focusNode5 = FocusNode();
  }

  @override
  void dispose() {
    _bodyweightController.dispose();
    _bodyFatController.dispose();
    _smmController.dispose();
    _bmiController.dispose();
    _notesController.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
    _focusNode5.dispose();

    super.dispose();
  }

  bool hasFocus() {
    return _focusNode1.hasFocus ||
        _focusNode2.hasFocus ||
        _focusNode3.hasFocus ||
        _focusNode4.hasFocus ||
        _focusNode5.hasFocus;
  }

  bool validate() {
    return _bodyweightController.text.isNotEmpty;
  }

  String? weightInputValidator(String? value) {
    final tryParsing = num.tryParse(value!);

    if (value.isEmpty) {
      return S.current.weightsHintText;
    } else if (tryParsing == null) {
      return S.current.pleaseEnderValidValue;
    }
    return null;
  }

  String? otherInputValidator(String? value) {
    if (value == null) {
      return null;
    } else {
      final tryParsing = num.tryParse(value);

      if (tryParsing == null) {
        return S.current.pleaseEnderValidValue;
      }
    }
  }

  void onDateTimeChanged(DateTime date) {
    _loggedTime = Timestamp.fromDate(date);

    notifyListeners();
  }

  void onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction >= 0.85) {
      _borderColor = kSecondaryColor;
    } else {
      _borderColor = Colors.grey;
    }

    notifyListeners();
  }

  /// Submit data to Firestore
  bool _validateAndSaveForm() {
    final form = formKey.currentState;

    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> submit(
    BuildContext context,
    Database database,
    User user,
  ) async {
    if (_validateAndSaveForm()) {
      try {
        final id = 'MS${Uuid().v1()}';
        final loggedTimeInDate = _loggedTime.toDate();
        final loggedDate = DateTime.utc(
          loggedTimeInDate.year,
          loggedTimeInDate.month,
          loggedTimeInDate.day,
        );

        final measurement = Measurement(
          measurementId: id,
          userId: user.userId,
          username: user.userName,
          loggedTime: _loggedTime,
          loggedDate: loggedDate,
          bodyWeight: bodyWeight,
          bodyFat: bodyFat,
          skeletalMuscleMass: skeletalMuscleMass,
          bmi: bmi,
          notes: notes,
        );

        await database.setMeasurement(measurement: measurement);

        Navigator.of(context).pop();

        getSnackbarWidget(
          S.current.addMeasurementSnackbarTitle,
          S.current.addMeasurementSnackbar,
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
  }

  //// STATIC
  /// FORM KEY
  static final formKey = GlobalKey<FormState>();

  /// FOR Navigation
  static Future<void> show(BuildContext context) async {
    final database = provider.Provider.of<Database>(context, listen: false);
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final user = (await database.getUserDocument(auth.currentUser!.uid))!;

    await HapticFeedback.mediumImpact();

    await Navigator.of(context, rootNavigator: true).push(
      CupertinoPageRoute(
        fullscreenDialog: true,
        builder: (context) => Consumer(
          builder: (context, watch, child) => AddMeasurementsScreen(
            user: user,
            database: database,
            model: watch(addMeasurementsModelProvider),
            textFieldModel: watch(textFieldModelProvider),
          ),
        ),
      ),
    );
  }
}
