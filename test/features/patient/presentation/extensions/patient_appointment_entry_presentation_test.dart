import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_appointment_entry_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();

  PatientAppointmentEntry buildEntry({
    required AppointmentStatus status,
    String? reason,
  }) {
    final appointment = fixtures.appointment(
      'test-id',
      'cardio-exam',
      'ayse',
      status,
      DateTime(2026, 10, 20, 10),
      20,
      reason: reason,
    );
    return PatientAppointmentEntry(
      appointment: appointment,
      service: fixtures.services.firstWhere((s) => s.id == 'cardio-exam'),
      staff: fixtures.staff.firstWhere((s) => s.id == 'ayse'),
      branch: fixtures.branch,
      department: fixtures.departments.firstWhere((d) => d.id == 'cardio'),
      isUpcoming: false,
      canCancel: false,
    );
  }

  testWidgets(
    'cancellationNote and serviceCaption format reason when present for rejected and staff cancelled',
    (tester) async {
      await loadTestTranslations(tester);

      // Rejected with reason
      final rejectedWithReason = buildEntry(
        status: AppointmentStatus.rejected,
        reason: 'Cihaz bakımda',
      );
      expect(rejectedWithReason.cancellationNote, 'Gerekçe: Cihaz bakımda');
      expect(rejectedWithReason.serviceCaption, 'Gerekçe: Cihaz bakımda');

      // Rejected without reason
      final rejectedNoReason = buildEntry(status: AppointmentStatus.rejected);
      expect(rejectedNoReason.cancellationNote, isNull);
      expect(rejectedNoReason.serviceCaption, 'Muayene · 20 dk');

      // Cancelled by staff with reason
      final cancelledByStaffWithReason = buildEntry(
        status: AppointmentStatus.cancelledByStaff,
        reason: 'Doktor izinli',
      );
      expect(
        cancelledByStaffWithReason.cancellationNote,
        'Gerekçe: Doktor izinli',
      );
      expect(
        cancelledByStaffWithReason.serviceCaption,
        'Gerekçe: Doktor izinli',
      );

      // Cancelled by staff without reason
      final cancelledByStaffNoReason = buildEntry(
        status: AppointmentStatus.cancelledByStaff,
      );
      expect(
        cancelledByStaffNoReason.cancellationNote,
        'Personel tarafından iptal edildi',
      );
      expect(
        cancelledByStaffNoReason.serviceCaption,
        'Personel tarafından iptal edildi',
      );

      // Cancelled by patient
      final cancelledByPatient = buildEntry(
        status: AppointmentStatus.cancelledByPatient,
      );
      expect(
        cancelledByPatient.cancellationNote,
        'Sizin tarafınızdan iptal edildi',
      );
      expect(
        cancelledByPatient.serviceCaption,
        'Sizin tarafınızdan iptal edildi',
      );
    },
  );
}
