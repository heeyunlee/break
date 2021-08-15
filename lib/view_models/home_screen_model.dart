import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart' as provider;
// import 'package:workout_player/models/custom_health_data_point.dart';
// import 'package:workout_player/models/steps.dart';
// import 'package:workout_player/models/user.dart';

import 'package:workout_player/generated/l10n.dart';
import 'main_model.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/view/widgets/get_snackbar_widget.dart';
import 'package:workout_player/view/widgets/navigation_tab/tab_item.dart';
import 'package:workout_player/view/widgets/show_exception_alert_dialog.dart';

double percentageFromValueInRange({required final double min, max, value}) {
  return (value - min) / (max - min);
}

final homeScreenModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => HomeScreenModel(),
);

class HomeScreenModel with ChangeNotifier {
  AuthBase? auth;
  Database? database;

  HomeScreenModel({
    this.auth,
    this.database,
  });

  TabItem _currentTab = TabItem.progress;
  int _currentTabIndex = 0;
  final Map<TabItem, GlobalKey<NavigatorState>> _tabNavigatorKeys = {
    TabItem.library: GlobalKey<NavigatorState>(),
    TabItem.search: GlobalKey<NavigatorState>(),
    TabItem.progress: GlobalKey<NavigatorState>(),
    TabItem.settings: GlobalKey<NavigatorState>(),
  };

  // Home Screen Navigator Key
  final GlobalKey<NavigatorState> homeScreenNavigatorKey =
      GlobalKey<NavigatorState>();

  // Miniplayer navigator key
  final GlobalKey<NavigatorState> miniplayerNavigatorKey =
      GlobalKey<NavigatorState>();

  TabItem get currentTab => _currentTab;
  int get currentTabIndex => _currentTabIndex;
  Map<TabItem, GlobalKey<NavigatorState>> get tabNavigatorKeys =>
      _tabNavigatorKeys;

  Future<bool> onWillPopMiniplayer() async {
    final state = miniplayerNavigatorKey.currentState!;

    if (!state.canPop()) return true;
    state.pop();

    return false;
  }

  Future<bool> onWillPopHomeScreen() async {
    final state = tabNavigatorKeys[_currentTab]!.currentState!.maybePop();

    final shouldPop = await state;

    return shouldPop;
  }

  void onSelectTab(int index) {
    _currentTabIndex = index;
    final tabItem = TabItem.values[index];

    if (tabItem == currentTab) {
      tabNavigatorKeys[tabItem]!
          .currentState!
          .popUntil((route) => route.isFirst);
    } else {
      _currentTab = tabItem;
    }

    notifyListeners();
  }

  Future<void> updateUser(BuildContext context) async {
    logger.d('HomeScreenModel updateUser() function called');

    database = provider.Provider.of<Database>(context, listen: false);
    auth = provider.Provider.of<AuthBase>(context, listen: false);

    // final user = await database!.getUserDocument(auth!.currentUser!.uid);
    final now = Timestamp.now();

    try {
      final userData = {
        'lastAppOpenedTime': now,
      };

      await database!.updateUser(auth!.currentUser!.uid, userData);

      // await fetchData(user!, context);

      // final now2 = Timestamp.now().toDate();
      // final diff = now.toDate().difference(now2);
      // print('execution time is $diff');
    } on FirebaseException catch (e) {
      logger.e(e.message);

      _showErrorDialog(e, context);
    }
  }

  // Future<void> fetchData(User user, BuildContext context) async {
  //   logger.d('fetching health data function called');

  //   // final database = provider.Provider.of<Database>(context, listen: false);
  //   // final auth = provider.Provider.of<AuthBase>(context, listen: false);
  //   final uid = auth!.currentUser!.uid;

  //   HealthFactory health = HealthFactory();

