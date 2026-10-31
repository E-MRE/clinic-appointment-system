import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

final class StaffFixtures {
  const StaffFixtures();

  Doctor doctor({
    String id = Staff.unsavedId,
    String fullName = 'Ada Kaya',
    String email = 'ada@example.com',
    String branchId = 'branch',
    String departmentId = 'department',
    String specialty = 'Cardiology',
    List<String> serviceIds = const [],
  }) {
    return Doctor(
      id: id,
      fullName: fullName,
      email: email,
      branchId: branchId,
      departmentId: departmentId,
      specialty: specialty,
      serviceIds: serviceIds,
    );
  }

  Technician technician({
    String id = Staff.unsavedId,
    String fullName = 'Ece Kaya',
    String email = 'ece@example.com',
    String branchId = 'branch',
    String departmentId = 'department',
    List<String> serviceIds = const [],
  }) {
    return Technician(
      id: id,
      fullName: fullName,
      email: email,
      branchId: branchId,
      departmentId: departmentId,
      serviceIds: serviceIds,
    );
  }

  List<MedicalService> services({
    String branchId = 'branch',
    String departmentId = 'department',
  }) {
    return [
      Examination(
        id: 'exam',
        name: 'Consultation',
        branchId: branchId,
        departmentId: departmentId,
        duration: ServiceDuration(30),
        fee: Money.minorUnits(50000),
      ),
      RadiologyService(
        id: 'radiology',
        name: 'X-ray',
        branchId: branchId,
        departmentId: departmentId,
        duration: ServiceDuration(15),
        fee: Money.minorUnits(50000),
        modality: RadiologyModality.xRay,
      ),
      LabTest(
        id: 'lab',
        name: 'Blood count',
        branchId: branchId,
        departmentId: departmentId,
        duration: ServiceDuration(10),
        fee: Money.minorUnits(50000),
        resultTime: LabResultTime.sameDay,
      ),
    ];
  }
}
