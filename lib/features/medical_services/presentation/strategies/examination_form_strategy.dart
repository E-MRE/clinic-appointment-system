import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/medical_service_form_strategy.dart';
import 'package:flutter/widgets.dart';

/// Form strategy for a doctor examination, which has no extra fields.
final class ExaminationFormStrategy extends MedicalServiceFormStrategy {
  /// Creates the examination form strategy.
  const ExaminationFormStrategy();

  @override
  Widget section() {
    return const SizedBox.shrink();
  }

  @override
  MedicalService create(
    MedicalServiceFormValues values, {
    required String id,
    required String branchId,
    required ServiceDuration duration,
    required Money fee,
  }) {
    return Examination(
      id: id,
      name: values.name,
      departmentId: values.departmentId,
      branchId: branchId,
      duration: duration,
      fee: fee,
    );
  }
}
