// compass_handler.dart
import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class CompassHandler {
  Stream<double>? _compassStream;
  StreamSubscription<MagnetometerEvent>? _subscription;

  Stream<double> get compassStream {
    _compassStream ??= _createCompassStream();
    return _compassStream!;
  }

  Stream<double> _createCompassStream() {
    return magnetometerEvents.map((event) {
      // Calculate heading from magnetometer data
      double heading = atan2(event.y, event.x) * (180 / pi);
      // Convert to 0-360 range and adjust for device orientation
      heading = (heading + 360) % 360;
      return heading;
    });
  }

  void dispose() {
    _subscription?.cancel();
  }
}