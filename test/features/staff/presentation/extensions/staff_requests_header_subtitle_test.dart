import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_requests_header_subtitle.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../../support/localization_test_app.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  final clock = FixedClock(DateTime(2026, 10, 20, 11, 20));

  testWidgets('formats header subtitle with count and oldest request age', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    final newer = fixture.restore(
      AppointmentStatus.pending,
      id: 'newer',
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'patient',
          byRole: UserRole.patient,
          at: DateTime(2026, 10, 20, 10, 20),
        ),
      ],
    );
    final older = fixture.restore(
      AppointmentStatus.pending,
      id: 'older',
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'patient',
          byRole: UserRole.patient,
          at: DateTime(2026, 10, 20, 9, 20),
        ),
      ],
    );

    final list = <Appointment>[newer, older];
    expect(list.oldestCreatedAt, DateTime(2026, 10, 20, 9, 20));
    expect(
      list.headerSubtitle(clock),
      '2 talep · en eskisi 2 saat önce oluşturuldu',
    );
  });

  testWidgets('falls back to count only when empty or oldest is not available', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    expect(<Appointment>[].headerSubtitle(clock), '0 talep');

    // Invalid history with no items cannot be created with Appointment.restore
    // because assert/check throws invalidHistory, so count only applies to empty.
  });
}
