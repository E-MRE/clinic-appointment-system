import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_preview.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  testWidgets('preview describes zero, one and two service durations', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    await AppFormatters.ensureInitialized();
    const fixture = AvailabilityFixture();
    const generator = SlotGenerator();
    final window = fixture.weekly(540, 720);
    expect(
      AvailabilityPreview(window, [], generator).message,
      'Pazartesi 09:00–12:00 eklenecek.',
    );
    expect(
      AvailabilityPreview(window, [ServiceDuration(20)], generator).message,
      'Pazartesi 09:00–12:00 eklenecek. Hizmet sürenize göre 20 dakikalık 9 randevu saati açılır.',
    );
    expect(
      AvailabilityPreview(window, [
        ServiceDuration(20),
        ServiceDuration(30),
      ], generator).message,
      'Pazartesi 09:00–12:00 eklenecek. Hizmet sürelerinize göre 20 dk: 9 · 30 dk: 6 randevu saati açılır.',
    );
    expect(
      AvailabilityPreview(fixture.oneOff(990, 1050), [], generator).message,
      '2 Kasım Pazartesi · 16:30–17:30 eklenecek.',
    );
    expect(
      AvailabilityPreview(window, [ServiceDuration(25)], generator).message,
      contains('25 dakikalık 7'),
    );
  });
}
