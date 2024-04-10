import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class ToDoCalendar extends StatelessWidget {
  final DateTime focusedDay;
  final Function(DateTime day, DateTime focusedDay) onDaySelected;

  const ToDoCalendar({
    super.key,
    required this.focusedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      focusedDay: focusedDay,
      firstDay: DateTime.utc(2014, 01, 01),
      lastDay: DateTime.utc(2034, 01, 01),
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
