import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/screens/calories_entries_screen.dart';
import 'package:workout_player/view/screens/more_nutritions_entries_screen.dart';
import 'package:workout_player/view/widgets/charts/weekly_bar_chart.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/weekly_calories_chart_model.dart';

class EatsTabBodyWidget extends ConsumerWidget {
  const EatsTabBodyWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return CustomStreamBuilder<EatsTabClass>(
      stream: ref.read(databaseProvider).eatsTabStream(),
      builder: (context, data) {
        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: size.height * 3 / 4,
              flexibleSpace: EatsTabFlexibleSpaceBar(data: data),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  WeeklyBarChartCard(
                    cardHeight: size.height / 3,
                    cardWidth: size.width,
                    titleOnTap: () => CaloriesEntriesScreen.show(
                      context,
                      user: data.user,
                    ),
                    titleIcon: Icons.local_fire_department_outlined,
                    defaultColor: Colors.greenAccent,
                    touchedColor: Colors.green,
                    title: S.current.consumedCalorie,
                    chart: Consumer(
                      builder: (context, ref, child) {
                        final model = ref.watch(
                          weeklyCaloriesChartModelProvider(data),
                        );
                        return WeeklyBarChart(
                          nutritions: data.thisWeeksNutritions,
                          maxY: model.getMaxY(),
                          defaultColor: Colors.greenAccent,
                          touchedColor: Colors.green,
                          getBarTooltipText: model.getTooltipText,
                          onTouchCallback: model.onTouchCallback,
                          getDaysOfTheWeek: model.getDaysOfTheWeek,
                          listOfYs: model.listOfYs(),
                          touchedIndex: model.touchedIndex,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const SizedBox(width: 28),
                      Text(
                        S.current.recentTransactions,
                        style: TextStyles.body1W800,
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => MoreNutritionsEntriesScreen.show(context),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            S.current.seeMore,
                            style: TextStyles.button1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.all(16),
                    child: data.recentNutritions.isEmpty
                        ? EmptyContent(message: S.current.addNutritions)
                        : ListView.separated(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) =>
                                kCustomDividerIndent8Heignt1,
                            itemCount: data.recentNutritions.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: size.width - 32,
                                child: NutritionsListTile(
                                  nutrition: data.recentNutritions[index],
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: kBottomNavigationBarHeight + 48),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
