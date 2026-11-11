import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offer.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_appointment_action_offers.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  final staff = fixture.actor(UserRole.doctor, 'staff');

  Appointment approvedAppointment() {
    return fixture.success(
      fixture.request().approve(by: staff, at: fixture.beforeStart),
    );
  }

  List<StaffAppointmentActionOffer> offersFor(
    Appointment appointment,
    AppointmentActor? actor,
    DateTime at,
  ) {
    return StaffAppointmentActionOffers(
      appointment: appointment,
      actor: actor,
      at: at,
    ).offers;
  }

  Future<void> loadLocale(WidgetTester tester) async {
    await loadTestTranslations(tester);
  }

  testWidgets('pending appointments offer enabled reject and approve', (
    tester,
  ) async {
    await loadLocale(tester);

    final offers = offersFor(fixture.request(), staff, fixture.beforeStart);

    expect(offers.map((offer) => offer.action), [
      AppointmentAction.reject,
      AppointmentAction.approve,
    ]);
    expect(offers.every((offer) => offer.isEnabled), isTrue);
  });

  testWidgets(
    'approved before start disables completion and no-show with hints',
    (tester) async {
      await loadLocale(tester);

      final offers = offersFor(
        approvedAppointment(),
        staff,
        fixture.beforeStart,
      );

      expect(offers.map((offer) => offer.action), [
        AppointmentAction.complete,
        AppointmentAction.markNoShow,
        AppointmentAction.cancelByStaff,
      ]);
      expect(offers[0].isEnabled, isFalse);
      expect(offers[0].hint, 'Randevu saati gelince işaretlenebilir.');
      expect(offers[1].isEnabled, isFalse);
      expect(offers[1].hint, '"Gelmedi" 10:15\'te açılır (15 dk tolerans).');
      expect(offers[2].isEnabled, isTrue);
    },
  );

  testWidgets('approved after start within tolerance enables completion', (
    tester,
  ) async {
    await loadLocale(tester);

    final offers = offersFor(
      approvedAppointment(),
      staff,
      fixture.start.add(const Duration(minutes: 1)),
    );

    expect(offers[0].isEnabled, isTrue);
    expect(offers[1].isEnabled, isFalse);
    expect(offers[2].isEnabled, isTrue);
  });

  testWidgets('approved after tolerance enables all three actions', (
    tester,
  ) async {
    await loadLocale(tester);

    final offers = offersFor(
      approvedAppointment(),
      staff,
      fixture.atTolerance.add(const Duration(minutes: 1)),
    );

    expect(offers.length, 3);
    expect(offers.every((offer) => offer.isEnabled), isTrue);
  });

  testWidgets('terminal statuses offer no staff actions', (tester) async {
    await loadLocale(tester);

    for (final status in AppointmentStatus.values) {
      if (status == AppointmentStatus.pending ||
          status == AppointmentStatus.approved) {
        continue;
      }
      final offers = offersFor(
        fixture.restore(status),
        staff,
        fixture.atTolerance,
      );
      expect(offers, isEmpty, reason: '${status.name} has no staff actions.');
    }
  });

  testWidgets('another staff member is offered no actions', (tester) async {
    await loadLocale(tester);
    final otherStaff = fixture.actor(UserRole.doctor, 'other-staff');

    expect(
      offersFor(fixture.request(), otherStaff, fixture.beforeStart),
      isEmpty,
    );
    expect(
      offersFor(approvedAppointment(), otherStaff, fixture.atTolerance),
      isEmpty,
    );
  });

  testWidgets('missing staff session offers no actions', (tester) async {
    await loadLocale(tester);

    expect(offersFor(fixture.request(), null, fixture.beforeStart), isEmpty);
  });
}
