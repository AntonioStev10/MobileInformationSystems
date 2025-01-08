import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationPickerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LatLng? selectedLocation;

    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(41.9981, 21.4254),
          zoom: 13.0,
          onTap: (tapPosition, point) {
            selectedLocation = point;
          },
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.pop(
              context,
              {'latitude': selectedLocation!.latitude, 'longitude': selectedLocation!.longitude},
            );
          }
        },
      ),
    );
  }
}
