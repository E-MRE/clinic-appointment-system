import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();

  test(
    'visitor copies all shared doctor fields and specialty without password',
    () {
      final doctor = fixtures.doctor(serviceIds: ['exam']);
      expect(
        StaffFormValues.fromStaff(doctor),
        StaffFormValues(
          role: doctor.role,
          fullName: doctor.fullName,
          specialty: doctor.specialty,
          email: doctor.email,
          branchId: doctor.branchId,
          departmentId: doctor.departmentId,
          serviceIds: doctor.serviceIds,
        ),
      );
    },
  );

  test(
    'visitor copies technician fields with empty specialty and password',
    () {
      final technician = fixtures.technician(serviceIds: ['lab']);
      expect(
        StaffFormValues.fromStaff(technician),
        StaffFormValues(
          role: technician.role,
          fullName: technician.fullName,
          email: technician.email,
          branchId: technician.branchId,
          departmentId: technician.departmentId,
          serviceIds: technician.serviceIds,
        ),
      );
    },
  );

  test(
    'copyWith preserves unspecified fields and compares every draft value',
    () {
      const empty = StaffFormValues.empty();
      final values = empty.copyWith(
        role: UserRole.technician,
        fullName: 'Name',
        specialty: 'Specialty',
        email: 'email',
        password: 'password',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: ['lab'],
      );
      expect(values.copyWith(), values);
      expect(empty, const StaffFormValues());
      final changes = [
        values.copyWith(role: UserRole.doctor),
        values.copyWith(fullName: ''),
        values.copyWith(specialty: ''),
        values.copyWith(email: ''),
        values.copyWith(password: ''),
        values.copyWith(branchId: ''),
        values.copyWith(departmentId: ''),
        values.copyWith(serviceIds: []),
      ];
      for (final changed in changes) {
        expect(changed, isNot(values));
      }
    },
  );
}
