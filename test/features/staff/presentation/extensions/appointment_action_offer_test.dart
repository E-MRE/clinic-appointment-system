import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_action_offer.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  final staff = fixture.actor(UserRole.doctor, 'staff');

  testWidgets('projects allowed, early, and refused actions', (tester) async {
    await loadTestTranslations(tester);

    final pending = fixture.request();
    final allowed = AppointmentAction.approve.offerFor(
      pending,
      actor: staff,
      at: fixture.beforeStart,
    );
    final approved = fixture.success(
      pending.approve(by: staff, at: fixture.beforeStart),
    );
    final early = AppointmentAction.complete.offerFor(
      approved,
      actor: staff,
      at: fixture.beforeStart,
    );
    final refused = AppointmentAction.reject.offerFor(
      approved,
      actor: staff,
      at: fixture.beforeStart,
    );

    expect(allowed?.action, AppointmentAction.approve);
    expect(allowed?.isEnabled, isTrue);
    expect(allowed?.hint, isNull);
    expect(early?.action, AppointmentAction.complete);
    expect(early?.isEnabled, isFalse);
    expect(early?.hint, 'Randevu saati gelince işaretlenebilir.');
    expect(refused, isNull);
  });
}
