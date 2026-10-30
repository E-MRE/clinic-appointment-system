import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';

/// Formatted presentation for medical service durations.
extension ServiceDurationFormatting on ServiceDuration {
  /// Formats this duration into minutes display (e.g. `"20 dk"`).
  String get formatted =>
      LocaleKeys.services_durationMinutes.translate(args: ['$minutes']);
}
