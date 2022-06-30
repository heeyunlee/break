import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/combined/eats_tab_class.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/progress/progress_widgets.dart';
import 'package:workout_player/features/screens/calories_entries_screen.dart';
import 'package:workout_player/features/screens/more_nutritions_entries_screen.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/models/enum/unit_of_mass.dart';

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
                  Consumer(
                    builder: (context, ref, child) {
                      final model = ref.watch(
                        weeklyCaloriesChartModelProvider(data),
                      );
                      return WeeklyBarChart(
                        height: size.height / 3,
                        width: size.width,
                        color: Colors.green,
                        leadingIcon: Icons.local_fire_department_outlined,
                        titleOnTap: () => CaloriesEntriesScreen.show(
                          context,
                          user: data.user,
                        ),
                        title: S.current.consumedCalorie,
                        unit: data.user.unitOfMassEnum!.gram,
                        yValues: model.listOfYs(),
                      );
                    },
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
