import 'package:clinic_appointment_system/features/users/presentation/extensions/staff_initials.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../staff_management/domain/doubles/staff_fixtures.dart';

void main() {
  test(
    'shared initials preserve first and last words and Unicode graphemes',
    () {
      const fixtures = StaffFixtures();
      expect(fixtures.doctor(fullName: ' Ali Veli Demir ').initials, 'AD');
      expect(fixtures.technician(fullName: 'Ece').initials, 'E');
      expect(fixtures.doctor(fullName: ' ').initials, '');
    },
  );
}
