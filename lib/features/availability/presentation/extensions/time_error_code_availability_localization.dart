import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';

/// Localized date/time validation feedback for availability forms.
extension TimeErrorCodeAvailabilityLocalization on TimeErrorCode {
  /// The localized validation message.
  String get availabilityMessage => switch (this) {
    TimeErrorCode.endBeforeStart =>
      LocaleKeys.availability_errors_endBeforeStart,
    TimeErrorCode.invalidTime => LocaleKeys.availability_errors_invalidTime,
    TimeErrorCode.invalidDate => LocaleKeys.availability_errors_invalidDate,
  }.translate();
}
