import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';

/// Shares input validation logic for medical service fields across use cases and presentation forms.
mixin MedicalServiceInputValidationMixin on InstitutionInputValidationMixin {
  /// Requires an assigned department identifier.
  InstitutionErrorCode? departmentError(String departmentId) {
    if (departmentId.trim().isEmpty) {
      return InstitutionErrorCode.departmentRequired;
    }
    return null;
  }

  /// Validates a duration string and returns any error code without throwing.
  InstitutionErrorCode? durationInputError(String input) {
    try {
      ServiceDuration.parse(input);
      return null;
    } on InstitutionException catch (error) {
      return error.code;
    }
  }

  /// Validates a fee amount string and returns any error code without throwing.
  InstitutionErrorCode? feeInputError(String input) {
    try {
      Money.parseLira(input);
      return null;
    } on InstitutionException catch (error) {
      return error.code;
    }
  }

  /// Validates a fasting hours string and returns any error code without throwing.
  InstitutionErrorCode? fastingInputError(String input) {
    try {
      FastingHours.parse(input);
      return null;
    } on InstitutionException catch (error) {
      return error.code;
    }
  }

  /// Validates a radiology preparation note length without throwing.
  InstitutionErrorCode? preparationNoteError(String note) {
    if (note.trim().length > MedicalServiceConstants.maxPreparationNoteLength) {
      return InstitutionErrorCode.preparationNoteTooLong;
    }
    return null;
  }

  /// Evaluates domain validity across standard fields and kind-specific details.
  InstitutionErrorCode? serviceError(MedicalService service) {
    return nameError(service.name) ??
        departmentError(service.departmentId) ??
        service.detailsError;
  }
}
