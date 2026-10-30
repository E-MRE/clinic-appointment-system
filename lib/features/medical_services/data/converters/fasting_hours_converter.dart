import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a fasting hours range to and from its stored map representation.
final class FastingHoursConverter
    extends JsonConverter<FastingHours, Map<String, dynamic>> {
  /// Creates a converter for fasting hours ranges.
  const FastingHoursConverter();

  @override
  FastingHours fromJson(Map<String, dynamic> json) {
    final min = json[FirestoreConstants.minimum];
    final max = json[FirestoreConstants.maximum];
    if (min is! int || max is! int) {
      throw const FormatException(
        'Fasting hours must contain integer min and max values.',
      );
    }
    return FastingHours(min: min, max: max);
  }

  @override
  Map<String, dynamic> toJson(FastingHours object) {
    return {
      FirestoreConstants.minimum: object.min,
      FirestoreConstants.maximum: object.max,
    };
  }
}
