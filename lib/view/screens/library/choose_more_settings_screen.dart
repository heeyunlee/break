import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/models/enum/location.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/view/widgets/widgets.dart';
import 'package:workout_player/view_models/create_new_routine_model.dart';

class ChooseMoreSettingsScreen extends ConsumerWidget {
  const ChooseMoreSettingsScreen({Key? key}) : super(key: key);

  static void showMoreSettings(
    BuildContext context, {
    required CreateNewRoutineModel model,
  }) {
    custmFadeTransition(
      context,
      duration: 500,
      screen: const ChooseMoreSettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final model = watch(createNewROutineModelProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: const AppbarBlurBG(),
        leading: const AppBarBackButton(),
        title: Text(S.current.moreSettings, style: TextStyles.subtitle2),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
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
                    Text(S.current.location, style: TextStyles.headline6_bold),
                  ],
                ),
              ),
              Card(
                margin: EdgeInsets.zero,
                color: kCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: model.location,
                    dropdownColor: kCardColor,
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
                  style: TextStyles.headline6_bold,
                ),
              ),
              Card(
                color: kCardColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Slider(
                  activeColor: kPrimaryColor,
                  inactiveColor: kPrimaryColor.withOpacity(0.2),
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
      floatingActionButton: _buildFAB(context, model),
    );
  }

  Widget _buildFAB(BuildContext context, CreateNewRoutineModel model) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width - 32,
      child: FloatingActionButton.extended(
        backgroundColor: kPrimaryColor,
        onPressed: () => model.submitToFirestore(context),
        label: Text(S.current.submit, style: TextStyles.button1),
      ),
    );
  }
}
