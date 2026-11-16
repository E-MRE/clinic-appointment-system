import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/staff/presentation/services/staff_appointment_action_offer_policy.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  const policy = StaffAppointmentActionOfferPolicy();
  final staff = fixture.actor(UserRole.doctor, 'staff');

  testWidgets('projects allowed, early, and refused actions', (tester) async {
    await loadTestTranslations(tester);

    final pending = fixture.request();
    final allowed = policy.offerFor(
      AppointmentAction.approve,
      pending,
      actor: staff,
      at: fixture.beforeStart,
    );
    final approved = fixture.success(
      pending.approve(by: staff, at: fixture.beforeStart),
    );
    final early = policy.offerFor(
      AppointmentAction.complete,
      approved,
      actor: staff,
      at: fixture.beforeStart,
    );
    final refused = policy.offerFor(
      AppointmentAction.reject,
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
