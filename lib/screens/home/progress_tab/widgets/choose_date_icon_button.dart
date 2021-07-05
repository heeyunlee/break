import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_player/screens/home/progress_tab/progress_tab_model.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/constants.dart';
import 'package:workout_player/styles/text_styles.dart';

import '../../home_screen_provider.dart';

class ChooseDateIconButton extends StatelessWidget {
  final ProgressTabModel model;

  const ChooseDateIconButton({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyles.text1,
      onPressed: () => _showCalendar(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat.MMMEd().format(model.selectedDate),
            style: TextStyles.subtitle2,
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Future<bool?> _showCalendar() {
    return showModalBottomSheet<bool>(
      context: homeScreenNavigatorKey.currentContext!,
      builder: (context) => Container(
        color: kCardColor,
        height: 500,
        child: TableCalendar(
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: TextStyles.body2,
            weekendStyle: TextStyles.body2_red,
          ),
          headerStyle: HeaderStyle(
            formatButtonShowsNext: false,
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyles.body1_w800,
          ),
          selectedDayPredicate: (day) {
            return isSameDay(model.selectedDate, day);
          },
          calendarStyle: CalendarStyle(
            weekendTextStyle: TextStyles.body2_red,
            defaultTextStyle: TextStyles.body2,
            outsideTextStyle: TextStyles.body2_grey700,
          ),
          onDaySelected: (selectedDay, focusedDay) {
            model.selectSelectedDate(selectedDay);
            model.selectFocusedDate(focusedDay);

            Navigator.of(context).pop();
          },
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: model.focusedDate,
        ),
      ),
    );
  }
}
