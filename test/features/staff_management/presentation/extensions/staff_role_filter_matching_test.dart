import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/staff_role_filter_matching.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  test(
    'all matches both roles and each specific filter matches only its role',
    () {
      final doctor = fixtures.doctor();
      final technician = fixtures.technician();
      expect(StaffRoleFilter.all.matches(doctor), isTrue);
      expect(StaffRoleFilter.all.matches(technician), isTrue);
      expect(StaffRoleFilter.doctor.matches(doctor), isTrue);
      expect(StaffRoleFilter.doctor.matches(technician), isFalse);
      expect(StaffRoleFilter.technician.matches(doctor), isFalse);
      expect(StaffRoleFilter.technician.matches(technician), isTrue);
    },
  );
}
