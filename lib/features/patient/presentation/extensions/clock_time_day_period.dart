import 'package:clinic_appointment_system/core/constants/booking_constants.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/day_period.dart';

/// Resolves the [DayPeriod] a time of day belongs to.
extension ClockTimeDayPeriod on ClockTime {
  /// Half-open periods: before 12:00 morning, before 17:00 afternoon,
  /// otherwise evening.
  DayPeriod get dayPeriod {
    if (minutesSinceMidnight < BookingConstants.afternoonStartMinutes) {
      return DayPeriod.morning;
    }
    if (minutesSinceMidnight < BookingConstants.eveningStartMinutes) {
      return DayPeriod.afternoon;
    }
    return DayPeriod.evening;
  }
}
