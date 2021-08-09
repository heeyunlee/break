import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:workout_player/classes/enum/unit_of_mass.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/classes/user.dart';
import 'package:workout_player/models/text_field_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/widgets/custom_fade_transition.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';

import 'sign_in_with_email_screen.dart';
import 'sign_up_with_email_screen.dart';

final signInWithEmailModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => SignInWithEmailModel(),
);

class SignInWithEmailModel extends ChangeNotifier {
  AuthService? auth;
  FirestoreDatabase? database;

  SignInWithEmailModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider);
    database = container.read(databaseProvider(auth!.currentUser?.uid));
  }

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

  void setIsLoading(bool value) {
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
      setIsLoading(true);
      _submitted = true;

      try {
        await auth!.createUserWithEmailAndPassword(
          _emailEditingController.text,
          _passwordEditingController.text,
        );

        final firebaseUser = auth!.currentUser!;

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

        await database!.setUser(user);

        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseException catch (e) {
        _showSignInError(e, context);
      }
      setIsLoading(false);
    }
  }

  // SIGN IN WITH EMAIL AND PASSWORD
  Future<void> signInWithEmailAndPassword(BuildContext context) async {
    if (_validateAndSaveForm()) {
      setIsLoading(true);
      _submitted = true;

      try {
        await auth!.signInWithEmailWithPassword(
          _emailEditingController.text,
          _passwordEditingController.text,
        );

        final updatedUserData = {
          'lastLoginDate': now,
        };

        await database!.updateUser(
          auth!.currentUser!.uid,
          updatedUserData,
        );

        Navigator.of(context).popUntil((route) => route.isFirst);
      } on FirebaseException catch (e) {
        _showSignInError(e, context);
      }
    }
    setIsLoading(false);
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
    logger.e(exception.message);

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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return androidInfo.toMap();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return iosInfo.toMap();
    }
  }

  void launchTermsURL() async => await canLaunch(_termsUrl)
      ? await launch(_termsUrl)
      : throw 'Could not launch $_termsUrl';

  void launchPrivacyServiceURL() async => await canLaunch(_privacyServiceUrl)
      ? await launch(_privacyServiceUrl)
      : throw 'Could not launch $_privacyServiceUrl';

  static void showSignUpScreen(BuildContext context) {
    custmFadeTransition(
      context,
      duration: 500,
      screen: Consumer(
        builder: (context, watch, child) => SignUpWithEmailScreen(
          model: watch(signInWithEmailModelProvider),
          textFieldModel: watch(textFieldModelProvider),
        ),
      ),
    );
  }

  static void showSignInScreen(BuildContext context) {
    custmFadeTransition(
      context,
      duration: 500,
      screen: Consumer(
        builder: (context, watch, child) => SignInWithEmailScreen(
          model: watch(signInWithEmailModelProvider),
          textFieldModel: watch(textFieldModelProvider),
        ),
      ),
    );
  }

  /// STATIC
  static final formKey = GlobalKey<FormState>();

  static const _termsUrl =
      'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
  static const _privacyServiceUrl =
      'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';
}
