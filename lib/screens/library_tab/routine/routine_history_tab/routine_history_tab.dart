import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/models/routine_history.dart';
import 'package:workout_player/services/auth.dart';
import 'package:workout_player/services/database.dart';
import 'package:workout_player/services/main_provider.dart';
import 'package:workout_player/widgets/custom_stream_builder_widget.dart';

class RoutineHistoryTab extends StatelessWidget {
  final Routine routine;
  final AuthBase auth;
  final Database database;

  const RoutineHistoryTab({
    Key? key,
    required this.routine,
    required this.auth,
    required this.database,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('build routine histories Tab');

    return CustomStreamBuilderWidget<List<RoutineHistory?>>(
      stream: database.routineHistoriesThisWeekStream2(
        auth.currentUser!.uid,
        routine.routineId,
      ),
      hasDataWidget: (context, snapshot) {
        print('data is ${snapshot.data}');

        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: AspectRatio(
            aspectRatio: 1.5,
            child: BarChart(
              BarChartData(
                maxY: 100,
                minY: 0,
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(
                  enabled: false,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) =>
                        const TextStyle(color: Color(0xff939393), fontSize: 10),
                    margin: 10,
                    getTitles: (double value) {
                      switch (value.toInt()) {
                        case 0:
                          return 'Apr';
                        case 1:
                          return 'May';
                        case 2:
                          return 'Jun';
                        case 3:
                          return 'Jul';
                        case 4:
                          return 'Aug';
                        default:
                          return '';
                      }
                    },
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    getTextStyles: (value) => const TextStyle(
                        color: Color(
                          0xff939393,
                        ),
                        fontSize: 10),
                    margin: 0,
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  checkToShowHorizontalLine: (value) => value % 10 == 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xffe7e8ec),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(y: 2000, rodStackItems: [
                        BarChartRodStackItem(0, 2000000000, Colors.black12),
                      ]),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
