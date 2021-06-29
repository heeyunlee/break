// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Routines`
  String get routines {
    return Intl.message(
      'Routines',
      name: 'routines',
      desc: '',
      args: [],
    );
  }

  /// `Workouts`
  String get workouts {
    return Intl.message(
      'Workouts',
      name: 'workouts',
      desc: '',
      args: [],
    );
  }

  /// `{seconds} seconds ago`
  String timeDifferenceInSeconds(Object seconds) {
    return Intl.message(
      '$seconds seconds ago',
      name: 'timeDifferenceInSeconds',
      desc: '',
      args: [seconds],
    );
  }

  /// `{minutes} minutes ago`
  String timeDifferenceInMinutes(Object minutes) {
    return Intl.message(
      '$minutes minutes ago',
      name: 'timeDifferenceInMinutes',
      desc: '',
      args: [minutes],
    );
  }

  /// `{hours} hours ago`
  String timeDifferenceInHours(Object hours) {
    return Intl.message(
      '$hours hours ago',
      name: 'timeDifferenceInHours',
      desc: '',
      args: [hours],
    );
  }

  /// `{days} days ago`
  String timeDifferenceInDays(Object days) {
    return Intl.message(
      '$days days ago',
      name: 'timeDifferenceInDays',
      desc: '',
      args: [days],
    );
  }

  /// `lifted`
  String get lifted {
    return Intl.message(
      'lifted',
      name: 'lifted',
      desc: '',
      args: [],
    );
  }

  /// `spent`
  String get spent {
    return Intl.message(
      'spent',
      name: 'spent',
      desc: '',
      args: [],
    );
  }

  /// `minutes`
  String get minutes {
    return Intl.message(
      'minutes',
      name: 'minutes',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settingsScreenTitle {
    return Intl.message(
      'Settings',
      name: 'settingsScreenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInformation {
    return Intl.message(
      'Personal Information',
      name: 'personalInformation',
      desc: '',
      args: [],
    );
  }

  /// `SKIP`
  String get skip {
    return Intl.message(
      'SKIP',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message(
      'NEXT',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `START`
  String get start {
    return Intl.message(
      'START',
      name: 'start',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Facebook`
  String get continueWithFacebook {
    return Intl.message(
      'Continue with Facebook',
      name: 'continueWithFacebook',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Apple`
  String get continueWithApple {
    return Intl.message(
      'Continue with Apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Kakao`
  String get continueWithKakao {
    return Intl.message(
      'Continue with Kakao',
      name: 'continueWithKakao',
      desc: '',
      args: [],
    );
  }

  /// `Continue Anonymously`
  String get continueAnonymously {
    return Intl.message(
      'Continue Anonymously',
      name: 'continueAnonymously',
      desc: '',
      args: [],
    );
  }

  /// `Signing In...`
  String get signingIn {
    return Intl.message(
      'Signing In...',
      name: 'signingIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Failed`
  String get signInFailed {
    return Intl.message(
      'Sign In Failed',
      name: 'signInFailed',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message(
      'OK',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Operation Failed`
  String get operationFailed {
    return Intl.message(
      'Operation Failed',
      name: 'operationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Edit Display Name`
  String get editDisplayNameTitle {
    return Intl.message(
      'Edit Display Name',
      name: 'editDisplayNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your Display Name`
  String get yourDisplayName {
    return Intl.message(
      'Your Display Name',
      name: 'yourDisplayName',
      desc: '',
      args: [],
    );
  }

  /// `Display Name is Empty`
  String get displayNameEmptyTitle {
    return Intl.message(
      'Display Name is Empty',
      name: 'displayNameEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Display Name cannot be empty. Please add something`
  String get displayNameEmptyContent {
    return Intl.message(
      'Display Name cannot be empty. Please add something',
      name: 'displayNameEmptyContent',
      desc: '',
      args: [],
    );
  }

  /// `"Hercules"`
  String get displayNameHintText {
    return Intl.message(
      '"Hercules"',
      name: 'displayNameHintText',
      desc: '',
      args: [],
    );
  }

  /// `Unit of Mass`
  String get unitOfMass {
    return Intl.message(
      'Unit of Mass',
      name: 'unitOfMass',
      desc: '',
      args: [],
    );
  }

  /// `Feedback & Feature Requests`
  String get FeedbackAndFeatureRequests {
    return Intl.message(
      'Feedback & Feature Requests',
      name: 'FeedbackAndFeatureRequests',
      desc: '',
      args: [],
    );
  }

  /// `Your Feedback Matters!`
  String get yourFeedbackMatters {
    return Intl.message(
      'Your Feedback Matters!',
      name: 'yourFeedbackMatters',
      desc: '',
      args: [],
    );
  }

  /// `SUBMIT`
  String get submit {
    return Intl.message(
      'SUBMIT',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Please tell us what we could do to improve this app and your workout experience.`
  String get feedbackHintText {
    return Intl.message(
      'Please tell us what we could do to improve this app and your workout experience.',
      name: 'feedbackHintText',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Herakles`
  String get applicationName {
    return Intl.message(
      'Herakles',
      name: 'applicationName',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get launguage {
    return Intl.message(
      'Language',
      name: 'launguage',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to logout? If you logged in anonymously, you will not be able to retrieve your data`
  String get confirmSignOutContext {
    return Intl.message(
      'Are you sure you want to logout? If you logged in anonymously, you will not be able to retrieve your data',
      name: 'confirmSignOutContext',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Quick Summary`
  String get quickSummary {
    return Intl.message(
      'Quick Summary',
      name: 'quickSummary',
      desc: '',
      args: [],
    );
  }

  /// `Sets`
  String get sets {
    return Intl.message(
      'Sets',
      name: 'sets',
      desc: '',
      args: [],
    );
  }

  /// `Set`
  String get set {
    return Intl.message(
      'Set',
      name: 'set',
      desc: '',
      args: [],
    );
  }

  /// `Bodyweight`
  String get bodyweight {
    return Intl.message(
      'Bodyweight',
      name: 'bodyweight',
      desc: '',
      args: [],
    );
  }

  /// `Notes`
  String get notes {
    return Intl.message(
      'Notes',
      name: 'notes',
      desc: '',
      args: [],
    );
  }

  /// `no notes...`
  String get notesHintText {
    return Intl.message(
      'no notes...',
      name: 'notesHintText',
      desc: '',
      args: [],
    );
  }

  /// `Add notes`
  String get addNotes {
    return Intl.message(
      'Add notes',
      name: 'addNotes',
      desc: '',
      args: [],
    );
  }

  /// `Make it visible to:   `
  String get makeItVisibleTo {
    return Intl.message(
      'Make it visible to:   ',
      name: 'makeItVisibleTo',
      desc: '',
      args: [],
    );
  }

  /// `Everyone`
  String get everyone {
    return Intl.message(
      'Everyone',
      name: 'everyone',
      desc: '',
      args: [],
    );
  }

  /// `Just Me`
  String get justMe {
    return Intl.message(
      'Just Me',
      name: 'justMe',
      desc: '',
      args: [],
    );
  }

  /// `DELETE`
  String get delete {
    return Intl.message(
      'DELETE',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure`
  String get deleteBottomSheetTitle {
    return Intl.message(
      'Are You Sure',
      name: 'deleteBottomSheetTitle',
      desc: '',
      args: [],
    );
  }

  /// `It will delete your data permanently. You can't undo this process`
  String get deleteBottomSheetMessage {
    return Intl.message(
      'It will delete your data permanently. You can\'t undo this process',
      name: 'deleteBottomSheetMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete History`
  String get deleteBottomSheetkButtonText {
    return Intl.message(
      'Delete History',
      name: 'deleteBottomSheetkButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Last edited on `
  String get lastEditedOn {
    return Intl.message(
      'Last edited on ',
      name: 'lastEditedOn',
      desc: '',
      args: [],
    );
  }

  /// `Log Routine`
  String get logRoutine {
    return Intl.message(
      'Log Routine',
      name: 'logRoutine',
      desc: '',
      args: [],
    );
  }

  /// `Start Routine`
  String get startRoutine {
    return Intl.message(
      'Start Routine',
      name: 'startRoutine',
      desc: '',
      args: [],
    );
  }

  /// `Deleted a Rest!`
  String get deletedARestMessage {
    return Intl.message(
      'Deleted a Rest!',
      name: 'deletedARestMessage',
      desc: '',
      args: [],
    );
  }

  /// `Deleted a Set!`
  String get deletedASet {
    return Intl.message(
      'Deleted a Set!',
      name: 'deletedASet',
      desc: '',
      args: [],
    );
  }

  /// `s`
  String get seconds {
    return Intl.message(
      's',
      name: 'seconds',
      desc: '',
      args: [],
    );
  }

  /// `DONE`
  String get done {
    return Intl.message(
      'DONE',
      name: 'done',
      desc: '',
      args: [],
    );
  }

  /// `Add a set`
  String get addASet {
    return Intl.message(
      'Add a set',
      name: 'addASet',
      desc: '',
      args: [],
    );
  }

  /// `Delete the workout?`
  String get deleteRoutineWorkoutMessage {
    return Intl.message(
      'Delete the workout?',
      name: 'deleteRoutineWorkoutMessage',
      desc: '',
      args: [],
    );
  }

  /// `Deleted a Workout!`
  String get deleteRoutineWorkoutSnakbarMessage {
    return Intl.message(
      'Deleted a Workout!',
      name: 'deleteRoutineWorkoutSnakbarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Workout`
  String get deleteRoutineWorkoutButton {
    return Intl.message(
      'Delete Workout',
      name: 'deleteRoutineWorkoutButton',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong...`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong...',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `You're one step away from creating your own routine!`
  String get savedRoutineEmptyText {
    return Intl.message(
      'You\'re one step away from creating your own routine!',
      name: 'savedRoutineEmptyText',
      desc: '',
      args: [],
    );
  }

  /// `Logged an activity`
  String get loggedRoutineHistorySnackbar {
    return Intl.message(
      'Logged an activity',
      name: 'loggedRoutineHistorySnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Add Log Workout`
  String get addWorkoutLog {
    return Intl.message(
      'Add Log Workout',
      name: 'addWorkoutLog',
      desc: '',
      args: [],
    );
  }

  /// `Start Time`
  String get startTime {
    return Intl.message(
      'Start Time',
      name: 'startTime',
      desc: '',
      args: [],
    );
  }

  /// `Duration: in Minutes`
  String get durationHintText {
    return Intl.message(
      'Duration: in Minutes',
      name: 'durationHintText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter duration!`
  String get durationValidatorText {
    return Intl.message(
      'Please enter duration!',
      name: 'durationValidatorText',
      desc: '',
      args: [],
    );
  }

  /// `Total Volume: in`
  String get totalVolumeHintText {
    return Intl.message(
      'Total Volume: in',
      name: 'totalVolumeHintText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter volumes!`
  String get totalVolumeValidatorText {
    return Intl.message(
      'Please enter volumes!',
      name: 'totalVolumeValidatorText',
      desc: '',
      args: [],
    );
  }

  /// `Effort`
  String get effort {
    return Intl.message(
      'Effort',
      name: 'effort',
      desc: '',
      args: [],
    );
  }

  /// `Deleted a routine!`
  String get deleteRoutineSnackbar {
    return Intl.message(
      'Deleted a routine!',
      name: 'deleteRoutineSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Edited a routine!`
  String get editRoutineSnackbar {
    return Intl.message(
      'Edited a routine!',
      name: 'editRoutineSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Edit Routine`
  String get editRoutineTitle {
    return Intl.message(
      'Edit Routine',
      name: 'editRoutineTitle',
      desc: '',
      args: [],
    );
  }

  /// `SAVE`
  String get save {
    return Intl.message(
      'SAVE',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Public Routine`
  String get publicRoutine {
    return Intl.message(
      'Public Routine',
      name: 'publicRoutine',
      desc: '',
      args: [],
    );
  }

  /// `Make your routine either just for yourself or sharable with other users`
  String get publicRoutineDescription {
    return Intl.message(
      'Make your routine either just for yourself or sharable with other users',
      name: 'publicRoutineDescription',
      desc: '',
      args: [],
    );
  }

  /// `Routine Title`
  String get routineTitleTitle {
    return Intl.message(
      'Routine Title',
      name: 'routineTitleTitle',
      desc: '',
      args: [],
    );
  }

  /// `'Chest Routine'`
  String get routineTitleHintText {
    return Intl.message(
      '\'Chest Routine\'',
      name: 'routineTitleHintText',
      desc: '',
      args: [],
    );
  }

  /// `Give your routine a name!`
  String get routineTitleValidatorText {
    return Intl.message(
      'Give your routine a name!',
      name: 'routineTitleValidatorText',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Add description here!`
  String get descriptionHintText {
    return Intl.message(
      'Add description here!',
      name: 'descriptionHintText',
      desc: '',
      args: [],
    );
  }

  /// `Training Level`
  String get trainingLevel {
    return Intl.message(
      'Training Level',
      name: 'trainingLevel',
      desc: '',
      args: [],
    );
  }

  /// `More Settings`
  String get moreSettings {
    return Intl.message(
      'More Settings',
      name: 'moreSettings',
      desc: '',
      args: [],
    );
  }

  /// `Main Muscle Group`
  String get mainMuscleGroup {
    return Intl.message(
      'Main Muscle Group',
      name: 'mainMuscleGroup',
      desc: '',
      args: [],
    );
  }

  /// `etc.`
  String get etc {
    return Intl.message(
      'etc.',
      name: 'etc',
      desc: '',
      args: [],
    );
  }

  /// `Equipment Required`
  String get equipmentRequired {
    return Intl.message(
      'Equipment Required',
      name: 'equipmentRequired',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure? You can't undo this process`
  String get deleteRoutineWarningMessage {
    return Intl.message(
      'Are you sure? You can\'t undo this process',
      name: 'deleteRoutineWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Routine`
  String get deleteRoutinekButtonText {
    return Intl.message(
      'Delete Routine',
      name: 'deleteRoutinekButtonText',
      desc: '',
      args: [],
    );
  }

  /// `No Main Muscle Group Selected`
  String get mainMuscleGroupAlertTitle {
    return Intl.message(
      'No Main Muscle Group Selected',
      name: 'mainMuscleGroupAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please Select at least one Main Muscle Group`
  String get mainMuscleGroupAlertContent {
    return Intl.message(
      'Please Select at least one Main Muscle Group',
      name: 'mainMuscleGroupAlertContent',
      desc: '',
      args: [],
    );
  }

  /// `No Equipment Required Selected`
  String get equipmentRequiredAlertTitle {
    return Intl.message(
      'No Equipment Required Selected',
      name: 'equipmentRequiredAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please Select at least one equipment required`
  String get equipmentRequiredAlertContent {
    return Intl.message(
      'Please Select at least one equipment required',
      name: 'equipmentRequiredAlertContent',
      desc: '',
      args: [],
    );
  }

  /// `Create New Routine`
  String get createNewRoutine {
    return Intl.message(
      'Create New Routine',
      name: 'createNewRoutine',
      desc: '',
      args: [],
    );
  }

  /// `Start Now`
  String get startNow {
    return Intl.message(
      'Start Now',
      name: 'startNow',
      desc: '',
      args: [],
    );
  }

  /// `No routine Title!`
  String get noRoutineAlertTitle {
    return Intl.message(
      'No routine Title!',
      name: 'noRoutineAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Difficulty`
  String get difficulty {
    return Intl.message(
      'Difficulty',
      name: 'difficulty',
      desc: '',
      args: [],
    );
  }

  /// `Abs`
  String get abs {
    return Intl.message(
      'Abs',
      name: 'abs',
      desc: '',
      args: [],
    );
  }

  /// `Arms`
  String get arms {
    return Intl.message(
      'Arms',
      name: 'arms',
      desc: '',
      args: [],
    );
  }

  /// `Cardio`
  String get cardio {
    return Intl.message(
      'Cardio',
      name: 'cardio',
      desc: '',
      args: [],
    );
  }

  /// `Chest`
  String get chest {
    return Intl.message(
      'Chest',
      name: 'chest',
      desc: '',
      args: [],
    );
  }

  /// `Full Body`
  String get fullBody {
    return Intl.message(
      'Full Body',
      name: 'fullBody',
      desc: '',
      args: [],
    );
  }

  /// `Glutes`
  String get glutes {
    return Intl.message(
      'Glutes',
      name: 'glutes',
      desc: '',
      args: [],
    );
  }

  /// `Hamstring`
  String get hamstring {
    return Intl.message(
      'Hamstring',
      name: 'hamstring',
      desc: '',
      args: [],
    );
  }

  /// `Lats`
  String get lats {
    return Intl.message(
      'Lats',
      name: 'lats',
      desc: '',
      args: [],
    );
  }

  /// `Lower Body`
  String get lowerBody {
    return Intl.message(
      'Lower Body',
      name: 'lowerBody',
      desc: '',
      args: [],
    );
  }

  /// `Lower Back`
  String get lowerBack {
    return Intl.message(
      'Lower Back',
      name: 'lowerBack',
      desc: '',
      args: [],
    );
  }

  /// `Quads`
  String get quads {
    return Intl.message(
      'Quads',
      name: 'quads',
      desc: '',
      args: [],
    );
  }

  /// `Shoulder`
  String get shoulder {
    return Intl.message(
      'Shoulder',
      name: 'shoulder',
      desc: '',
      args: [],
    );
  }

  /// `Stretch`
  String get stretch {
    return Intl.message(
      'Stretch',
      name: 'stretch',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Add workouts to your routine`
  String get routineWorkoutEmptyText {
    return Intl.message(
      'Add workouts to your routine',
      name: 'routineWorkoutEmptyText',
      desc: '',
      args: [],
    );
  }

  /// `Add workout`
  String get addWorkoutkButtonText {
    return Intl.message(
      'Add workout',
      name: 'addWorkoutkButtonText',
      desc: '',
      args: [],
    );
  }

  /// `No {workout} workouts...`
  String noWorkoutEmptyContent(Object workout) {
    return Intl.message(
      'No $workout workouts...',
      name: 'noWorkoutEmptyContent',
      desc: '',
      args: [workout],
    );
  }

  /// `using {equipment}`
  String usingEquipment(Object equipment) {
    return Intl.message(
      'using $equipment',
      name: 'usingEquipment',
      desc: '',
      args: [equipment],
    );
  }

  /// `Save workouts, or create your own!`
  String get savedWorkoutsEmptyText {
    return Intl.message(
      'Save workouts, or create your own!',
      name: 'savedWorkoutsEmptyText',
      desc: '',
      args: [],
    );
  }

  /// `Create your own Workout now!`
  String get savedWorkoutEmptykButtonText {
    return Intl.message(
      'Create your own Workout now!',
      name: 'savedWorkoutEmptykButtonText',
      desc: '',
      args: [],
    );
  }

  /// `No workout name`
  String get workoutTitleAlertTitle {
    return Intl.message(
      'No workout name',
      name: 'workoutTitleAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Give workout a name!`
  String get workoutTitleAlertContent {
    return Intl.message(
      'Give workout a name!',
      name: 'workoutTitleAlertContent',
      desc: '',
      args: [],
    );
  }

  /// `Workout Name`
  String get workoutName {
    return Intl.message(
      'Workout Name',
      name: 'workoutName',
      desc: '',
      args: [],
    );
  }

  /// `More About This Workout`
  String get moreAboutThisWorkout {
    return Intl.message(
      'More About This Workout',
      name: 'moreAboutThisWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Create New Workout`
  String get createNewWorkout {
    return Intl.message(
      'Create New Workout',
      name: 'createNewWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Created a new routine!`
  String get createNewRoutineSnackbar {
    return Intl.message(
      'Created a new routine!',
      name: 'createNewRoutineSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Created a new workout!`
  String get createNewWorkoutSnackbar {
    return Intl.message(
      'Created a new workout!',
      name: 'createNewWorkoutSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Custom Workout Name`
  String get workoutHintText {
    return Intl.message(
      'Custom Workout Name',
      name: 'workoutHintText',
      desc: '',
      args: [],
    );
  }

  /// `Workout Difficulty`
  String get workoutDifficultySliderText {
    return Intl.message(
      'Workout Difficulty',
      name: 'workoutDifficultySliderText',
      desc: '',
      args: [],
    );
  }

  /// `Seconds per rep`
  String get secondsPerRep {
    return Intl.message(
      'Seconds per rep',
      name: 'secondsPerRep',
      desc: '',
      args: [],
    );
  }

  /// `This will help us calculate duration for a routine`
  String get secondsPerRepHelperText {
    return Intl.message(
      'This will help us calculate duration for a routine',
      name: 'secondsPerRepHelperText',
      desc: '',
      args: [],
    );
  }

  /// `Added workout to the routine`
  String get addWorkoutToRoutineSnackbar {
    return Intl.message(
      'Added workout to the routine',
      name: 'addWorkoutToRoutineSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Succfessfully Deleted a Workout!`
  String get deleteWorkoutSnackbar {
    return Intl.message(
      'Succfessfully Deleted a Workout!',
      name: 'deleteWorkoutSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Updated a Workout Info!`
  String get updateWorkoutSnackbar {
    return Intl.message(
      'Updated a Workout Info!',
      name: 'updateWorkoutSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Edit Workout`
  String get editWorkoutTitle {
    return Intl.message(
      'Edit Workout',
      name: 'editWorkoutTitle',
      desc: '',
      args: [],
    );
  }

  /// `Public Workout`
  String get publicWorkout {
    return Intl.message(
      'Public Workout',
      name: 'publicWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Make your workout either just for yourself or sharable with other users`
  String get publicWorkoutDescription {
    return Intl.message(
      'Make your workout either just for yourself or sharable with other users',
      name: 'publicWorkoutDescription',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure? You cannot undo this process`
  String get deleteWorkoutWarningMessage {
    return Intl.message(
      'Are you sure? You cannot undo this process',
      name: 'deleteWorkoutWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Workout`
  String get deleteWorkoutkButtonText {
    return Intl.message(
      'Delete Workout',
      name: 'deleteWorkoutkButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Add workout to your routine`
  String get addWorkoutToRoutine {
    return Intl.message(
      'Add workout to your routine',
      name: 'addWorkoutToRoutine',
      desc: '',
      args: [],
    );
  }

  /// `You haven't created routines yet`
  String get emptyRoutineMessage {
    return Intl.message(
      'You haven\'t created routines yet',
      name: 'emptyRoutineMessage',
      desc: '',
      args: [],
    );
  }

  /// `Lifted Weights`
  String get liftedWeights {
    return Intl.message(
      'Lifted Weights',
      name: 'liftedWeights',
      desc: '',
      args: [],
    );
  }

  /// `Nothing's here...`
  String get homeTabEmptyMessage {
    return Intl.message(
      'Nothing\'s here...',
      name: 'homeTabEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Start working out now and see your progress!`
  String get weightsChartMessage {
    return Intl.message(
      'Start working out now and see your progress!',
      name: 'weightsChartMessage',
      desc: '',
      args: [],
    );
  }

  /// `SET DAILY GOAL`
  String get setWeightsDailyGoal {
    return Intl.message(
      'SET DAILY GOAL',
      name: 'setWeightsDailyGoal',
      desc: '',
      args: [],
    );
  }

  /// `Add Protein`
  String get addProteinkButtonText {
    return Intl.message(
      'Add Protein',
      name: 'addProteinkButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Start Workout`
  String get startWorkoutkButtonText {
    return Intl.message(
      'Start Workout',
      name: 'startWorkoutkButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Histories`
  String get routineHistoryTitle {
    return Intl.message(
      'Histories',
      name: 'routineHistoryTitle',
      desc: '',
      args: [],
    );
  }

  /// `Use your own routines to Workout, and save your progress!`
  String get routineHistoyEmptyMessage {
    return Intl.message(
      'Use your own routines to Workout, and save your progress!',
      name: 'routineHistoyEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add Proteins`
  String get addProteins {
    return Intl.message(
      'Add Proteins',
      name: 'addProteins',
      desc: '',
      args: [],
    );
  }

  /// `Getting your protein is as important as working out!`
  String get proteinChartContentText {
    return Intl.message(
      'Getting your protein is as important as working out!',
      name: 'proteinChartContentText',
      desc: '',
      args: [],
    );
  }

  /// `Deleted a protein entry`
  String get deleteProteinSnackbar {
    return Intl.message(
      'Deleted a protein entry',
      name: 'deleteProteinSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Protein Entries`
  String get proteinEntriesTitle {
    return Intl.message(
      'Protein Entries',
      name: 'proteinEntriesTitle',
      desc: '',
      args: [],
    );
  }

  /// `You haven't recorded any proteins yet!`
  String get proteinEntriesEmptyMessage {
    return Intl.message(
      'You haven\'t recorded any proteins yet!',
      name: 'proteinEntriesEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Deleted workout history`
  String get deleteRoutineHistorySnackbar {
    return Intl.message(
      'Deleted workout history',
      name: 'deleteRoutineHistorySnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Workout`
  String get workout {
    return Intl.message(
      'Workout',
      name: 'workout',
      desc: '',
      args: [],
    );
  }

  /// `Added a protein entry!`
  String get addProteinEntrySnackbar {
    return Intl.message(
      'Added a protein entry!',
      name: 'addProteinEntrySnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Select Meal Type!`
  String get selectMealTypeAlertTitle {
    return Intl.message(
      'Select Meal Type!',
      name: 'selectMealTypeAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `Please select meal type in order to save`
  String get selectMeapTypeAlertContent {
    return Intl.message(
      'Please select meal type in order to save',
      name: 'selectMeapTypeAlertContent',
      desc: '',
      args: [],
    );
  }

  /// `Time`
  String get time {
    return Intl.message(
      'Time',
      name: 'time',
      desc: '',
      args: [],
    );
  }

  /// `Amount`
  String get amount {
    return Intl.message(
      'Amount',
      name: 'amount',
      desc: '',
      args: [],
    );
  }

  /// `Meal Type`
  String get mealType {
    return Intl.message(
      'Meal Type',
      name: 'mealType',
      desc: '',
      args: [],
    );
  }

  /// `Before Workout`
  String get beforeWorkout {
    return Intl.message(
      'Before Workout',
      name: 'beforeWorkout',
      desc: '',
      args: [],
    );
  }

  /// `After Workout`
  String get afterWorkout {
    return Intl.message(
      'After Workout',
      name: 'afterWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Breakfast`
  String get breakfast {
    return Intl.message(
      'Breakfast',
      name: 'breakfast',
      desc: '',
      args: [],
    );
  }

  /// `Lunch`
  String get lunch {
    return Intl.message(
      'Lunch',
      name: 'lunch',
      desc: '',
      args: [],
    );
  }

  /// `Dinner`
  String get dinner {
    return Intl.message(
      'Dinner',
      name: 'dinner',
      desc: '',
      args: [],
    );
  }

  /// `Snack`
  String get snack {
    return Intl.message(
      'Snack',
      name: 'snack',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get others {
    return Intl.message(
      'Others',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  /// `Choose Routine to Start`
  String get chooseRoutineToStart {
    return Intl.message(
      'Choose Routine to Start',
      name: 'chooseRoutineToStart',
      desc: '',
      args: [],
    );
  }

  /// `No {chip} routines yet...`
  String emptyroutinesContentTitle(Object chip) {
    return Intl.message(
      'No $chip routines yet...',
      name: 'emptyroutinesContentTitle',
      desc: '',
      args: [chip],
    );
  }

  /// `Nothing here...`
  String get emptyContentTitle {
    return Intl.message(
      'Nothing here...',
      name: 'emptyContentTitle',
      desc: '',
      args: [],
    );
  }

  /// `CREATE\nYOUR\nOWN\nROUTINE`
  String get announcementCardTitle1 {
    return Intl.message(
      'CREATE\nYOUR\nOWN\nROUTINE',
      name: 'announcementCardTitle1',
      desc: '',
      args: [],
    );
  }

  /// `SAVE\nYOUR\nPROGRESS`
  String get announcementCardTitle2 {
    return Intl.message(
      'SAVE\nYOUR\nPROGRESS',
      name: 'announcementCardTitle2',
      desc: '',
      args: [],
    );
  }

  /// `Barbell`
  String get barbell {
    return Intl.message(
      'Barbell',
      name: 'barbell',
      desc: '',
      args: [],
    );
  }

  /// `Bench`
  String get bench {
    return Intl.message(
      'Bench',
      name: 'bench',
      desc: '',
      args: [],
    );
  }

  /// `Cable`
  String get cable {
    return Intl.message(
      'Cable',
      name: 'cable',
      desc: '',
      args: [],
    );
  }

  /// `Chains`
  String get chains {
    return Intl.message(
      'Chains',
      name: 'chains',
      desc: '',
      args: [],
    );
  }

  /// `Dumbbell`
  String get dumbbell {
    return Intl.message(
      'Dumbbell',
      name: 'dumbbell',
      desc: '',
      args: [],
    );
  }

  /// `EZ Bar`
  String get eZBar {
    return Intl.message(
      'EZ Bar',
      name: 'eZBar',
      desc: '',
      args: [],
    );
  }

  /// `Gym Ball`
  String get gymBall {
    return Intl.message(
      'Gym Ball',
      name: 'gymBall',
      desc: '',
      args: [],
    );
  }

  /// `Kettlebell`
  String get kettlebell {
    return Intl.message(
      'Kettlebell',
      name: 'kettlebell',
      desc: '',
      args: [],
    );
  }

  /// `Machine`
  String get machine {
    return Intl.message(
      'Machine',
      name: 'machine',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message(
      'Other',
      name: 'other',
      desc: '',
      args: [],
    );
  }

  /// `Add Measurement`
  String get addMeasurement {
    return Intl.message(
      'Add Measurement',
      name: 'addMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `Body weight`
  String get bodyweightMeasurement {
    return Intl.message(
      'Body weight',
      name: 'bodyweightMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `Please add weight data`
  String get weightsHintText {
    return Intl.message(
      'Please add weight data',
      name: 'weightsHintText',
      desc: '',
      args: [],
    );
  }

  /// `Body Fat`
  String get bodyFat {
    return Intl.message(
      'Body Fat',
      name: 'bodyFat',
      desc: '',
      args: [],
    );
  }

  /// `Skeletal Muscle Mass`
  String get skeletalMuscleMass {
    return Intl.message(
      'Skeletal Muscle Mass',
      name: 'skeletalMuscleMass',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Own Workout`
  String get createYourOwnWorkout {
    return Intl.message(
      'Create Your Own Workout',
      name: 'createYourOwnWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Log Your Workout`
  String get logYourWorkout {
    return Intl.message(
      'Log Your Workout',
      name: 'logYourWorkout',
      desc: '',
      args: [],
    );
  }

  /// `See Your Progress`
  String get seeYourProgress {
    return Intl.message(
      'See Your Progress',
      name: 'seeYourProgress',
      desc: '',
      args: [],
    );
  }

  /// `Share With Others`
  String get shareWithOthers {
    return Intl.message(
      'Share With Others',
      name: 'shareWithOthers',
      desc: '',
      args: [],
    );
  }

  /// `x`
  String get x {
    return Intl.message(
      'x',
      name: 'x',
      desc: '',
      args: [],
    );
  }

  /// `At Home`
  String get atHome {
    return Intl.message(
      'At Home',
      name: 'atHome',
      desc: '',
      args: [],
    );
  }

  /// `Gym`
  String get gym {
    return Intl.message(
      'Gym',
      name: 'gym',
      desc: '',
      args: [],
    );
  }

  /// `Outdoor`
  String get outdoor {
    return Intl.message(
      'Outdoor',
      name: 'outdoor',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message(
      'Location',
      name: 'location',
      desc: '',
      args: [],
    );
  }

  /// `Body Measurement`
  String get bodyMeasurement {
    return Intl.message(
      'Body Measurement',
      name: 'bodyMeasurement',
      desc: '',
      args: [],
    );
  }

  /// `You haven't added any body measurements records yet!`
  String get measurementsEmptyMessage {
    return Intl.message(
      'You haven\'t added any body measurements records yet!',
      name: 'measurementsEmptyMessage',
      desc: '',
      args: [],
    );
  }

  /// `Successfully delete Measurement!`
  String get deleteMeasurementSnackbar {
    return Intl.message(
      'Successfully delete Measurement!',
      name: 'deleteMeasurementSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Add at least two data to see your chart`
  String get addMasurementDataMessage {
    return Intl.message(
      'Add at least two data to see your chart',
      name: 'addMasurementDataMessage',
      desc: '',
      args: [],
    );
  }

  /// `You've finished your workout! \nKeep Lifting! 🎉`
  String get afterWorkoutSnackbar {
    return Intl.message(
      'You\'ve finished your workout! \nKeep Lifting! 🎉',
      name: 'afterWorkoutSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Add few sets to your workout`
  String get addSetsToWorkout {
    return Intl.message(
      'Add few sets to your workout',
      name: 'addSetsToWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Weights`
  String get weights {
    return Intl.message(
      'Weights',
      name: 'weights',
      desc: '',
      args: [],
    );
  }

  /// `Reps`
  String get reps {
    return Intl.message(
      'Reps',
      name: 'reps',
      desc: '',
      args: [],
    );
  }

  /// `To Previous Workout`
  String get toPreviousWorkout {
    return Intl.message(
      'To Previous Workout',
      name: 'toPreviousWorkout',
      desc: '',
      args: [],
    );
  }

  /// `To previous set`
  String get toPreviousSet {
    return Intl.message(
      'To previous set',
      name: 'toPreviousSet',
      desc: '',
      args: [],
    );
  }

  /// `Pause Workout`
  String get pauseWorkout {
    return Intl.message(
      'Pause Workout',
      name: 'pauseWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Resume Workout`
  String get resumeWorkout {
    return Intl.message(
      'Resume Workout',
      name: 'resumeWorkout',
      desc: '',
      args: [],
    );
  }

  /// `To Next Set`
  String get toNextSet {
    return Intl.message(
      'To Next Set',
      name: 'toNextSet',
      desc: '',
      args: [],
    );
  }

  /// `To Next Workout`
  String get toNextWorkout {
    return Intl.message(
      'To Next Workout',
      name: 'toNextWorkout',
      desc: '',
      args: [],
    );
  }

  /// `SAVE & END WORKOUT`
  String get saveAndEndWorkout {
    return Intl.message(
      'SAVE & END WORKOUT',
      name: 'saveAndEndWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Stop your workout? Data won't be saved`
  String get endWorkoutWarningMessage {
    return Intl.message(
      'Stop your workout? Data won\'t be saved',
      name: 'endWorkoutWarningMessage',
      desc: '',
      args: [],
    );
  }

  /// `Stop the workout`
  String get stopTheWorkout {
    return Intl.message(
      'Stop the workout',
      name: 'stopTheWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Today's Workout Summary: `
  String get todaysWorkoutSummary {
    return Intl.message(
      'Today\'s Workout Summary: ',
      name: 'todaysWorkoutSummary',
      desc: '',
      args: [],
    );
  }

  /// `Stats`
  String get stats {
    return Intl.message(
      'Stats',
      name: 'stats',
      desc: '',
      args: [],
    );
  }

  /// `How do you feel? Add Notes`
  String get addNotesHintText {
    return Intl.message(
      'How do you feel? Add Notes',
      name: 'addNotesHintText',
      desc: '',
      args: [],
    );
  }

  /// `How was your workout?`
  String get setEffortsTitle {
    return Intl.message(
      'How was your workout?',
      name: 'setEffortsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Beginner',
      name: 'beginner',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermediate',
      name: 'intermediate',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Advanced',
      name: 'advanced',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Email`
  String get continueWithEmail {
    return Intl.message(
      'Continue with Email',
      name: 'continueWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'confirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Create Account`
  String get createAccount {
    return Intl.message(
      'Create Account',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In with Email`
  String get signInWithEmail {
    return Intl.message(
      'Sign In with Email',
      name: 'signInWithEmail',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get signUp {
    return Intl.message(
      'Sign Up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Log In`
  String get logIn {
    return Intl.message(
      'Log In',
      name: 'logIn',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your password`
  String get passwordHintText {
    return Intl.message(
      'Please enter your password',
      name: 'passwordHintText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email`
  String get emptyEmailValidationText {
    return Intl.message(
      'Please enter email',
      name: 'emptyEmailValidationText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email address`
  String get invalidEmailValidationText {
    return Intl.message(
      'Please enter valid email address',
      name: 'invalidEmailValidationText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password`
  String get emptyPasswordValidationText {
    return Intl.message(
      'Please enter a password',
      name: 'emptyPasswordValidationText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter at least 8 letters`
  String get shortPasswordValidationText {
    return Intl.message(
      'Please enter at least 8 letters',
      name: 'shortPasswordValidationText',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your password`
  String get confirmPasswordHintText {
    return Intl.message(
      'Confirm your password',
      name: 'confirmPasswordHintText',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a password again`
  String get emptyConfirmPasswordValidationtext {
    return Intl.message(
      'Please enter a password again',
      name: 'emptyConfirmPasswordValidationtext',
      desc: '',
      args: [],
    );
  }

  /// `Password do not match`
  String get passwordNotMatchValidationText {
    return Intl.message(
      'Password do not match',
      name: 'passwordNotMatchValidationText',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Need an account?`
  String get needAnAccount {
    return Intl.message(
      'Need an account?',
      name: 'needAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get signIn {
    return Intl.message(
      'Sign In',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Register!`
  String get register {
    return Intl.message(
      'Register!',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `User Not Found`
  String get userNotFound {
    return Intl.message(
      'User Not Found',
      name: 'userNotFound',
      desc: '',
      args: [],
    );
  }

  /// `User was not found. Please check your email again.`
  String get userNotFoundMessage {
    return Intl.message(
      'User was not found. Please check your email again.',
      name: 'userNotFoundMessage',
      desc: '',
      args: [],
    );
  }

  /// `Wrong Password`
  String get wrongPassword {
    return Intl.message(
      'Wrong Password',
      name: 'wrongPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please check your password again`
  String get wrongPasswordMessage {
    return Intl.message(
      'Please check your password again',
      name: 'wrongPasswordMessage',
      desc: '',
      args: [],
    );
  }

  /// `Email Already In Use`
  String get emailAlreadyInUse {
    return Intl.message(
      'Email Already In Use',
      name: 'emailAlreadyInUse',
      desc: '',
      args: [],
    );
  }

  /// `The email addresss is already in use by another account. Please sign in of sign up with different email`
  String get emailAlreadyInUseMessage {
    return Intl.message(
      'The email addresss is already in use by another account. Please sign in of sign up with different email',
      name: 'emailAlreadyInUseMessage',
      desc: '',
      args: [],
    );
  }

  /// `Band`
  String get band {
    return Intl.message(
      'Band',
      name: 'band',
      desc: '',
      args: [],
    );
  }

  /// `Plate`
  String get plate {
    return Intl.message(
      'Plate',
      name: 'plate',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Traps`
  String get traps {
    return Intl.message(
      'Traps',
      name: 'traps',
      desc: '',
      args: [],
    );
  }

  /// `Add Description`
  String get addDescription {
    return Intl.message(
      'Add Description',
      name: 'addDescription',
      desc: '',
      args: [],
    );
  }

  /// ` worked out {mainMuscleGroup}`
  String workedOutMainMuscleGroup(Object mainMuscleGroup) {
    return Intl.message(
      ' worked out $mainMuscleGroup',
      name: 'workedOutMainMuscleGroup',
      desc: '',
      args: [mainMuscleGroup],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get terms {
    return Intl.message(
      'Terms',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `By signing in with one of the social login providers, you acknowledge that you've read and accepted our\n`
  String get acceptingTerms {
    return Intl.message(
      'By signing in with one of the social login providers, you acknowledge that you\'ve read and accepted our\n',
      name: 'acceptingTerms',
      desc: '',
      args: [],
    );
  }

  /// `에 동의하는 것입니다`
  String get acepptingTermsKorean {
    return Intl.message(
      '에 동의하는 것입니다',
      name: 'acepptingTermsKorean',
      desc: '',
      args: [],
    );
  }

  /// `By signing up you acknowledge that you've read and accepted our\n`
  String get acceptingTermsEmail {
    return Intl.message(
      'By signing up you acknowledge that you\'ve read and accepted our\n',
      name: 'acceptingTermsEmail',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAcocunt {
    return Intl.message(
      'Delete Account',
      name: 'deleteAcocunt',
      desc: '',
      args: [],
    );
  }

  /// `Manage Account`
  String get manageAccount {
    return Intl.message(
      'Manage Account',
      name: 'manageAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message(
      'Account',
      name: 'account',
      desc: '',
      args: [],
    );
  }

  /// `Display Name`
  String get displayName {
    return Intl.message(
      'Display Name',
      name: 'displayName',
      desc: '',
      args: [],
    );
  }

  /// `Edit Email`
  String get editEmail {
    return Intl.message(
      'Edit Email',
      name: 'editEmail',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Updated Email!`
  String get updateEmailSnackbar {
    return Intl.message(
      'Successfully Updated Email!',
      name: 'updateEmailSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Successfully Updated Display Name!`
  String get updateDisplayNameSnackbar {
    return Intl.message(
      'Successfully Updated Display Name!',
      name: 'updateDisplayNameSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Delete {username}'s Account?`
  String deleteAccountTitle(Object username) {
    return Intl.message(
      'Delete $username\'s Account?',
      name: 'deleteAccountTitle',
      desc: '',
      args: [username],
    );
  }

  /// `By deleting the account:`
  String get byDeletingAccount {
    return Intl.message(
      'By deleting the account:',
      name: 'byDeletingAccount',
      desc: '',
      args: [],
    );
  }

  /// `• Your personal data will be deleted permenantely and will not be able to recover`
  String get deletingAccountWarning1 {
    return Intl.message(
      '• Your personal data will be deleted permenantely and will not be able to recover',
      name: 'deletingAccountWarning1',
      desc: '',
      args: [],
    );
  }

  /// `• Some data that are not saved on your user account might not be deleted`
  String get deletingAccountWarning2 {
    return Intl.message(
      '• Some data that are not saved on your user account might not be deleted',
      name: 'deletingAccountWarning2',
      desc: '',
      args: [],
    );
  }

  /// `• Continue?`
  String get deletingAccountWarning3 {
    return Intl.message(
      '• Continue?',
      name: 'deletingAccountWarning3',
      desc: '',
      args: [],
    );
  }

  /// `CONTINUE`
  String get continueButton {
    return Intl.message(
      'CONTINUE',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Rest`
  String get rest {
    return Intl.message(
      'Rest',
      name: 'rest',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Added to your Saved Routines`
  String get savedRoutineSnackbar {
    return Intl.message(
      'Added to your Saved Routines',
      name: 'savedRoutineSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Removed from your Saved Routines`
  String get unsavedRoutineSnackbar {
    return Intl.message(
      'Removed from your Saved Routines',
      name: 'unsavedRoutineSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Saved Routines`
  String get savedRoutines {
    return Intl.message(
      'Saved Routines',
      name: 'savedRoutines',
      desc: '',
      args: [],
    );
  }

  /// `routine`
  String get routine {
    return Intl.message(
      'routine',
      name: 'routine',
      desc: '',
      args: [],
    );
  }

  /// `routines`
  String get routinesLowerCase {
    return Intl.message(
      'routines',
      name: 'routinesLowerCase',
      desc: '',
      args: [],
    );
  }

  /// `No saved routines yet...`
  String get noSavedRoutinesYet {
    return Intl.message(
      'No saved routines yet...',
      name: 'noSavedRoutinesYet',
      desc: '',
      args: [],
    );
  }

  /// `E-MAIL ADDRESS`
  String get emailAddress {
    return Intl.message(
      'E-MAIL ADDRESS',
      name: 'emailAddress',
      desc: '',
      args: [],
    );
  }

  /// `PASSWORD`
  String get passwordAllCap {
    return Intl.message(
      'PASSWORD',
      name: 'passwordAllCap',
      desc: '',
      args: [],
    );
  }

  /// `FIRST NAME`
  String get firstName {
    return Intl.message(
      'FIRST NAME',
      name: 'firstName',
      desc: '',
      args: [],
    );
  }

  /// `Please Add your first name`
  String get firstNameValidationText {
    return Intl.message(
      'Please Add your first name',
      name: 'firstNameValidationText',
      desc: '',
      args: [],
    );
  }

  /// `John`
  String get firstNameHintText {
    return Intl.message(
      'John',
      name: 'firstNameHintText',
      desc: '',
      args: [],
    );
  }

  /// `LAST NAME`
  String get lastName {
    return Intl.message(
      'LAST NAME',
      name: 'lastName',
      desc: '',
      args: [],
    );
  }

  /// `Please Add your last name`
  String get lastNameValidationText {
    return Intl.message(
      'Please Add your last name',
      name: 'lastNameValidationText',
      desc: '',
      args: [],
    );
  }

  /// `Doe`
  String get lastNameHintText {
    return Intl.message(
      'Doe',
      name: 'lastNameHintText',
      desc: '',
      args: [],
    );
  }

  /// `Start Workout`
  String get startWorkout {
    return Intl.message(
      'Start Workout',
      name: 'startWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Nutritions`
  String get nutritions {
    return Intl.message(
      'Nutritions',
      name: 'nutritions',
      desc: '',
      args: [],
    );
  }

  /// `Body`
  String get measurements {
    return Intl.message(
      'Body',
      name: 'measurements',
      desc: '',
      args: [],
    );
  }

  /// `Routine is empty!`
  String get emptyRoutineAlertTitle {
    return Intl.message(
      'Routine is empty!',
      name: 'emptyRoutineAlertTitle',
      desc: '',
      args: [],
    );
  }

  /// `END`
  String get endMiniplayerButtonText {
    return Intl.message(
      'END',
      name: 'endMiniplayerButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Add sets to your workout`
  String get noWorkoutSetTitle {
    return Intl.message(
      'Add sets to your workout',
      name: 'noWorkoutSetTitle',
      desc: '',
      args: [],
    );
  }

  /// `An error has occured`
  String get errorOccuredMessage {
    return Intl.message(
      'An error has occured',
      name: 'errorOccuredMessage',
      desc: '',
      args: [],
    );
  }

  /// `Saved Workouts`
  String get savedWorkouts {
    return Intl.message(
      'Saved Workouts',
      name: 'savedWorkouts',
      desc: '',
      args: [],
    );
  }

  /// `Hello,\n{displayName}`
  String progressTabIntroduction(Object displayName) {
    return Intl.message(
      'Hello,\n$displayName',
      name: 'progressTabIntroduction',
      desc: '',
      args: [displayName],
    );
  }

  /// `Proteins`
  String get proteins {
    return Intl.message(
      'Proteins',
      name: 'proteins',
      desc: '',
      args: [],
    );
  }

  /// `Workouts`
  String get workoutsUpperCase {
    return Intl.message(
      'Workouts',
      name: 'workoutsUpperCase',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get history {
    return Intl.message(
      'History',
      name: 'history',
      desc: '',
      args: [],
    );
  }

  /// `Progress`
  String get progress {
    return Intl.message(
      'Progress',
      name: 'progress',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Search Workouts`
  String get searchBarHintText {
    return Intl.message(
      'Search Workouts',
      name: 'searchBarHintText',
      desc: '',
      args: [],
    );
  }

  /// `By Muscle Group`
  String get byMuscleGroup {
    return Intl.message(
      'By Muscle Group',
      name: 'byMuscleGroup',
      desc: '',
      args: [],
    );
  }

  /// `By Equipment`
  String get byEquipment {
    return Intl.message(
      'By Equipment',
      name: 'byEquipment',
      desc: '',
      args: [],
    );
  }

  /// `By Location`
  String get byLocation {
    return Intl.message(
      'By Location',
      name: 'byLocation',
      desc: '',
      args: [],
    );
  }

  /// `Search Result is Empty...`
  String get searchResultsEmptyText {
    return Intl.message(
      'Search Result is Empty...',
      name: 'searchResultsEmptyText',
      desc: '',
      args: [],
    );
  }

  /// `{muscle} workout using {equipment}`
  String searchResultSubtitle(Object muscle, Object equipment) {
    return Intl.message(
      '$muscle workout using $equipment',
      name: 'searchResultSubtitle',
      desc: '',
      args: [muscle, equipment],
    );
  }

  /// `Saved Routine`
  String get savedRoutineSnackBarTitle {
    return Intl.message(
      'Saved Routine',
      name: 'savedRoutineSnackBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Unsaved Routine`
  String get unsavedRoutineSnackBarTitle {
    return Intl.message(
      'Unsaved Routine',
      name: 'unsavedRoutineSnackBarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Routine History`
  String get deleteRoutineHistorySnackbarTitle {
    return Intl.message(
      'Delete Routine History',
      name: 'deleteRoutineHistorySnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Add Workout`
  String get addWorkoutToRoutineSnackbarTitle {
    return Intl.message(
      'Add Workout',
      name: 'addWorkoutToRoutineSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Added Protein`
  String get addProteinEntrySnackbarTitle {
    return Intl.message(
      'Added Protein',
      name: 'addProteinEntrySnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Added measurement entry`
  String get addMeasurementSnackbar {
    return Intl.message(
      'Added measurement entry',
      name: 'addMeasurementSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Add Measurement`
  String get addMeasurementSnackbarTitle {
    return Intl.message(
      'Add Measurement',
      name: 'addMeasurementSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Successfully updated notes`
  String get updateRoutineHistoryNotesSnackbar {
    return Intl.message(
      'Successfully updated notes',
      name: 'updateRoutineHistoryNotesSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Update Notes`
  String get updateRoutineHistoryNotesSnackbarTitle {
    return Intl.message(
      'Update Notes',
      name: 'updateRoutineHistoryNotesSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Changed the record to public`
  String get makeRoutineHistoryPublicSnackbar {
    return Intl.message(
      'Changed the record to public',
      name: 'makeRoutineHistoryPublicSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Changed the record to private`
  String get makeRoutineHistoryPrivateSnackbar {
    return Intl.message(
      'Changed the record to private',
      name: 'makeRoutineHistoryPrivateSnackbar',
      desc: '',
      args: [],
    );
  }

  /// `Update Routine History`
  String get isPublicRoutineHistorySnackbarTitle {
    return Intl.message(
      'Update Routine History',
      name: 'isPublicRoutineHistorySnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Protein`
  String get deleteProteinSnackbarTitle {
    return Intl.message(
      'Delete Protein',
      name: 'deleteProteinSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Body Measurement`
  String get deleteMeasurementSnackbarTitle {
    return Intl.message(
      'Delete Body Measurement',
      name: 'deleteMeasurementSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Update Display Name`
  String get updateDisplayNameSnackbarTitle {
    return Intl.message(
      'Update Display Name',
      name: 'updateDisplayNameSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `We have successfully deleted your user data`
  String get deleteAccountSnackbarMessage {
    return Intl.message(
      'We have successfully deleted your user data',
      name: 'deleteAccountSnackbarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccountSnackbarTitle {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccountSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Delete Workout`
  String get deleteRoutineWorkoutSnakbarTitle {
    return Intl.message(
      'Delete Workout',
      name: 'deleteRoutineWorkoutSnakbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Create Routine`
  String get createNewRoutineSnackbarTitle {
    return Intl.message(
      'Create Routine',
      name: 'createNewRoutineSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Updated equipment required for the {dataType}`
  String updateEquipmentRequiredMessage(Object dataType) {
    return Intl.message(
      'Updated equipment required for the $dataType',
      name: 'updateEquipmentRequiredMessage',
      desc: '',
      args: [dataType],
    );
  }

  /// `Updated Equipment Required`
  String get updateEquipmentRequiredTitle {
    return Intl.message(
      'Updated Equipment Required',
      name: 'updateEquipmentRequiredTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have signed out of your account`
  String get signOutSnackbarMessage {
    return Intl.message(
      'You have signed out of your account',
      name: 'signOutSnackbarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sign Out`
  String get signOutSnackbarTitle {
    return Intl.message(
      'Sign Out',
      name: 'signOutSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your feedback!`
  String get submitUserFeedbackSnackbarMessage {
    return Intl.message(
      'Thank you for your feedback!',
      name: 'submitUserFeedbackSnackbarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Feedback Submitted`
  String get submitUserFeedbackSnackbarTitle {
    return Intl.message(
      'Feedback Submitted',
      name: 'submitUserFeedbackSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back, {displayName}!`
  String signInSnackbarMessage(Object displayName) {
    return Intl.message(
      'Welcome Back, $displayName!',
      name: 'signInSnackbarMessage',
      desc: '',
      args: [displayName],
    );
  }

  /// `This Week`
  String get thisWeek {
    return Intl.message(
      'This Week',
      name: 'thisWeek',
      desc: '',
      args: [],
    );
  }

  /// `Delete Routine`
  String get deleteRoutineSnackbarTitle {
    return Intl.message(
      'Delete Routine',
      name: 'deleteRoutineSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Updated this {dataType}'s location`
  String updateLocationMessage(Object dataType) {
    return Intl.message(
      'Updated this $dataType\'s location',
      name: 'updateLocationMessage',
      desc: '',
      args: [dataType],
    );
  }

  /// `Location`
  String get updateLocationTitle {
    return Intl.message(
      'Location',
      name: 'updateLocationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Updated main muscle group for this {dataType}`
  String updateMainMuscleGroupMessage(Object dataType) {
    return Intl.message(
      'Updated main muscle group for this $dataType',
      name: 'updateMainMuscleGroupMessage',
      desc: '',
      args: [dataType],
    );
  }

  /// `Main Muscle Group`
  String get updateMainMuscleGroupTitle {
    return Intl.message(
      'Main Muscle Group',
      name: 'updateMainMuscleGroupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Updated unit of mass for this {dataType}`
  String updateUnitOfMassMessage(Object dataType) {
    return Intl.message(
      'Updated unit of mass for this $dataType',
      name: 'updateUnitOfMassMessage',
      desc: '',
      args: [dataType],
    );
  }

  /// `Added {workoutTitle} to this routine`
  String addWorkoutToRoutineSnackbarMessage(Object workoutTitle) {
    return Intl.message(
      'Added $workoutTitle to this routine',
      name: 'addWorkoutToRoutineSnackbarMessage',
      desc: '',
      args: [workoutTitle],
    );
  }

  /// `Add Workout`
  String get addWorkout {
    return Intl.message(
      'Add Workout',
      name: 'addWorkout',
      desc: '',
      args: [],
    );
  }

  /// `Update Workout`
  String get updateWorkoutSnackbarTitle {
    return Intl.message(
      'Update Workout',
      name: 'updateWorkoutSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Caneled the current workout`
  String get cancelWorkoutSnackbarMessage {
    return Intl.message(
      'Caneled the current workout',
      name: 'cancelWorkoutSnackbarMessage',
      desc: '',
      args: [],
    );
  }

  /// `Caneled Workout`
  String get cancelWorkoutSnackbarTitle {
    return Intl.message(
      'Caneled Workout',
      name: 'cancelWorkoutSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `Updated unit of mass`
  String get updateUnitOfMassUserMessage {
    return Intl.message(
      'Updated unit of mass',
      name: 'updateUnitOfMassUserMessage',
      desc: '',
      args: [],
    );
  }

  /// `Sign In Successful`
  String get signInSuccessful {
    return Intl.message(
      'Sign In Successful',
      name: 'signInSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Create Your Own Routine`
  String get createYourOwnRoutine {
    return Intl.message(
      'Create Your Own Routine',
      name: 'createYourOwnRoutine',
      desc: '',
      args: [],
    );
  }

  /// `Workout Seamlessly With Workout Player`
  String get WorkoutSeamlesslyWithWorkoutPlayer {
    return Intl.message(
      'Workout Seamlessly With Workout Player',
      name: 'WorkoutSeamlesslyWithWorkoutPlayer',
      desc: '',
      args: [],
    );
  }

  /// `Today Is \n{today}`
  String todayIs(Object today) {
    return Intl.message(
      'Today Is \n$today',
      name: 'todayIs',
      desc: '',
      args: [today],
    );
  }

  /// `Today's Summary`
  String get todaysSummary {
    return Intl.message(
      'Today\'s Summary',
      name: 'todaysSummary',
      desc: '',
      args: [],
    );
  }

  /// `Take a look`
  String get takeALook {
    return Intl.message(
      'Take a look',
      name: 'takeALook',
      desc: '',
      args: [],
    );
  }

  /// `Overview`
  String get overview {
    return Intl.message(
      'Overview',
      name: 'overview',
      desc: '',
      args: [],
    );
  }

  /// `See your daily and weekly progress`
  String get previewFirstWidget {
    return Intl.message(
      'See your daily and weekly progress',
      name: 'previewFirstWidget',
      desc: '',
      args: [],
    );
  }

  /// `Welcome, {name}! Let's get lifting`
  String firstSignInSnackbarMessage(Object name) {
    return Intl.message(
      'Welcome, $name! Let\'s get lifting',
      name: 'firstSignInSnackbarMessage',
      desc: '',
      args: [name],
    );
  }

  /// `Personal Goals`
  String get personalGoals {
    return Intl.message(
      'Personal Goals',
      name: 'personalGoals',
      desc: '',
      args: [],
    );
  }

  /// `Proteins Goal`
  String get proteinsGoal {
    return Intl.message(
      'Proteins Goal',
      name: 'proteinsGoal',
      desc: '',
      args: [],
    );
  }

  /// `Set Goal`
  String get setGoal {
    return Intl.message(
      'Set Goal',
      name: 'setGoal',
      desc: '',
      args: [],
    );
  }

  /// `Set your daily protein and lifting goal!`
  String get progressTabBannerTitle {
    return Intl.message(
      'Set your daily protein and lifting goal!',
      name: 'progressTabBannerTitle',
      desc: '',
      args: [],
    );
  }

  /// `DISMISS`
  String get DISMISS {
    return Intl.message(
      'DISMISS',
      name: 'DISMISS',
      desc: '',
      args: [],
    );
  }

  /// `SET NOW`
  String get SETNOW {
    return Intl.message(
      'SET NOW',
      name: 'SETNOW',
      desc: '',
      args: [],
    );
  }

  /// `Protein Goal`
  String get setProteinGoalSnackbarTitle {
    return Intl.message(
      'Protein Goal',
      name: 'setProteinGoalSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've successfully set a daily protein goal!`
  String get setProteinGoalSnackbarBody {
    return Intl.message(
      'You\'ve successfully set a daily protein goal!',
      name: 'setProteinGoalSnackbarBody',
      desc: '',
      args: [],
    );
  }

  /// `Lifting Goal`
  String get liftingGoal {
    return Intl.message(
      'Lifting Goal',
      name: 'liftingGoal',
      desc: '',
      args: [],
    );
  }

  /// `Lifting Goal`
  String get setLiftingGoalSnackbarTitle {
    return Intl.message(
      'Lifting Goal',
      name: 'setLiftingGoalSnackbarTitle',
      desc: '',
      args: [],
    );
  }

  /// `You've successfully set a daily lifting goal!`
  String get setLiftingGoalSnackbarBody {
    return Intl.message(
      'You\'ve successfully set a daily lifting goal!',
      name: 'setLiftingGoalSnackbarBody',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ko'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
