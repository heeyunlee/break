import 'package:flutter/cupertino.dart';

import 'package:workout_player/generated/l10n.dart';
import 'package:workout_player/main_provider.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../add_measurements_model.dart';

class SelectDatesWidget extends StatelessWidget {
  final AddMeasurementsModel model;

  const SelectDatesWidget({
    Key? key,
    required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    logger.d('Select Dates Widget building...');

    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () => _showDatePicker(context),
            child: Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: kPrimaryGrey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child:
                      Text(model.loggedTimeInString, style: TextStyles.body1),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12,
            top: -6,
            child: Container(
              color: kBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(S.current.time, style: TextStyles.caption1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    final size = MediaQuery.of(context).size;

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          color: kCardColorLight,
          height: size.height / 3,
          child: CupertinoTheme(
            data: CupertinoThemeData(brightness: Brightness.dark),
            child: CupertinoDatePicker(
              initialDateTime: model.loggedTime.toDate(),
              onDateTimeChanged: model.onDateTimeChanged,
            ),
          ),
        );
      },
    );
  }
}
