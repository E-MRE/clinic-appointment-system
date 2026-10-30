import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:equatable/equatable.dart';

/// Service duration in minutes.
final class ServiceDuration extends Equatable {
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
    if (!MedicalServiceConstants.durationPattern.hasMatch(trimmed)) {
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
  List<Object> get props => [minutes];

  @override
  String toString() => '$minutes min';
}
