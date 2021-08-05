import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_player/classes/enum/main_muscle_group.dart';
import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/widgets/app_bar/appbar_blur_bg.dart';
import 'package:workout_player/widgets/appbar_back_button.dart';
import 'package:workout_player/widgets/check_box_list_view.dart';
import 'package:provider/provider.dart' as provider;

import 'create_new_routine_model.dart';

class ChooseMainMuscleGroupScreen extends ConsumerWidget {
  const ChooseMainMuscleGroupScreen({Key? key}) : super(key: key);

  static void showMainMuscleGroup(
    BuildContext context, {
    required CreateNewRoutineModel model,
  }) {
    HapticFeedback.mediumImpact();

    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondAnimation) {
          return provider.ListenableProvider(
            create: (cintext) => animation,
            child: ChooseMainMuscleGroupScreen(),
          );
        },
      ),
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
        title: Text(S.current.mainMuscleGroup, style: TextStyles.subtitle2),
      ),
      body: Builder(builder: (context) => _buildBody(context, model)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () => model.saveMainMuscleGroup(context, model),
        child: const Icon(
          Icons.arrow_forward_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CreateNewRoutineModel model) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: Scaffold.of(context).appBarMaxHeight!),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.current.chooseMainMuscleGroupMessage,
              style: TextStyles.body1,
            ),
          ),
          CheckboxListView(
            checked: model.selectedMainMuscleGroupEnum.contains,
            items: MainMuscleGroup.values,
            onChangedMainMuscleEnum: (checked, muscle) =>
                model.onChangedMuscleGroup(checked, muscle),
            getTitle: (muscle) => (muscle as MainMuscleGroup).translation!,
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
