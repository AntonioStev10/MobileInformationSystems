import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  Future<List<LatLng>> getRoute(LatLng start, LatLng end) async {
    final startCoords = "${start.longitude},${start.latitude}";
    final endCoords = "${end.longitude},${end.latitude}";
    final url =
        "https://router.project-osrm.org/route/v1/driving/$startCoords;$endCoords?overview=full";

    try {
      final response = await Dio().get(url);
      final route = response.data['routes'][0]['geometry'];
      return _decodePolyline(route);
    } catch (e) {
      print("Error fetching route: $e");
      return [];
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
}
