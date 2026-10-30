import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:flutter/widgets.dart';

/// The kind-specific part of the medical service form: its configuration
/// section and the entity built from the submitted values.
///
/// [build] parses the fields every kind shares and trims the result; a
/// subclass provides [section] and [create] for its own kind.
abstract base class MedicalServiceFormStrategy {
  /// Creates a form strategy.
  const MedicalServiceFormStrategy();

  /// The configuration section shown below the shared fields.
  Widget section();

  /// Creates this kind's service from [values] and the parsed shared fields.
  MedicalService create(
    MedicalServiceFormValues values, {
    required String id,
    required String branchId,
    required ServiceDuration duration,
    required Money fee,
  });

  /// Builds the concrete service from raw [values], normalizing text fields
  /// through [MedicalService.trimmed]. Throws `InstitutionException` for an
  /// invalid duration, fee or kind-specific value.
  MedicalService build(
    MedicalServiceFormValues values, {
    required String id,
    required String branchId,
  }) {
    final service = create(
      values,
      id: id,
      branchId: branchId,
      duration: ServiceDuration.parse(values.durationText),
      fee: Money.parseLira(values.feeText),
    );
    return service.trimmed();
  }
}
