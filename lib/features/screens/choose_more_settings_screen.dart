import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/features/screens/routine_detail_screen.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/models/routine.dart';
import 'package:workout_player/providers.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/features/widgets/widgets.dart';
import 'package:workout_player/view_models/create_new_routine_model.dart';
import 'package:workout_player/view_models/home_screen_model.dart';

class ChooseMoreSettingsScreen extends ConsumerStatefulWidget {
  const ChooseMoreSettingsScreen({super.key});

  static void showMoreSettings(
    BuildContext context, {
    required CreateNewRoutineModel model,
  }) {
    customFadeTransition(
      context,
      duration: 500,
      screenBuilder: (animation) => const ChooseMoreSettingsScreen(),
    );
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChooseMoreSettingsScreenState();
}

class _ChooseMoreSettingsScreenState
    extends ConsumerState<ChooseMoreSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final model = ref.watch(createNewROutineModelProvider);
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: Text(S.current.moreSettings, style: TextStyles.subtitle2),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Scaffold.of(context).appBarMaxHeight! + 16),

              /// Location
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.place_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(S.current.location, style: TextStyles.headline6Bold),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: model.location,
                    dropdownColor: theme.cardTheme.color,
                    decoration: const InputDecoration(
                      enabledBorder: InputBorder.none,
                    ),
                    style: TextStyles.body1,
                    onChanged: model.onChangedLocation,
                    items: [
                      DropdownMenuItem(
                        value: 'Location.gym',
                        child: Text(Location.gym.translation!),
                      ),
                      DropdownMenuItem(
                        value: 'Location.atHome',
                        child: Text(Location.atHome.translation!),
                      ),
                      DropdownMenuItem(
                        value: 'Location.outdoor',
                        child: Text(Location.outdoor.translation!),
                      ),
                      DropdownMenuItem(
                        value: 'Location.others',
                        child: Text(Location.others.translation!),
                      ),
                    ],
                  ),
                ),
              ),

              /// Difficulty
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '${S.current.difficulty}: ${model.routineDifficultyLabel}',
                  style: TextStyles.headline6Bold,
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Slider(
                  activeColor: theme.primaryColor,
                  inactiveColor: theme.primaryColor.withOpacity(0.2),
                  value: model.routineDifficulty,
                  onChanged: model.onChangedDifficulty,
                  label: model.routineDifficultyLabel,
                  // min: 0,
                  max: 2,
                  divisions: 2,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFAB(context, ref, model),
    );
  }

  Widget _buildFAB(
    BuildContext context,
    WidgetRef ref,
    CreateNewRoutineModel model,
  ) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width - 32,
      child: FloatingActionButton.extended(
        onPressed: () async {
          final status = await model.submitToFirestore();

          if (!mounted) return;

          Navigator.of(context).popUntil((route) => route.isFirst);

          final homeScreenModel = ref.read(homeScreenModelProvider);

          final currentContext = HomeScreenModel
              .tabNavigatorKeys[homeScreenModel.currentTab]!.currentContext!;

          final routine = status.object as Routine;

          RoutineDetailScreen.show(
            currentContext,
            routine: routine,
            tag: 'createRoutine${routine.routineId}',
          );
        },
        label: Text(S.current.submit, style: TextStyles.button1),
      ),
    );
  }
}
