import 'package:clinic_appointment_system/features/staff/presentation/visitors/staff_role_subtitle_visitor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../staff_management/domain/doubles/staff_fixtures.dart';

void main() {
  testWidgets('staff visitor composes doctor specialty and technician role', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    const fixtures = StaffFixtures();
    const visitor = StaffRoleSubtitleVisitor();
    expect(
      fixtures.doctor(specialty: 'Kardiyoloji').accept(visitor),
      'Doktor · Kardiyoloji',
    );
    expect(fixtures.technician().accept(visitor), 'Teknisyen');
  });
}
