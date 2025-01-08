import 'package:flutter/material.dart';
import 'package:lab4/models/event.dart';
import 'package:latlong2/latlong.dart';
import 'package:intl/intl.dart';
import 'package:lab4/screens/map_screen.dart';

class AddEventScreen extends StatefulWidget {
  final DateTime initialDate;

  AddEventScreen({required this.initialDate});

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  LatLng? _selectedLocation;
  DateTime _selectedTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Event Title'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Location Description'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text(_selectedLocation == null
                  ? 'Select Location'
                  : 'Change Location'),
              onPressed: () async {
                final selectedLocation = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapScreen(
                      events: [],
                      initialLocation: _selectedLocation,
                    ),
                  ),
                );
                if (selectedLocation != null) {
                  setState(() {
                    _selectedLocation = selectedLocation;
                  });
                }
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Select Date and Time'),
              onPressed: () async {
                final pickedDateTime = await showDatePicker(
                  context: context,
                  initialDate: _selectedTime,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDateTime != null) {
                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(_selectedTime),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _selectedTime = DateTime(
                        pickedDateTime.year,
                        pickedDateTime.month,
                        pickedDateTime.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      );
                    });
                  }
                }
              },
            ),
            SizedBox(height: 16.0),
            Text('Selected Time: ${DateFormat('yyyy-MM-dd HH:mm').format(_selectedTime)}'),
            SizedBox(height: 16.0),
            ElevatedButton(
              child: Text('Add Event'),
              onPressed: () {
                if (_selectedLocation == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a location!')),
                  );
                  return;
                }
                final event = Event(
                  name: _titleController.text,
                  location: '${_locationController.text} (${_selectedLocation!.latitude}, ${_selectedLocation!.longitude})',
                  date: _selectedTime,
                  latitude: _selectedLocation!.latitude,
                  longitude: _selectedLocation!.longitude,
                );
                Navigator.pop(context, event);
              },
            ),
          ],
        ),
      ),
    );
  }
}
