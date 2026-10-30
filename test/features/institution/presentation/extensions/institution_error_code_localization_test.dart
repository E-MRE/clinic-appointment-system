import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every institution error code resolves to its translation key', () {
    expect(
      InstitutionErrorCode.values.map((code) => code.messageKey).toList(),
      [
        'institution.errors.invalidTime',
        'institution.errors.closeBeforeOpen',
        'institution.errors.overlappingRanges',
        'institution.errors.nameRequired',
        'institution.errors.addressRequired',
        'institution.errors.invalidRecord',
        'institution.errors.unavailable',
        'institution.errors.departmentRequired',
        'institution.errors.invalidDuration',
        'institution.errors.invalidFee',
        'institution.errors.invalidFastingHours',
        'institution.errors.preparationNoteTooLong',
      ],
    );
  });
}
