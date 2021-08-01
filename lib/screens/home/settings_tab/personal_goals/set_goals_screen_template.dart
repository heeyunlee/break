import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:workout_player/classes/user.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/screens/home/settings_tab/personal_goals/personal_goals_screen_model.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';
import 'package:workout_player/utils/formatter.dart';

class SetGoalsScreenTemplate extends StatelessWidget {
  final PersonalGoalsScreenModel model;
  final User user;
  final bool isRoot;
  final void Function(BuildContext context) fabOnPressed;
  final Color color;
  final String title;
  final int intMinValue;
  final int intMaxValue;
  final int intStep;
  final String unit;
  final bool isDouble;

  const SetGoalsScreenTemplate({
    Key? key,
    required this.model,
    required this.user,
    required this.isRoot,
    required this.fabOnPressed,
    required this.color,
    required this.title,
    required this.intMinValue,
    required this.intMaxValue,
    required this.intStep,
    required this.unit,
    required this.isDouble,
  }) : super(key: key);

  static void show(
    BuildContext context, {
    required bool isRoot,
    required PersonalGoalsScreenModel model,
    required User user,
    required void Function(BuildContext context) fabOnPressed,
    required Color color,
    required String title,
    required int intMinValue,
    required int intMaxValue,
    required int intStep,
    required String unit,
    required bool isDouble,
  }) {
    Navigator.of(context, rootNavigator: isRoot).push(
      CupertinoPageRoute(
        fullscreenDialog: isRoot,
        builder: (context) => SetGoalsScreenTemplate(
          model: model,
          user: user,
          isRoot: isRoot,
          fabOnPressed: fabOnPressed,
          color: color,
          title: title,
          intMinValue: intMinValue,
          intMaxValue: intMaxValue,
          intStep: intStep,
          unit: unit,
          isDouble: isDouble,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.d('SetWeightGoalScreen scaffold building...');
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: (!isRoot)
              ? const Icon(Icons.arrow_back_ios_rounded, color: Colors.white)
              : const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -1),
              child: Text(title, style: TextStyles.headline5),
            ),
            _buildNumberPicker(size),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        width: size.width - 32,
        child: FloatingActionButton.extended(
          onPressed: () => fabOnPressed(context),
          backgroundColor: kPrimaryColor,
          label: Text(S.current.setGoal, style: TextStyles.button1_bold),
        ),
      ),
    );
  }

  Widget _buildNumberPicker(Size size) {
    return Center(
      child: Consumer(
        builder: (context, watch, child) {
          final model = watch(personalGoalsScreenModelProvider(user));

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NumberPicker(
                minValue: intMinValue,
                maxValue: intMaxValue,
                step: intStep,
                itemHeight: 48,
                textStyle: TextStyles.subtitle1,
                selectedTextStyle: TextStyles.headline4.copyWith(color: color),
                value: model.intValue,
                itemWidth: (isDouble) ? (size.width * 0.4) : (size.width * 0.6),
                onChanged: model.onIntChanged,
                textMapper: Formatter.noDecimalWithString,
              ),
              if (isDouble) const Text('.', style: TextStyles.headline4),
              if (isDouble)
                NumberPicker(
                  minValue: 0,
                  maxValue: 9,
                  itemHeight: 48,
                  textStyle: TextStyles.subtitle1,
                  selectedTextStyle: TextStyles.headline4.copyWith(
                    color: color,
                  ),
                  value: model.doubleValue,
                  onChanged: model.onDoubleChanged,
                ),
              Text(unit, style: TextStyles.body1),
            ],
          );
        },
      ),
    );
  }
}
