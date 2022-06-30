import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/features/widgets/widgets.dart';

import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/dummy_data.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/user.dart';

import '../../styles/constants.dart';
import '../../view_models/personal_goals_screen_model.dart';
import 'set_goals_screen_template.dart';

class PersonalGoalsScreen extends ConsumerWidget {
  const PersonalGoalsScreen({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    customPush(
      context,
      rootNavigator: false,
      builder: (context) => const PersonalGoalsScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: Text(S.current.personalGoals, style: TextStyles.subtitle2),
      ),
      body: Builder(
        builder: (context) => _buildBody(context, ref),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return CustomStreamBuilder<User?>(
      initialData: DummyData.user,
      stream: ref.read(databaseProvider).userStream(),
      builder: (context, user) => Consumer(
        builder: (context, ref, child) {
          final model = ref.watch(personalGoalsScreenModelProvider(user!));
          model.init();

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),
                _buildLiftingGoalListTile(context, user, model),
                kCustomDividerIndent16,
                _buildWeightGoalListTile(context, user, model),
                _buildBodyFatGoalListTile(context, user, model),
                kCustomDividerIndent16,
                _buildCalorieGoalListTile(context, user, model),
                _buildProteinGoalListTile(context, user, model),
                _buildCarbsGoalListTile(context, user, model),
                _buildFatGoalListTile(context, user, model),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiftingGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      showTrailingText: user.dailyWeightsGoal != null,
      trailingText: model.getLiftingGoalPreview(),
      iconData: Icons.fitness_center_rounded,
      title: S.current.liftingGoal,
      onTap: () {
        SetGoalsScreenTemplate.show(
          context,
          model: model,
          user: user,
          fabOnPressed: model.setLiftingGoal,
          color: Colors.redAccent,
          title: S.current.liftingGoal,
          intMinValue: 0,
          intMaxValue: 50000,
          intStep: 50,
          unit: model.kilogramUnit,
          isDouble: false,
          initValue: model.setInitialValue,
          initialValue: model.liftingGoal,
        );
      },
    );
  }

  Widget _buildWeightGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      title: S.current.weightGoal,
      iconData: Icons.monitor_weight_outlined,
      trailingText: model.getBodyWeightGoalPreview(),
      showTrailingText: user.weightGoal != null,
      onTap: () => SetGoalsScreenTemplate.show(
        context,
        model: model,
        user: user,
        fabOnPressed: model.setWeightGoal,
        color: Colors.lightBlueAccent,
        title: S.current.weightGoal,
        intMinValue: 0,
        intMaxValue: 500,
        intStep: 1,
        unit: model.kilogramUnit,
        isDouble: true,
        initValue: model.setInitialValue,
        initialValue: model.weightGoal,
      ),
    );
  }

  Widget _buildBodyFatGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      showTrailingText: user.bodyFatPercentageGoal != null,
      title: S.current.bodyFatGoal,
      iconData: Icons.monitor_weight_outlined,
      trailingText: model.getBodyFatGoalsPreview(),
      onTap: () => SetGoalsScreenTemplate.show(
        context,
        model: model,
        user: user,
        fabOnPressed: model.setBodyFatPercentageGoal,
        color: Colors.lightBlueAccent,
        title: S.current.bodyFatGoal,
        intMinValue: 0,
        intMaxValue: 50,
        intStep: 1,
        unit: '%',
        isDouble: true,
        initValue: model.setInitialValue,
        initialValue: model.bodyFatPercentageGoal,
      ),
    );
  }

  ListTile _buildCalorieGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      title: S.current.calorieGoal,
      showTrailingText: user.dailyCalorieConsumptionGoal != null,
      iconData: Icons.local_fire_department_rounded,
      trailingText: model.getCalorieGoalPreview(),
      onTap: () => SetGoalsScreenTemplate.show(
        context,
        model: model,
        user: user,
        fabOnPressed: model.setCalorieGoal,
        color: Colors.redAccent,
        title: S.current.calorieGoal,
        intMinValue: 0,
        intMaxValue: 5000,
        intStep: 5,
        unit: 'kcal',
        isDouble: false,
        initValue: model.setInitialValue,
        initialValue: model.calorieConsumptionGoal,
      ),
    );
  }

  ListTile _buildProteinGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      showTrailingText: user.dailyProteinGoal != null,
      iconData: Icons.restaurant_menu_rounded,
      title: S.current.proteinsGoal,
      trailingText: model.getProteinGoalPreview(),
      onTap: () => SetGoalsScreenTemplate.show(
        context,
        model: model,
        user: user,
        fabOnPressed: model.setProteinGoal,
        color: Colors.greenAccent,
        title: S.current.proteins,
        intMinValue: 0,
        intMaxValue: 500,
        intStep: 1,
        unit: model.gramUnit,
        isDouble: true,
        initValue: model.setInitialValue,
        initialValue: model.proteinGoal,
      ),
    );
  }

  ListTile _buildCarbsGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      title: S.current.carbsGoal,
      showTrailingText: user.dailyCarbsGoal != null,
      iconData: Icons.restaurant_menu_rounded,
      trailingText: model.getCarbsGoalPreview(),
      onTap: () => SetGoalsScreenTemplate.show(
        context,
        model: model,
        user: user,
        fabOnPressed: model.setCarbsGoal,
        color: Colors.greenAccent,
        title: S.current.carbs,
        intMinValue: 0,
        intMaxValue: 500,
        intStep: 1,
        unit: model.gramUnit,
        isDouble: true,
        initValue: model.setInitialValue,
        initialValue: model.carbsGoal,
      ),
    );
  }

  ListTile _buildFatGoalListTile(
    BuildContext context,
    User user,
    PersonalGoalsScreenModel model,
  ) {
    return _buildListTile(
      title: S.current.fatGoal,
      showTrailingText: user.dailyFatGoal != null,
      iconData: Icons.restaurant_menu_rounded,
      trailingText: model.getFatsGoalPreview(),
      onTap: () => SetGoalsScreenTemplate.show(
        context,
        model: model,
        user: user,
        fabOnPressed: model.setFatGoal,
        color: Colors.greenAccent,
        title: S.current.fat,
        intMinValue: 0,
        intMaxValue: 200,
        intStep: 1,
        unit: model.gramUnit,
        isDouble: true,
        initValue: model.setInitialValue,
        initialValue: model.fatGoal,
      ),
    );
  }

  ListTile _buildListTile({
    required bool showTrailingText,
    required void Function() onTap,
    required IconData iconData,
    required String title,
    required String trailingText,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(iconData, color: Colors.white),
      title: Text(title, style: TextStyles.body2),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTrailingText) Text(trailingText, style: TextStyles.body2Grey),
          const SizedBox(width: 16),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 20,
          ),
        ],
      ),
    );
  }
}
