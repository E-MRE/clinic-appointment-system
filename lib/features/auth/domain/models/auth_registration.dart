import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';

/// Patient registration input, including the name saved in the Auth profile.
/// Use cases validate it with `AuthInputValidationMixin`; raw input is
/// preserved here.
final class AuthRegistration extends AuthCredentials {
  const AuthRegistration({
    required this.fullName,
    required super.email,
    required super.password,
  });

  final String fullName;
}
