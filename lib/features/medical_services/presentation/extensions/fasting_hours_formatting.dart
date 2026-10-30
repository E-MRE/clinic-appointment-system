import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';

/// Formatting and input presentation for fasting hour requirements.
extension FastingHoursFormatting on FastingHours {
  /// Formats this fasting window into display text (e.g. `"8 saat"` or `"8–12 saat"`).
  String get formatted => isSingle
      ? LocaleKeys.services_fastingHoursSingle.translate(args: ['$min'])
      : LocaleKeys.services_fastingHoursRange.translate(args: ['$min', '$max']);

  /// Plain string representation used to prefill input forms (e.g. `8` or `8–12`).
  String get inputText => isSingle ? '$min' : '$min\u2013$max';
}
