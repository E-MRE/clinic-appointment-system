import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/medical_service_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/radiology_form_section.dart';
import 'package:flutter/widgets.dart';

/// Form strategy for an imaging procedure with modality and preparation note.
final class RadiologyFormStrategy extends MedicalServiceFormStrategy {
  /// Creates the radiology form strategy.
  const RadiologyFormStrategy();

  @override
  Widget section() {
    return const RadiologyFormSection();
  }

  @override
  MedicalService create(
    MedicalServiceFormValues values, {
    required String id,
    required String branchId,
    required ServiceDuration duration,
    required Money fee,
  }) {
    return RadiologyService(
      id: id,
      name: values.name,
      departmentId: values.departmentId,
      branchId: branchId,
      duration: duration,
      fee: fee,
      modality: values.modality,
      preparationNote: values.preparationNote,
    );
  }
}
