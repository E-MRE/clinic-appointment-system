import 'package:clinic_appointment_system/features/staff_management/domain/services/temporary_password_generator.dart';

final class SequenceTemporaryPasswordGenerator
    implements TemporaryPasswordGenerator {
  int calls = 0;

  @override
  String generate() {
    calls++;
    return 'Generated-$calls-Aa9';
  }
}
