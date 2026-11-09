import 'package:clinic_appointment_system/core/constants/clock_constants.dart';

/// Fixed values of the patient booking calendar.
abstract final class BookingConstants {
  /// value = 7; days from one week start to the next.
  static const int daysPerWeek = 7;

  /// value = 6; Monday through Saturday are always listed.
  static const int alwaysListedDays = 6;

  /// value = 12:00 in minutes; windows starting here or later are afternoon.
  static const int afternoonStartMinutes = 12 * ClockConstants.minutesPerHour;

  /// value = 17:00 in minutes; windows starting here or later are evening.
  static const int eveningStartMinutes = 17 * ClockConstants.minutesPerHour;
}
