import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:workout_player/models/measurement.dart';

import 'package:workout_player/models/user.dart';
import 'package:workout_player/screens/home/progress_tab/widgets/blurred_background.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/services/api_path.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';
import 'package:workout_player/widgets/blur_background_card.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';
import 'package:workout_player/widgets/get_snackbar_widget.dart';
import 'package:workout_player/widgets/shimmer/progress_tab_shimmer.dart';

import '../../../styles/constants.dart';
import 'daily_progress_summary/daily_nutrition_widget.dart';
import 'daily_progress_summary/daily_weights_widget.dart';
import 'measurement/measurements_line_chart_widget.dart';
import 'progress_tab_model.dart';
import 'proteins_eaten/weekly_nutrition_chart.dart';
import 'weights_lifted_history/weights_lifted_chart_widget.dart';
import 'widgets/blurred_material_banner.dart';
import 'widgets/choose_background_icon.dart';
import 'widgets/choose_date_icon_button.dart';

class ProgressTab extends StatefulWidget {
  final ProgressTabModel model;

  const ProgressTab({
    Key? key,
    required this.model,
  }) : super(key: key);

  static Widget create(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) => ProgressTab(
        model: ref.watch(progressTabModelProvider),
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
    widget.model.init(this);
    widget.model.initShowBanner();
  }

  @override
  void dispose() {
    widget.model.animationController.dispose();
    super.dispose();
  }

  List<HealthDataPoint> _healthDataList = [];

  Future<void> _showPermission() async {
    final request = Permission.activityRecognition.request();

    if (await request.isDenied || await request.isPermanentlyDenied) {
      getSnackbarWidget(
        'title',
        'Permission is needed',
      );
    }
  }

