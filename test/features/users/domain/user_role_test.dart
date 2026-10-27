import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only patients book appointments', () {
    expect(UserRole.patient.canBookAppointments, isTrue);
    expect(UserRole.doctor.canBookAppointments, isFalse);
    expect(UserRole.technician.canBookAppointments, isFalse);
    expect(UserRole.admin.canBookAppointments, isFalse);
  });

  test('doctors and technicians approve appointments', () {
    expect(UserRole.doctor.canApproveAppointments, isTrue);
    expect(UserRole.technician.canApproveAppointments, isTrue);
    expect(UserRole.patient.canApproveAppointments, isFalse);
    expect(UserRole.admin.canApproveAppointments, isFalse);
  });

  test('only doctors mark no-shows', () {
    expect(UserRole.doctor.canMarkNoShow, isTrue);
    expect(UserRole.technician.canMarkNoShow, isFalse);
    expect(UserRole.patient.canMarkNoShow, isFalse);
    expect(UserRole.admin.canMarkNoShow, isFalse);
  });

  test('only admins manage the clinic and view all appointments', () {
    for (final role in UserRole.values) {
      final isAdmin = role == UserRole.admin;
      expect(role.canManageClinic, isAdmin);
      expect(role.canViewAllAppointments, isAdmin);
    }
  });
}
