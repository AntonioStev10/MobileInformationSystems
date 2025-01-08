import 'package:flutter/material.dart';
import 'package:lab4/models/event.dart';
import 'package:lab4/screens/map_screen.dart';
import 'package:lab4/screens/add_event_screen.dart';
import 'package:lab4/widgets/calendar_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<Event>> _events = {};

  DateTime _stripTime(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Schedule'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapScreen(
                    events: _events.values.expand((e) => e).toList(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          CalendarWidget(
            selectedDate: _selectedDate,
            onDateSelected: (date) => setState(() => _selectedDate = _stripTime(date)),
            events: _events,
          ),
          Expanded(
            child: ListView(
              children: (_events[_stripTime(_selectedDate)] ?? []).map((event) => ListTile(
                title: Text(event.name),
                subtitle: Text('Location: ${event.location}'),
              )).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newEvent = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEventScreen(initialDate: _selectedDate),
            ),
          );
          if (newEvent != null && newEvent is Event) {
            final eventDate = _stripTime(newEvent.date);
            setState(() {
              if (_events[eventDate] == null) {
                _events[eventDate] = [];
              }
              _events[eventDate]!.add(newEvent);
            });
          }
        },
      ),
    );
  }
}