  Future fetchData(User user) async {
    DateTime now = DateTime.now();
    DateTime startDate =
        user.lastHealthDataFetchedTime ?? now.subtract(Duration(days: 7));

    HealthFactory health = HealthFactory();

    /// Define the types to get.
    List<HealthDataType> types = [
      HealthDataType.WEIGHT,
      HealthDataType.BODY_FAT_PERCENTAGE,
      HealthDataType.BODY_MASS_INDEX,
    ];

    /// You MUST request access to the data types before reading them
    bool accessWasGranted = await health.requestAuthorization(types);

    if (accessWasGranted) {
      try {
        /// Fetch new data
        List<HealthDataPoint> rawHealthData =
            await health.getHealthDataFromTypes(
          startDate,
          now,
          types,
        );

        if (rawHealthData.isNotEmpty) {
          print('raw data length is ${rawHealthData.length}');

          final id = 'MS${Uuid().v1()}';

          // final batch = FirebaseFirestore.instance.batch();
          Measurement measurement = Measurement(
            measurementId: id,
            userId: widget.model.auth!.currentUser!.uid,
            username: user.displayName,
            loggedTime: Timestamp.fromDate(now),
            loggedDate: DateTime.utc(now.year, now.month, now.day),
          );

          rawHealthData.forEach((element) async {
            print('data is ${element.toJson()}');

            if (element.type == HealthDataType.WEIGHT) {
              measurement = measurement.copyWith(
                bodyWeight: (user.unitOfMass == 0)
                    ? element.value
                    : element.value * 2.20462,
                dataSource: 'appleHealthKitApi',
                dataType: element.typeString,
                platformType: element.platform.toString(),
                sourceId: element.sourceId,
                sourceName: element.sourceName,
              );
              // final measurement = Measurement(
              //   measurementId: id,
              //   userId: widget.model.auth!.currentUser!.uid,
              //   username: user.displayName,
              //   loggedTime: Timestamp.fromDate(element.dateFrom),
              //   loggedDate: DateTime.utc(
              //     element.dateFrom.year,
              //     element.dateFrom.month,
              //     element.dateFrom.day,
              //   ),
              //   bodyWeight: element.value,
              //   dataSource: 'appleHealthKitApi',
              //   dataType: element.typeString,
              //   platformType: element.platform.toString(),
              //   sourceId: element.sourceId,
              //   sourceName: element.sourceName,
              // );

              // final userData = {
              //   'lastHealthDataFetchedTime': now,
              // };

              // final path = APIPath.measurement(
              //   widget.model.auth!.currentUser!.uid,
              //   id,
              // );

              // final doc = FirebaseFirestore.instance.doc(path);

              // batch.set(
              //   doc,
              //   measurement,
              // );

              // await widget.model.database!
              //     .setMeasurement(measurement: measurement);
            } else if (element.type == HealthDataType.BODY_MASS_INDEX) {
              measurement = measurement.copyWith(
                bmi: element.value,
                dataSource: 'appleHealthKitApi',
                dataType: element.typeString,
                platformType: element.platform.toString(),
                sourceId: element.sourceId,
                sourceName: element.sourceName,
              );
            } else if (element.type == HealthDataType.BODY_FAT_PERCENTAGE) {
              measurement = measurement.copyWith(
                bodyFat: element.value,
                dataSource: 'appleHealthKitApi',
                dataType: element.typeString,
                platformType: element.platform.toString(),
                sourceId: element.sourceId,
                sourceName: element.sourceName,
              );
            }

            await widget.model.database!.setMeasurement(
              measurement: measurement,
            );
          });

          // await batch.commit();

          /// Save all the new data points
          // _healthDataList.addAll(healthData);
          print('measurement data at the end is ${measurement.toJson()}');
        }
      } catch (e) {
        print('Caught exception in getHealthDataFromTypes: $e');
      }

      /// Filter out duplicates
      _healthDataList = HealthFactory.removeDuplicates(_healthDataList);
    } else {
      await _showPermission();
      logger.d('Authorization not granted');
    }
  }

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
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: AppBar(
                centerTitle: true,
                brightness: Brightness.dark,
                elevation: 0,
                leading: ChooseBackgroundIcon(user: user!),
                title: ChooseDateIconButton(model: widget.model),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      onPressed: () {
                        fetchData(user);
                        // print('${_healthDataList.length}');
                        // print('${_healthDataList.first}');
                        // print('${_healthDataList.last}');
                      },
                      icon: Icon(
                        Icons.get_app,
                      ))
                ],
              ),
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
    final size = MediaQuery.of(context).size;

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
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (widget.model.showBanner)
                    BlurredMaterialBanner(model: widget.model),
                  SizedBox(
                    height: widget.model.showBanner
                        ? size.height * 0.5 - 136
                        : size.height * 0.5,
                  ),
                  Stack(
                    children: [
                      DailyWeightsWidget.create(
                        context,
                        user: user,
                        model: widget.model,
                      ),
                      DailyNutritionWidget.create(
                        user: user,
                        model: widget.model,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      CustomStreamBuilderWidget<List<Measurement>>(
                        stream: widget.model.database!.measurementsStream(),
                        hasDataWidget: (context, list) {
                          final lastMeasurement = list.last;
                          final date = DateFormat.MMMEd()
                              .format(lastMeasurement.loggedDate);
                          final weight = Formatter.weights(
                              lastMeasurement.bodyWeight ?? 0);
                          final unit = Formatter.unitOfMass(user.unitOfMass);

                          return BlurBackgroundCard(
                            width: size.width / 2 - 24,
                            height: 104,
                            borderRadius: 8,
                            child: Stack(
                              children: [
                                // Container(
                                //   color: Colors.blue,
                                //   width: (size.width / 2 - 24) * 0.8,
                                //   height: double.maxFinite,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        date,
                                        style: TextStyles.overline,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '$weight $unit',
                                        style: TextStyles.headline5_menlo,
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '-2.2kg',
                                        style: TextStyles.caption1_grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      BlurBackgroundCard(
                        width: size.width / 2 - 24,
                        height: 104,
                        child: Text('asdas'),
                      ),
                    ],
                  ),
                  WeightsLiftedChartWidget.create(context, user: user),
                  WeeklyNutritionChart.create(context, user: user),
                  MeasurementsLineChartWidget(user: user),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
