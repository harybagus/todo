import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TodoCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final Function(DateTime day, DateTime focusedDay) onDaySelected;

  const TodoCalendar({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: firstDay,
      lastDay: DateTime.utc(2050),
      rowHeight: 40,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
      availableGestures: AvailableGestures.all,
      onDaySelected: onDaySelected,
      selectedDayPredicate: (day) => isSameDay(day, focusedDay),
    );
  }
}
