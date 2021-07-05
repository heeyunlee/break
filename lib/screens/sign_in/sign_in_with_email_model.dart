import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/sign_in/string_validator.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/show_alert_dialog.dart';

final signInWithEmailModelProvider =
    ChangeNotifierProvider((ref) => SignInWithEmailModel());

class SignInWithEmailModel extends ChangeNotifier
    with EmailAndPasswordValidators {
  AuthService? auth;
  FirestoreDatabase? database;

  SignInWithEmailModel({
    this.auth,
    this.database,
  }) {
    final container = ProviderContainer();
    auth = container.read(authServiceProvider2);
    database = container.read(databaseProvider2(auth!.currentUser?.uid));
  }

  bool _isLoading = false;
  bool _submitted = false;
  bool _signUpScreenStringsValid = false;
  bool _signInScreenStringsValid = false;
  final GlobalKey<FormState> _signInWithEmailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signUpWithEmailformKey = GlobalKey<FormState>();
  late TextEditingController _emailEditingController;
  late TextEditingController _passwordEditingController;
  late TextEditingController _firstNameEditingController;
  late TextEditingController _lastNameEditingController;
  late FocusNode _focusNode1;
  late FocusNode _focusNode2;
  late FocusNode _focusNode3;
  late FocusNode _focusNode4;

  String? _emailErrorText;
  String? _passwordErrorText;
  String? _firstNameErrorText;
  String? _lastNameErrorText;

  bool get isLoading => _isLoading;
  bool get submitted => _submitted;
  bool get signUpScreenStringsValid => _signUpScreenStringsValid;
  bool get signInScreenStringsValid => _signInScreenStringsValid;
  GlobalKey<FormState> get signInWithEmailFormKey => _signInWithEmailFormKey;
  GlobalKey<FormState> get signUpWithEmailFormKey => _signUpWithEmailformKey;
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

  String? get emailErrorText => _emailErrorText;
  String? get passwordErrorText => _passwordErrorText;
  String? get firstNameErrorText => _firstNameErrorText;
  String? get lastNameErrorText => _lastNameErrorText;

  void toggleIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void toggleSubmitted() {
    _submitted = false;
    notifyListeners();
  }

  void signInScreenValidate(String _) {
    bool isEmailValid = validator.isEmailValid(_emailEditingController.text);
    bool isPasswordValid =
        validator.isPasswordValid(_passwordEditingController.text);

    bool _showEmailError = _submitted && !isEmailValid;
    bool _showPasswordError = _submitted && !isPasswordValid;

    _emailErrorText = _showEmailError ? invalidEmailText : null;
    _passwordErrorText = _showPasswordError ? emptyPasswordText : null;

    _signInScreenStringsValid = isEmailValid && isPasswordValid;

    notifyListeners();
  }

  void signUpScreenValidate(String _) {
    bool isEmailValid = validator.isEmailValid(_emailEditingController.text);
    bool isPasswordValid =
        validator.isPasswordValid(_passwordEditingController.text);
    bool isFirstNameValid =
        validator.isFirstNameValid(_firstNameEditingController.text);
    bool isLastNameValid =
        validator.isLastNameValid(_lastNameEditingController.text);

    bool _showEmailError = _submitted && !isEmailValid;
    bool _showPasswordError = _submitted && !isPasswordValid;
    bool _showFirstNameError = _submitted && !isFirstNameValid;
    bool _showLastNameError = _submitted && !isLastNameValid;

    _emailErrorText = _showEmailError ? invalidEmailText : null;
    _passwordErrorText = _showPasswordError ? emptyPasswordText : null;
    _firstNameErrorText = _showFirstNameError ? emptyFirstNameText : null;
    _lastNameErrorText = _showLastNameError ? emptyLastNameText : null;

    _signUpScreenStringsValid =
        isEmailValid && isPasswordValid && isFirstNameValid && isLastNameValid;

    notifyListeners();
  }

  bool _validateAndSaveForm(GlobalKey<FormState> formKey) {
    final form = formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // SIGN UP WITH EMAIL AND PASSWORD
  Future<void> signUpWithEmail(BuildContext context) async {
    final locale = Intl.getCurrentLocale();

    if (_validateAndSaveForm(signUpWithEmailFormKey)) {
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
        final currentTime = Timestamp.now();

        final user = User(
          userId: firebaseUser.uid,
          displayName:
              '${_firstNameEditingController.text} ${_lastNameEditingController.text}',
          userName: firebaseUser.providerData[0].displayName ?? id,
          userEmail: firebaseUser.providerData[0].email ?? '',
          signUpDate: currentTime,
          signUpProvider: 'email',
          totalWeights: 0,
          totalNumberOfWorkouts: 0,
          unitOfMass: (locale == 'ko') ? 0 : 1,
          lastLoginDate: currentTime,
          // dailyWorkoutHistories: [],
          // dailyNutritionHistories: [],
          savedRoutines: [],
          savedWorkouts: [],
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
    if (_validateAndSaveForm(_signInWithEmailFormKey)) {
      setIsLoading(true);
      _submitted = true;

      try {
        await auth!.signInWithEmailWithPassword(
          _emailEditingController.text,
          _passwordEditingController.text,
        );

        // Update Data if exist
        final currentTime = Timestamp.now();

        final updatedUserData = {
          'lastLoginDate': currentTime,
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

  void signUpInit() {
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
    _firstNameEditingController = TextEditingController();
    _lastNameEditingController = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
    _focusNode3 = FocusNode();
    _focusNode4 = FocusNode();
  }

  void signInInit() {
    _emailEditingController = TextEditingController();
    _passwordEditingController = TextEditingController();
    _focusNode1 = FocusNode();
    _focusNode2 = FocusNode();
  }

  void signInDispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();

    _focusNode1.dispose();
    _focusNode2.dispose();
  }

  void signUpDispose() {
    _emailEditingController.dispose();
    _passwordEditingController.dispose();
    _firstNameEditingController.dispose();
    _lastNameEditingController.dispose();
    _focusNode1.dispose();
    _focusNode2.dispose();
    _focusNode3.dispose();
    _focusNode4.dispose();
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
          // content: exception.toString(),
          defaultActionText: S.current.ok,
        );
    }
  }

  void launchTermsURL() async => await canLaunch(_termsUrl)
      ? await launch(_termsUrl)
      : throw 'Could not launch $_termsUrl';

  void launchPrivacyServiceURL() async => await canLaunch(_privacyServiceUrl)
      ? await launch(_privacyServiceUrl)
      : throw 'Could not launch $_privacyServiceUrl';

  static const _termsUrl =
      'https://app.termly.io/document/terms-of-use-for-ios-app/94692e31-d268-4f30-b710-2eebe37cc750';
  static const _privacyServiceUrl =
      'https://app.termly.io/document/privacy-policy/34f278e4-7150-48c6-88c0-ee9a3ee082d1';
}
