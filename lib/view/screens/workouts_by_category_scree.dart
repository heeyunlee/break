import 'package:flutter/material.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/equipment_required.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/enum/main_muscle_group.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';

import 'search_category_screen.dart';

class WorkoutsByCategoryScreen extends StatelessWidget {
  const WorkoutsByCategoryScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => const WorkoutsByCategoryScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const AppBarBackButton(),
      ),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight!),
                const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Text(
                    'Workouts and Routines \nby Category',
                    style: TextStyles.headline6Bold,
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    S.current.mainMuscleGroup,
                    style: TextStyles.body1W900Menlo,
                  ),
                ),
                GridView.count(
                  childAspectRatio: 2.5,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: MainMuscleGroup.values.map(
                    (muscle) {
                      return SearchCategoryWidget(
                        color: theme.colorScheme.secondary,
                        text: muscle.translation!,
                        onTap: () => SearchCategoryScreen.show(
                          context,
                          arrayContains: muscle.toString(),
                          searchCategory: 'mainMuscleGroup',
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    S.current.equipmentRequired,
                    style: TextStyles.body1W900Menlo,
                  ),
                ),
                GridView.count(
                  childAspectRatio: 2.5,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: EquipmentRequired.values.map(
                    (equipment) {
                      return SearchCategoryWidget(
                        color: theme.colorScheme.secondary,
                        text: equipment.translation!,
                        onTap: () => SearchCategoryScreen.show(
                          context,
                          arrayContains: equipment.toString(),
                          searchCategory: 'equipmentRequired',
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    S.current.equipmentRequired,
                    style: TextStyles.body1W900Menlo,
                  ),
                ),
                GridView.count(
                  childAspectRatio: 2.5,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.all(8),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: Location.values.map(
                    (location) {
                      return SearchCategoryWidget(
                        color: Colors.amber,
                        text: location.translation!,
                        onTap: () => SearchCategoryScreen.show(
                          context,
                          searchCategory: 'location',
                          isEqualTo: location.toString(),
                        ),
                      );
                    },
                  ).toList(),
                ),
                const SizedBox(height: kBottomNavigationBarHeight + 40),
              ],
            ),
          );
        },
      ),
    );
  }
}
