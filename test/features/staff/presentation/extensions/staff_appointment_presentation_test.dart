import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_presentation.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();

  setUpAll(() async {
    await AppFormatters.ensureInitialized();
  });

  testWidgets('derives displayPatientName and initials with fallback', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    final withName = fixture.request(patientName: 'Ali Yılmaz');
    expect(withName.displayPatientName, 'Ali Yılmaz');
    expect(withName.patientInitials, 'AY');

    final singleWord = fixture.request(patientName: 'Zeynep');
    expect(singleWord.displayPatientName, 'Zeynep');
    expect(singleWord.patientInitials, 'Z');

    final emptyName = fixture.request(patientName: '');
    expect(emptyName.displayPatientName, 'Hasta');
    expect(emptyName.patientInitials, 'H');
  });

  testWidgets('formats scheduleAndServiceLabel and requestedAgoLabel', (
    tester,
  ) async {
    await loadTestTranslations(tester);

    final now = DateTime(2026, 10, 20, 11, 20);
    final request = fixture.restore(
      AppointmentStatus.pending,
      patientName: 'Ali Yılmaz',
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'patient',
          byRole: UserRole.patient,
          at: DateTime(2026, 10, 20, 9, 20),
        ),
      ],
    );
    final customized = fixture.restore(
      AppointmentStatus.pending,
      id: request.id,
      patientName: 'Ali Yılmaz',
      history: request.history,
    );

    expect(
      customized.scheduleAndServiceLabel,
      'Paz 1 Kas · 10:00 · Examination',
    );
    expect(customized.requestedAgoLabel(now), '2 saat önce talep etti');

    final tuesdayRequest = fixture.restore(
      AppointmentStatus.pending,
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'patient',
          byRole: UserRole.patient,
          at: DateTime(2026, 10, 20, 9, 20),
        ),
      ],
    );
    // Overriding date/range for Tuesday 27 Oct 09:20
    final dated = fixture.restore(
      AppointmentStatus.pending,
      history: tuesdayRequest.history,
    );
    expect(dated.startsAt, isNotNull);
  });
}
