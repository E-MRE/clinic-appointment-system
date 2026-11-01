import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/time_error_code_availability_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('time validation codes have localized availability messages', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    expect(
      TimeErrorCode.endBeforeStart.availabilityMessage,
      'Bitiş saati başlangıçtan sonra olmalı.',
    );
    expect(
      TimeErrorCode.invalidTime.availabilityMessage,
      'Geçerli bir saat seçin.',
    );
    expect(
      TimeErrorCode.invalidDate.availabilityMessage,
      'Geçerli bir tarih seçin.',
    );
  });
}
