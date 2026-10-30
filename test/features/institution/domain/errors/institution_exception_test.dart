import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('keeps its typed code and formats its string representation', () {
    const exception = InstitutionException(InstitutionErrorCode.invalidTime);

    expect(exception.code, InstitutionErrorCode.invalidTime);
    expect(exception.toString(), 'InstitutionException: invalidTime');
  });
}
