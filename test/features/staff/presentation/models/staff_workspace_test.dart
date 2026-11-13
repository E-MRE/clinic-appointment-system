import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_workspace.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const staff = Doctor(
    id: 'staff-1',
    fullName: 'Dr. Ada Kaya',
    email: 'ada@example.com',
    branchId: 'branch-1',
    departmentId: 'dept-1',
    serviceIds: ['exam-1'],
    specialty: 'Cardiology',
  );

  final availability = StaffAvailability(
    staffId: 'staff-1',
    branchId: 'branch-1',
  );

  final branch = Branch(
    id: 'branch-1',
    clinicId: 'clinic-1',
    name: 'Merkez Şube',
    address: 'Adres',
    workingHours: WorkingHours.closed(),
  );

  const department = Department(
    id: 'dept-1',
    name: 'Kardiyoloji',
    branchId: 'branch-1',
  );

  final service = Examination(
    id: 'exam-1',
    branchId: 'branch-1',
    departmentId: 'dept-1',
    name: 'Muayene',
    fee: Money.minorUnits(10000),
    duration: ServiceDuration(30),
  );

  test('indexes services by id and supports lookup by id', () {
    final workspace = StaffWorkspace(
      staff: staff,
      availability: availability,
      branch: branch,
      department: department,
      services: [service],
    );

    expect(workspace.staff, staff);
    expect(workspace.availability, availability);
    expect(workspace.branch, branch);
    expect(workspace.department, department);
    expect(workspace.services, [service]);
    expect(workspace.serviceById('exam-1'), service);
    expect(workspace.serviceById('unknown'), isNull);
  });

  test('equality is based on all workspace fields', () {
    final first = StaffWorkspace(
      staff: staff,
      availability: availability,
      branch: branch,
      department: department,
      services: [service],
    );
    final second = StaffWorkspace(
      staff: staff,
      availability: availability,
      branch: branch,
      department: department,
      services: [service],
    );

    expect(first, equals(second));
    expect(first.hashCode, equals(second.hashCode));
  });
}
