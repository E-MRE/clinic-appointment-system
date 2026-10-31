import 'package:clinic_appointment_system/features/staff_management/domain/services/temporary_password_generator.dart';

final class FixedTemporaryPasswordGenerator
    implements TemporaryPasswordGenerator {
  const FixedTemporaryPasswordGenerator([this.password = 'Kx7-mP2q-9Tz']);

  final String password;

  @override
  String generate() => password;
}
