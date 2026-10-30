import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:clinic_appointment_system/features/users/domain/extensions/user_role_permissions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only patients book appointments', () {
    expect(UserRole.patient.permissions.canBookAppointments, isTrue);
    expect(UserRole.doctor.permissions.canBookAppointments, isFalse);
    expect(UserRole.technician.permissions.canBookAppointments, isFalse);
    expect(UserRole.admin.permissions.canBookAppointments, isFalse);
  });

  test('doctors and technicians approve appointments', () {
    expect(UserRole.doctor.permissions.canApproveAppointments, isTrue);
    expect(UserRole.technician.permissions.canApproveAppointments, isTrue);
    expect(UserRole.patient.permissions.canApproveAppointments, isFalse);
    expect(UserRole.admin.permissions.canApproveAppointments, isFalse);
  });

  test('only doctors mark no-shows', () {
    expect(UserRole.doctor.permissions.canMarkNoShow, isTrue);
    expect(UserRole.technician.permissions.canMarkNoShow, isFalse);
    expect(UserRole.patient.permissions.canMarkNoShow, isFalse);
    expect(UserRole.admin.permissions.canMarkNoShow, isFalse);
  });

  test('only admins manage the clinic and view all appointments', () {
    for (final role in UserRole.values) {
      final isAdmin = role == UserRole.admin;
      expect(role.permissions.canManageClinic, isAdmin);
      expect(role.permissions.canViewAllAppointments, isAdmin);
    }
  });
}
