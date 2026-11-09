import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_display_name.dart';
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
      const patient = Patient(id: 'p', fullName: 'Elif Kaya', email: 'e@x');
      expect(patient.initials, 'EK');
    },
  );

  test('first name is the first word of the trimmed full name', () {
    const fixtures = StaffFixtures();
    expect(fixtures.doctor(fullName: '  Elif   Nur Kaya ').firstName, 'Elif');
    expect(fixtures.technician(fullName: 'Ece').firstName, 'Ece');
    expect(fixtures.doctor(fullName: ' ').firstName, '');
  });
}
