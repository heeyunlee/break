import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/models/models.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/firebase_auth_service.dart';
import 'package:workout_player/services/top_level_variables.dart';
import 'package:workout_player/view/preview/preview_model.dart';
import 'package:workout_player/view_models/add_measurements_screen_model.dart';
import 'package:workout_player/view_models/add_nutrition_screen_model.dart';
import 'package:workout_player/view_models/add_workout_to_routine_screen_model.dart';
import 'package:workout_player/view_models/add_workouts_to_routine_model.dart';
import 'package:workout_player/view_models/change_display_name_screen_model.dart';
import 'package:workout_player/view_models/choose_background_screen_model.dart';
import 'package:workout_player/view_models/choose_routine_screen_model.dart';
import 'package:workout_player/view_models/create_new_routine_model.dart';
import 'package:workout_player/view_models/customize_widgets_screen_model.dart';
import 'package:workout_player/view_models/edit_nutrition_entry_screen_model.dart';
import 'package:workout_player/view_models/edit_routine_equipment_required_model.dart';
import 'package:workout_player/view_models/edit_routine_main_muscle_group_model.dart';
import 'package:workout_player/view_models/edit_routine_screen_model.dart';
import 'package:workout_player/view_models/edit_unit_of_mass_screen_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/log_routine_screen_model.dart';
import 'package:workout_player/view_models/miniplayer_model.dart';
import 'package:workout_player/view_models/move_tab_widgets_model.dart';
import 'package:workout_player/view_models/nutritions_detail_screen_model.dart';
import 'package:workout_player/view_models/personal_goals_screen_model.dart';
import 'package:workout_player/view_models/progress_tab_model.dart';
import 'package:workout_player/view_models/reorder_routine_workouts_screen_model.dart';
import 'package:workout_player/view_models/routine_detail_screen_model.dart';
import 'package:workout_player/view_models/routine_workout_card_model.dart';
import 'package:workout_player/view_models/settings_tab_model.dart';
import 'package:workout_player/view_models/sign_in_screen_model.dart';
import 'package:workout_player/view_models/sign_in_with_email_screen_model.dart';
import 'package:workout_player/view_models/weekly_calories_chart_model.dart';
import 'package:workout_player/view_models/workout_set_rest_widget_model.dart';
import 'package:workout_player/view_models/workout_set_widget_model.dart';
import 'package:workout_player/view_models/workout_summary_screen_model.dart';

/// Provider for [FirebaseAuthService] that interacts with [FirebaseAuth] and
/// handles social/email sign in/out.
final firebaseAuthProvider = Provider<FirebaseAuthService>(
  (ref) => FirebaseAuthService(),
);

/// Provider for [Database] that uses [FirebaseFirestore] to interact with Firebase
/// Cloud Firestore
final databaseProvider = Provider<Database>(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final uid = auth.currentUser?.uid;

    return Database(uid: uid);
  },
);

/// Provider for [TopLevelVariables]
final topLevelVariablesProvider = Provider<TopLevelVariables>(
  (ref) => TopLevelVariables(),
);

/// Provider for [AddWorkoutToRoutineScreenModel]
final addWorkoutToRoutineScreenModelProvider =
    ChangeNotifierProvider.autoDispose((ref) {
  final database = ref.watch(databaseProvider);

  return AddWorkoutToRoutineScreenModel(database: database);
});

/// Provider for [AddWorkoutsToRoutineScreenModel]
final addWorkoutsToRoutineScreenModelProvider =
    ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return AddWorkoutsToRoutineScreenModel(database: database);
  },
);

/// Provider for [ChangeDisplayNameScreenModel]
final changeDisplayNameScreenModelProvider = ChangeNotifierProvider.autoDispose
    .family<ChangeDisplayNameScreenModel, User>(
  (ref, user) {
    final database = ref.watch(databaseProvider);

    return ChangeDisplayNameScreenModel(user: user, database: database);
  },
);

/// Provider for [ChooseBackgroundScreenModel]
final chooseBackgroundScreenModelModel = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return ChooseBackgroundScreenModel(database: database);
  },
);

/// Provider for [CreateNewRoutineModel]
final createNewROutineModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return CreateNewRoutineModel(database: database);
  },
);

/// Provider for [CustomizeWidgetsScreenModel]
final customizeWidgetsScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return CustomizeWidgetsScreenModel(database: database);
  },
);

/// Provider for [EditNutritionModel]
final editNutritionModelProvider =
    ChangeNotifierProvider.autoDispose.family<EditNutritionModel, Nutrition>(
  (ref, nutrition) {
    final database = ref.watch(databaseProvider);

    return EditNutritionModel(
      nutrition: nutrition,
      database: database,
    );
  },
);