  //   /// Define the types to get.
  //   /// For now, we'll only fetch steps data
  //   List<HealthDataType> types = [
  //     // HealthDataType.WEIGHT,
  //     // HealthDataType.BODY_FAT_PERCENTAGE,
  //     // HealthDataType.BODY_MASS_INDEX,
  //     // HealthDataType.ACTIVE_ENERGY_BURNED,
  //     // HealthDataType.BASAL_ENERGY_BURNED,
  //     // HealthDataType.DISTANCE_WALKING_RUNNING,
  //     HealthDataType.STEPS,
  //     // HealthDataType.MOVE_MINUTES,
  //     // HealthDataType.DISTANCE_DELTA,
  //   ];

  //   /// You MUST request access to the data types before reading them
  //   bool accessWasGranted = await health.requestAuthorization(types);

  //   if (accessWasGranted) {
  //     try {
  //       // Get steps data that are already on firestores
  //       final stepsDataFromFirestore = await database!.getSteps(uid);

  //       final endDate = DateTime.now();
  //       final startDate = stepsDataFromFirestore?.lastUpdateTime.toDate() ??
  //           endDate.subtract(Duration(days: 7));
  //       print('startdate is $startDate');

  //       /// Fetch new data
  //       List<HealthDataPoint> rawHealthData =
  //           await health.getHealthDataFromTypes(startDate, endDate, types);

  //       /// Clean Data
  //       rawHealthData = HealthFactory.removeDuplicates(rawHealthData);

  //       logger.d('fecthed health data length: ${rawHealthData.length}');

  //       if (rawHealthData.isNotEmpty) {
  //         /// Group data by HealthDataType
  //         final Map<HealthDataType, List<HealthDataPoint>> groupedMap =
  //             rawHealthData.groupListsBy<HealthDataType>(
  //           (element) => element.type,
  //         );

  //         /// Convert fetched data to custom CustomHealthDataPoint data
  //         /// so that we can convert and write to firestore
  //         final stepsData = groupedMap[HealthDataType.STEPS]
  //             ?.map((point) => CustomHealthDataPoint.fromRawData(point))
  //             .toList();

  //         if (stepsData != null) {
  //           if (stepsData.isNotEmpty) {
  //             print('steps data length is: ${stepsData.length}');

  //             if (stepsDataFromFirestore != null) {
  //               final stepsDataAsMap =
  //                   stepsData.map((e) => e.toJson()).toList();
  //               final updatedStepsData = {
  //                 'healthDataPoints': FieldValue.arrayUnion(stepsDataAsMap),
  //                 'lastUpdateTime': Timestamp.now(),
  //               };

  //               await database!.updateSteps(uid, updatedStepsData);

  //               print('updated');
  //             } else {
  //               final step = Steps(
  //                 healthDataPoints: stepsData,
  //                 lastUpdateTime: Timestamp.now(),
  //                 ownerId: user.userId,
  //               );

  //               await database!.setSetps(step);
  //               print('created');
  //             }
  //           } else {
  //             print('stepsData is empty');
  //           }
  //         } else {
  //           print('stepsData is null');
  //         }
  //       } else {
  //         print('rawHealthData is empty');
  //       }
  //     } on FirebaseException catch (e) {
  //       _showErrorDialog(e, context);
  //     }
  //   } else {
  //     logger.d('Authorization not granted');
  //   }
  // }

  void _showErrorDialog(FirebaseException exception, BuildContext context) {
    logger.e(exception);

    showExceptionAlertDialog(
      context,
      title: S.current.errorOccuredMessage,
      exception: exception.message ?? S.current.errorOccuredMessage,
    );
  }

  void popUntilRoot(BuildContext context) {
    final currentState = tabNavigatorKeys[_currentTab]!.currentState;

    Navigator.of(context).popUntil((route) => route.isFirst);
    currentState?.popUntil((route) => route.isFirst);
  }

  Future<void> showPermission() async {
    final request = Permission.activityRecognition.request();

    if (await request.isDenied || await request.isPermanentlyDenied) {
      getSnackbarWidget(
        'title',
        'Permission is needed',
      );
    }
  }
}
