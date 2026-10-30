import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/medical_service_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/lab_test_form_section.dart';
import 'package:flutter/widgets.dart';

/// Form strategy for a laboratory test with fasting rules and turnaround time.
final class LabTestFormStrategy extends MedicalServiceFormStrategy {
  /// Creates the laboratory test form strategy.
  const LabTestFormStrategy();

  @override
  Widget section() {
    return const LabTestFormSection();
  }

  @override
  MedicalService create(
    MedicalServiceFormValues values, {
    required String id,
    required String branchId,
    required ServiceDuration duration,
    required Money fee,
  }) {
    return LabTest(
      id: id,
      name: values.name,
      departmentId: values.departmentId,
      branchId: branchId,
      duration: duration,
      fee: fee,
      resultTime: values.resultTime,
      fastingHours: _fastingHours(values),
    );
  }

  /// The fasting window when fasting is required; typed text is ignored otherwise.
  FastingHours? _fastingHours(MedicalServiceFormValues values) {
    if (!values.requiresFasting) return null;
    return FastingHours.parse(values.fastingText);
  }
}
