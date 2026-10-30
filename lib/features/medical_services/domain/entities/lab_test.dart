import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';

/// Laboratory diagnostic test service.
base class LabTest extends MedicalService {
  /// Creates a laboratory test service.
  const LabTest({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.branchId,
    required super.duration,
    required super.fee,
    required this.resultTime,
    this.fastingHours,
  });

  /// Required pre-test fasting window, or null if fasting is not needed.
  final FastingHours? fastingHours;

  /// Expected timeframe for test results.
  final LabResultTime resultTime;

  /// Whether this diagnostic test requires fasting beforehand.
  bool get requiresFasting => fastingHours != null;

  @override
  MedicalServiceKind get kind => MedicalServiceKind.lab;

  @override
  R accept<R>(MedicalServiceVisitor<R> visitor) => visitor.visitLabTest(this);

  @override
  LabTest trimmed() {
    return LabTest(
      id: id,
      name: name.trim(),
      departmentId: departmentId.trim(),
      branchId: branchId.trim(),
      duration: duration,
      fee: fee,
      resultTime: resultTime,
      fastingHours: fastingHours,
    );
  }

  @override
  LabTest withId(String id) {
    return LabTest(
      id: id,
      name: name,
      departmentId: departmentId,
      branchId: branchId,
      duration: duration,
      fee: fee,
      resultTime: resultTime,
      fastingHours: fastingHours,
    );
  }
}
