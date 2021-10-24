import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_player/models/user.dart';
import 'package:workout_player/view_models/home_screen_model.dart';
import 'package:workout_player/view_models/progress_tab_model.dart';
import 'package:workout_player/styles/button_styles.dart';
import 'package:workout_player/styles/text_styles.dart';

class ChooseDateIconButton extends StatelessWidget {
  final ProgressTabModel model;
  final User user;

  const ChooseDateIconButton({
    Key? key,
    required this.model,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool enabled = user.widgetsList?.contains('activityRing') ?? true;

    return TextButton(
      style: ButtonStyles.text1(context),
      onPressed: enabled ? () => _showCalendar(context) : null,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            DateFormat.MMMEd().format(model.selectedDate),
            style: TextStyles.subtitle2,
          ),
          if (enabled) const SizedBox(width: 8),
          if (enabled) const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }

  Future<bool?> _showCalendar(BuildContext context) {
    final theme = Theme.of(context);
    final homeContext = HomeScreenModel.homeScreenNavigatorKey.currentContext!;

    return showModalBottomSheet<bool>(
      context: homeContext,
      builder: (context) => Container(
        color: theme.cardTheme.color,
        height: 500,
        child: TableCalendar(
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyles.body2,
            weekendStyle: TextStyles.body2Red,
          ),
          headerStyle: const HeaderStyle(
            formatButtonShowsNext: false,
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: TextStyles.body1W800,
          ),
          selectedDayPredicate: (day) {
            return isSameDay(model.selectedDate, day);
          },
          calendarStyle: const CalendarStyle(
            weekendTextStyle: TextStyles.body2Red,
            defaultTextStyle: TextStyles.body2,
            outsideTextStyle: TextStyles.body2Grey700,
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
