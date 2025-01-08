import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:lab4/models/event.dart';
import 'package:geolocator/geolocator.dart';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';

class MapScreen extends StatefulWidget {
  final List<Event> events;
  final LatLng? initialLocation;

  MapScreen({required this.events, this.initialLocation});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLocation;
  LatLng? _userLocation;
  bool _isUserLocationLoaded = false;
  List<LatLng> _routePoints = [];
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  late Timer _timer;
  Set<String> notifiedEvents = Set();

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _requestNotificationPermission();

    // Notification setup
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettings = InitializationSettings(android: androidSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);


    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _checkNearbyEvents();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _requestNotificationPermission() async {
    if (Theme.of(context).platform == TargetPlatform.android) {
      print('Notification permissions are automatically granted on Android.');
    } else if (Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS) {
      final permission = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );

      if (permission == null || permission == false) {
        print('Notification permission denied.');
      } else {
        print('Notification permission granted.');
      }
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
      _isUserLocationLoaded = true;
    });
  }

  Future<void> _fetchRoute(LatLng destination) async {
    if (_userLocation == null) return;

    final start = "${_userLocation!.longitude},${_userLocation!.latitude}";
    final end = "${destination.longitude},${destination.latitude}";

    final url =
        "https://router.project-osrm.org/route/v1/driving/$start;$end?overview=full";

    try {
      final response = await Dio().get(url);
      final route = response.data['routes'][0]['geometry'];
      final decodedRoute = _decodePolyline(route);

      setState(() {
        _routePoints = decodedRoute;
      });
    } catch (e) {
      print("Error fetching route: $e");
    }
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> coordinates = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = polyline.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      coordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return coordinates;
  }

  Future<void> _checkNearbyEvents() async {
    if (_userLocation == null) return;

    for (var event in widget.events) {
      double distance = await Geolocator.distanceBetween(
        _userLocation!.latitude,
        _userLocation!.longitude,
        event.latitude,
        event.longitude,
      );

      if (distance <= 500 && !notifiedEvents.contains(event.name)) {
        _showNotification(event.name);
      }
    }
  }

  Future<void> _showNotification(String eventName) async {
    const androidDetails = AndroidNotificationDetails(
      'event_channel',
      'Event Notifications',
      channelDescription: 'This channel is used for event location notifications.',
      importance: Importance.high,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      'You are near $eventName!',
      'Your location is within 500 meters of the event.',
      notificationDetails,
    );

    setState(() {
      notifiedEvents.add(eventName);
    });
  }

  void _addEvent() {
    if (_selectedLocation != null) {
      setState(() {
        widget.events.add(Event(

          name: 'New Event',
          date: DateTime.now(),
          location: 'Skopje',
          latitude: _selectedLocation!.latitude,
          longitude: _selectedLocation!.longitude,
        ));
        _selectedLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map View'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _userLocation ?? widget.initialLocation ?? LatLng(41.9981, 21.4254),
                zoom: 13.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    if (_isUserLocationLoaded && _userLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _userLocation!,
                        builder: (ctx) => Icon(Icons.my_location, color: Colors.blue),
                      ),
                    ...widget.events.map((event) {
                      return Marker(
                        width: 80.0,
                        height: 80.0,
                        point: LatLng(event.latitude, event.longitude),
                        builder: (ctx) => GestureDetector(
                          onTap: () async {
                            if (_userLocation != null) {
                              double distance = await Geolocator.distanceBetween(
                                _userLocation!.latitude,
                                _userLocation!.longitude,
                                event.latitude,
                                event.longitude,
                              );

                              if (distance <= 500) {
                                _showNotification(event.name);
                              }


                              await _fetchRoute(LatLng(event.latitude, event.longitude));
                            }
                          },
                          child: Icon(Icons.location_on, color: Colors.red),
                        ),
                      );
                    }).toList(),
                    if (_selectedLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _selectedLocation!,
                        builder: (ctx) => Icon(Icons.add_location, color: Colors.green),
                      ),
                  ],
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        color: Colors.red,
                        strokeWidth: 4.0,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _addEvent,
                  child: Text('Add Event'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _routePoints.clear();
                      _selectedLocation = null;
                    });
                  },
                  child: Text('Clear Route'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context, _selectedLocation);
        },
      ),
    );
  }
}
