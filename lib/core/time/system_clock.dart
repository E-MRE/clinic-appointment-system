import 'package:clinic_appointment_system/core/time/clock.dart';

/// Reads the device's current local time.
final class SystemClock implements Clock {
  /// Creates a system clock.
  const SystemClock();

  /// Returns the current system instant.
  @override
  DateTime now() => DateTime.now();
}
