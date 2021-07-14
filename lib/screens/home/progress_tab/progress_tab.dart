// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart' as provider;
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/models/auth_and_database.dart';
// import 'package:health/health.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:uuid/uuid.dart';
// import 'package:workout_player/models/measurement.dart';

import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/blurred_background.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
// import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../../styles/constants.dart';
import 'progress_tab_model.dart';
import 'widgets/blurred_material_banner.dart';
import 'widgets/choose_background_button.dart';
import 'widgets/choose_date_icon_button.dart';
import 'widgets/daily_activity_ring_widget/daily_activty_ring_widget.dart';
import 'widgets/measurement/weekly_measurements_card.dart';
import 'widgets/nutritions_chart/weekly_nutrition_card.dart';
import 'widgets/recent_body_fat_percentage_widget.dart';
import 'widgets/latest_weight_widget/latest_weight_widget.dart';
import 'widgets/weekly_weights_lifted_chart/weights_lifted_chart_widget.dart';
import 'widgets/weekly_workout_summary/weekly_workout_summary.dart';

class ProgressTab extends StatefulWidget {
  final ProgressTabModel model;
  // final AuthBase auth;
  final AuthAndDatabase authAndDatabase;

  const ProgressTab({
    Key? key,
    required this.model,
    // required this.auth,
    required this.authAndDatabase,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    final auth = provider.Provider.of<AuthBase>(context, listen: false);
    final database = provider.Provider.of<Database>(context, listen: false);

    return Consumer(
      builder: (context, ref, child) => ProgressTab(
        model: ref.watch(progressTabModelProvider),
        authAndDatabase: AuthAndDatabase(auth: auth, database: database),
      ),
    );
  }

  @override
  _ProgressTabState createState() => _ProgressTabState();
}

class _ProgressTabState extends State<ProgressTab>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.model.init(this, widget.authAndDatabase);
    widget.model.initShowBanner();
  }

  @override
  void dispose() {
    widget.model.animationController.dispose();
    super.dispose();
  }

  // List<HealthDataPoint> _healthDataList = [];

  // Future<void> _showPermission() async {
  //   final request = Permission.activityRecognition.request();

  //   if (await request.isDenied || await request.isPermanentlyDenied) {
  //     getSnackbarWidget(
  //       'title',
  //       'Permission is needed',
  //     );
  //   }
  // }

  // Future<void> _fetchData(User user) async {
  //   DateTime now = DateTime.now();
  //   DateTime startDate =
  //       user.lastHealthDataFetchedTime ?? now.subtract(Duration(days: 7));

  //   HealthFactory health = HealthFactory();

  //   /// Define the types to get.
  //   List<HealthDataType> types = [
  //     HealthDataType.WEIGHT,
  //     HealthDataType.BODY_FAT_PERCENTAGE,
  //     HealthDataType.BODY_MASS_INDEX,
  //     HealthDataType.ACTIVE_ENERGY_BURNED,
  //     HealthDataType.DISTANCE_WALKING_RUNNING,
  //     HealthDataType.STEPS,
  //   ];

  //   /// You MUST request access to the data types before reading them
  //   bool accessWasGranted = await health.requestAuthorization(types);

  //   if (accessWasGranted) {
  //     try {
  //       /// Fetch new data
  //       List<HealthDataPoint> rawHealthData =
  //           await health.getHealthDataFromTypes(
  //         startDate,
  //         now,
  //         types,
  //       );

  //       if (rawHealthData.isNotEmpty) {
  //         print('raw data length is ${rawHealthData.length}');

  //         final id = 'MS${Uuid().v1()}';

  //         Measurement _measurement = Measurement(
  //           measurementId: id,
  //           userId: widget.auth.currentUser!.uid,
  //           username: user.displayName,
  //           loggedTime: Timestamp.fromDate(now),
  //           loggedDate: DateTime.utc(now.year, now.month, now.day),
  //         );

  //         rawHealthData.forEach((element) async {
  //           print('data is ${element.toJson()}');

  //           if (element.type == HealthDataType.WEIGHT) {
  //             _measurement = _measurement.copyWith(
  //               bodyWeight: (user.unitOfMass == 0)
  //                   ? element.value
  //                   : element.value * 2.20462,
  //               dataSource: 'appleHealthKitApi',
  //               dataType: element.typeString,
  //               platformType: element.platform.toString(),
  //               sourceId: element.sourceId,
  //               sourceName: element.sourceName,
  //             );
  //           } else if (element.type == HealthDataType.BODY_MASS_INDEX) {
  //             _measurement = _measurement.copyWith(
  //               bmi: element.value,
  //               dataSource: 'appleHealthKitApi',
  //               dataType: element.typeString,
  //               platformType: element.platform.toString(),
  //               sourceId: element.sourceId,
  //               sourceName: element.sourceName,
  //             );
  //           } else if (element.type == HealthDataType.BODY_FAT_PERCENTAGE) {
  //             _measurement = _measurement.copyWith(
  //               bodyFat: element.value,
  //               dataSource: 'appleHealthKitApi',
  //               dataType: element.typeString,
  //               platformType: element.platform.toString(),
  //               sourceId: element.sourceId,
  //               sourceName: element.sourceName,
  //             );
  //           }

  //           await widget.model.database!.setMeasurement(
  //             measurement: _measurement,
  //           );

  //           final userData = {
  //             'lastHealthDataFetchedTime': now,
  //           };

  //           await widget.model.database!.updateUser(
  //             // widget.model.auth!.currentUser!.uid,
  //             widget.auth.currentUser!.uid,
  //             userData,
  //           );
  //         });

  //         // await batch.commit();

  //         /// Save all the new data points
  //         // _healthDataList.addAll(healthData);
  //         print('measurement data at the end is ${_measurement.toJson()}');
  //       } else {
  //         debugPrint('health data do NOT exist');
  //       }
  //     } catch (e) {
  //       print('Caught exception in getHealthDataFromTypes: $e');
  //     }

  //     /// Filter out duplicates
  //     _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
  //   } else {
  //     // await _showPermission();
  //     logger.d('Authorization not granted');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    logger.d('Progress Tab Scaffold building...');

    return CustomStreamBuilderWidget<User?>(
      stream: widget.model.database!.userStream(),
      loadingWidget: ProgressTabShimmer(),
      hasDataWidget: (context, user) {
        return NotificationListener<ScrollNotification>(
          onNotification: widget.model.onNotification,
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              centerTitle: true,
              brightness: Brightness.dark,
              elevation: 0,
              leading: ChooseBackgroundButton(user: user!),
              title: ChooseDateIconButton(model: widget.model),
              backgroundColor: Colors.transparent,
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.dashboard_customize_rounded),
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: Builder(
              builder: (context) => _buildChildWidget(context, user),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChildWidget(BuildContext context, User user) {
    final appBarHeight = Scaffold.of(context).appBarMaxHeight!;
    final bottomNavBarHeight = Platform.isAndroid ? 56 : 90;
    final size = MediaQuery.of(context).size;
    final gridWidth = size.width - 32;
    final gridHeight = size.height - appBarHeight - bottomNavBarHeight;

    return Stack(
      children: [
        BlurredBackground(
          model: widget.model,
          imageIndex: user.backgroundImageIndex,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0, -1.00),
              end: Alignment(0, -0.75),
              colors: [
                Colors.black.withOpacity(0.500),
                Colors.transparent,
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            top: Scaffold.of(context).appBarMaxHeight!,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  if (widget.model.showBanner)
                    BlurredMaterialBanner(model: widget.model),
                  SizedBox(
                    height: (widget.model.showBanner)
                        ? gridHeight / 2 - 136
                        : gridHeight / 2,
                  ),
                  SizedBox(
                    height: gridHeight / 4,
                    child: DailyActivityRingWidget(
                      auth: widget.authAndDatabase.auth,
                      database: widget.authAndDatabase.database,
                      user: user,
                      model: widget.model,
                    ),
                  ),
                  SizedBox(
                    height: gridHeight / 4,
                    child: Row(
                      children: [
                        SizedBox(
                          width: gridWidth / 2 - 8,
                          child: RecentWeightWidget(
                            model: widget.model,
                            user: user,
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: gridWidth / 2 - 8,
                          child: RecentBodyFatPercentageWidget(
                            model: widget.model,
                            user: user,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: gridHeight / 4,
                    child: WeeklyWorkoutWidget.create(
                      AuthAndDatabase(
                        auth: widget.authAndDatabase.auth,
                        database: widget.authAndDatabase.database,
                      ),
                      user,
                    ),
                  ),
                  SizedBox(
                    height: gridHeight / 2,
                    child: WeightsLiftedChartWidget.create(
                      context,
                      user: user,
                    ),
                  ),
                  SizedBox(
                    height: gridHeight / 2,
                    child: WeeklyNutritionCard(
                      auth: widget.authAndDatabase.auth,
                      database: widget.authAndDatabase.database,
                      user: user,
                    ),
                  ),
                  SizedBox(
                    height: gridHeight / 2,
                    child: WeeklyMeasurementsCard(
                      database: widget.authAndDatabase.database,
                      user: user,
                    ),
                  ),
                  SizedBox(
                    height: gridHeight / 4,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/svgs/herakles_icon.svg',
                            width: 32,
                          ),
                          const SizedBox(height: 24),
                          Text('Herakles', style: TextStyles.body1_menlo),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 90),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
