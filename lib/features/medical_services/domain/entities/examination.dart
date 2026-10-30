import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';

/// Doctor consultation or general checkup service.
final class Examination extends MedicalService {
  /// Creates an examination service.
  const Examination({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.branchId,
    required super.duration,
    required super.fee,
  });

  @override
  MedicalServiceKind get kind => MedicalServiceKind.examination;

  @override
  R accept<R>(MedicalServiceVisitor<R> visitor) =>
      visitor.visitExamination(this);

  @override
  Examination trimmed() {
    return Examination(
      id: id,
      name: name.trim(),
      departmentId: departmentId.trim(),
      branchId: branchId.trim(),
      duration: duration,
      fee: fee,
    );
  }

  @override
  Examination withId(String id) {
    return Examination(
      id: id,
      name: name,
      departmentId: departmentId,
      branchId: branchId,
      duration: duration,
      fee: fee,
    );
  }
}