/// Provider for [EditRoutineScreenModel]
final editRoutineScreenModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return EditRoutineScreenModel(database: database);
  },
);

/// Provider for [EditUnitOfMassModel]
final editUnitOfMassModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return EditUnitOfMassModel(database: database);
  },
);

/// Provider for [HomeScreenModel]
final homeScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return HomeScreenModel(database: database);
  },
);

/// Provider for [MiniplayerModel]
final miniplayerModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return MiniplayerModel(database: database);
  },
);

/// Provider for [MoveTabWidgetsModel]
final progressTabWidgetsModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);
    final topLevelVars = ref.watch(topLevelVariablesProvider);

    return MoveTabWidgetsModel(
      database: database,
      topLevelVariables: topLevelVars,
    );
  },
);

/// Provider for [PersonalGoalsScreenModel]
final personalGoalsScreenModelProvider =
    ChangeNotifierProvider.autoDispose.family<PersonalGoalsScreenModel, User>(
  (ref, data) {
    final database = ref.watch(databaseProvider);

    return PersonalGoalsScreenModel(
      user: data,
      database: database,
    );
  },
);

/// Provider for [ProgressTabModel]
final progressTabModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return ProgressTabModel(database: database);
  },
);

/// Provider for [ReorderRoutineWorkoutsScreenModel]
final reorderRoutineWorkoutsScreenModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return ReorderRoutineWorkoutsScreenModel(database: database);
  },
);

/// Provider for [RoutineDetailScreenModel]
final routineDetailScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return RoutineDetailScreenModel(database: database);
  },
);

/// Provider for [RoutineWorkoutCardModel]
final routineWorkoutCardModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return RoutineWorkoutCardModel(database: database);
  },
);

/// Provider for [SettingsTabModel]
final settingsTabModelProvider = ChangeNotifierProvider(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final database = ref.watch(databaseProvider);

    return SettingsTabModel(database: database, auth: auth);
  },
);

/// Provider for [SignInScreenModel]
final signInScreenProvider = ChangeNotifierProvider(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final database = ref.watch(databaseProvider);

    return SignInScreenModel(auth: auth, database: database);
  },
);

/// Provider for [SignInWithEmailModel]
final signInWithEmailModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final database = ref.watch(databaseProvider);

    return SignInWithEmailModel(auth: auth, database: database);
  },
);

/// Provider for [WorkoutSetRestWidgetModel]
final workoutSetRestWidgetModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return WorkoutSetRestWidgetModel(database: database);
  },
);

/// Provider for [WorkoutSummaryScreenModel]
final workoutSummaryScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return WorkoutSummaryScreenModel(database: database);
  },
);

/// Provider for [AddMeasurementsScreenModel]
final addMeasurementsScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);
    return AddMeasurementsScreenModel(database: database);
  },
);

/// Provider for [AddMeasurementsScreenModel]
final addNutritionScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final auth = ref.watch(firebaseAuthProvider);
    final database = ref.watch(databaseProvider);

    return AddNutritionScreenModel(auth: auth, database: database);
  },
);

/// Provider for [WorkoutSetWidgetModel]
final workoutSetWidgetModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);
    return WorkoutSetWidgetModel(database: database);
  },
);

/// Provider for [ChooseRoutineScreenModel]
final chooseRoutineScreenModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return ChooseRoutineScreenModel(database: database);
  },
);

/// Provider for [EditRoutineEquipmentRequiredModel]
final editRoutineEquipmentRequiredModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);
    return EditRoutineEquipmentRequiredModel(database: database);
  },
);

/// Provider for [EditRoutineMainMuscleGroupModel]
final editRoutineMainMuscleGroupModel = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);
    return EditRoutineMainMuscleGroupModel(database: database);
  },
);

/// Provider for [NutritionsDetailScreenModel]
final nutritionsDetailScreenModelProvider = ChangeNotifierProvider(
  (ref) {
    final database = ref.watch(databaseProvider);

    return NutritionsDetailScreenModel(database: database);
  },
);

/// Provider for [LogRoutineModel]
final logRoutineModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final database = ref.watch(databaseProvider);

    return LogRoutineModel(database: database);
  },
);

final previewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PreviewModel(),
);

final weeklyCaloriesChartModelProvider = ChangeNotifierProvider.autoDispose
    .family<WeeklyCaloriesChartModel, EatsTabClass>(
  (ref, data) {
    final topLevelVariables = ref.watch(topLevelVariablesProvider);

    return WeeklyCaloriesChartModel(
      nutritions: data.thisWeeksNutritions,
      user: data.user,
      topLevelVariables: topLevelVariables,
    );
  },
);
