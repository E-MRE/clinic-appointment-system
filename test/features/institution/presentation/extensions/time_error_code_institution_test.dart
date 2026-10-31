import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/time_error_code_institution.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('maps shared time errors to institution messages', () {
    expect(
      TimeErrorCode.invalidTime.institutionCode,
      InstitutionErrorCode.invalidTime,
    );
    expect(
      TimeErrorCode.endBeforeStart.institutionCode,
      InstitutionErrorCode.closeBeforeOpen,
    );
    expect(
      TimeErrorCode.invalidDate.institutionCode,
      InstitutionErrorCode.invalidTime,
    );
  });
}
