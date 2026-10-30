import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// Pre-procedure fasting requirements in hours.
final class FastingHours {
  /// One number of hours, or two joined by `-` or an en dash.
  static final RegExp _hoursPattern = RegExp(
    r'^(\d+)(?:\s*[-\u2013]\s*(\d+))?$',
  );

  /// Creates a fasting range with [min] and [max] hours.
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidFastingHours] if
  /// values are out of bounds or [min] exceeds [max].
  factory FastingHours({required int min, required int max}) {
    if (min < MedicalServiceConstants.minFastingHours ||
        min > MedicalServiceConstants.maxFastingHours ||
        max < MedicalServiceConstants.minFastingHours ||
        max > MedicalServiceConstants.maxFastingHours ||
        min > max) {
      throw const InstitutionException(
        InstitutionErrorCode.invalidFastingHours,
      );
    }
    return FastingHours._(min: min, max: max);
  }

  /// Parses `8` (8–8) or a range such as `8-12`, `8–12` or `8 - 12`.
  /// Throws [InstitutionException] with
  /// [InstitutionErrorCode.invalidFastingHours] on malformed input.
  factory FastingHours.parse(String input) {
    final match = _hoursPattern.firstMatch(input.trim());
    final min = int.tryParse(match?.group(1) ?? '');
    if (match == null || min == null) {
      throw const InstitutionException(
        InstitutionErrorCode.invalidFastingHours,
      );
    }
    final max = int.tryParse(match.group(2) ?? '') ?? min;
    return FastingHours(min: min, max: max);
  }

  const FastingHours._({required this.min, required this.max});

  /// Minimum required fasting duration in hours.
  final int min;

  /// Maximum recommended fasting duration in hours.
  final int max;

  /// Whether this specifies an exact number of hours rather than a range.
  bool get isSingle => min == max;

  @override
  bool operator ==(Object other) {
    return other is FastingHours && other.min == min && other.max == max;
  }

  @override
  int get hashCode => Object.hash(min, max);

  @override
  String toString() => isSingle ? '$min h' : '$min–$max h';
}
