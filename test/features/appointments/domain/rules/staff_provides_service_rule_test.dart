import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/staff_provides_service_rule.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

import 'package:flutter_test/flutter_test.dart';

import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  group('StaffProvidesServiceRule', () {
    const rule = StaffProvidesServiceRule();
    test('a listed eligible service passes', () {
      expect(rule.check(f.appointment(), f.context()), isNull);
    });
    test('an unlisted service fails', () {
      expect(
        rule
            .check(f.appointment(), f.context(staff: f.doctor(serviceIds: [])))
            ?.code,
        AppointmentErrorCode.serviceNotProvided,
      );
    });
    test('a listed service in another department fails', () {
      expect(
        rule
            .check(
              f.appointment(),
              f.context(staff: f.doctor(departmentId: 'other')),
            )
            ?.code,
        AppointmentErrorCode.serviceNotProvided,
      );
    });
    test('a technician cannot provide an examination', () {
      const technician = Technician(
        id: 'staff',
        fullName: 'Tech',
        email: 't@test',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: ['service'],
      );
      expect(
        rule.check(f.appointment(), f.context(staff: technician))?.code,
        AppointmentErrorCode.serviceNotProvided,
      );
    });
    test('a mismatched staff id fails', () {
      expect(
        rule.check(f.appointment(staffId: 'other'), f.context())?.code,
        AppointmentErrorCode.serviceNotProvided,
      );
    });
    test('a mismatched service id fails', () {
      expect(
        rule.check(f.appointment(serviceId: 'other'), f.context())?.code,
        AppointmentErrorCode.serviceNotProvided,
      );
    });
  });
}
