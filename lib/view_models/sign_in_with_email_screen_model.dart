import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/firebase_auth_service.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import '../view/screens/sign_in_with_email_screen.dart';
import '../view/screens/sign_up_with_email_screen.dart';
import 'text_field_model.dart';

class SignInWithEmailModel extends ChangeNotifier {
  SignInWithEmailModel({required this.auth, required this.database});

  final FirebaseAuthService auth;
  final Database database;

  bool _isLoading = false;
  bool _submitted = false;
  late TextEditingController _emailEditingController;
  late TextEditingController _passwordEditingController;
  late TextEditingController _firstNameEditingController;
  late TextEditingController _lastNameEditingController;
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;

  bool get isLoading => _isLoading;
  bool get submitted => _submitted;
  TextEditingController get emailEditingController => _emailEditingController;
  TextEditingController get passwordEditingController =>
      _passwordEditingController;
  TextEditingController get firstNameEditingController =>
      _firstNameEditingController;
  TextEditingController get lastNameEditingController =>
      _lastNameEditingController;
  FocusNode get focusNode1 => _focusNode1;
  FocusNode get focusNode2 => _focusNode2;
  FocusNode get focusNode3 => _focusNode3;
  FocusNode get focusNode4 => _focusNode4;

  List<FocusNode> get signUpFocusNodes =>
      [_focusNode1, _focusNode2, _focusNode3, _focusNode4];

  List<FocusNode> get signInFocusNodes => [_focusNode1, _focusNode2];

  final locale = Intl.getCurrentLocale();
  final randomNumber = Random().nextInt(6);
  final now = Timestamp.now();

  void signUpInit() {
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();

    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
    _firstNameEditingController = TextEditingController();
    _lastNameEditingController = TextEditingController();
  }

  void signInInit() {
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();

    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
  }

  void setIsLoading({required bool value}) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleSubmitted() {
    _submitted = false;
    notifyListeners();
  }

  void signInOnChanged(String value) {
    if (_submitted) {
      final form = formKey.currentState!;
      form.validate();
    }
    notifyListeners();
  }

  // SIGN UP WITH EMAIL AND PASSWORD
  Future<void> signUpWithEmail(BuildContext context) async {
    if (_validateAndSaveForm()) {
      setIsLoading(value: true);
      _submitted = true;

      try {
        await auth.signUpWithEmailAndPassword(
          _emailEditingController.text,
          _passwordEditingController.text,
        );

        final firebaseUser = auth.currentUser!;

        final uniqueId = UniqueKey().toString();
        final id = 'Player $uniqueId';
        final deviceInfo = await _getDeviceInfo();

        final user = User(
          userId: firebaseUser.uid,
          displayName:
              '${_firstNameEditingController.text} ${_lastNameEditingController.text}',
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email ?? '',
          signUpDate: now,
          signUpProvider: 'email',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: now,
          savedRoutines: [],
          savedWorkouts: [],
          backgroundImageIndex: randomNumber,
          creationTime: now.toDate(),
          unitOfMassEnum:
              (locale == 'ko') ? UnitOfMass.kilograms : UnitOfMass.pounds,
          deviceInfo: deviceInfo,
        );

        await database.setUser(user);

        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseException catch (e) {
        _showSignInError(e, context);
      }
      setIsLoading(value: false);
    }
  }

  // SIGN IN WITH EMAIL AND PASSWORD
  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    if (_validateAndSaveForm()) {
      setIsLoading(value: true);
      _submitted = true;

      try {
        await auth.signInWithEmailWithPassword(
          _emailEditingController.text,
          _passwordEditingController.text,
        );

        final updatedUserData = {
          'lastLoginDate': now,
        };

        await database.updateUser(
          auth.currentUser!.uid,
          updatedUserData,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseException catch (e) {
        _showSignInError(e, context);
      }
    }
    setIsLoading(value: false);
  }

  bool _validateAndSaveForm() {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _showSignInError(FirebaseException exception, BuildContext context) {
    switch (exception.code) {
      case 'user-not-found':
        showAlertDialog(
          context,
          title: S.current.userNotFound,
          content: S.current.userNotFoundMessage,
          defaultActionText: S.current.ok,
        );
        break;
      case 'wrong-password':
        showAlertDialog(
          context,
          title: S.current.wrongPassword,
          content: S.current.wrongPasswordMessage,
          defaultActionText: S.current.ok,
        );
        break;
      case 'email-already-in-use':
        showAlertDialog(
          context,
          title: S.current.emailAlreadyInUse,
          content: S.current.emailAlreadyInUseMessage,
          defaultActionText: S.current.ok,
        );
        break;
      default:
        showAlertDialog(
          context,
          title: exception.code,
          content: exception.message ?? 'Message',
          defaultActionText: S.current.ok,
        );
    }
  }

  Future<Map<String, dynamic>?> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return androidInfo.toMap();
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.toMap();
    }
    return null;
  }

  static void showSignUpScreen(BuildContext context) {
    custmFadeTransition(
      context,
      duration: 500,
      screenBuilder: (animation) => Consumer(
        builder: (context, ref, child) {
          return SignUpWithEmailScreen(
            animation: animation,
            model: ref.watch(signInWithEmailModelProvider),
            textFieldModel: ref.watch(textFieldModelProvider),
          );
        },
      ),
    );
  }

  static void showSignInScreen(BuildContext context) {
    custmFadeTransition(
      context,
      duration: 500,
      screenBuilder: (animation) => Consumer(
        builder: (context, ref, child) {
          return SignInWithEmailScreen(
            animation: animation,
            model: ref.watch(signInWithEmailModelProvider),
            textFieldModel: ref.watch(textFieldModelProvider),
          );
        },
      ),
    );
  }

  /// STATIC
  static final formKey = GlobalKey<FormState>();
}
