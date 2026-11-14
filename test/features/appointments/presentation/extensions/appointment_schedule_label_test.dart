import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_schedule_label.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../domain/support/appointment_fixture.dart';

void main() {
  testWidgets('formats the weekday, abbreviated date, and start time', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    final appointment = const AppointmentFixture().request();

    expect(appointment.weekdayDateTimeLabel, 'Paz 1 Kas · 10:00');
  });
}
