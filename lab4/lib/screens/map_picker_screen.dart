import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPickerScreen extends StatefulWidget {
  @override
  _MapPickerScreenState createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng _selectedLocation = LatLng(41.9981, 21.4254);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: _selectedLocation,
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
              Marker(
                point: _selectedLocation,
                builder: (ctx) =>
                    Icon(Icons.location_on, color: Colors.red, size: 40),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          Navigator.pop(context,
              '${_selectedLocation.latitude}, ${_selectedLocation.longitude}');
        },
      ),
    );
  }
}
