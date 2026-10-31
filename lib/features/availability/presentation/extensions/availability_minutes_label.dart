import 'package:clinic_appointment_system/core/constants/clock_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';

/// Localized weekly and daily duration totals.
extension AvailabilityMinutesLabel on int {
  /// Whole hours, mixed hours/minutes, or a dash for an empty duration.
  String get availabilityLabel {
    if (this == Duration.zero.inMinutes) {
      return LocaleKeys.availability_noMinutes.translate();
    }
    final hours = this ~/ ClockConstants.minutesPerHour;
    final minutes = this % ClockConstants.minutesPerHour;
    if (minutes == Duration.zero.inMinutes) {
      return LocaleKeys.availability_hours.translate(args: ['$hours']);
    }
    return LocaleKeys.availability_hoursMinutes.translate(
      args: ['$hours', '$minutes'],
    );
  }
}
