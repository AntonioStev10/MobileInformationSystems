
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:lab4/models/event.dart';

class CalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;
  final Map<DateTime, List<Event>> events;

  CalendarWidget({
    required this.selectedDate,
    required this.onDateSelected,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: selectedDate,
      selectedDayPredicate: (day) => isSameDay(selectedDate, day),
      onDaySelected: (selectedDay, focusedDay) {
        onDateSelected(selectedDay);
      },
      eventLoader: (day) {
        return events[DateTime(day.year, day.month, day.day)] ?? [];
      },
      calendarStyle: CalendarStyle(
        markersMaxCount: 1,
        markerDecoration: BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}