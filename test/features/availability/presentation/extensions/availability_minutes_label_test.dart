import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_minutes_label.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('totals include whole, partial and empty hours', (tester) async {
    await loadTestTranslations(tester);
    expect(0.availabilityLabel, '—');
    expect(120.availabilityLabel, '2 saat');
    expect(95.availabilityLabel, '1 sa 35 dk');
    expect(20.availabilityLabel, '0 sa 20 dk');
  });
}
