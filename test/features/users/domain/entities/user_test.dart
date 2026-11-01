import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../staff_management/domain/doubles/staff_fixtures.dart';

void main() {
  test(
    'staffProfile exposes staff polymorphically and hides non-staff roles',
    () {
      const fixtures = StaffFixtures();
      final List<User> staff = [fixtures.doctor(), fixtures.technician()];
      for (final user in staff) {
        expect(user.staffProfile, same(user));
      }
      const List<User> otherProfiles = [
        Patient(id: 'patient', fullName: 'Hasta', email: 'patient@example.com'),
        Admin(id: 'admin', fullName: 'Admin', email: 'admin@example.com'),
      ];
      for (final user in otherProfiles) {
        expect(user.staffProfile, isNull);
      }
    },
  );
}
