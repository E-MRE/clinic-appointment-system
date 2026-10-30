import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/service_duration_formatting.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('formats service duration in minutes (20 dk)', (tester) async {
    await loadTestTranslations(tester);
    final duration = ServiceDuration(20);
    expect(duration.formatted, '20 dk');
  });
}
