import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

//osmr servis üzerinden yol hesaplama
class RouteDirectionResult {
  final List<LatLng> points;
  final double distanceKm;
  final int durationMinutes;

  const RouteDirectionResult({
    required this.points,
    required this.distanceKm,
    required this.durationMinutes,
  });

  factory RouteDirectionResult.fallback(List<LatLng> points) {
    return RouteDirectionResult(
      points: points,
      distanceKm: 0,
      durationMinutes: 0,
    );
  }
}

class RouteDirectionService {
  static Future<RouteDirectionResult> getRoute({
    required List<LatLng> points,
  }) async {
    if (points.length < 2) {
      return RouteDirectionResult.fallback(points);
    }

    final coordinates = points
        .map((point) => '${point.longitude},${point.latitude}')
        .join(';');

    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/$coordinates'
      '?overview=full&geometries=geojson',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        return RouteDirectionResult.fallback(points);
      }

      final data = jsonDecode(response.body);
      final routes = data['routes'] as List?;

      if (routes == null || routes.isEmpty) {
        return RouteDirectionResult.fallback(points);
      }

      final firstRoute = routes.first;
      final geometry = firstRoute['geometry'];
      final coordinatesList = geometry['coordinates'] as List;

      final routePoints = coordinatesList.map((item) {
        final lng = (item[0] as num).toDouble();
        final lat = (item[1] as num).toDouble();
        return LatLng(lat, lng);
      }).toList();

      final distanceMeter = (firstRoute['distance'] as num?)?.toDouble() ?? 0;
      final durationSecond = (firstRoute['duration'] as num?)?.toDouble() ?? 0;

      return RouteDirectionResult(
        points: routePoints,
        distanceKm: distanceMeter / 1000,
        durationMinutes: (durationSecond / 60).ceil(),
      );
    } catch (_) {
      return RouteDirectionResult.fallback(points);
    }
  }
}