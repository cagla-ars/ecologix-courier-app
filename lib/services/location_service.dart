import 'dart:async';

import 'package:geolocator/geolocator.dart';

import 'api_service.dart';

class LocationService {
  Timer? _timer;
  bool _isSending = false;

  Future<bool> _checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position?> sendCurrentLocation({
    required int courierId,
    void Function(Position position)? onLocationChanged,
  }) async {
    if (_isSending) return null;

    _isSending = true;

    try {
      final hasPermission = await _checkPermission();

      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

      await ApiService.updateCourierLocation(
        courierId: courierId,
        lat: position.latitude,
        lon: position.longitude,
      );

      onLocationChanged?.call(position);

      return position;
    } finally {
      _isSending = false;
    }
  }

  void startTracking({
    required int courierId,
    Duration interval = const Duration(seconds: 15),
    void Function(Position position)? onLocationChanged,
  }) {
    stopTracking();

    sendCurrentLocation(
      courierId: courierId,
      onLocationChanged: onLocationChanged,
    );

    _timer = Timer.periodic(interval, (_) {
      sendCurrentLocation(
        courierId: courierId,
        onLocationChanged: onLocationChanged,
      );
    });
  }

  void stopTracking() {
    _timer?.cancel();
    _timer = null;
  }
}