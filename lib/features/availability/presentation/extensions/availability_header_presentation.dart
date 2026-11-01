import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_minutes_label.dart';

/// Header copy that omits totals until a schedule is available.
extension AvailabilityHeaderPresentation
    on WatchState<StaffAvailability, AvailabilityErrorCode> {
  /// Adds the weekly total to a localized subtitle when loaded.
  String withWeeklyTotal(String subtitle) {
    if (this case WatchLoaded(:final data)) {
      return LocaleKeys.availability_weeklyTotal.translate(
        args: [subtitle, data.weeklyMinutes.availabilityLabel],
      );
    }
    return subtitle;
  }
}
