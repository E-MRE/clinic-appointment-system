import 'package:clinic_appointment_system/core/time/clock.dart';

/// A deterministic clock at a caller-supplied instant.
final class FixedClock implements Clock {
  /// Creates a fixed clock.
  const FixedClock(this.instant);

  /// The instant returned on every read.
  final DateTime instant;

  /// Returns the fixed instant.
  @override
  DateTime now() => instant;
}
