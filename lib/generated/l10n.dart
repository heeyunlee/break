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
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();
  
  static S current;
  
  static const AppLocalizationDelegate delegate =
    AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name); 
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();
      
      return S.current;
    });
  } 

  static S of(BuildContext context) {
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

  /// `GET STARTED`
  String get getStarted {
    return Intl.message(
      'GET STARTED',
      name: 'getStarted',
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

  /// `Login with Kakao`
  String get continueWithKakao {
    return Intl.message(
      'Login with Kakao',
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

  /// `Edit Username`
  String get editUserNameTitle {
    return Intl.message(
      'Edit Username',
      name: 'editUserNameTitle',
      desc: '',
      args: [],
    );
  }

  /// `Your username`
  String get yourUsername {
    return Intl.message(
      'Your username',
      name: 'yourUsername',
      desc: '',
      args: [],
    );
  }

  /// `Username is Empty`
  String get usernameEmptyTitle {
    return Intl.message(
      'Username is Empty',
      name: 'usernameEmptyTitle',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty. Please add something`
  String get usernameEmptyContent {
    return Intl.message(
      'Username cannot be empty. Please add something',
      name: 'usernameEmptyContent',
      desc: '',
      args: [],
    );
  }

  /// `"Player H"`
  String get usernameHintText {
    return Intl.message(
      '"Player H"',
      name: 'usernameHintText',
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

  /// `Please tell us what we could do to improve this app and {username} workout experience.`
  String feedbackHintText(Object username) {
    return Intl.message(
      'Please tell us what we could do to improve this app and $username workout experience.',
      name: 'feedbackHintText',
      desc: '',
      args: [username],
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

  /// `PLAYER H`
  String get applicationName {
    return Intl.message(
      'PLAYER H',
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

  /// `Are you sure you want to logout?`
  String get confirmSignOutContext {
    return Intl.message(
      'Are you sure you want to logout?',
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

  /// `sets`
  String get sets {
    return Intl.message(
      'sets',
      name: 'sets',
      desc: '',
      args: [],
    );
  }

  /// `set`
  String get set {
    return Intl.message(
      'set',
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
  String get deleteBottomSheetButtonText {
    return Intl.message(
      'Delete History',
      name: 'deleteBottomSheetButtonText',
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
  String get deleteRoutineWorkoutSnakbar {
    return Intl.message(
      'Deleted a Workout!',
      name: 'deleteRoutineWorkoutSnakbar',
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

  /// `Chest Routine`
  String get routineTitleHintText {
    return Intl.message(
      'Chest Routine',
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
  String get deleteRoutineButtonText {
    return Intl.message(
      'Delete Routine',
      name: 'deleteRoutineButtonText',
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
  String get addWorkoutButtonText {
    return Intl.message(
      'Add workout',
      name: 'addWorkoutButtonText',
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
  String get savedWorkoutEmptyButtonText {
    return Intl.message(
      'Create your own Workout now!',
      name: 'savedWorkoutEmptyButtonText',
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

  /// `Add workout to the routine`
  String get addWorkoutToRoutineButtonText {
    return Intl.message(
      'Add workout to the routine',
      name: 'addWorkoutToRoutineButtonText',
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
  String get deleteWorkoutButtonText {
    return Intl.message(
      'Delete Workout',
      name: 'deleteWorkoutButtonText',
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
  String get addProteinButtonText {
    return Intl.message(
      'Add Protein',
      name: 'addProteinButtonText',
      desc: '',
      args: [],
    );
  }

  /// `Start Workout`
  String get startWorkoutButtonText {
    return Intl.message(
      'Start Workout',
      name: 'startWorkoutButtonText',
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
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}