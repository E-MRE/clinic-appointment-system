import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/fasting_hours_formatting.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('formats single fasting hour (8 saat) and inputText (8)', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final fasting = FastingHours(min: 8, max: 8);
    expect(fasting.formatted, '8 saat');
    expect(fasting.inputText, '8');
  });

  testWidgets('formats fasting hour range (8–12 saat) and inputText (8–12)', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final fasting = FastingHours(min: 8, max: 12);
    expect(fasting.formatted, '8–12 saat');
    expect(fasting.inputText, '8–12');
  });
}
