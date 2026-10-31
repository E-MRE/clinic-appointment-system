import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';

/// Staff provisioning input. Passwords are excluded from string representations.
final class StaffRegistration extends StaffAssignment {
  /// Creates staff input with the exact temporary sign-in password.
  const StaffRegistration({
    required super.staff,
    required super.availableServices,
    required this.password,
  });

  /// The temporary password, preserved exactly as supplied.
  final String password;

  /// Sign-in input for the new staff member's account.
  AuthCredentials get credentials =>
      AuthCredentials(email: staff.email, password: password);
}
