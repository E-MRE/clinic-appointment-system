import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';

/// Converts a [DateTime] to the domain [Weekday].
extension DateTimeWeekday on DateTime {
  /// The weekday this date falls on.
  Weekday toWeekday() => Weekday.values[weekday - DateTime.monday];
}
