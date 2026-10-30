import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// Service duration in minutes.
final class ServiceDuration {
  static final RegExp _digitsOnlyPattern = RegExp(r'^\d+$');

  /// Creates a service duration from minutes.
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidDuration] if
  /// [minutes] is outside [MedicalServiceConstants.minDurationMinutes] and
  /// [MedicalServiceConstants.maxDurationMinutes].
  factory ServiceDuration(int minutes) {
    if (minutes < MedicalServiceConstants.minDurationMinutes ||
        minutes > MedicalServiceConstants.maxDurationMinutes) {
      throw const InstitutionException(InstitutionErrorCode.invalidDuration);
    }
    return ServiceDuration._(minutes);
  }

  /// Parses a string representation into a [ServiceDuration].
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidDuration] if
  /// [input] is not integer digits or out of range.
  factory ServiceDuration.parse(String input) {
    final trimmed = input.trim();
    if (!_digitsOnlyPattern.hasMatch(trimmed)) {
      throw const InstitutionException(InstitutionErrorCode.invalidDuration);
    }
    final minutes = int.tryParse(trimmed);
    if (minutes == null) {
      throw const InstitutionException(InstitutionErrorCode.invalidDuration);
    }
    return ServiceDuration(minutes);
  }

  const ServiceDuration._(this.minutes);

  /// Duration in minutes.
  final int minutes;

  @override
  bool operator ==(Object other) =>
      other is ServiceDuration && other.minutes == minutes;

  @override
  int get hashCode => minutes.hashCode;

  @override
  String toString() => '$minutes min';
}
