import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/features/availability/presentation/visitors/availability_window_label_visitor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  testWidgets('visitor labels recurring and dated windows in Turkish', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    await AppFormatters.ensureInitialized();
    const fixture = AvailabilityFixture();
    const visitor = AvailabilityWindowLabelVisitor();
    expect(
      fixture.weekly(540, 720, day: Weekday.wednesday).accept(visitor),
      'Çarşamba 09:00–12:00',
    );
    expect(
      fixture.oneOff(990, 1050).accept(visitor),
      '2 Kasım Pazartesi · 16:30–17:30',
    );
  });
}
