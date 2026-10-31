import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../staff_management/domain/doubles/recording_staff_visitor.dart';
import '../../../staff_management/domain/doubles/staff_fixtures.dart';

void main() {
  const StaffFixtures fixtures = StaffFixtures();

  test('roles allow only their service kinds in their own department', () {
    final List<MedicalService> services = fixtures.services();
    expect(services.map(fixtures.doctor().canProvide), [true, false, false]);
    expect(services.map(fixtures.technician().canProvide), [false, true, true]);
  });

  test('both roles reject services from another branch or department', () {
    final List<MedicalService> foreignServices = [
      ...fixtures.services(branchId: 'other'),
      ...fixtures.services(departmentId: 'other'),
    ];
    for (final Staff staff in [fixtures.doctor(), fixtures.technician()]) {
      expect(foreignServices.any(staff.canProvide), isFalse);
    }
  });

  test('doctor trims text and copies identity without losing role details', () {
    final doctor = fixtures.doctor(
      id: 'original',
      fullName: ' Ada Kaya ',
      email: ' ada@example.com ',
      branchId: ' branch ',
      departmentId: ' department ',
      specialty: ' Cardiology ',
      serviceIds: [' exam '],
    );
    final trimmed = doctor.trimmed();
    expect(trimmed.id, 'original');
    expect(trimmed.fullName, 'Ada Kaya');
    expect(trimmed.email, 'ada@example.com');
    expect(trimmed.branchId, 'branch');
    expect(trimmed.departmentId, 'department');
    expect(trimmed.specialty, 'Cardiology');
    expect(trimmed.serviceIds, ['exam']);
    expect(doctor.serviceIds, [' exam ']);
    final copy = doctor.withId('uid');
    expect(copy.id, 'uid');
    expect(copy.fullName, doctor.fullName);
    expect(copy.email, doctor.email);
    expect(copy.branchId, doctor.branchId);
    expect(copy.departmentId, doctor.departmentId);
    expect(copy.specialty, doctor.specialty);
    expect(copy.serviceIds, doctor.serviceIds);
    final RecordingStaffVisitor visitor = RecordingStaffVisitor();
    expect(doctor.accept(visitor), 'doctor');
    expect(visitor.visited, same(doctor));
  });

  test('technician trims text and copies identity without changing fields', () {
    final technician = fixtures.technician(
      id: 'original',
      fullName: ' Ece Kaya ',
      email: ' ece@example.com ',
      branchId: ' branch ',
      departmentId: ' department ',
      serviceIds: [' radiology ', ' lab '],
    );
    final trimmed = technician.trimmed();
    expect(trimmed.id, 'original');
    expect(trimmed.fullName, 'Ece Kaya');
    expect(trimmed.email, 'ece@example.com');
    expect(trimmed.branchId, 'branch');
    expect(trimmed.departmentId, 'department');
    expect(trimmed.serviceIds, ['radiology', 'lab']);
    expect(technician.serviceIds, [' radiology ', ' lab ']);
    final copy = technician.withId('uid');
    expect(copy.id, 'uid');
    expect(copy.fullName, technician.fullName);
    expect(copy.email, technician.email);
    expect(copy.branchId, technician.branchId);
    expect(copy.departmentId, technician.departmentId);
    expect(copy.serviceIds, technician.serviceIds);
    expect(copy.detailsError, isNull);
    final RecordingStaffVisitor visitor = RecordingStaffVisitor();
    expect(technician.accept(visitor), 'technician');
    expect(visitor.visited, same(technician));
  });

  test('doctor requires specialty including whitespace-only input', () {
    for (final String specialty in ['', ' \t\n ']) {
      expect(
        fixtures.doctor(specialty: specialty).detailsError,
        UserErrorCode.specialtyRequired,
      );
    }
    expect(fixtures.doctor().detailsError, isNull);
  });
}
