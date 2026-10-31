import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:flutter_test/flutter_test.dart';

/// Domain error assertions shared by availability tests.
final class AvailabilityMatchers {
  /// Creates availability assertions.
  const AvailabilityMatchers();

  /// Matches the specified provider-independent failure.
  Matcher throwsCode(AvailabilityErrorCode code) {
    return throwsA(
      isA<AvailabilityException>().having((error) => error.code, 'code', code),
    );
  }
}
