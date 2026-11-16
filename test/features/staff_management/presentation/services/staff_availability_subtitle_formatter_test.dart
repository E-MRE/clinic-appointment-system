import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/services/staff_availability_subtitle_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  const formatter = StaffAvailabilitySubtitleFormatter();
  final staff = fixtures.doctor(
    id: 'doctor',
    fullName: 'Ada Kaya',
    departmentId: 'cardiology',
  );

  test('includes the department name when it is available', () {
    expect(
      formatter.format(
        staff: staff,
        roleLabel: 'Doktor',
        departments: const [
          Department(id: 'cardiology', name: 'Kardiyoloji', branchId: 'branch'),
        ],
      ),
      'Ada Kaya · Doktor · Kardiyoloji',
    );
  });

  test('omits an unknown department name', () {
    expect(
      formatter.format(
        staff: staff,
        roleLabel: 'Doktor',
        departments: const [],
      ),
      'Ada Kaya · Doktor',
    );
  });
}
