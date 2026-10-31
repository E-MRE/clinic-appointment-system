import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_error_code_staff_localization.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('every profile code resolves to a Turkish staff message', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    for (final code in UserErrorCode.values) {
      expect(code.staffMessage, isNotEmpty, reason: code.name);
      expect(code.staffMessage, isNot(startsWith('staff.')), reason: code.name);
    }
    final orphanMessage = UserErrorCode.orphanAccount.staffMessage;
    expect(orphanMessage, contains('Hesap oluşturuldu'));
    expect(orphanMessage, contains('personel profili kaydedilemedi'));
    expect(orphanMessage, contains('hesap silinemedi'));
    expect(orphanMessage, contains('destek ekibiyle iletişime geçin'));
  });
}
